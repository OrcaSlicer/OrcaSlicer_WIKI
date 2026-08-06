# Registry

The embedded plugin API is exposed through a single Python module named `orca`
(`PYBIND11_EMBEDDED_MODULE(orca, ...)` in `PythonPluginBridge.cpp`). It provides the
capability base classes, the package base, result types, and capability registration.

| Symbol | Kind | Members / purpose |
|---|---|---|
| `orca.PluginType` | enum | `PrinterConnection`, `Automation`, `Analysis`, `Importer`, `Exporter`, `Visualization`, `Script`, `SlicingPipeline`, `Unknown` |
| `orca.PluginResult` | enum | `Success`, `Skipped`, `RecoverableError`, `FatalError` |
| `orca.PluginContext` | class | base context, field `orca_version: str` |
| `orca.ExecutionResult` | class | fields `status`, `message`, `data`; factories below |
| `orca.PythonPluginBase` | class | the root **capability** base; subclasses must implement `get_name()` |
| `orca.base` | class | the **package** base; subclass it and override `register_capabilities()` |
| `orca.plugin` | decorator | marks the single package class for the file (exactly one per file) |
| `orca.register_capability(cls)` | function | register one capability class; call it inside `register_capabilities()` |
| `orca.slicing` | submodule | [Slicing Pipeline](slicing): `Step`, `SlicingPipelineContext`, `SlicingPipelineCapabilityBase` |
| `orca.script` | submodule | [Script](script): `ScriptPluginCapabilityBase` |
| `orca.printer_agent` | submodule | [Printer Agent](printer_agent): `PrinterAgentBase` and its data types |
| `orca.host` | submodule | [Host](host): read-only host access to the live model, presets, and mesh geometry |
| `orca.host.ui` | submodule | [Host UI](host_ui): dialogs, progress dialogs, and interactive windows |

Every capability also inherits configuration methods from `orca.PythonPluginBase`:

| Method | Purpose |
|---|---|
| `has_config_ui()` | Select a custom HTML editor instead of the host JSON editor. |
| `get_config_ui()` | Return the custom HTML editor page. |
| `get_default_config()` | Return a Python dict used by **Restore defaults**; the Python call returns its JSON string. |
| `get_config()` | Return the effective configuration as a JSON string. |
| `get_config_version()` | Return the version that last saved the configuration. |
| `save_config(config)` | Persist a JSON string for this capability; returns `False` on invalid JSON or write failure. |

Use `json.loads()` and `json.dumps()` at this boundary. See
[Capability configuration](plugin_development#capability-configuration) for storage layers and
custom UI messaging.

## Execution Results

`ExecutionResult` is how a plugin reports the outcome of a run:

```python
orca.ExecutionResult.success(message="", data="")
orca.ExecutionResult.skipped(message="")
orca.ExecutionResult.failure(status, message, data="")   # status is an orca.PluginResult
```

- `status` - an `orca.PluginResult`.
- `message` - human-readable text; this is what surfaces in error/result dialogs.
- `data` - a free-form string whose meaning is defined by the plugin/workflow (not
  interpreted by the framework).

## Registration

Registration has two parts, both resolved at **module import / load time**.

**Capabilities** - each capability is a class that subclasses a typed base and implements
`get_name(self) -> str`. The name is how the capability appears in the UI and how presets
refer to it, so it must be **unique within the plugin** and **must not contain a `;`**. That
character is reserved as a separator in preset references, and a `;` in a capability name
fails the load.

**The package** - exactly one class per file is decorated with `@orca.plugin` and subclasses
`orca.base`. Its `register_capabilities(self)` method calls `orca.register_capability(Cls)`
once for each capability class you want to expose:

```python
@orca.plugin
class SamplePlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(GCodeBenchmark)
        orca.register_capability(EnvironmentReport)
```

OrcaSlicer instantiates the package class (it must be callable as `SamplePlugin()` with no
arguments), calls `register_capabilities()`, then instantiates each registered capability.

Rules enforced when a plugin loads (most in `PythonPluginBridge.cpp`):

- The `@orca.plugin` class **must** subclass `orca.base`, and there must be **exactly one**
  per file. A second `@orca.plugin` fails the load.
- Each class passed to `orca.register_capability` must subclass a capability base (ultimately
  `orca.PythonPluginBase`); otherwise it raises `value_error`.
- Every capability must resolve `get_name()` (checked in the bridge); the loader
  (`PluginLoader.cpp`) additionally rejects the plugin if the resulting `(type, name)` pair is
  not unique across it.
- A capability class you never pass to `orca.register_capability` is **invisible** to
  OrcaSlicer, even if it is defined in the file.

## Capability Names and Types

`get_name()` is required; `get_type()` usually is not. Every capability must implement
`get_name()`. It is pure virtual on the root base, and a missing override fails the load.
The typed C++ bases already implement `get_type()` (for example,
`ScriptPluginCapability::get_type()` returns `Script`), so a subclass of a *typed* base does
not need to override it. Only a capability that subclasses the **root**
`orca.PythonPluginBase` directly must set its own `get_type()`.
