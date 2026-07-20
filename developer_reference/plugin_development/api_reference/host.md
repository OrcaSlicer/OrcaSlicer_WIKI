# Host

`orca.host` (bound in `PluginHostApi.cpp`) gives plugins **read-only** access to the running
slicer. It is intended for analysis, reporting, and export plugins; nothing here mutates the
model.

**Script plugins run on the main/UI thread**, so within one `execute()` the model cannot
change under you. **Slicing-pipeline and printer-agent plugins run on a background
thread** while the GUI keeps running. Either way, treat everything as a momentary snapshot and
do not stash references across runs.

## Entry Points

Each entry point raises `RuntimeError` if called before the GUI/model is ready:

```python
import orca
model  = orca.host.model()           # the active Model
plater = orca.host.plater()          # the Plater
bundle = orca.host.preset_bundle()   # presets (prints/printers/filaments/...)
```

## Model Graph

`Model.objects()` returns `ModelObject` values. Each object has `volumes()` / `volume(i)`
(returning `ModelVolume`) and `instances()` / `instance(i)` (returning `ModelInstance`).
Bounding boxes are a `host.BoundingBox` value type (`min` / `max` / `size` / `center` as
`(x, y, z)` mm tuples, plus `radius` / `defined`).

## Mesh Geometry

`ModelVolume.mesh()` returns `host.TriangleMesh`.

| Member | Returns | Notes |
|---|---|---|
| `vertex_count()` / `triangle_count()` (`facets_count()`) / `is_empty()` | `int` / `bool` | numpy-free |
| `vertex(i)` / `triangle(i)` | `(x, y, z)` / `(a, b, c)` tuple | numpy-free, bounds-checked |
| `vertices()` | `(N, 3)` float32 ndarray | **read-only, zero-copy**, requires numpy |
| `triangles()` | `(M, 3)` int32 ndarray | vertex indices; **read-only, zero-copy**, requires numpy |
| `face_normals()` | `(M, 3)` float32 ndarray | computed copy, requires numpy |
| `volume()` / `bounding_box()` / `is_manifold()` | `float` / `BoundingBox` / `bool` | numpy-free |

Coordinates are **local** (the volume's own frame, in mm). The `vertices()` / `triangles()`
arrays are zero-copy views into the live mesh and are marked read-only; writing to them raises
`ValueError`. Their lifetime is pinned to an immutable mesh snapshot, so they stay valid even
if the volume's mesh is later replaced.

## Worked Example

Declare numpy in the PEP 723 block so the bundled `uv` installs it:

```python
# /// script
# dependencies = ["numpy"]
# ///
import orca, numpy as np

class MeshReport(orca.script.ScriptPluginCapabilityBase):
    def get_name(self): return "Mesh Report"
    def execute(self):
        model = orca.host.model()
        for obj in model.objects():
            for vol in obj.volumes():
                mesh = vol.mesh()
                V = np.asarray(mesh.vertices())          # (N, 3) float32, read-only
                T = np.asarray(mesh.triangles())         # (M, 3) int32
                # World-space coordinates for the first instance (row-vector convention):
                M = obj.instance(0).matrix() @ vol.matrix()      # 4x4 float64
                world = (np.c_[V.astype(np.float64), np.ones(len(V))] @ M.T)[:, :3]
                print(vol.name, V.shape, T.shape, world.min(0), world.max(0))
        return orca.ExecutionResult.success()

@orca.plugin
class MeshReportPlugin(orca.base):
    def register_capabilities(self):
        orca.register_capability(MeshReport)
```

> [!NOTE]
> If the instance is mirrored (`instance.is_left_handed()` is `True`, i.e. `det(M) < 0`),
> flip triangle winding / negate face normals when computing outward-facing normals in world
> space.

## numpy Requirement

`vertices()`, `triangles()`, `face_normals()`, and the `matrix()` accessors on
`ModelVolume` / `ModelInstance` require numpy and raise a clear `ImportError` if it is not
installed (declare `dependencies = ["numpy"]`). Everything else - counts, `vertex(i)` /
`triangle(i)`, `volume()`, `bounding_box()`, `is_manifold()`, and the `offset` / `rotation` /
`scaling_factor` / `mirror` tuple accessors - works without numpy.
