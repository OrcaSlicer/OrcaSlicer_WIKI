# Plugin Audit Hook

This page describes the CPython audit hook used by OrcaSlicer's plugin system. Python can
read and write files, spawn processes, open sockets, and load native code, so plugin code is
checked before sensitive runtime operations are allowed to continue.

> [!NOTE]
> This is intentionally a narrow, low-risk first version, not a complete sandbox. Today it
> enforces one thing: file writes are restricted to an allow-list of directories while a
> plugin is executing. Reads are left permissive so Python can still import modules.
> Process/network/native-code events are not yet enforced. See [Limitations](#limitations)
> before relying on it as a security boundary.

## What Is a Plugin Audit Hook?

CPython exposes an auditing API (PEP 578). Any interpreter-wide hook registered with
`PySys_AddAuditHook` is called *before* the runtime performs a sensitive operation. For
example opening a file (`open`), spawning a subprocess (`subprocess.Popen`), or connecting
a socket (`socket.connect`). The hook receives the event name and its arguments and may
abort the operation by setting a Python exception and returning a non-zero value.

We register exactly **one** such hook, once, from `PythonInterpreter::initialize()` via
`PluginAuditManager::instance().install_hook()`. Everything else - *which* plugin is
running, *what* mode it runs under, and *which* directories it may touch - is tracked by
`PluginAuditManager`.

The hook itself is global to the interpreter, but it only enforces anything when a plugin
**audit context** is active (see below). Non-plugin Python code, and plugin loading before
the context is set, pass through untouched.

## How It Works

There are three moving parts. Keep them distinct; conflating them is the usual source of
confusion.

### 1. Audit Identity

Every plugin instance carries a C++-only identity string, never exposed to Python:

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

Stamping the identity does **not** turn on enforcement. It only labels the object so that
later calls know which plugin they belong to. This matters because printer-agent plugins
are later invoked through `IPrinterAgent` / `NetworkAgent`, where the original `plugin_key`
is no longer available at the call site; the instance carries it instead.

### 2. Audit Context

The active plugin, mode, and scoped roots live in thread-local state on
`PluginAuditManager`. They are set and restored by an RAII guard,
`ScopedPluginAuditContext`:

```cpp
// constructor: remember previous state, then apply the new plugin/mode and clear scoped roots
ScopedPluginAuditContext(const std::string& plugin_key,
                         AuditMode mode = AuditMode::Loading);
// destructor: restore the previous plugin/mode/scoped-roots
```

A context is constructed at the **start of every C++ to Python trampoline call** and
destroyed when that call returns or throws. So enforcement is *per call*: outside any
trampoline call the mode is just its default and `current_plugin()` is empty, so the hook
allows everything.

### 3. Audit Modes

```cpp
enum class AuditMode {
    // Import/loading phase: allow reads anywhere, only block writes
    // outside allowed roots.  Python needs to read stdlib modules
    // during import and those are not inside plugin directories.
    Loading,

    // Execution phase: block both reads and writes outside allowed
    // roots, plus subprocess/socket/ctypes.
    Enforcing,
};
```

The check that implements this is `PluginAuditManager::check_open(path, mode)`:

1. Empty path -> allow.
2. No active plugin (`current_plugin()` empty) -> allow.
3. `Loading` **and** the open is a read (`mode` has no `w`/`a`/`+`) -> allow (early-out).
4. Otherwise the path must resolve inside a **scoped allowed root** or the **global
   allowed root**, else it is blocked.

So the only difference between the two modes is step 3: `Loading` lets reads through before
the allow-list check; `Enforcing` does not, so reads are subject to the same allow-list as
writes.

### Allowed roots

There are two tiers, checked in this order:

| Tier | Stored in | Lifetime | Set by |
|---|---|---|---|
| **Scoped** | thread-local, cleared on every new context | one call | `add_scoped_allowed_root()` inside an `audit_setup` callback |
| **Global** | shared, mutex-guarded | process | `add_global_allowed_root()` in `install_hook()` |

In this version the global allow-list contains **only `data_dir()`**. The executable
directory and resources directory are deliberately *not* allowed; plugins must not write
there. Slicing-pipeline plugins at `psGCodePostProcess` additionally get the temp G-code folder as a *scoped* root for the
duration of their `execute()` call.

Path matching (`is_inside_allowed_root`) canonicalizes both paths with
`weakly_canonical` (resolving symlinks without requiring existence) and does a
component-wise prefix match that rejects any `..` traversal.

### Flow of One Call

```
PluginLoader (once)         set_audit_plugin_key(plugin_key)   // identity stamped
        │
        ▼
C++ calls plugin->execute() ─► trampoline method
        │                         ├─ ScopedPluginAuditContext ctor  // mode + plugin set
        │                         ├─ audit_setup()                  // e.g. add scoped roots
        │                         └─ PYBIND11_OVERRIDE(_PURE) ──► Python runs
        │                                                            │
        │                              Python does open("/x", "w") ─┤
        │                                                            ▼
        │                                    CPython raises "open" audit event
        │                                                            │
        │                                    PluginAuditManager::audit_hook
        │                                                            │
        │                                    check_open("/x","w") → blocked?
        │                                       └─ PyErr_SetString + return -1  ► PermissionError
        ▼
trampoline returns ─► ScopedPluginAuditContext dtor  // previous state restored
```

## Audit Hook Development

The point of interest is **`PluginAuditManager.hpp` / `.cpp`** (the modes, the events, and
the policy) and the trampoline macros in **`PyPluginTrampoline.hpp`** (how each plugin
function opts into a mode).

### Handling events

Events are dispatched by name in `PluginAuditManager::audit_hook`. Return `0` to allow;
set a Python exception and return non-zero (we use `-1`) to block:

```cpp
int PluginAuditManager::audit_hook(const char* event, PyObject* args, void* user_data)
{
    auto* mgr = static_cast<PluginAuditManager*>(user_data);
    std::string event_name(event ? event : "");

    if (event_name == "open") {
        // CPython passes ("open", path, mode, flags)
        const char* path = nullptr; const char* mode = nullptr; int flags = 0;
        if (!PyArg_ParseTuple(args, "s|si", &path, &mode, &flags)) {
            PyErr_Clear();
            return 0;                       // couldn't parse — allow
        }
        if (!mgr->check_open(path ? path : "", mode ? mode : "r").allowed) {
            PyErr_SetString(PyExc_PermissionError,
                            "Plugin attempted to access a blocked file path");
            return -1;                      // block
        }
        return 0;
    }

    // else if (event_name == "os.rename") { ... }   // see below

    return 0;                               // unhandled event — allow
}
```

To audit a new operation, add another `else if` branch. **Each event has its own argument
tuple**; you cannot assume `(path, mode, flags)`. Look the event up in the official table
and parse accordingly:

- `os.rename` -> `(src, dst, src_dir_fd, dst_dir_fd)`
- `os.remove` -> `(path, dir_fd)`
- `os.mkdir`  -> `(path, mode, dir_fd)`
- `subprocess.Popen` -> `(executable, args, cwd, env)`

The complete, version-specific list of audit events and their arguments:
**https://docs.python.org/3/library/audit_events.html**

For filesystem mutations you'll usually want to route the extracted path(s) through
`check_open(path, "w")` (or a dedicated checker) so they share the same allow-list logic.

### Defining the Audit Mode of a Function

Every C++ to Python plugin call crosses a trampoline method, and those methods wrap the
pybind11 override in the `ORCA_PY_OVERRIDE_AUDITED` macro
(`PyPluginTrampoline.hpp`). The macro both (a) logs and rethrows Python exceptions at the
single boundary and (b) opens the audit context. Its signature:

```cpp
ORCA_PY_OVERRIDE_AUDITED(mode, audit_setup, override_macro, ret, base, name, /* args... */)
```

| Param | Meaning |
|---|---|
| `mode` | `AuditMode::Loading` or `AuditMode::Enforcing` for this call |
| `audit_setup` | a callable (often `[] {}`) run *after* the context is constructed; use it to register scoped roots |
| `override_macro` | `PYBIND11_OVERRIDE` or `PYBIND11_OVERRIDE_PURE` |
| `ret, base, name, ...` | the usual pybind11 override arguments |

When you add a new method to any trampoline, **you must choose its mode** based on what the
function legitimately needs:

```cpp
void on_load() override
{
    ORCA_PY_OVERRIDE_AUDITED(
        ::Slic3r::PluginAuditManager::AuditMode::Loading,   // imports during load → reads allowed
        [] {},                                              // no extra setup
        PYBIND11_OVERRIDE,
        void, Base, on_load);
}
```

Rule of thumb:

- Use **`Loading`** for lifecycle/setup calls that may import modules (`on_load`,
  `on_unload`, `get_type`) or any call where you only care about restricting writes.
- Use **`Enforcing`** for calls that should also be prevented from *reading* outside the
  allow-list. Be aware this will block lazily-imported stdlib/3rd-party modules read from
  disk during the call, so only use it where the plugin is not expected to import at call
  time.

### Adding Per-Call Allowed Roots

`ScopedPluginAuditContext`'s constructor **clears** the scoped roots, so any scoped root
must be added *after* construction, which is exactly what `audit_setup` is for. The
slicing-pipeline trampoline uses it to grant write access to the folder holding the current
G-code file at `psGCodePostProcess`:

```cpp
ExecutionResult execute(SlicingPipelineContext& ctx) override
{
    ORCA_PY_OVERRIDE_AUDITED(
        ::Slic3r::PluginAuditManager::AuditMode::Loading,
        [&] {                                               // runs only when a context is active
            if (!ctx.gcode_path.empty())
                ::Slic3r::PluginAuditManager::instance().add_scoped_allowed_root(
                        boost::filesystem::path(ctx.gcode_path).parent_path());
        },
        PYBIND11_OVERRIDE_PURE,
        ExecutionResult, SlicingPipelinePluginCapability, execute, ctx);
}
```

The callback runs only when the instance has a non-empty audit key (i.e. a context was
actually opened), so it's safe to assume enforcement is live inside it.

### Adding a Global Allowed Root

If *every* plugin should be allowed a directory, add it in `install_hook()`:

```cpp
void PluginAuditManager::install_hook()
{
    PySys_AddAuditHook(audit_hook, this);
    add_global_allowed_root(data_dir());          // the only global root today
    // add_global_allowed_root(std::filesystem::temp_directory_path());  // e.g. to allow /tmp
}
```

Prefer scoped roots over global ones. A global root widens the boundary for *all* plugins
and is process-lifetime. Only add a global root when the access is genuinely universal.

### Identity Wiring

If you add a new way to load or re-key plugin instances, make sure the new path also calls
`set_audit_plugin_key()`; otherwise the instance has an empty key and **no context is ever
opened**, so its calls run completely unaudited. The existing call sites are
`PluginLoader::load_plugin_impl()` and `PluginLoader::update_loaded_plugin_key()`.

## Current Policy

| Plugin call | Mode | Effective access |
|---|---|---|
| `on_load` / `on_unload` / `get_type` | `Loading` | read anywhere; write only under `data_dir()` |
| G-code `execute()` | `Loading` | + write under the current temp G-code folder |
| Script `execute()` | `Loading` | read anywhere; write only under `data_dir()` |
| Printer-agent methods | `Loading` | read anywhere; write only under `data_dir()` |

> [!NOTE]
> Modes are chosen at each trampoline call site, so this table reflects the current source;
> always check the actual `ORCA_PY_OVERRIDE_AUDITED(...)` call when in doubt.

## Limitations

This version is deliberately minimal. Do **not** treat it as a hardened sandbox. Known gaps:

- **Only the `open` event is enforced.** `subprocess.Popen`, `os.system`, `socket.*`,
  `ctypes.*` and friends are *not* blocked. (The `Enforcing` enum comment describes an
  aspiration, not current behavior.)
- **Non-string paths slip through the `open` check.** The audit callback parses only a
  string path (`"s|si"`); any `open`-event call whose first argument is bytes or an integer
  file descriptor, including `os.open`, which additionally passes `mode = None`, fails the
  parse and is allowed. Low-level and non-`str` opens are currently unaudited.
- **`open(path, "x")`** (exclusive create, a write) contains no `w`/`a`/`+`, so it is
  classified as a read and allowed under `Loading`.
- **Non-`open` filesystem mutations are unaudited.** `os.remove`, `os.rename`, `os.mkdir`,
  `shutil.*` raise their own events, which we don't yet handle. A plugin can delete or
  rename files outside `data_dir()` without tripping anything.
- Enforcement is **per process / per thread** via thread-locals; code that hops threads
  without re-establishing a context runs unaudited.

Closing these gaps (especially the filesystem-mutation events and `os.open` flags) is the
natural next step for anyone hardening this into a real write-sandbox.

## Debugging

Enforcement only fires while a context is active, and the read/write distinction trips
people up, so when something is unexpectedly blocked (or unexpectedly allowed), get the
facts first.

**Temporary block log.** `check_open` logs each block just before returning, including the
mode that was actually live:

```
[AUDIT] block path=/tmp open_mode=w audit_mode=Loading plugin=local:.../Environment_Report_Script_
```

Read it field by field:

- `open_mode=w` -> it's a **write**. Under `Loading`, writes outside the allow-list are
  *supposed* to be blocked. A blocked `open_mode=r` under `audit_mode=Loading` is
  impossible from current source; if you see it, your binary is stale (see below).
- `audit_mode=` -> tells you whether the live call site is `Loading` or `Enforcing`, which
  is the quickest way to confirm a trampoline change actually took effect.
- `path=` -> the resolved path that failed the allow-list. Compare against `data_dir()`.

The permanent `report_violation` log (`[AUDIT BLOCKED] ...`) fires on the same blocks and
includes the plugin key, event name, path, and reason.

**Common pitfalls**

- **Read vs write.** `Loading` never blocks a read. If a "read" is blocked, it's actually a
  write (check `open_mode`), or the mode is `Enforcing`.
- **Stale / incremental builds.** `PyPluginTrampoline.hpp` and `PluginAuditManager.hpp` are
  included by many translation units. A header-only change (e.g. flipping a trampoline's
  mode) may not propagate with an incremental build. If runtime behavior contradicts the
  source, do a clean rebuild of the affected targets. `PluginAuditManager.cpp` changes are
  a single-TU recompile + relink.
- **No context = no enforcement.** If a plugin's calls are never audited, check that its
  instance got `set_audit_plugin_key()` (non-empty key) and that the method actually wraps
  through `ORCA_PY_OVERRIDE_AUDITED`.

## Key Files

| File | Responsibility |
|---|---|
| `src/slic3r/plugin/PluginAuditManager.{hpp,cpp}` | modes, allowed roots, `audit_hook`, `check_open`, `ScopedPluginAuditContext` |
| `src/slic3r/plugin/PyPluginTrampoline.hpp` | the `ORCA_PY_*` macros (logging + audit context) |
| `src/slic3r/plugin/PythonPluginInterface.hpp` | the per-instance audit identity |
| `src/slic3r/plugin/PluginLoader.cpp` | stamps the audit key at load / key migration |
| `src/slic3r/plugin/pluginTypes/*/*Trampoline.hpp` | per-plugin-type methods and their chosen modes |
| `src/slic3r/plugin/PythonInterpreter.cpp` | installs the hook once at interpreter init |
