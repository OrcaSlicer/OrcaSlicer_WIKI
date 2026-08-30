# Visualization

The `orca.visualization` module exposes `VisualizationPluginCapabilityBase` for plugins that
consume OrcaSlicer's complete final FFF Preview scene. A capability declares acceptable inputs,
then OrcaSlicer publishes a negotiated immutable resource and passes its typed descriptor to Python. Standard
Preview remains available if no visualizer is installed or a visualizer fails.

| Base class | `get_type()` returns | Required methods | Invoked by |
|---|---|---|---|
| `orca.visualization.VisualizationPluginCapabilityBase` | `Visualization` | `get_name()`, `get_supported_inputs()`, `open(self, ctx) -> ExecutionResult`, `update(self, ctx) -> ExecutionResult` | the Preview **Visualize** action and later completed FFF scenes |

`close(self) -> None` is optional and defaults to doing nothing. Implement it when the
capability owns a window, renderer, mapping, or other session resource.

## Context

`open()` and `update()` receive an
`orca.visualization.VisualizationContext` with these fields:

| Field | Type | Meaning |
|---|---|---|
| `orca_version` | `str` | OrcaSlicer version string inherited from `PluginContext` |
| `revision` | `int` | monotonically increasing identity of the source content |
| `input` | `VisualizationInput` | negotiated immutable resource descriptor |
| `metadata` | `dict[str, str]` | optional producer strings; currently includes `plate_index` |

`input` exposes read-only `kind`, `format`, `transport`, `location`, `major_version`, and
`minor_version` fields. Treat the context and resource as read-only and ignore unknown metadata.

## Input negotiation

`get_supported_inputs()` is called once while the capability is materialized. Return one or more
`VisualizationInputSpec` alternatives. Identifiers are case-sensitive, and version bounds are
inclusive `(major, minor)` pairs. OrcaSlicer currently produces file-transport toolpaths as GLB,
STL, OBJ, or Draco and selects the first declared format it can produce.

GLB is the rich toolpath format: it retains normals, UVs, material slots, primitive metadata, and
Orca scene metadata. STL, OBJ, and Draco are geometry-only alternatives. The built-in constants
are `INPUT_TOOLPATH`, `FORMAT_GLTF_BINARY`, `FORMAT_STL`, `FORMAT_OBJ`, `FORMAT_DRACO`, and
`TRANSPORT_FILE`.

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

The toolpath input contains the **complete final FFF extrusion scene**. Preview layer-slider and
feature visibility do not truncate it, and travel moves are not included. Visualization is not
invoked for a non-FFF result or before a complete final scene exists.

## Threading and Callbacks

Snapshot capture runs synchronously in the Preview workflow without entering Python. Resource
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

This visualizer negotiates GLB and verifies its typed descriptor and magic, then records the accepted revision.
performs no rendering. It is useful for checking registration and lifecycle behavior without a
GUI toolkit or renderer dependency.

```python
# /// script
# [tool.orcaslicer.plugin]
# name = "Dummy Visualizer"
# description = "Validates visualization lifecycle and GLB publication."
# author = "Your Name"
# version = "1.0.0"
# ///
from pathlib import Path

import orca


class DummyVisualizer(orca.visualization.VisualizationPluginCapabilityBase):
    def __init__(self):
        self.revision = None
        self.location = None

    def get_name(self):
        return "Dummy Visualizer"

    def get_supported_inputs(self):
        return [orca.visualization.VisualizationInputSpec(
            orca.visualization.INPUT_TOOLPATH,
            orca.visualization.FORMAT_GLTF_BINARY,
            orca.visualization.TRANSPORT_FILE,
            2, 0, 2, 0)]

    @staticmethod
    def _accept(ctx):
        if (ctx.input.format, ctx.input.major_version) != (
                orca.visualization.FORMAT_GLTF_BINARY, 2):
            return orca.ExecutionResult.failure(
                orca.PluginResult.RecoverableError,
                "Unsupported visualization input")
        path = Path(ctx.input.location)
        with path.open("rb") as snapshot:
            if snapshot.read(4) != b"glTF":
                return orca.ExecutionResult.failure(
                    orca.PluginResult.RecoverableError,
                    "Invalid GLB resource")
        return orca.ExecutionResult.success()

    def open(self, ctx):
        result = self._accept(ctx)
        if result.status == orca.PluginResult.Success:
            self.revision = ctx.revision
            self.location = ctx.input.location
        return result

    def update(self, ctx):
        result = self._accept(ctx)
        if result.status == orca.PluginResult.Success:
            self.revision = ctx.revision
            self.location = ctx.input.location
        return result

    def close(self):
        self.revision = None
        self.location = None


@orca.plugin
class DummyVisualizerPlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(DummyVisualizer)
```

This example intentionally does only a bounded header check in the callback. A real consumer
must validate the complete negotiated file before using any record or offset, preferably
outside Python.
