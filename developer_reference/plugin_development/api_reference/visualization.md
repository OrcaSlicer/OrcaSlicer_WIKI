# Visualization

The `orca.visualization` module exposes `VisualizationPluginCapabilityBase` for plugins that
consume OrcaSlicer's model or final FFF toolpath geometry. A capability declares acceptable
input formats and the resource kinds and scopes it needs. OrcaSlicer negotiates each request,
publishes immutable files, and passes their typed descriptors to Python. Standard Preview remains
available if a visualizer fails.

Enabled visualization capabilities automatically appear in the
[Actions Speed Dial](plugins_speed_dial). They do not need a companion script capability.

| Base class | `get_type()` returns | Required methods | Optional methods |
|---|---|---|---|
| `orca.visualization.VisualizationPluginCapabilityBase` | `Visualization` | `get_name()`, `get_supported_inputs()`, `open(self, ctx) -> ExecutionResult`, `update(self, ctx) -> ExecutionResult` | `get_requested_resources()`, `close()` |

`get_requested_resources()` defaults to the current plate's toolpath. `close()` defaults to doing
nothing. Implement `close()` when the capability owns a window, renderer, mapping, or other session
resource.

## Declaring inputs and resources

`get_supported_inputs()` is called once while the capability is materialized. Return one or more
`VisualizationInputSpec` alternatives. Identifiers are case-sensitive, version bounds are inclusive
`(major, minor)` pairs, and the host chooses the first compatible specification for each request.
An empty declaration, empty identifier, or inverted version range rejects the capability at load
time.

`get_requested_resources()` is also called once and cached. Return one or more
`VisualizationResourceRequest(kind, scope)` values. An empty list, unsupported scope, or requested
kind without a matching input specification rejects the capability at load time. The built-in
scopes are:

| Scope | Result |
|---|---|
| `SCOPE_CURRENT_PLATE` | one resource for the selected plate, when its requested geometry is available |
| `SCOPE_PROJECT` | one resource per plate that has the requested geometry |

The built-in resource kinds are:

| Kind | Contents |
|---|---|
| `INPUT_TOOLPATH` | complete final FFF extrusion geometry; requires a completed slice |
| `INPUT_MODEL` | printable model-part volumes assigned to the plate; modifiers are excluded and no completed slice is required |

Unavailable plates are omitted. If none of the requested resources are available, the session is
not opened.

```python
def get_supported_inputs(self):
    return [
        orca.visualization.VisualizationInputSpec(
            orca.visualization.INPUT_TOOLPATH,
            orca.visualization.FORMAT_GLTF_BINARY,
            orca.visualization.TRANSPORT_FILE,
            2, 0, 2, 0),
        orca.visualization.VisualizationInputSpec(
            orca.visualization.INPUT_MODEL,
            orca.visualization.FORMAT_OBJ,
            orca.visualization.TRANSPORT_FILE,
            1, 0, 1, 0),
    ]

def get_requested_resources(self):
    return [
        orca.visualization.VisualizationResourceRequest(
            orca.visualization.INPUT_TOOLPATH,
            orca.visualization.SCOPE_CURRENT_PLATE),
        orca.visualization.VisualizationResourceRequest(
            orca.visualization.INPUT_MODEL,
            orca.visualization.SCOPE_PROJECT),
    ]
```

### Current formats

The current producer uses file transport and supports these formats for both built-in kinds:

| Constant | Media type | Version | Notes |
|---|---|---|---|
| `FORMAT_GLTF_BINARY` | `model/gltf-binary` | `2.0` | indexed GLB; toolpaths retain Preview materials and Orca metadata |
| `FORMAT_STL` | `model/stl` | `1.0` | triangle geometry only |
| `FORMAT_OBJ` | `model/obj` | `1.0` | triangle geometry only |
| `FORMAT_DRACO` | `model/vnd.google.draco` | `1.0` | Draco-compressed triangle geometry only |

`TRANSPORT_FILE` is currently the only transport. Additional identifiers remain extensible, but a
capability must declare a format the running host can produce.

## Context and inputs

`open()` and `update()` receive an immutable
`orca.visualization.VisualizationContext`:

| Field | Type | Meaning |
|---|---|---|
| `orca_version` | `str` | OrcaSlicer version inherited from `PluginContext` |
| `revision` | `int` | monotonically increasing request revision |
| `resources` | `list[VisualizationInput]` | all negotiated resources |
| `input` | `VisualizationInput` | compatibility alias for `resources[0]` |
| `metadata` | `dict[str, str]` | compatibility metadata for the first resource; currently `plate_index` |

Each `VisualizationInput` exposes read-only `kind`, `format`, `transport`, `location`,
`major_version`, `minor_version`, `scope`, and `metadata` fields. File resources include their
zero-based `plate_index` in `input.metadata`. Resources follow request order, then plate order for
project-scoped requests. Ignore unknown metadata.

Treat every descriptor and resource as read-only. Do not delete, rename, replace, or modify a
host-owned file.

## GLB toolpath payload

A toolpath GLB is standard glTF 2.0. Position accessors remain in OrcaSlicer's right-handed, Z-up
printer space; the root node contains a -90-degree X rotation so a normal glTF renderer presents
the scene in Y-up coordinates. Consumers reading raw accessors without applying node transforms
must account for that rotation themselves.

OrcaSlicer stores extension data in ordinary glTF `extras` objects:

| JSON path | Fields |
|---|---|
| `scenes[0].extras.orca` | `sceneId`, `plateIndex`, `spiralVase`, `zOffset`, `printableHeight` |
| toolpath primitive `extras.orca` | `layerId`, `extrusionRole`, `extruderId`, `colourId` |
| `materials[*].extras.orca` | `extruderId`, `presetId` |
| plate-outline primitive `extras.orca` | `areaKind`: `printable`, `bed-excluded`, or `wrapping-excluded` |

Toolpath primitives are indexed triangles. Plate outlines are closed line-loop primitives.
Material names and `presetId` currently contain the captured filament preset identifier; the base
color is OrcaSlicer's resolved Preview color. Unknown `extras` fields must be ignored.

The toolpath resource contains the complete final FFF extrusion scene. Preview layer-slider and
feature visibility do not truncate it, and travel moves are not included.

## Actions and session lifecycle

OrcaSlicer keeps at most one active session per capability identity (plugin key, type, and
capability name):

1. Running the visualization's Actions Speed Dial entry captures its declared resources and calls
   `open(ctx)`. Returning `Success` starts the session. Running the action again closes the old
   session and opens a new one.
2. `request_update(resources=[])` asks the host to capture a new revision. An empty list repeats
   the session's current requests; a supplied list may change the resource kinds or scopes. It
   returns `False` when no session is active, otherwise it queues the request. A successful build
   calls `update(ctx)`.
3. `close()` ends the session. It is called when the capability or plugin is disabled or unloaded,
   when the application shuts down, before the action reopens an existing session, and after a
   fatal update result. Implement it as idempotent.

OrcaSlicer does not update a session automatically after every slice. A persistent visualizer can
call `self.request_update()` from a host-UI message callback or its own managed worker when it
needs fresh resources.

Resources from a successful `open()` remain valid until a successful `update()` or `close()`.
Resources from a successful `update()` then have the same lifetime. If an update is skipped, fails,
raises, is cancelled, or is superseded, the previous successful resources remain valid and the new
files are removed.

## Threading and callbacks

Geometry capture runs on OrcaSlicer's UI thread without entering Python. Serialization and atomic
file publication run on a host worker. `open()` and `update()` are dispatched on the UI thread only
after publication; lifecycle teardown may invoke `close()` from another host thread. Calls for one
capability are serialized.

`open()`, `update()`, and `close()` must return quickly. Use them to validate descriptors and signal
an already managed renderer or worker; do not parse or render a large scene synchronously on the UI
thread. A newer request can supersede pending work.

Plugins must not import wxPython, Qt, Tk, or another GUI toolkit. A second GUI event loop can
conflict with OrcaSlicer's wxWidgets loop, especially during unload. Use host-owned UI from
[`orca.host.ui`](host_ui) for plugin dialogs and windows. Visualization does not add a host-managed
subprocess API or grant special process permissions.

## Results and errors

Use the shared factories described in [Registry](registry):

- `ExecutionResult.success()` accepts all resources. OrcaSlicer commits the session or update.
- `ExecutionResult.skipped(message)` declines them without treating the callback as an error.
- `RecoverableError` reports the problem. During an update, the previous successful resources stay
  active for a later retry.
- `FatalError` reports the problem. During an update, it closes only the affected session.
- An uncaught Python exception is logged with its traceback and treated as recoverable; it does not
  close or replace standard Preview.

Any non-successful `open()` leaves no active session. Do not return `Success` until every consumer
that needs the new paths has accepted them. OrcaSlicer may release the previous files as soon as a
successful `update()` returns.

## Audit mode

Visualization callbacks use the audit hook's `Loading` mode. This allows normal module reads and
lazy imports while retaining the current write restriction to approved plugin/data storage. No
extra global or per-call writable root is granted for visualization, and the mode is not a
subprocess permission. See [Plugin Audit Hook](plugin_audit_hook) for the enforced policy and its
limitations.

## Minimal dummy visualizer

This visualizer uses the default current-plate toolpath request, negotiates GLB, verifies each typed
descriptor and file header, and records the accepted revision. It performs no rendering, so it is
useful for checking registration and lifecycle behavior without another GUI toolkit.

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
        self.locations = []

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
        for resource in ctx.resources:
            path = Path(resource.location)
            with path.open("rb") as snapshot:
                magic = snapshot.read(4)
            if (resource.format != orca.visualization.FORMAT_GLTF_BINARY or
                    resource.major_version != 2 or magic != b"glTF"):
                return orca.ExecutionResult.failure(
                    orca.PluginResult.RecoverableError,
                    "Invalid GLB visualization resource")
        return orca.ExecutionResult.success()

    def open(self, ctx):
        result = self._accept(ctx)
        if result.status == orca.PluginResult.Success:
            self.revision = ctx.revision
            self.locations = [resource.location for resource in ctx.resources]
        return result

    def update(self, ctx):
        result = self._accept(ctx)
        if result.status == orca.PluginResult.Success:
            self.revision = ctx.revision
            self.locations = [resource.location for resource in ctx.resources]
        return result

    def close(self):
        self.revision = None
        self.locations = []


@orca.plugin
class DummyVisualizerPlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(DummyVisualizer)
```

Enable the capability, slice the current FFF plate, then run **Dummy Visualizer** from the Actions
Speed Dial. This example intentionally performs only a bounded header check in the callback. A real
consumer must validate the complete negotiated file before using any record or offset, preferably
off the UI thread.
