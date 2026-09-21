# Sketching

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

A sketch is a 2D profile drawn on a plane or on a flat face of an existing body. It is the starting point of almost every feature in the [Design tab](design_tab): a closed profile becomes a solid, an open one drives a rib or a sweep path, and construction geometry guides the rest without ever being built.

- [Starting a sketch](#starting-a-sketch)
- [Sketch entities](#sketch-entities)
- [Snapping and inference](#snapping-and-inference)
- [Editing what you have drawn](#editing-what-you-have-drawn)
- [Construction geometry](#construction-geometry)
- [Dimensions and typed values](#dimensions-and-typed-values)
- [Constraints](#constraints)
- [Degrees of freedom](#degrees-of-freedom)
- [Closing a loop](#closing-a-loop)
- [Finishing and reopening a sketch](#finishing-and-reopening-a-sketch)

## Starting a sketch

1. Click the face or reference plane you want to draw on.
2. Press `Shift + S`, or pick **Sketch** from the [offer menu](design_interaction#the-offer-menu).
3. The offer reopens with the drawing tools on it. Pick one and start clicking.

Three things change at once when a sketch opens, so the state is legible at a glance:

- A **teal banner** appears across the top of the viewport naming the sketch you are editing.
- **The printer bed is muted.** A plate grid and a sketch grid are the same visual language, and reading one as the other is how a sketch gets drawn against the wrong reference. The **Bed** checkbox still works if you want it back; the stored preference is restored when the sketch ends.
- `N` looks **normal to the sketch plane**, keeping the current zoom. A sketch read at an angle is a sketch whose right angles do not look like right angles, and no hand-orbit lands exactly square.

While a sketch is open, **single letters drive the sketch tools**. Feature shortcuts are `Shift` + letter and only work when no sketch is open — the two maps are chosen by the mode, so a letter never means two things at once.

## Sketch entities

| Icon | Entity | Key | How to draw it |
| --- | --- | --- | --- |
| <img alt="design_line" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_line.svg?raw=true" height="18"> | Line | `L` | Click start, then end |
| <img alt="design_polyline" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_polyline.svg?raw=true" height="18"> | Polyline | — | Click points; click the first point to close the loop, or right-click to end it open |
| <img alt="design_rect" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_rect.svg?raw=true" height="18"> | Corner rectangle | `R` | Click two opposite corners |
| <img alt="design_crect" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_crect.svg?raw=true" height="18"> | Centre rectangle | — | Click the centre, then a corner |
| <img alt="design_rect_oblique" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_rect_oblique.svg?raw=true" height="18"> | Oblique rectangle | — | Click two corners of one edge, then a point for the width |
| <img alt="design_rect_rounded" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_rect_rounded.svg?raw=true" height="18"> | Rounded rectangle | — | Click two opposite corners, then a point for the corner radius |
| <img alt="design_circle" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_circle.svg?raw=true" height="18"> | Centre circle | `C` | Click the centre, then the radius |
| <img alt="design_circle2pt" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_circle2pt.svg?raw=true" height="18"> | 2-point circle | — | Click two ends of the diameter |
| <img alt="design_circle3pt" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_circle3pt.svg?raw=true" height="18"> | 3-point circle | — | Click three points on the circle |
| <img alt="design_arc3pt" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_arc3pt.svg?raw=true" height="18"> | 3-point arc | `A` | Click start, end, then a point |
| <img alt="design_tangentarc" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_tangentarc.svg?raw=true" height="18"> | Tangent arc | — | Click start (on the last entity), then end |
| <img alt="design_arc_center" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_arc_center.svg?raw=true" height="18"> | Centre-point arc | — | Click the centre, then start, then a point for the end angle |
| <img alt="design_slot" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_slot.svg?raw=true" height="18"> | Slot | `S` | Click the two centreline ends, then the end radius |
| <img alt="design_slot_arc" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_slot_arc.svg?raw=true" height="18"> | Arc slot | — | Click centre, start, end, then a point for the width |
| <img alt="design_ellipse" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_ellipse.svg?raw=true" height="18"> | Ellipse | `E` | Click the centre, the major-axis end, then a minor point |
| <img alt="design_ellipse_arc" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_ellipse_arc.svg?raw=true" height="18"> | Elliptical arc | — | Click centre, major end, minor point, then the arc start and end |
| <img alt="design_bspline" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_bspline.svg?raw=true" height="18"> | Spline | `B` | Click the control points |
| <img alt="design_polygon" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_polygon.svg?raw=true" height="18"> | Polygon | `G` | Click the centre, then a vertex |
| <img alt="design_point" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_point.svg?raw=true" height="18"> | Point | `P` | Click to place |
| <img alt="design_text" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_text.svg?raw=true" height="18"> | Text | — | Type text; its outline is added to the sketch as editable lines |
| <img alt="design_svg" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_svg.svg?raw=true" height="18"> | SVG | — | Import an SVG outline into the sketch as editable lines |

The polygon family covers triangle, square, pentagon, hexagon, octagon and dodecagon, each in an **inscribed** variant (measured to its corners) or a **circumscribed** one (measured to its flats). `G` arms the hexagon; the other variants are in the polygon submenu of the offer.

> [!TIP]
> A family key arms that family's default tool. The other variants — centre rectangle, tangent arc, 3-point circle and so on — are one level down in the offer, under the family name.

## Snapping and inference

As you draw, the cursor snaps onto the most relevant nearby target, and the relation it snapped to is recorded as a real constraint so it survives the next solve. Targets are taken in this order of priority: **endpoint**, **centre**, **sketch origin**, **midpoint**, **point on an edge**. Construction geometry takes part too — you can snap and constrain to it like anything else.

A segment drawn within about 3° of an axis picks up a **Horizontal** or **Vertical** constraint on the way in.

Inference is deliberately conservative: a relation is only pinned when it is *already* true within tolerance, so an inferred constraint never moves geometry you drew — it records what is visibly there.

## Editing what you have drawn

| Icon | Tool | Key | What it does |
| --- | --- | --- | --- |
| <img alt="design_trim" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_trim.svg?raw=true" height="18"> | Trim | `T` | Click a segment to trim it back to its intersections |
| <img alt="design_extend" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_extend.svg?raw=true" height="18"> | Extend | `X` | Click a line or arc to extend it |
| <img alt="design_offset" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_offset.svg?raw=true" height="18"> | Offset | `O` | Pick an entity, then drag the distance |
| <img alt="design_filletedge" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_filletedge.svg?raw=true" height="18"> | Fillet | `F` | Pick two lines, set the radius |
| <img alt="design_chamfer" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_chamfer.svg?raw=true" height="18"> | Chamfer | `H` | Pick two lines, set the distance |
| <img alt="design_mirror" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_mirror.svg?raw=true" height="18"> | Mirror | `M` | Pick the axis, then the entities |
| <img alt="design_array" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_array.svg?raw=true" height="18"> | Linear array | — | Pick entities, drag the spacing handle, click the count; click empty space to apply |
| <img alt="design_polararray" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_polararray.svg?raw=true" height="18"> | Polar array | — | Pick entities, drag the sweep handle, click the count; click empty space to apply |
| <img alt="design_move" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_move.svg?raw=true" height="18"> | Move | — | Pick entities, then drag the handle or type the distance |
| <img alt="design_rotate" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_rotate.svg?raw=true" height="18"> | Rotate | — | Pick entities, then drag around the pivot or type the angle |
| <img alt="design_scale" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_scale.svg?raw=true" height="18"> | Scale | — | Pick entities, then drag the handle or type the factor |
| <img alt="design_delete" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_delete.svg?raw=true" height="18"> | Delete | `Del` | Delete the selected sketch entities, or the last one drawn if nothing is selected |

`Ctrl + Z` inside a sketch drops the last entity you drew.

## Construction geometry

<img alt="design_construction" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_construction.svg?raw=true" height="22"> Construction geometry guides a sketch but is never built into the solid — centrelines, mirror axes, bolt-circle references.

`Q` does one of two things, depending on what is selected:

- **With entities selected**, it converts those entities between construction and real geometry.
- **With nothing selected**, it arms construction for whatever you draw next.

## Dimensions and typed values

<img alt="design_dimension" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_dimension.svg?raw=true" height="22"> Press `D` for the dimension tool, then click two points or a single entity. Dimensions are live: editing a dimension's value **updates that dimension** rather than adding a second one next to it, and the sketch re-solves as you type.

`V` types the defining number of whatever is selected, without reaching for the dimension tool first:

| Selection | What `V` asks for |
| --- | --- |
| A line | Its length |
| An arc or circle | The radius, or the diameter |
| Two lines, or two picks | The angle between them, or the distance |

If the selection has no value to type, the status line says so.

Any numeric field accepts an expression — `width/2`, `wall*3` — and anything you define under [Variables](design_variables) can be used by name.

## Constraints

<img alt="design_constrain" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_constrain.svg?raw=true" height="22"> Select the entities you want to relate, then apply a constraint from the **CONSTRAIN** group in the toolbar or from the offer. `K` finishes the live sketch tool and enters the constrain session.

Constraints apply to the live selection during a sketch — you do not have to finish the sketch first.

### Geometric

| Icon | Constraint | Icon | Constraint |
| --- | --- | --- | --- |
| <img alt="design_c_horizontal" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_horizontal.svg?raw=true" height="18"> | Horizontal | <img alt="design_c_vertical" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_vertical.svg?raw=true" height="18"> | Vertical |
| <img alt="design_c_parallel" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_parallel.svg?raw=true" height="18"> | Parallel | <img alt="design_c_perpendicular" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_perpendicular.svg?raw=true" height="18"> | Perpendicular |
| <img alt="design_c_coincident" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_coincident.svg?raw=true" height="18"> | Coincident | <img alt="design_c_collinear" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_collinear.svg?raw=true" height="18"> | Collinear |
| <img alt="design_c_equal" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_equal.svg?raw=true" height="18"> | Equal length | <img alt="design_c_equal_radius" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_equal_radius.svg?raw=true" height="18"> | Equal radius |
| <img alt="design_c_concentric" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_concentric.svg?raw=true" height="18"> | Concentric | <img alt="design_c_tangent" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_tangent.svg?raw=true" height="18"> | Tangent |
| <img alt="design_c_midpoint" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_midpoint.svg?raw=true" height="18"> | Midpoint | <img alt="design_c_symmetric" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_symmetric.svg?raw=true" height="18"> | Symmetric |
| <img alt="design_c_sym_v" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_sym_v.svg?raw=true" height="18"> | Symmetric about the vertical axis | <img alt="design_c_sym_h" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_sym_h.svg?raw=true" height="18"> | Symmetric about the horizontal axis |
| <img alt="design_c_fix" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_fix.svg?raw=true" height="18"> | Fix point (anchor in place) | | |

### Dimensional

| Icon | Constraint | Icon | Constraint |
| --- | --- | --- | --- |
| <img alt="design_c_radius" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_radius.svg?raw=true" height="18"> | Radius | <img alt="design_c_diameter" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_diameter.svg?raw=true" height="18"> | Diameter |
| <img alt="design_c_angle" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_angle.svg?raw=true" height="18"> | Angle | <img alt="design_c_dist_x" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_dist_x.svg?raw=true" height="18"> | Horizontal distance |
| <img alt="design_c_dist_y" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_dist_y.svg?raw=true" height="18"> | Vertical distance | | |

## Degrees of freedom

The solver reports the sketch's remaining **degrees of freedom** on its own line in the sidebar, updated after every solve. It tells you when a sketch is fully constrained, and it tells you when a constraint conflicts with one already there rather than silently dropping either.

A fully constrained sketch is the one that survives edits: every point has a reason to be where it is, so changing a dimension moves exactly what you meant and nothing else.

## Closing a loop

A profile has to close before it can become a solid. By default, endpoints within 0.001 mm are treated as one joint and the loop is welded shut — this is the **Auto-close sketch loops** preference under **General > Features**.

Turn it off and only exactly coincident endpoints join, so a loop with a tiny gap is reported as open instead of being closed for you. That is the stricter behaviour, and it is the one to use when you want the kernel to demand an exact joint.

> [!WARNING]
> A sketch whose entities form no wire **fails** instead of extruding a default box. If Extrude refuses, check the status line — it names the reason.

## Finishing and reopening a sketch

- **Confirm** in the action bar ends the sketch and keeps it.
- **Cancel** discards it, and asks first when the sketch holds geometry.
- `Esc` clears the selection; it leaves the sketch session only when the sketch is empty, so it can never throw away work. See [What Escape does](design_interaction#what-escape-does).

Sketches stay editable. Select one in the [Feature tree](design_tab#sidebar) and double-click it — or double-click a sketch stroke in the viewport — to reopen it with its dimensions live. Everything downstream rebuilds when you confirm.
