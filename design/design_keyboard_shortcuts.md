# Design Keyboard Shortcuts

The [Design tab](design_tab) has two key maps, and the one in force depends on whether a sketch is open:

- **A sketch is open** — single letters drive the [sketch tools](design_sketching).
- **No sketch is open** — `Shift` and a letter drive the [modeling tools](design_modeling_tools), and single letters drive the view.

Shortcuts are never intercepted while you are typing in a field, and the offer menu shows each verb's key beside it.

- [Sketch Tools](#sketch-tools)
- [Modeling Tools](#modeling-tools)
- [View and Document](#view-and-document)

## Sketch Tools

Available while a sketch is open.

| Key | Tool |
| --- | --- |
| `L` | Line — click start, then end |
| `R` | Rectangle — click two opposite corners |
| `C` | Circle — click center, then radius |
| `A` | Arc — click start, end, then a point |
| `S` | Slot — two centerline ends, then the end radius |
| `E` | Ellipse — center, major end, minor point |
| `B` | Spline — click control points |
| `P` | Point — click to place |
| `G` | Polygon — click center, then a vertex |
| `D` | Dimension — click 2 points or an entity |
| `T` | Trim — click a segment to trim it |
| `X` | Extend — click a line or arc to extend it |
| `O` | Offset — pick an entity, drag the distance |
| `M` | Mirror — pick the axis, then the entities |
| `F` | Fillet — pick two lines, set the radius |
| `H` | Chamfer — pick two lines, set the distance |
| `V` | Value — type the defining number of the selection |
| `K` | Constrain — finish the live tool and enter constraining |
| `Q` | Construction — draw the next entity as construction geometry, or convert the selection |
| `N` | Look normal to the sketch plane |
| `Enter` | Finish the sketch |
| `Esc` | Close the value field, drop the entity being drawn, or drop the armed tool |
| `Del` / `Backspace` | Delete the selected sketch entities |
| `Ctrl + Z` | Remove the last entity drawn |

## Modeling Tools

Available when no sketch is open.

| Key | Tool |
| --- | --- |
| `Shift + S` | Sketch |
| `Shift + E` | Extrude — extrude a profile, or push and pull a picked face |
| `Shift + R` | Revolve |
| `Shift + W` | Sweep |
| `Shift + L` | Loft |
| `Shift + N` | Pattern |
| `Shift + G` | Surface Extrude |
| `Shift + J` | Surface Revolve |
| `Shift + O` | Surface Loft |
| `Shift + Q` | Surface Fill |
| `Shift + U` | Surface Offset |
| `Shift + V` | Thicken Surface |
| `Shift + P` | Plane |
| `Shift + A` | Axis |
| `Shift + C` | Coord Sys |
| `Shift + Y` | Transform |
| `Shift + Z` | Mirror |
| `Shift + B` | Boolean |
| `Shift + X` | Cut |
| `Shift + F` | Fillet / Chamfer |
| `Shift + D` | Draft |
| `Shift + K` | Shell |
| `Shift + H` | Hole |
| `Shift + T` | Thread |
| `Shift + I` | Import STEP |
| `Shift + M` | Import mesh |

## View and Document

Available when no sketch is open.

| Key | Action |
| --- | --- |
| `Home` | Isometric view, fitted to the model |
| `P` | Show or hide the origin planes |
| `A` | Show or hide the world axes |
| `X` | Section view on or off |
| `Page Up` / `Page Down` | Move the section plane, while the section is on |
| `F` | Flip the section while it is on, otherwise lay the picked face on the bed |
| `Ctrl + Shift + B` | Show or hide the printer bed |
| `Ctrl + Shift + P` | Commit to Plate |
| `Menu` / `Shift + F10` | Open the offer menu on the current selection |
| `F2` | Rename the selected feature |
| `Del` | Delete the selected feature |
| `Esc` | Clear the selection |
| `Ctrl + Z` | Undo |
| `Ctrl + Shift + Z` / `Ctrl + Y` | Redo |
