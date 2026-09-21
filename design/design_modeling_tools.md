# Modeling Tools

The tools that turn [sketches](design_sketching) into solids in the [Design tab](design_tab), and the reference geometry they attach to. Every tool consumes what is already selected, and every one of them becomes a feature in the tree that can be edited later.

- [Add Material](#add-material)
- [Surfaces](#surfaces)
- [Dress-up](#dress-up)
- [Holes and Threads](#holes-and-threads)
- [Placement](#placement)
- [Combining](#combining)
- [Reference Geometry](#reference-geometry)
- [Assemblies](#assemblies)
- [Variables and Expressions](#variables-and-expressions)
- [The Feature Tree](#the-feature-tree)

## Add Material

| Tool | Key | What it does |
| --- | --- | --- |
| Extrude | `Shift + E` | Extrude a profile, or push and pull a face that is already on a body |
| Revolve | `Shift + R` | Revolve a profile about an axis |
| Sweep | `Shift + W` | Sweep a profile along a path, including a helix for springs and augers |
| Loft | `Shift + L` | Skin between two or more profiles |
| Thicken | — | Offset a solid face into a thin plate as a new body |
| Rib | — | Grow a stiffening wall from an open sketch line, fused to a body |

Extrude offers blind, symmetric, two-sided, through-all and up-to-face end conditions, plus a draft angle on the side wall. Its result can add to, subtract from or intersect an existing body, or start a new one.

> [!NOTE]
> A subtraction that removes no material is reported as an error rather than succeeding silently.

## Surfaces

Sheet bodies are surfaces with no thickness, for shapes that are easier to build as a skin and solidify afterwards.

| Tool | Key |
| --- | --- |
| Surface Extrude | `Shift + G` |
| Surface Revolve | `Shift + J` |
| Surface Loft | `Shift + O` |
| Surface Fill | `Shift + Q` |
| Surface Offset | `Shift + U` |
| Thicken Surface | `Shift + V` |

Thicken Surface is how a sheet body becomes a printable solid.

## Dress-up

| Tool | Key | What it does |
| --- | --- | --- |
| Fillet / Chamfer | `Shift + F` | Round or bevel a picked edge |
| Draft | `Shift + D` | Taper a picked face by an angle |
| Shell | `Shift + K` | Hollow the body to a wall thickness, opening a picked face |
| Delete Face | — | Remove faces and heal the solid, which is how a feature is stripped off an imported part |

## Holes and Threads

**Hole** (`Shift + H`) drills simple, counterbored and countersunk holes, centered on a picked face or placed on a plane. It carries an ISO and ANSI standards table, so you can ask for an M6 clearance hole instead of computing a diameter.

**Thread** (`Shift + T`) cuts a real helical thread into a bore or onto a shaft.

## Placement

Operations that move a body without changing its shape: **Transform** (`Shift + Y`) moves and rotates a body, **Mirror** (`Shift + Z`) reflects it about a plane, and **Mate** places one body against another (see [Assemblies](#assemblies)).

## Combining

**Boolean** (`Shift + B`) unions, subtracts or intersects two bodies. **Cut** (`Shift + X`) splits a body with a plane. **Pattern** (`Shift + N`) repeats a body linearly, in a circle, or along a curve.

## Reference Geometry

Datum features carry no material. They exist to give later features something to attach to.

| Feature | Key | Built from |
| --- | --- | --- |
| Plane | `Shift + P` | An offset, a tilt, a midplane, a tangency, two edges, or coincidence with a face |
| Axis | `Shift + A` | Two points, a face normal, a cylinder centerline, the intersection of two planes, or an edge |
| Coord Sys | `Shift + C` | A full frame, from a world point or from a face plus a direction edge |
| Helix | — | A helical curve to sweep along |
| Project | — | A body's edges projected onto a plane as sketch geometry |

> [!TIP]
> On the Coord Sys tool, picking a direction edge is worth the extra click. Without one the frame takes its X from the face's first edge, which is repeatable but not necessarily the direction you meant.

## Assemblies

**Mate** aligns two coordinate systems and moves one body onto the other. Five kinds are available:

| Kind | Leaves free |
| --- | --- |
| Fastened | Nothing — all six degrees of freedom are locked |
| Planar | Sliding in the plane |
| Revolute | Rotation about the axis |
| Slider | Sliding along the axis |
| Cylindrical | Rotation and sliding |

**Check interference** reports every overlapping pair of solids together with the overlapping volume, so a clash is a number rather than an impression. Bodies that only touch enclose no volume and are not reported.

> [!NOTE]
> Mates are applied in the order they were created rather than solved together, and mate limits are not implemented. Build an assembly from the fixed body outwards.

## Variables and Expressions

Define named variables and drive dimensions from them. Any numeric field accepts an expression, such as `width/2` or `wall*3`, and everything is re-evaluated on recompute. Change one variable and the whole model follows.

## The Feature Tree

The tree is editable history rather than a log. Selecting a feature reopens it with the same on-geometry interaction that created it, `F2` renames it, and `Del` removes it. Every change replays the recipe from the start, so a dimension set early in the model rebuilds everything downstream. `Ctrl + Z` and `Ctrl + Shift + Z` undo and redo across the whole tab.
