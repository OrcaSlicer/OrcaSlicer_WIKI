# Plugin Audit Hook

This page describes the CPython audit hook used by OrcaSlicer's plugin system. Python can
read and write files, spawn processes, open sockets, and load native code, so plugin actions
in these categories prompt the user for a **Yes/No** decision before CPython performs the
operation, and remembered answers are persisted per plugin.

> [!NOTE]
> This is an interactive permission system, not a sandbox: a user who clicks **Yes** has
> authorized the action, and there is no isolation layer stopping a genuinely malicious
> plugin from doing damage after that. Today it categorizes and gates filesystem,
> network, and process-spawn events; native-code loading (`ctypes`) and OS-thread
> spawning are not covered. See [Known Current Limitations](#known-current-limitations)
> before relying on it as a security boundary.

## What Is a Plugin Audit Hook?

CPython exposes an auditing API (PEP 578). Any interpreter-wide hook registered with
`PySys_AddAuditHook` is called *before* the runtime performs a sensitive operation — for
example opening a file (`open`), spawning a subprocess (`subprocess.Popen`), or connecting
a socket (`socket.connect`). The hook receives the event name and its arguments and may
abort the operation by setting a Python exception and returning a non-zero value.

We register exactly **one** such hook, once, from `PythonInterpreter.cpp` via
`PluginAuditManager::instance().install_hook()`. It is a single process-wide C hook — there
is no separate interpreter or process sandbox around plugin code; the audit hook itself is
the boundary. Everything else — *which* plugin is running, *what* it is trying to do, and
*what the user has already approved* — is tracked by `PluginAuditManager`.

The hook only acts while a plugin **audit context** is active (see below). Non-plugin Python
code, and plugin loading before a context is set, pass through untouched.

## How It Works

### 1. Audit Identity

Every capability instance carries a C++-only identity, never exposed to Python:

```cpp
// PythonPluginInterface.hpp
class PluginCapabilityInterface {
public:
    void               set_audit_plugin_key(std::string key);
    const std::string& audit_plugin_key() const;
private:
    std::string m_audit_plugin_key;   // == PluginDescriptor::plugin_key
};
```

This is the canonical runtime ID, `PluginDescriptor::plugin_key`. It is stamped onto the
instance by the loader **after** the plugin is captured and **before** `on_load()` runs:

- `PluginLoader::load_plugin_impl()` -> `set_audit_plugin_key(descriptor.plugin_key)`
- `PluginLoader::update_loaded_plugin_key()` -> re-stamps it if a key is migrated

Stamping the identity does **not** turn on enforcement by itself — it only labels the object
so that later calls know which plugin they belong to. This matters because printer-agent
plugins are later invoked through `IPrinterAgent` / `NetworkAgent`, where the original
`plugin_key` is no longer available at the call site; the instance carries it instead.

### 2. Audit Context

The active plugin, capability name, and any scoped roots live in `thread_local` state on
`PluginAuditManager`, set and restored by an RAII guard, `ScopedPluginAuditContext`:

```cpp
explicit ScopedPluginAuditContext(const std::string& plugin_key,
                                   const std::string& capability_name = {});
// destructor restores the previous plugin/capability/scoped-roots
```

A context is opened at the **start of every C++ to Python trampoline call** (see
[Trampolines and the audit macros](#trampolines-and-the-audit-macros)) and closed when that
call returns or throws. So enforcement is *per call*: outside any trampoline call
`current_plugin()` is empty, and `audit_hook` allows everything unconditionally — this is
how OrcaSlicer's own internal Python use, and plugin import/registration before the first
trampoline call, stay unaudited.

**Being `thread_local`, the context does not propagate to a Python thread the plugin spawns
itself** (`threading.Thread`, `_thread.start_new_thread`, ...). A freshly spawned OS thread
gets its own empty `thread_local` storage, so `current_plugin()` reads empty inside it and
everything that thread does is unaudited unless it happens to call back into a C++ to Python
trampoline. There is currently no thread-spawn attribution mechanism that closes this gap.

### 3. Category Resolution

Every audited CPython event is mapped to an `AuditEventCategory`:

```cpp
enum class AuditEventCategory {
    None, FsRead, FsReadWrite, FsCreate, FsDelete, Http, Socket, ProcessCreate, Threading,
};
```

`audit_event_categories` (`PluginAuditManager.cpp`) is a flat `event_name -> category`
lookup table. `event_category(event_name)` returns `None` for anything not listed, and
`audit_hook` allows a `None`-category event immediately, unaudited.

| Category | Events |
|---|---|
| `FsRead` | `glob.glob`, `glob.glob/2`, `os.fwalk`, `os.getxattr`, `os.listdir`, `os.listdrives`, `os.listmounts`, `os.listvolumes`, `os.listxattr`, `os.scandir`, `os.walk`, `pathlib.Path.glob`, `pathlib.Path.rglob` |
| `FsReadWrite` | `os.chflags`, `os.chmod`, `os.chown`, `os.removexattr`, `os.rename`, `os.setxattr`, `os.truncate`, `os.utime`, `shutil.chown`, `shutil.copymode`, `shutil.copystat`, `shutil.copyfile`, `shutil.copytree`, `shutil.make_archive`, `shutil.move`, `shutil.unpack_archive` |
| `FsCreate` | `os.link`, `os.mkdir`, `os.symlink`, `tempfile.mkdtemp`, `tempfile.mkstemp`, `_winapi.CreateJunction` |
| `FsDelete` | `os.remove`, `os.rmdir`, `shutil.rmtree` |
| `Http` | `http.client.connect`, `http.client.send`, `urllib.Request` |
| `Socket` | `socket.__new__`, `socket.bind`, `socket.connect`, `socket.getaddrinfo`, `socket.gethostbyaddr`, `socket.gethostbyname`, `socket.gethostname`, `socket.getnameinfo`, `socket.getservbyname`, `socket.getservbyport`, `socket.sendmsg`, `socket.sendto` |
| `ProcessCreate` | `os.fork`, `os.forkpty`, `os.posix_spawn`, `os.spawn`, `os.system`, `os.startfile`, `os.startfile/2`, `pty.spawn`, `subprocess.Popen`, `_winapi.CreateProcess`, `_posixsubprocess.fork_exec` |
| `Threading` | *(declared, but no event currently maps to it — thread-spawn events are not audited)* |

`open` is a special case, checked before the map: CPython's `open` audit event fires for both
`open()`/`io.open()` (`args = (path, mode, flags)`, `mode` a string like `"r"`/`"wb"`/`"a+"`)
and the low-level `os.open()` (`mode` is `None`, `flags` carries the numeric `os.O_*` bitmask
instead). A plain read-mode string resolves to `FsRead`; anything else — a
write/append/create/truncate/exclusive mode character, or an unrecognized `None` mode —
resolves to `FsReadWrite`. This is the one event whose category depends on its arguments
rather than its name, so it cannot live in the static map.

### 4. The Decision Pipeline

`audit_hook` resolves the category first (`None` -> allow, unaudited), then walks through:

1. **Denied-path check** (fs categories only — `is_denied_path`, see [Allowed Roots and Denied
   Paths](#allowed-roots-and-denied-paths) below). If any target is a denied filename or
   matches a denied path keyword, block immediately: `report_denied`, no dialog — regardless
   of what an ancestor-cascade approval or an allowed root would otherwise say. This runs
   *before* the next two steps specifically so neither can launder access to a denied path.
2. **Ancestor-cascade check.** If the current Python call stack already contains a stdlib
   frame approved for an earlier event in the same call chain, allow immediately with no
   dialog.
3. **Allowed-root shortcut** (fs categories only — `check_path_access`). If every target
   resolves inside an allowed root — and, for a write/create/delete-shaped event, a root that
   permits writes — allow immediately with no dialog and nothing persisted.
4. The rest funnels through `PluginAuditDetail::decide_audited_event`:
    1. **Extract targets** (`audit_targets`) — the path(s)/address/command the event names, as
       display-and-persistence strings.
    2. **Look up the permission list** for this category (`permission_list_for`) — `nullptr`
       for categories that never persist.
    3. **Filter already-granted targets** out of the list to prompt for. If the category
       persists grants and every target is already granted, allow with no dialog.
    4. **Show one dialog** for everything still unresolved (`audit_message` + a Yes/No message
       box).
    5. **On Yes**: persist each newly-approved target (if the category persists), record the
       current call-site chain as approved (for the cascade check), allow.
    6. **On No**: `report_denied` records an `AuditViolation`, raises `PermissionError` in the
       calling interpreter, and the hook returns `-1` — CPython treats a nonzero return as
       "block this operation," so the audited call never completes.

#### Target extraction

- **Filesystem categories** (`FsRead`/`FsReadWrite`/`FsCreate`/`FsDelete`, including `open`):
  the target is the path, read via `PyOS_FSPath` (so both `str` and path-like objects work).
  Almost every fs event's path is argument 0; a small exception set, `two_path_fs_events`,
  lists the events that take a *source and destination* (`os.rename`, `os.link`,
  `os.symlink`, `shutil.copyfile`/`copytree`/`copymode`/`copystat`/`move`/`unpack_archive`,
  `_winapi.CreateJunction`) — both arguments land in the *same* dialog and the *same*
  persisted grant.
- **http/socket/processcreate**: `audit_target_arg_indices` maps each event to candidate
  argument indices, tried in order until one has a non-empty `str()`. Using `str()` avoids
  hand-parsing every address shape (`AF_INET` host/port tuple vs. `AF_UNIX` path vs.
  `AF_INET6`, etc.) — whatever `str()` produces becomes the stable target/persistence key.
  `http.client.send` is deliberately not listed: it carries no host in its own arguments and
  relies on the ancestor cascade instead.
- **Events with nothing sensible to point at** (`socket.__new__`, `os.fork`, ...) get an
  empty target list. An empty list prompts for the bare event name and never persists —
  there is nothing to remember a grant *for*.

#### Persistence

Persisted categories map onto `PluginPermissions` (`PluginFsUtils.hpp`) 1:1:

| Category | `PluginPermissions` field |
|---|---|
| `FsRead` | `fs_read` |
| `FsReadWrite` | `fs_readwrite` |
| `Http` | `network_http` |
| `Socket` | `network_socket` |
| `ProcessCreate` | `process` |
| `FsCreate`, `FsDelete` | *(none — never persisted)* |

`FsCreate`/`FsDelete` always prompt, with nothing remembered across calls, since creating or
deleting a file is consequential enough to confirm every time, even for the same target
repeated in the same run.

A grant is a plain string-equality match (`has_permission`) against the persisted list — no
path canonicalization, no argument-shape awareness beyond what `str()` already produced.
`persist_permission` writes through to the plugin's `.install_state.json` sidecar:

```json
{
    "permissions": {
        "fs_read": ["/path/to/declared/file.py", "/home/user/.bashrc"],
        "fs_readwrite": [],
        "network_http": ["http://example.com"],
        "network_socket": ["('example.com', 80)"],
        "process": ["/usr/bin/python3"]
    }
}
```

A separate, declarative grant path exists alongside this reactive one:
`orca.request_permissions(fs_read: list[str] = [])`, typically called once from
`register_capabilities()`, checks/persists a batch of `fs_read` paths up front instead of
waiting for the first access to prompt. It raises `ValueError` if called outside plugin
discovery or with an empty path string, shows its own dialog (marshaled to the UI thread when
called off-thread), and writes the same `fs_read` list that reactive grants do — a path
granted either way satisfies the other check, since both read/write the same JSON array. Only
`fs_read` has a declarative form today; the other four persisted lists are populated
reactively, one dialog "Yes" at a time.

#### The call-site ancestor cascade

A single logical plugin action often fires several *nested* CPython audit events as it passes
through stdlib layers — `urllib.request.urlopen()` internally triggers `urllib.Request`, then
`http.client.connect`, then `http.client.send`, all before `urlopen()` returns. Without
special handling, this means three separate prompts for what a user experiences as one
action.

`call_site_identities(plugin_root)` walks the live Python call stack upward from the
currently-firing event, building an identity string (`filename:function:first_line`) for each
frame, and **stops as soon as it reaches a frame whose file lives under the plugin's own
`plugin_root`**. Only the stdlib/third-party frames between the audited call and that
boundary are returned.

That exclusion is load-bearing: a plugin's own entry point (its capability's `execute()`,
say) is an ancestor of every action the plugin ever takes. If plugin frames were included,
approving *any* single prompt would record that entry-point frame as "approved," and every
subsequent action anywhere in that call — or, since identity is by code location rather than
a live object, in *any future call to that same function* — would silently bypass the audit.
Restricting recorded frames to library code means the identity actually shared between
`urllib.Request` and `http.client.connect` is `urlopen()`'s own stdlib frame, still genuinely
on the stack for both — the cascade only fires within one still-live call chain doing one
library-mediated action, not "this plugin was approved once, ever."

This cache (`unordered_map<plugin_key, unordered_set<call_site_id>>`) is in-memory only,
never persisted to the sidecar, and never pruned — it grows with the number of distinct
stdlib call sites a plugin's actions pass through, which in practice is small and bounded by
the plugin's own code.

### Allowed Roots and Denied Paths

`check_path_access(path, is_write)` / `check_open(path, mode)` implement a second policy layer
that `audit_hook` consults directly, ahead of the per-target dialog/persistence flow (decision
pipeline steps 1 and 3 above):

1. **Deny by filename** (`is_denied_filename` — the app config and cloud refresh token, by
   base-name prefix match, case-insensitive, so `.bak`/`.tmp` companions and Windows
   alternate-data-stream variants are covered too).
2. **Deny by path keyword** (`is_denied_path_keyword` — any path *component*, not just the
   base name, containing `"secret"`, `"cert"`, or `"conf"` case-insensitively, seeded from
   `default_denied_path_keywords()`). This is deliberately broader and fuzzier than (1): it
   rules out whole *classes* of sensitive paths — a `secrets/` subfolder, a `certificates/`
   folder, a `*.conf`/`config/` file or folder — wherever they sit, including inside an
   otherwise-allowed root, at the cost of over-blocking an unrelated name that happens to
   contain the keyword. That's the fail-safe direction, same rationale as (1).
3. **Allow only if inside an allowed root** (`is_inside_allowed_root`, `weakly_canonical` +
   component-wise comparison, rejecting `..` traversal) — a scoped root
   (`m_scoped_allowed_roots`, `thread_local`, cleared and restored per
   `ScopedPluginAuditContext` scope) or a global root (`m_global_allowed_roots`,
   mutex-guarded, process-wide). Each registered root (`AllowedRoot { path; allow_write; }`)
   carries its own write permission: a root registered read-only matches a read-shaped
   request but never a write/create/delete-shaped one, which instead falls through to
   "outside allowed root" for that root specifically.

`is_denied_path(path)` is the convenience `is_denied_filename(path) ||
is_denied_path_keyword(path)` that `audit_hook` calls at decision-pipeline step 1, before it
even knows which root (if any) the target sits inside.

`install_hook()` populates both roots and both deny registries:

| Root | Access | Covers |
|---|---|---|
| `data_dir()` (global) | read+write | each plugin's storage folder (`data_dir()/orca_plugins`), the installed/system profile cache (`data_dir()/system`), and the rest of `data_dir()` |
| `resources_dir()` (global) | **read-only** | the app's bundled, shared assets (installed system profiles, the bundled TLS client cert, web assets) — never write-eligible, since the install can be shared/read-only on disk |
| current G-code file's parent directory (scoped, `SlicingPipelinePluginCapabilityTrampoline::execute()`) | read+write | only while a `psGCodePostProcess` call is on the stack, and only for that call |

Denied filenames: `default_denied_filenames()` (the app config, both extensions and app keys,
plus the cloud refresh token). Denied keywords: `default_denied_path_keywords()` =
`{"secret", "cert", "conf"}` — this is also what keeps the bundled cert at
`resources_dir()/cert/...` unreachable despite `resources_dir()` itself being an allowed root.

`check_path_access`/`check_open` are exercised directly by
`tests/slic3rutils/test_plugin_audit.cpp`, independent of a live interpreter.

## Audit Hook Development

The point of interest is **`PluginAuditManager.hpp`/`.cpp`** (categories, targets,
persistence, the decision pipeline) and **`PyPluginTrampoline.hpp`** (how each plugin
function opens an audit context).

### Mapping a new event

To audit a CPython event that isn't covered yet, add it to `audit_event_categories` in
`PluginAuditManager.cpp` under the category it belongs to (or extend the enum with a new
category first if none fits). Look the event up in the official table for its exact argument
tuple before wiring `audit_targets`/`audit_target_arg_indices` for it — each event has its own
shape; you cannot assume argument 0 is the path for events outside `two_path_fs_events`.

The complete, version-specific list of audit events and their arguments:
**https://docs.python.org/3/library/audit_events.html**

If the event should persist grants, add its category to `permission_list_for` mapping onto
the right `PluginPermissions` field; if not (like `FsCreate`/`FsDelete`), leave it prompting
every time.

### Trampolines and the audit macros

Every C++ to Python plugin call crosses a trampoline method, and each one opens an audit
context via one of two macros in `PyPluginTrampoline.hpp`:

```cpp
#define ORCA_PY_AUDIT_SCOPE() \
    std::optional<::Slic3r::ScopedPluginAuditContext> _orca_audit_scope; \
    if (const std::string& _orca_audit_key = this->audit_plugin_key(); !_orca_audit_key.empty()) \
    _orca_audit_scope.emplace(_orca_audit_key, this->name())

#define ORCA_PY_OVERRIDE_AUDITED(audit_setup, override_macro, ret, base, name, ...) \
    do { \
        ::Slic3r::PluginCapabilityInterface::RefCounter _orca_ref_counter(*this); \
        ::Slic3r::PythonGILState _orca_python_gil; \
        if (!_orca_python_gil) throw std::runtime_error("Python interpreter is shutting down"); \
        ORCA_PY_AUDIT_SCOPE(); \
        if (_orca_audit_scope) audit_setup(); \
        ORCA_PY_LOGGED_OVERRIDE_BODY(override_macro(ret, base, name, ##__VA_ARGS__)); \
    } while (0)
```

`ORCA_PY_AUDIT_SCOPE()` is the primitive: it opens `ScopedPluginAuditContext(audit_plugin_key(),
name())` for the current call, but only if the instance actually has a non-empty audit key
(a plugin whose loader never stamped an identity opens no context, so its calls stay
unaudited — see [Identity Wiring](#identity-wiring)). `ORCA_PY_OVERRIDE_AUDITED` is what
almost every trampoline method actually calls: it wraps that scope together with the
reference-count guard, the GIL acquisition, and traceback logging/rethrowing at the single
C++/Python boundary. Two real call sites:

```cpp
// ScriptPluginCapabilityTrampoline.hpp
ExecutionResult execute() override
{
    ORCA_PY_OVERRIDE_AUDITED([] {}, PYBIND11_OVERRIDE_PURE,
                              ExecutionResult, ScriptPluginCapability, execute);
}
```

```cpp
// PrinterAgentPluginCapabilityTrampoline.hpp
int connect_printer(const std::string& dev_id, const std::string& dev_ip,
                     const std::string& username, const std::string& password, bool use_ssl) override
{
    ORCA_PY_OVERRIDE_AUDITED([] {}, PYBIND11_OVERRIDE_PURE, int, PrinterAgentPluginCapability,
                              connect_printer, dev_id, dev_ip, username, password, use_ssl);
}
```

A method that needs to hand-unpack a Python return value (rather than a plain pybind11
override) can call `ORCA_PY_AUDIT_SCOPE()` directly instead of going through
`ORCA_PY_OVERRIDE_AUDITED` —
`PrinterAgentPluginCapabilityTrampoline::request_bind_ticket` does this to unpack a
`(result, ticket)` tuple through an out-parameter.

| Param | Meaning |
|---|---|
| `audit_setup` | a callable (often `[] {}`) run *after* the context is opened; use it to register a scoped root |
| `override_macro` | `PYBIND11_OVERRIDE` or `PYBIND11_OVERRIDE_PURE` |
| `ret, base, name, ...` | the usual pybind11 override arguments |

There is no per-call "mode" argument to choose — every trampoline call is audited the same
way; what varies per call is only the `audit_setup` callback (see below).

### Adding Per-Call Scoped Roots

`ScopedPluginAuditContext`'s constructor clears the previous scoped roots, so a scoped root
must be added *after* construction — that is what `audit_setup` is for. The slicing-pipeline
trampoline uses it to grant write access to the folder holding the current G-code file at
`psGCodePostProcess`, which the allowed-root shortcut (decision-pipeline step 3) now actually
consults:

```cpp
ExecutionResult execute(SlicingPipelineContext& ctx) override
{
    ORCA_PY_OVERRIDE_AUDITED(
        [&] {                                               // runs only when a context is active
            if (!ctx.gcode_path.empty())
                ::Slic3r::PluginAuditManager::instance().add_scoped_allowed_root(
                        boost::filesystem::path(ctx.gcode_path).parent_path());
        },
        PYBIND11_OVERRIDE_PURE,
        ExecutionResult, SlicingPipelinePluginCapability, execute, ctx);
}
```

Pass `false` as the second argument to grant a **read-only** scoped root instead —
`add_scoped_allowed_root(root, /*allow_write=*/false)` — for a call that should be able to
read a directory without being able to write into it.

### Adding a Global Allowed Root

If *every* plugin should be allowed a directory, add it in `install_hook()`. `install_hook()`
grants `data_dir()` read+write and `resources_dir()` read-only:

```cpp
void PluginAuditManager::install_hook()
{
    add_global_allowed_root(data_dir());
    add_global_allowed_root(resources_dir(), /*allow_write=*/false);
    // add_global_allowed_root(std::filesystem::temp_directory_path());  // e.g. to allow /tmp

    for (const auto& name : default_denied_filenames())
        add_denied_filename(name);
    for (const auto& keyword : default_denied_path_keywords())
        add_denied_path_keyword(keyword);

    PySys_AddAuditHook(audit_hook, this);
}
```

Prefer a scoped root over widening a global one, and prefer read-only over read+write unless
the plugin genuinely needs to write there — a global root is process-lifetime and applies to
every plugin. Remember that the deny checks (filename and keyword) run *before* any root is
consulted, so a global root can never make a denied path reachable.

### Identity Wiring

If you add a new way to load or re-key plugin instances, make sure the new path also calls
`set_audit_plugin_key()`; otherwise the instance has an empty key and `ORCA_PY_AUDIT_SCOPE()`
never opens a context, so its calls run completely unaudited. The existing call sites are
`PluginLoader::load_plugin_impl()` and `PluginLoader::update_loaded_plugin_key()`.

## Known Current Limitations

- **`is_denied_path_keyword` is a plain substring match, not a targeted rule.** A plugin file
  legitimately named e.g. `myconfig.py` or `deconfliction_report.txt` is blocked too. This is
  intentional (see [Allowed Roots and Denied Paths](#allowed-roots-and-denied-paths)), but
  there is no allowlist mechanism to reclaim a specific over-blocked name short of removing
  the keyword.
- **The allowed-root shortcut applies uniformly to all four fs categories**, including
  `FsCreate`/`FsDelete`: a create/delete inside an allowed root (e.g. a plugin's own file
  under `data_dir()`) now skips the per-call dialog entirely, whereas outside an allowed root
  `FsCreate`/`FsDelete` still always prompt and never persist (see
  [Persistence](#persistence)). A pre-determined allowed root is meant to need no prompt at
  all — this is a deliberate behavior difference from the plain category+dialog model, not a
  bug.
- **`Threading` has no events mapped to it**; thread-related audit events are not gated at
  all.
- **A plugin-spawned OS thread is entirely unaudited** — it runs with an empty `thread_local`
  plugin context unless it re-enters through a C++ to Python trampoline call.
- **`os.open()`'s numeric-flags form is not decoded.** With `mode=None` it always resolves to
  `FsReadWrite`, which can over-prompt for what is actually a read-only `os.open()` call.
- **Persistence for `Http`/`Socket`/`ProcessCreate` is keyed by `str()`** of an extracted
  argument (an address tuple, an argv list, ...), not a normalized/validated value —
  approving one call can silently cover a different future call whose relevant argument
  happens to `str()`-format identically.
- **This is not a hardened sandbox.** A user who approves a prompt has authorized that
  action; native-code loading (`ctypes`) is not audited at all.

## Debugging

Enforcement only fires while a context is active, and it now depends on what the user clicked
in a dialog, so when something is unexpectedly blocked (or unexpectedly silent), get the facts
from the log first.

**The live block path.** A denial from the dialog/permission flow logs:

```
[AUDIT BLOCKED] plugin=local:.../Environment_Report_Script_ event=open reason=...
```

This comes from `report_violation`, fired from `decide_audited_event` after the user answers
**No**. `audit_denial_pending()` / `last_violation()` let the C++ side downstream (e.g.
`ORCA_PY_LOGGED_OVERRIDE_BODY`, when catching the resulting `pybind11::error_already_set`)
distinguish an audit denial from an ordinary Python exception; it clears
`current_plugin()` before logging the traceback so nothing touched while formatting/logging
the exception is itself audited against the now-departed plugin.

**A second, noisier log line exists in the same file** —
`[AUDIT] block path=... is_write=...` — emitted by `check_path_access` itself, at `warning`
level, every time a target fails *that specific check*: a denied filename/keyword, or a path
outside every allowed root. Since `audit_hook`'s allowed-root shortcut (decision-pipeline step
3) now calls `check_path_access` for every fs-category target, this line fires for the
ordinary, expected case of "not covered by an allow-list, falling through to the normal
prompt" just as often as for an actual deny — **it does not by itself mean the operation was
blocked**. Only `[AUDIT BLOCKED]` (from `report_violation`) means the call was actually denied
(either an unconditional deny-path hit, or the user later answered No in the dialog).

**Common pitfalls**

- **No prompt appears at all.** Check whether the target was already granted (persisted in
  the plugin's `.install_state.json` sidecar) or covered by the ancestor cascade — both allow
  silently by design, not a bug.
- **No context = no enforcement.** If a plugin's calls are never audited, check that its
  instance got `set_audit_plugin_key()` (non-empty key) and that the method actually wraps
  through `ORCA_PY_OVERRIDE_AUDITED` / `ORCA_PY_AUDIT_SCOPE()`.
- **Stale / incremental builds.** `PyPluginTrampoline.hpp` and `PluginAuditManager.hpp` are
  included by many translation units. A header-only change may not propagate with an
  incremental build; do a clean rebuild of the affected targets if runtime behavior
  contradicts the source. `PluginAuditManager.cpp` changes are a single-TU recompile +
  relink.

## Testing

- `tests/slic3rutils/test_plugin_audit.cpp` — pure-logic coverage of the denied-filename list,
  the denied-path-keyword list, and `check_path_access`/`check_open` (allowed roots, read-only
  roots, and denies), independent of a live interpreter or the `audit_hook` flow itself.
- `sandboxes/orca_audit_matrix_plugin_any.py` — a manual, end-to-end fixture plugin with one
  capability per category (`Audit: fsread`, `Audit: fsreadwrite`, `Audit: fscreate`,
  `Audit: fsdelete`, `Audit: http`, `Audit: socket`, `Audit: processcreate`) plus a run-all
  capability, runnable from the Plugin Manager UI to observe real prompting, persistence, and
  denial behavior for every category (including `open()` and the cascade/persistence
  guarantees documented above) against a live interpreter.

## Key Files

| File | Responsibility |
|---|---|
| `src/slic3r/plugin/PluginAuditManager.{hpp,cpp}` | categories, targets, persistence, the decision pipeline, `audit_hook`, `ScopedPluginAuditContext` |
| `src/slic3r/plugin/PyPluginTrampoline.hpp` | `ORCA_PY_AUDIT_SCOPE()` / `ORCA_PY_OVERRIDE_AUDITED` (audit context + traceback logging) |
| `src/slic3r/plugin/PythonPluginInterface.hpp` | the per-instance audit identity |
| `src/slic3r/plugin/PluginLoader.cpp` | stamps the audit key at load / key migration |
| `src/slic3r/plugin/pluginTypes/*/*Trampoline.hpp` | per-plugin-type methods and their `audit_setup` callbacks |
| `src/slic3r/plugin/PythonPluginBridge.cpp` | binds `orca.request_permissions(fs_read=[...])` |
| `src/slic3r/plugin/PythonInterpreter.cpp` | installs the hook once at interpreter init |
