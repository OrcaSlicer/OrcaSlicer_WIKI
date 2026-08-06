# Script

The `orca.script` module exposes `ScriptPluginCapabilityBase` for plugins that run from the
Plugins dialog.

| Base class | `get_type()` returns | Required methods | Invoked by |
|---|---|---|---|
| `orca.script.ScriptPluginCapabilityBase` | `Script` | `get_name()`, `execute(self) -> ExecutionResult` | the **Plugins dialog -> Run** action |

Lifecycle hooks `on_load()` / `on_unload()` are optional and available on every capability
(defaults do nothing).

> [!IMPORTANT]
> `ScriptPluginCapabilityBase.execute()` runs on the **main/UI thread**: live host handles are
> safe to read for the whole call and `orca.host.ui` dialogs open inline, but a slow
> `execute()` **freezes the UI**. Keep it quick; offload heavy work to your own
> `threading.Thread` (which must not touch the model) and surface results through a
> `create_window` panel.

## Minimal Shape

```python
import orca

class HelloScript(orca.script.ScriptPluginCapabilityBase):
    def get_name(self):
        return "Hello Script"

    def execute(self):
        return orca.ExecutionResult.success("Hello from a script plugin")
```

See [Registry](registry) for `ExecutionResult`, package registration, and capability name
rules.
