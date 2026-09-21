# Reference Geometry

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Datum features carry no material. They exist to give later features something to attach to — a plane to sketch on that no face provides, an axis to revolve about, a frame to mate against. The same family in the [offer menu](design_interaction#the-offer-menu) also holds the tools that measure rather than build.

- [Datum planes](#datum-planes)
- [Datum axes](#datum-axes)
- [Coordinate systems](#coordinate-systems)
- [Helix](#helix)
- [Project](#project)
- [Measuring and inspecting](#measuring-and-inspecting)

## Datum planes

<img alt="design_plane" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_plane.svg?raw=true" height="22"> **Plane** (`Shift + P`) builds a reference plane where no face gives you one. Six constructions:

| Construction | Built from |
| --- | --- |
| Offset | A face or plane, plus a distance |
| Angle | A face or plane, tilted about an edge |
| Midplane | Halfway between two faces or planes |
| Tangent | Tangent to a cylindrical face |
| Two edges | Through two edges |
| Coincident | Coincident with a face or plane |

The three **origin planes** can be shown or hidden at any time with `P`, which is useful when the model itself gives you nothing to sketch against.

## Datum axes

<img alt="design_line" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_line.svg?raw=true" height="22"> **Axis** (`Shift + A`) builds a datum axis. Five constructions:

| Construction | Built from |
| --- | --- |
| Two points | Two picked vertices |
| Face normal | Normal to a picked face |
| Cylinder centreline | The axis of a cylindrical face |
| Plane intersection | Where two planes meet |
| Along edge | Collinear with a picked edge |

The **world axes** can be toggled on and off with `A` while you orient yourself.

## Coordinate systems

<img alt="design_point" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_point.svg?raw=true" height="22"> **Coord Sys** (`Shift + C`) builds a full frame — origin plus three axes. Two constructions: from a **world point**, or from a **face plus a direction edge**.

Coordinate systems are what [Mate](design_assemblies) aligns, so they double as mate connectors.

> [!TIP]
> Picking a direction **edge** is worth the extra click. Without one, the frame takes its X from the face's first edge, which is deterministic but not necessarily the direction you meant.

## Helix

<img alt="design_thread" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_thread.svg?raw=true" height="22"> **Helix** builds a helical curve. On its own it is just a reference curve; its purpose is to be the path for a [Sweep](design_features#add-material), which is how you model coils, springs and augers.

## Project

<img alt="design_sketch" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_sketch.svg?raw=true" height="22"> **Project** projects a body's edges onto a plane as sketch geometry. Use it when a new sketch has to line up with something already modelled — project the edges, then constrain to them instead of measuring by eye.

## Measuring and inspecting

These report and change nothing:

| Tool | What it reports |
| --- | --- |
| Measure | The distance or angle between the picked points, edges or faces |
| Mass | The volume and surface area of the selected body |
| Interference | Whether two bodies overlap, and by how much — see [Assemblies](design_assemblies#check-interference) |

> [!NOTE]
> Prepare has its own [Measure Tool](prepare_basic#measure-tool) for models already on the plate. The Design tab's measurement tools work on the parametric model, before it is committed.
