# Visualization

The `orca.visualization` module exposes `VisualizationPluginCapabilityBase` for plugins that
consume OrcaSlicer's complete final FFF Preview scene. OrcaSlicer publishes the scene as an
immutable [ORPM v1](orpm_v1) file and passes only its typed descriptor to Python. Standard
Preview remains available if no visualizer is installed or a visualizer fails.

| Base class | `get_type()` returns | Required methods | Invoked by |
|---|---|---|---|
| `orca.visualization.VisualizationPluginCapabilityBase` | `Visualization` | `get_name()`, `open(self, ctx) -> ExecutionResult`, `update(self, ctx) -> ExecutionResult` | the Preview **Visualize** action and later completed FFF scenes |

`close(self) -> None` is optional and defaults to doing nothing. Implement it when the
capability owns a window, renderer, mapping, or other session resource.

## Context

`open()` and `update()` receive an
`orca.visualization.VisualizationContext` with these fields:

| Field | Type | Meaning |
|---|---|---|
| `orca_version` | `str` | OrcaSlicer version string inherited from `PluginContext` |
| `scene_id` | `int` | process-scoped identity of the completed slice result |
| `plate_index` | `int` | zero-based plate index; `-1` means no plate |
| `geometry_path` | `str` | absolute path to the immutable, fully published snapshot |
| `geometry_format` | `str` | `"ORPM"` in v1 |
| `geometry_major_version` | `int` | ORPM major version, `1` in v1 |
| `geometry_minor_version` | `int` | ORPM minor version, `0` in v1 |

Treat the context and snapshot as read-only. Detailed scene data belongs in ORPM; there is no
schema-less metadata field and Python does not receive Preview vertex or index arrays.

## Session and Snapshot Lifecycle

OrcaSlicer keeps at most **one active session per capability identity** (plugin key, type, and
capability name):

1. `open(ctx)` is called with a complete, atomically published scene. Returning `Success`
   starts the session.
2. `update(ctx)` is called only while that session is active and only for a different completed
   scene. Returning `Success` replaces the session's current snapshot.
3. `close()` ends the session. It is called for capability disable/unload, an incompatible
   printer-technology change, application shutdown, and other host teardown. Implement it as
   idempotent because cleanup code may also call it defensively.

A snapshot passed to a successful `open()` remains valid until a successful `update()` or
`close()`. A snapshot passed to a successful `update()` then has the same lifetime. If an
update is skipped, fails, raises, or is cancelled, the previous successful snapshot remains
valid and the rejected snapshot is removed. Do not delete, rename, or modify a host-owned
snapshot, and do not retain it after replacement or close.

ORPM v1 always contains the **complete final FFF extrusion scene**. Preview layer-slider and
feature visibility do not truncate it, and travel moves are not included. Visualization is not
invoked for a non-FFF result or before a complete final scene exists.

## Threading and Callbacks

Snapshot capture runs synchronously in the Preview workflow without entering Python. ORPM
serialization and publication then run on a host worker. OrcaSlicer invokes Python only after
publication, holds the GIL for each capability call, and serializes calls for a capability. Host
lifecycle can initiate cleanup from a different host thread, so do not rely on callback thread
identity.

`open()`, `update()`, and `close()` must return quickly. Use them to validate the descriptor and
signal an already managed renderer or worker; do not parse or render a large scene synchronously
in Python. A newer request can supersede pending work, and no cancelled request is intentionally
entered after capability unload or interpreter shutdown begins.

Plugins must not import wxPython, Qt, Tk, or another GUI toolkit. A second GUI event loop can
conflict with OrcaSlicer's wxWidgets loop, especially during unload. Use host-owned UI from
[`orca.host.ui`](host_ui) for plugin dialogs and windows. Visualization does not add a
host-managed subprocess API or grant special process permissions.

## Results and Errors

Use the shared factories described in [Registry](registry):

- `ExecutionResult.success()` accepts the new scene. OrcaSlicer commits the session or update.
- `ExecutionResult.skipped(message)` declines it without treating the callback as an error.
- `RecoverableError` reports the problem, preserves standard Preview, and leaves an existing
  successful session and snapshot available for a later update.
- `FatalError` reports the problem and closes only the affected visualization session according
  to the plugin capability failure policy.
- An uncaught Python exception is logged with its traceback and surfaced as a capability error;
  it must not close or replace standard Preview.

Do not return `Success` until every consumer that needs the new path has accepted it. OrcaSlicer
may release the previous snapshot as soon as a successful `update()` returns.

## Audit Mode

Visualization callbacks use the audit hook's `Loading` mode. This allows normal module reads and
lazy imports while retaining the current write restriction to approved plugin/data storage. It
is required because `open()` may be the first time a visualizer imports its reader or renderer
adapter. No extra global or per-call writable root is granted for visualization, and the mode is
not a subprocess permission. See [Plugin Audit Hook](plugin_audit_hook) for the enforced policy
and its limitations.

## Minimal Dummy Visualizer

This visualizer verifies the typed descriptor and ORPM magic, records the accepted scene, and
performs no rendering. It is useful for checking registration and lifecycle behavior without a
GUI toolkit or renderer dependency.

```python
# /// script
# [tool.orcaslicer.plugin]
# name = "Dummy Visualizer"
# description = "Validates visualization lifecycle and ORPM publication."
# author = "Your Name"
# version = "1.0.0"
# ///
from pathlib import Path

import orca


class DummyVisualizer(orca.visualization.VisualizationPluginCapabilityBase):
    def __init__(self):
        self.scene_id = None
        self.geometry_path = None

    def get_name(self):
        return "Dummy Visualizer"

    @staticmethod
    def _accept(ctx):
        if (ctx.geometry_format, ctx.geometry_major_version) != ("ORPM", 1):
            return orca.ExecutionResult.failure(
                orca.PluginResult.RecoverableError,
                "Unsupported visualization geometry format")
        path = Path(ctx.geometry_path)
        with path.open("rb") as snapshot:
            if snapshot.read(4) != b"ORPM":
                return orca.ExecutionResult.failure(
                    orca.PluginResult.RecoverableError,
                    "Invalid ORPM snapshot")
        return orca.ExecutionResult.success()

    def open(self, ctx):
        result = self._accept(ctx)
        if result.status == orca.PluginResult.Success:
            self.scene_id = ctx.scene_id
            self.geometry_path = ctx.geometry_path
        return result

    def update(self, ctx):
        result = self._accept(ctx)
        if result.status == orca.PluginResult.Success:
            self.scene_id = ctx.scene_id
            self.geometry_path = ctx.geometry_path
        return result

    def close(self):
        self.scene_id = None
        self.geometry_path = None


@orca.plugin
class DummyVisualizerPlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(DummyVisualizer)
```

This example intentionally does only a bounded header check in the callback. A real consumer
must validate the complete [ORPM v1](orpm_v1) file before using any record or offset, preferably
outside Python.
