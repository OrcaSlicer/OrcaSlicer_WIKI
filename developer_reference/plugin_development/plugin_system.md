# Plugin System Overview

This page describes the architecture of OrcaSlicer's Python plugin system. Python plugins
run inside an embedded CPython interpreter, so users can extend OrcaSlicer without
recompiling the application or patching the C++ core.

The other plugin development pages cover the implementation details:

- [Plugin Development](plugin_development) - how to write a Python plugin and how to
  add a new plugin type in C++.
- [API Reference](registry) - the embedded `orca` module, registration,
  host access, UI helpers, and each capability module.
- [Plugin Audit Hook](plugin_audit_hook) - the CPython audit hook that constrains
  what plugin code may do.

> [!NOTE]
> All paths below are under `src/slic3r/plugin/` unless stated otherwise.

## What the System Provides

- **Extensibility without rebuilding** - users drop a plugin into a folder (or subscribe to
  one from the cloud) and OrcaSlicer loads it.
- **Capabilities, not single-purpose plugins** - one plugin is a *package* that registers one
  or more **capabilities**, each a typed unit of functionality (e.g. `post-processing`,
  `script`, `printer-connection`). Each capability type has a fixed C++ entry point and is
  invoked at a specific place in the app; a plugin's "types" are simply the set of capability
  types it registers.
- **Presets remember the plugins they use** - when a preset references a plugin capability,
  the full reference is stored in the preset and can be restored from OrcaCloud on another
  machine (see [Plugin references in presets](#plugin-references-in-presets)).
- **A single, narrow API surface** - plugins see only the embedded `orca` module, not the
  slicer internals.
- **A security boundary** - file access by plugin code is filtered by an audit hook with a
  write allow-list (groundwork; see the audit doc for current scope).
- **Isolation of failure** - a misbehaving plugin reports an error and is unloaded rather
  than taking down the app; tracebacks are persisted to a log file.

## Architecture Overview

```
                         ┌──────────────────────────────────────────────┐
        app startup ───► │  PluginManager  (singleton orchestrator)       │
   (GUI_App::OnInit)     │   owns: CloudPluginService, PluginCatalog,     │
                         │         PluginLoader                           │
                         └───────┬───────────────┬───────────────┬───────┘
                                 │               │               │
                 discover (scan) │     install/  │   load/unload │
                                 ▼      download  ▼               ▼
                    ┌──────────────────┐  ┌───────────────┐  ┌────────────────────┐
                    │  PluginCatalog   │  │ CloudPlugin   │  │   PluginLoader     │
                    │  manifest-only   │  │ Service       │  │  threaded loads,   │
                    │  inventory of    │  │ (cloud fetch/ │  │  deps (uv), audit  │
                    │  PluginDescriptor│  │  download)    │  │  key, capabilities │
                    └──────────────────┘  └───────────────┘  └─────────┬──────────┘
                                                                       │ instantiates via
                                                                       ▼
   ┌─────────────────────────────────────────────────────────────────────────────────┐
   │                       Embedded CPython  (PythonInterpreter, singleton)            │
   │   PythonPluginBridge → `orca` module + @orca.plugin/register_capability + capture │
   │   PyPluginTrampoline → C++↔Python call boundary (traceback logging + audit scope) │
   │   PluginAuditManager → CPython audit hook (filesystem policy)                     │
   │   pluginTypes/* (gcode, script, printerAgent) → typed capability bases + tramps   │
   └─────────────────────────────────────────────────────────────────────────────────┘
                                                                       │ get_plugin_capability_* + dynamic_pointer_cast
                                                                       ▼
   workflow call sites:  PostProcessor (G-code post-processing) ·
                         PluginsDialog "Run" (script) · NetworkAgentFactory (printer agent)
```

There are two broad layers:

- **Orchestration (C++, no Python):** `PluginManager`, `PluginCatalog`, `CloudPluginService`,
  `PluginLoader`, `PluginDescriptor`. These discover, install, and manage plugins as data.
- **Execution (the C++ to Python bridge):** `PythonInterpreter`, `PythonPluginBridge`,
  `PyPluginTrampoline`, `PluginAuditManager`, and the per-type bases under `pluginTypes/`.
  These turn a discovered plugin into a live object the app can call.

## Core Components

| Component | Responsibility |
|---|---|
| `PluginManager` | Top-level **singleton orchestrator**. Owns the catalog, loader, and cloud service; exposes `initialize()`, `discover_plugins()`, install/update/delete, and `shutdown()`. |
| `PluginCatalog` | **Manifest-only inventory.** Scans the plugin directories, parses each plugin's metadata into a `PluginDescriptor`, and splits results into valid vs. invalid. Loads no Python. |
| `CloudPluginService` | Thin wrapper over the cloud agent: fetch subscribed/owned plugin manifests, download a plugin payload, unsubscribe/delete. |
| `PluginLoader` | **Load/unload lifecycle.** Installs dependencies (bundled `uv`), imports the module, instantiates the package and its capabilities, stamps their audit identity, runs `on_load()`, and keeps the live capability instances keyed by a `PluginCapabilityIdentifier`. Provides `get_plugin_capabilities_by_type()` / `get_plugin_capability_by_name()` and on-load/unload + on-capability-load/unload callbacks. |
| `PluginDescriptor` | The canonical record for one plugin: key, paths, capability/display types, version, changelog, dependencies, cloud overlay, and any error/validity state. |
| `PythonInterpreter` | **Singleton RAII wrapper around embedded CPython.** Init/finalize, GIL handoff, `sys.path`, module loading, and installing the audit hook + stderr-to-log redirect. |
| `PythonPluginBridge` | Defines the embedded **`orca` module**, the `@orca.plugin` decorator + `orca.base` package class + `register_capability` entry, and captures/instantiates the package and the capability classes it registers. |
| `PyPluginTrampoline` | The pybind11 override base at the **C++ to Python boundary**: logs Python tracebacks and opens the per-call audit scope. |
| `pluginTypes/*` | Per-type C++ capability bases + trampolines (`SlicingPipelinePluginCapability`, `ScriptPluginCapability`, `PrinterAgentPluginCapability`) that define each type's entry method and dispatch. |
| `PluginAuditManager` | **Singleton CPython audit hook**: filesystem policy (write allow-list), scoped roots, `Loading`/`Enforcing` modes. See the audit doc. |

## Plugin Packaging and Discovery

A plugin is a folder under one of two roots, containing a single **entry file**:

| Root | Source |
|---|---|
| `data_dir()/orca_plugins/` | locally installed / side-loaded |
| `data_dir()/orca_plugins/_subscribed/<user_id>/` | cloud-subscribed (per logged-in user) |

The entry file is either a single **`.py`** file (metadata in a PEP 723 comment block) or a
**`.whl`** wheel (metadata from the wheel's `METADATA`). The **capabilities** the plugin
registers determine which workflows can run it; there is no separate `type` declaration in the
metadata. Metadata and packaging details are in
[Plugin Development](plugin_development).

**Discovery vs. loading are separate stages.** `PluginCatalog` *scans* directories and
produces `PluginDescriptor`s; it parses manifests only and never executes plugin code. A
*catalog entry* is just data; a *loaded plugin* is a live Python instance created later by
`PluginLoader`. Cloud manifests are merged into the catalog as an overlay once a user is
logged in.

## Plugin Lifecycle

```
1. App startup (GUI_App::OnInit, after network init)
        │
2. PluginManager::initialize()
        │   └─ PythonInterpreter::initialize()  (MAIN THREAD ONLY)
        │        ├─ start embedded CPython, set sys.path / python home
        │        ├─ install the audit hook (global allowed root = data_dir())
        │        ├─ tee sys.stderr → data_dir()/log/python_*.log
        │        └─ release the GIL (PyEval_SaveThread)
        │
3. discover_plugins()  ─► PluginCatalog scans local + cloud roots
        │                   → PluginDescriptor list (valid / invalid)
        │   (cloud login later: fetch_plugins_from_cloud → catalog overlay)
        │
4. PluginLoader::load_plugin()  (worker thread, serialized)
        │   ├─ install dependencies via bundled `uv`; extract bundled .whl deps onto sys.path
        │   ├─ begin capture → import module (runs @orca.plugin, marking the package class)
        │   ├─ finalize capture → instantiate package, call register_capabilities(),
        │   │      then instantiate each registered capability and cache its get_name()
        │   ├─ set_audit_plugin_key(descriptor.plugin_key)   // audit identity
        │   ├─ on_load()  (under the GIL)
        │   └─ store the capabilities; fire on-load + on-capability-load callbacks
        │
5. Use:  a workflow call site resolves a capability (get_plugin_capability_by_name /
        │   get_plugin_capabilities_by_type) + dynamic_pointer_cast<TypeCapability>,
        │   builds the type's context, and calls the entry method (under the GIL).
        │   Each call crosses a trampoline that opens a ScopedPluginAuditContext.
        │
6. Unload / shutdown:  set_shutting_down → unload_plugin / unload_all_plugins
            (the instance's destructor runs on_unload() + Py_DECREF under the GIL)
            → PythonInterpreter::shutdown()
```

A few load-time invariants worth knowing:

- **`set_audit_plugin_key()` is what arms enforcement.** Without it the instance has an empty
  key and its calls run unaudited. It is stamped at load and re-stamped on key migration
  (`update_loaded_plugin_key`). See the audit doc.
- A module must mark exactly one package class with `@orca.plugin` (a subclass of
  `orca.base`), and that class's `register_capabilities()` must register at least one valid
  capability via `orca.register_capability(...)`, or the load fails. Each capability must
  resolve `get_name()`, and `(type, name)` must be unique within the plugin.

## Execution Model

Capabilities are reached **by type, not by name**. There is no per-type instantiation
registry: a capability's Python class subclasses a typed C++ base, the package registers it
via `register_capability`, and each workflow call site narrows the stored capability instance
(`PluginCapabilityInterface`) with `std::dynamic_pointer_cast<ConcreteType>`. If the cast
succeeds, the capability is present and is invoked; if not (no such capability installed or
enabled), the path is a no-op. This is how the system guarantees that absent/disabled
capabilities never change existing behavior.

| Capability type | Entry method | Invoked by |
|---|---|---|
| `slicing-pipeline` | `execute(ctx)` | `Print` at configured slicing steps, and `PostProcessor` at `psGCodePostProcess` during G-code export |
| `script` | `execute()` | the **Plugins dialog -> Run** action |
| `printer-connection` | agent methods | `NetworkAgentFactory`, registered through a loader on-capability-load callback wired in `GUI_App` |

The on-load / on-unload **callbacks** (`PluginLoader::subscribe_on_load_callback` /
`subscribe_on_unload_callback`) and the per-capability variants
(`subscribe_on_capability_load_callback` / `subscribe_on_capability_unload_callback`) are how
subsystems react to plugins and capabilities appearing or disappearing. For example, the
printer-agent layer registers/deregisters an agent for each `PrinterConnection` capability,
and the Plugins dialog refreshes. Adding a new type and wiring a call site is covered in
[Plugin Development](plugin_development).

## Threading and GIL

- **The interpreter is initialized on the main thread.** CPython is started once via
  `PythonInterpreter` (singleton). Initializing it off the main thread risks heap
  corruption, so `PluginManager::initialize()` does it eagerly and synchronously.
- **After init the GIL is released** (`PyEval_SaveThread`) and reacquired at shutdown, so
  other threads may take it.
- **Plugin loads run on worker threads**, serialized by a static mutex so module imports
  don't race. Discovery can also run on a background thread (`discover_plugins(async=true)`),
  though startup discovery is synchronous.
- **Every touch of Python from a non-main thread acquires the GIL** through the
  `PythonGILState` RAII guard (`PyGILState_Ensure` / `Release`) - load, execute, and the
  instance destructor (`on_unload` + `Py_DECREF`) all wrap in it.

## Cloud Subscriptions

`CloudPluginService` wraps the cloud agent (`OrcaCloudServiceAgent`) and is gated on login.
It fetches the manifests of subscribed/owned plugins, merges them into the catalog as an
overlay, and downloads a plugin's payload (sniffing the file to tell a `.whl` from a `.py`)
to a temporary file. `PluginManager` sets the loader's cloud user id, and `PluginLoader`
installs the downloaded payload under `orca_plugins/_subscribed/<user_id>/`. Logging out
unloads cloud plugins. The cloud auth token (`orca_refresh_token.sec`) is owned by the cloud
agent, not by the plugin layer.

## Plugin References in Presets

When a setting points at a plugin capability (for example `post_process_plugin`), the value
the setting stores is just the capability's **name**. So that the reference survives being
copied to another machine where the plugin might not be installed, each preset also carries
a `plugins` array that records the **full reference** for every capability it uses.

Each entry is a single string with three `;`-separated fields:

```
<plugin_name>;<cloud_uuid>;<capability_name>
```

```json
{
  "plugins": [
    "Sample Plugin;1f998ea9-0183-4cc5-957f-4eef659ba4e6;G-code Benchmark (.py)",
    "master_plugin;;header-stamp"
  ],
  "post_process_plugin": ["G-code Benchmark (.py)", "header-stamp"]
}
```

- The **`cloud_uuid`** is present for plugins subscribed from OrcaCloud and **empty** for
  local-only plugins (note the adjacent `;;`). It is what lets OrcaSlicer offer to restore a
  missing plugin automatically.
- Because `;` is the field separator, a **capability name may not contain `;`** (the loader
  rejects such a plugin), and plugin display names have any `;` replaced with `_`
  (`sanitize_plugin_name`).
- The `plugins` array is an internal manifest (`coStrings`, `comDevelop` mode), not a
  user-edited field. Fields that hold a capability name are flagged `support_plugin`; on
  save the array is **pruned** to only the references still used by such a field, so stale
  entries drop out.
- Parsing/serialization lives in `Config.cpp` (`parse_capability_ref` ->
  `PluginCapabilityRef{ name, capability_name, uuid }`); the `plugins` option is defined in
  `PrintConfig.cpp` and is tracked on **process, printer, and filament** presets. See
  `tests/libslic3r/test_config.cpp` and
  `tests/slic3rutils/test_plugin_capability_identifier.cpp`.

## Restoring Missing Plugins

When you prepare to slice, OrcaSlicer resolves the active process, printer, and filament
presets' `plugins` arrays against the loaded catalog (`Plater::refresh_missing_plugin_block`).
Any reference it cannot satisfy is surfaced as a **non-closable notification**, and while any
remain, the **Slice button stays blocked**. There is no "slice anyway" path; you resolve the
reference (or change the setting that pulls it in). References are sorted into four buckets:

- **Missing OrcaCloud plugins** (ref carries a UUID) - notification action **Install Plugins**,
  which subscribes to, installs, loads, and enables each one so it becomes usable immediately.
- **Missing local plugins** (no UUID) - cannot be fetched automatically; the action **Find on
  OrcaCloud** just opens a browser search on the OrcaCloud plugins page. It is a suggestion
  only: it neither closes the notification nor unblocks slicing.
- **Inactive plugins** - the package is installed locally but the referenced capability is not
  active (plugin not loaded, or capability disabled). Action **Activate Now** loads/enables it
  locally, with no download.
- **Broken references** - the plugin is installed and loaded but no longer provides the
  referenced capability (renamed/removed/outdated). Activation cannot fix this, so it is
  informational, with **Find on OrcaCloud** to look for an update.

The bucketing lives in `PluginResolver` (`get_missing_cloud_plugins`, `get_missing_local_plugins`,
`get_inactive_plugins`, `get_broken_plugins`); the notifications and the slice block are driven
from `Plater.cpp` (`refresh_missing_plugin_block`).

## The Plugins Dialog

The Plugins dialog (`PluginsDialog.cpp` + `resources/web/dialog/PluginsDialog/`) presents each
installed plugin as an expandable row (Activate · Name · Version · Status). Expanding a plugin
shows a **capability tree**: one row per registered capability with its own enable checkbox,
type label, and (for runnable script capabilities) a **Run** button. The details pane is
tabbed:

| Tab | Shows |
|---|---|
| **Plugin Info** | thumbnail, source, types, author, version (with an update badge) |
| **Description** | the plugin's own description, taken from its Python/wheel metadata |
| **Config** | JSON or custom configuration for the selected plugin capabilities |
| **Changelog** | version / date / changes table |
| **Diagnostics** | load status and any error state |

Installing is done from a **Browse plugins** split dropdown that opens the OrcaCloud plugins
hub, with an **Install local plugin** option for side-loading a `.py` or `.whl` directly.
Per-plugin and per-capability enablement is persisted in a per-plugin `.install_state.json`
sidecar (written by `PluginManager`).

## Security and Observability

- **Security** - all C++ to Python calls cross a trampoline that opens a per-call audit context;
  the `PluginAuditManager` audit hook then filters sensitive operations (today: a filesystem
  write allow-list rooted at `data_dir()`, plus scoped roots such as the current G-code
  folder). This is groundwork, not a hardened sandbox; read
  [Plugin Audit Hook](plugin_audit_hook) for exactly what is and isn't enforced.
- **Observability** - Python `sys.stderr` (plugin tracebacks, including from
  plugin-spawned threads) is teed to `data_dir()/log/python_*.log`; C++-side
  load/discovery messages go to the main session log. How errors surface in the UI (message
  box vs. the plugin details area) is described in
  [Plugin Development](plugin_development#how-errors-are-surfaced).

## Related Documents

- [Plugin Development](plugin_development) - authoring Python plugins; adding a new
  C++ plugin type; testing and debugging.
- [API Reference](registry) - the embedded `orca` module, registration,
  host access, UI helpers, and each capability module.
- [Plugin Audit Hook](plugin_audit_hook) - the audit hook: modes, allow-list,
  extending the policy.

## Key Files

| File | Role |
|---|---|
| `src/slic3r/plugin/PluginManager.{hpp,cpp}` | top-level orchestrator; startup `initialize()` / `discover_plugins()` / `shutdown()` |
| `src/slic3r/plugin/PluginCatalog.{hpp,cpp}` | directory scan -> `PluginDescriptor` inventory |
| `src/slic3r/plugin/PluginLoader.{hpp,cpp}` | threaded load/unload, dependency install, capability registry, audit-key stamping |
| `src/slic3r/plugin/PluginDescriptor.hpp` | the per-plugin record (types, changelog, `sanitize_plugin_name`) |
| `src/slic3r/plugin/CloudPluginService.{hpp,cpp}` | cloud fetch / download / subscribe / unsubscribe |
| `src/slic3r/plugin/PythonInterpreter.{hpp,cpp}` | embedded CPython, GIL handoff, audit-hook + log install |
| `src/slic3r/plugin/PythonPluginBridge.{hpp,cpp}` | the `orca` module, `@orca.plugin` / `register_capability`, package + capability capture |
| `src/slic3r/plugin/PyPluginPackage.hpp` | the package base (`orca.base`) + `register_capabilities` |
| `src/slic3r/plugin/PyPluginTrampoline.hpp` | C++ to Python boundary macros (traceback logging + audit scope) |
| `src/slic3r/plugin/pluginTypes/*` | per-type capability bases + trampolines |
| `src/slic3r/plugin/PluginAuditManager.{hpp,cpp}` | the CPython audit hook and policy |
| `src/libslic3r/Config.cpp` | `parse_capability_ref`, the `plugins` array (de)serialization |
| `src/libslic3r/PrintConfig.cpp` | the `plugins` / `post_process_plugin` option definitions |
| `src/slic3r/GUI/PostProcessor.cpp` | resolves preset plugin refs and runs the `psGCodePostProcess` slicing-pipeline step |
| `src/slic3r/GUI/PluginPickerDialog.{hpp,cpp}` | pick a capability as a setting value |
| `src/slic3r/GUI/Plater.cpp` | the missing-plugins resolution dialog on slice (`reslice`) |
| `src/slic3r/GUI/GUI_App.cpp` | startup wiring (init, discovery, on-load / on-capability-load callbacks) and shutdown |
| `src/slic3r/GUI/PluginsDialog.cpp` | the Plugins dialog (capability tree, tabs, Run, Browse plugins) |
| `src/slic3r/plugin/PluginConfig.{hpp,cpp}` | global capability config, preset overrides, and JSON/custom UI responses |
