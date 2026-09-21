# Solid and Surface Features

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Features turn [sketches](design_sketching) into solids and then refine them. Every one of them lands in the feature tree and is replayed in order, so a change anywhere upstream rebuilds everything below it.

Feature tools are `Shift` + a letter, and they are only live when **no sketch is open** — inside a sketch, single letters drive the drawing tools instead.

- [The feature tree](#the-feature-tree)
- [Add material](#add-material)
- [Surfaces](#surfaces)
- [Dress-up](#dress-up)
- [Holes and threads](#holes-and-threads)
- [Combining bodies](#combining-bodies)
- [Repeating and transforming](#repeating-and-transforming)
- [Bodies](#bodies)

## The feature tree

<img alt="design_sketch" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_sketch.svg?raw=true" height="22"> The tree in the sidebar is the part. A row for every feature, in the order it is replayed: `Sketch1 → Extrude2 → Chamfer3 → Sketch4 → Extrude5 → Hole6 → Thread7`.

| Gesture | What it does |
| --- | --- |
| Single click | Selects the feature and highlights the solid it produced |
| Double-click | Reopens the feature to change what it was made from |
| `F2`, or right-click then **Rename** | Renames the row. A body takes its name from the feature that makes it |
| Right-click then **Move up** / **Move down** | Reorders the feature in the replay |
| Right-click then **Show / hide** | Suppresses the feature without deleting it |
| Right-click then **Delete** | Removes the feature |
| Right-click then **Scale artwork** | Only on a feature that carries an imported outline (Text or SVG) |

Selecting a row also puts a note on the status line naming the two gestures the row supports, because neither is visible on it.

## Add material

| Icon | Tool | Shortcut | What it does |
| --- | --- | --- | --- |
| <img alt="design_extrude" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_extrude.svg?raw=true" height="18"> | Extrude | `Shift + E` | Extrude a sketch profile, or push and pull a face that is already on a body |
| <img alt="design_revolve" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_revolve.svg?raw=true" height="18"> | Revolve | `Shift + R` | Revolve a profile about an in-plane axis, through any angle from 1° to 360° |
| <img alt="design_sweep" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_sweep.svg?raw=true" height="18"> | Sweep | `Shift + W` | Sweep a profile along a second sketch used as the path — including a [helix](design_reference_geometry#helix), for springs and augers |
| <img alt="design_loft" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_loft.svg?raw=true" height="18"> | Loft | `Shift + L` | Skin between two or more closed profiles, each on its own plane, smooth or ruled |
| <img alt="design_thicken" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_thicken.svg?raw=true" height="18"> | Thicken | — | Offset a solid face into a thin plate as a new body |
| <img alt="design_rib" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_rib.svg?raw=true" height="18"> | Rib | — | Grow a stiffening wall from an open sketch line, fused to a body |

### Extrude end conditions

Extrude is the workhorse, and it carries the most options:

| End condition | What it means |
| --- | --- |
| Blind | A fixed depth in one direction |
| Symmetric | The same depth either side of the sketch plane |
| Two-sided | Independent depths either side |
| Through all | All the way through the body |
| Up to face | Stops on a picked face |
| Up to vertex | Stops at a picked vertex |

Extrude also takes a **draft angle** on the side wall, and chooses what the result does to the model: start a **new body**, **add** to one, **subtract** from one, or **intersect** with one.

> [!NOTE]
> **Rib** needs a sketch that contains an explicit open line. A parametric rectangle sketch carries no individual entities, so Rib cannot consume one — draw the rib line with the Line tool.

## Surfaces

<img alt="design_surface" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_surface.svg?raw=true" height="22"> Sheet bodies are surfaces with no thickness, for shapes that are easier to build as a skin and solidify afterwards.

| Tool | Shortcut | What it does |
| --- | --- | --- |
| Surface Extrude | `Shift + G` | Extrude a sketch into a sheet body, with no end caps |
| Surface Revolve | `Shift + J` | Revolve a profile into a sheet body |
| Surface Loft | `Shift + O` | Skin between two or more profiles, open |
| Surface Fill | `Shift + Q` | Fill a sketch boundary with a smooth face |
| Surface Offset | `Shift + U` | Offset a sheet body's shell by a signed distance |
| Thicken Surface | `Shift + V` | Thicken a sheet body into a solid |

**Thicken Surface** is how a sheet becomes a printable solid — a sheet body on its own has no volume to slice.

> [!WARNING]
> **Surface Loft** and **Surface Fill** have kernel tests but have not been exercised by hand. Check the result before you rely on it.

## Dress-up

| Icon | Tool | Shortcut | What it does |
| --- | --- | --- | --- |
| <img alt="design_filletedge" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_filletedge.svg?raw=true" height="18"> | Fillet | `Shift + F` | Pick an edge, then drag the radius arrow or type it |
| <img alt="design_chamfer" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_chamfer.svg?raw=true" height="18"> | Chamfer | `Shift + F` | The same tool, switched to a bevel: pick an edge, then drag the distance arrow or type it |
| <img alt="design_draft" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_draft.svg?raw=true" height="18"> | Draft | `Shift + D` | Tilt a picked face by a draft angle |
| <img alt="design_shell" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_shell.svg?raw=true" height="18"> | Shell | `Shift + K` | Hollow the body to a wall thickness, opening a picked face |
| <img alt="design_delete" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_delete.svg?raw=true" height="18"> | Delete Face | — | Remove faces from a body and heal the solid |

**Delete Face** is how you strip a feature off an imported part: remove the faces it is made of, and the kernel heals what is left.

> [!TIP]
> Draft is worth reaching for before you print, not after. Tapering a vertical wall a degree or two is what lets a part release cleanly and takes the sharpness off a first-layer elephant foot.

## Holes and threads

<img alt="design_hole" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_hole.svg?raw=true" height="22"> **Hole** (`Shift + H`) drills a hole centred on a picked face or positioned on a plane. It comes in three styles:

- **Simple** — a plain bore
- **Counterbore** — a larger cylinder at the entry face, for a socket-head cap screw
- **Countersink** — a cone at the entry face, for a flat-head screw

A hole is either **through** the body or **blind** to a set depth.

A **clearance-hole standards table** saves you computing a diameter: pick a designation and the bore, counterbore and countersink dimensions come with it. The table covers **M3, M4, M5, M6, M8, M10** and the imperial sizes **#6-32, #8-32, 1/4-20, 5/16-18, 3/8-16**.

<img alt="design_thread" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_thread.svg?raw=true" height="22"> **Thread** (`Shift + T`) cuts a real helical thread — modelled geometry, not a texture, so it slices into real helical toolpaths. Threads are either **internal** (tapped into a bore) or **external** (onto a shaft), and the thread standards list covers:

| Series | Coverage |
| --- | --- |
| ISO metric coarse | M1 to M64 |
| ISO metric fine | M8×1, M10×1.25, M10×1, M12×1.5, M12×1.25, M16×1.5, M20×1.5, M24×2 |
| Unified coarse (UNC) | #1-64 to 1-8 |
| Unified fine (UNF) | #2-64 to 1-12 |

All of them use the common 60° V profile shared by ISO 261/965 and ASME B1.1.

> [!TIP]
> A printed thread is only as good as the calibration underneath it. Check [Tolerance](tolerance_calib) and [Flow Ratio](flow_ratio_calib) before blaming the model for a thread that will not turn.

## Combining bodies

| Icon | Tool | Shortcut | What it does |
| --- | --- | --- | --- |
| <img alt="design_boolean" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_boolean.svg?raw=true" height="18"> | Union | `Shift + B` | Fuse the tool body into the target — one solid, no seam |
| <img alt="design_boolean" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_boolean.svg?raw=true" height="18"> | Subtract | — | Cut the tool body out of the target |
| <img alt="design_boolean" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_boolean.svg?raw=true" height="18"> | Intersect | — | Keep only where the two bodies overlap |
| <img alt="design_cut" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_cut.svg?raw=true" height="18"> | Cut | `Shift + X` | Trim the body with a plane — drag the offset arrow, keep one half or both |
| <img alt="design_cut" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_cut.svg?raw=true" height="18"> | Split | — | Split the body along a picked face into two solids |

> [!NOTE]
> A subtraction that removes nothing is reported as an error rather than a silent success. If a boolean seems to have done nothing, read the status line.

## Repeating and transforming

| Icon | Tool | Shortcut | What it does |
| --- | --- | --- | --- |
| <img alt="design_array" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_array.svg?raw=true" height="18"> | Linear pattern | `Shift + N` | Repeat the body along a direction — drag the spacing, set the count |
| <img alt="design_polararray" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_polararray.svg?raw=true" height="18"> | Circular pattern | — | Repeat the body around an axis — set the count and the total sweep |
| <img alt="design_pattern" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_pattern.svg?raw=true" height="18"> | Pattern on Curve | — | Repeat the body along a picked curve |
| <img alt="design_mirror" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_mirror.svg?raw=true" height="18"> | Mirror | `Shift + Z` | Reflect a body about a plane |
| <img alt="design_move" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_move.svg?raw=true" height="18"> | Move | `Shift + Y` | Move and rotate an existing body without changing its shape |
| <img alt="design_move" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_move.svg?raw=true" height="18"> | Align to | — | Align the body to a picked face or plane |

For fitting one body to another rather than just placing it, see [Assemblies](design_assemblies).

## Bodies

<img alt="design_extrude" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_extrude.svg?raw=true" height="22"> The **Bodies** card lists every solid and sheet body in the document, one row each. The buttons in its header act on the selected row:

| Icon | Action |
| --- | --- |
| <img alt="design_move" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_move.svg?raw=true" height="18"> | Move body |
| <img alt="design_boolean" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_boolean.svg?raw=true" height="18"> | Boolean — join, subtract or intersect with another body |
| <img alt="design_eye" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_eye.svg?raw=true" height="18"> | Show or hide |
| <img alt="design_delete" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_delete.svg?raw=true" height="18"> | Delete the body, and the feature that made it |
| <img alt="color_palette" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/color_palette.svg?raw=true" height="18"> | Set the body's display colour |

Hiding a body matters at commit time: **what you see on the Design plate is what gets committed**, and a multi-body document ships each visible body to Prepare as its own independently arrangeable object. See [Commit to Plate](design_import_export#commit-to-plate).
