# Design Keyboard Shortcuts

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

The [Design tab](design_tab) has **two key maps**, chosen by the mode rather than by which window has focus:

- **While a sketch is open**, single letters drive the sketch tools.
- **When no sketch is open**, `Shift` + letter drives the feature tools, and single letters drive the view toggles.

That is what lets `F` mean Fillet while drawing and Place on Face while not, without either ever being ambiguous.

These shortcuts are specific to the Design tab. For the rest of the application, see [Keyboard Shortcuts](keyboard_shortcuts).

- [Sketch tools](#sketch-tools)
- [Feature tools](#feature-tools)
- [View toggles](#view-toggles)
- [Document and editing](#document-and-editing)

## Sketch tools

Active only while a sketch is open. See [Sketching](design_sketching).

| Key | Tool |
| --- | --- |
| `L` | Line — click start, then end |
| `R` | Rectangle — click two opposite corners |
| `C` | Circle — click centre, then radius |
| `A` | Arc — click start, end, then a point |
| `S` | Slot — two centreline ends, then width |
| `E` | Ellipse — centre, major end, minor point |
| `B` | Spline — click control points |
| `P` | Point — click to place |
| `G` | Polygon — click centre, then a vertex |
| `D` | Dimension — click 2 points or an entity |
| `T` | Trim — click a segment to trim it |
| `X` | Extend — click a line or arc to extend it |
| `O` | Offset — pick an entity, drag the distance |
| `M` | Mirror — pick axis, then entities |
| `F` | Fillet — pick two lines, set the radius |
| `H` | Chamfer — pick two lines, set the distance |
| `K` | Constrain — finish the live tool and enter constrain |
| `Q` | Construction — convert the selection, or arm construction for what you draw next |
| `V` | Type the value of the selection — a length, a radius, a diameter, an angle or a distance |
| `N` | Look normal to the sketch plane |
| `Del` / `Backspace` | Delete the selected sketch entities, or the last one drawn |
| `Ctrl + Z` | Drop the last entity drawn |
| `Esc` | Cancel the live tool |
| `Enter` | Commit the entity, the value, or finish the sketch |

## Feature tools

Active when no sketch is open. See [Solid and Surface Features](design_features).

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
| `Shift + Y` | Transform — move and rotate a body |
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

## View toggles

Single letters, active when no sketch is open. See [View controls](design_interaction#view-controls).

| Key | Action |
| --- | --- |
| `Home` | Axonometric view, fitted to the model |
| `P` | Origin planes on or off |
| `A` | World axes on or off |
| `X` | Section view on or off |
| `F` | Place on Face — lay the picked face flat on the bed (no section active) |
| `Ctrl + Shift + B` | Show or hide the printer bed |

While a section view is on:

| Key | Action |
| --- | --- |
| `PageUp` / `PageDown` | Move the cut plane |
| `F` | Flip which half is kept |
| `Del` | Remove the section |

## Document and editing

Available in every mode.

| Key | Action |
| --- | --- |
| `Ctrl + Shift + P` | Commit to Plate |
| `Ctrl + Z` | Undo |
| `Ctrl + Shift + Z` or `Ctrl + Y` | Redo |
| `F2` | Rename the selected feature |
| `Del` / `Backspace` | Delete the selected feature |
| `Menu` or `Shift + F10` | Open the offer menu from the keyboard |
| `Esc` | Unwind one level — see [What Escape does](design_interaction#what-escape-does) |
| `Enter` | Confirm the open tool or value |
