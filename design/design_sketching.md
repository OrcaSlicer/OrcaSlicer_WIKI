# Sketching

A sketch is a 2D profile drawn on a reference plane or on a flat face of an existing body. It is the starting point of almost everything in the [Design tab](design_tab): profiles become solids through [Modeling Tools](design_modeling_tools), and they stay editable afterwards.

- [Starting a Sketch](#starting-a-sketch)
- [The Sketch Environment](#the-sketch-environment)
- [Entities](#entities)
- [Editing](#editing)
- [Constraints and Dimensions](#constraints-and-dimensions)
- [Finishing a Sketch](#finishing-a-sketch)
- [Reopening a Sketch](#reopening-a-sketch)

## Starting a Sketch

1. Click the face or reference plane you want to draw on.
2. Press `Shift + S`, or pick **Sketch** from the offer menu. The sketch opens on the face you clicked, on the first click.
3. Pick a tool — a single letter, the toolbar, or the offer menu — and draw.

Each tool says in the status line what it wants next, for example *Circle — click center, then radius*.

## The Sketch Environment

Three things change when a sketch opens, so the mode is unmistakable:

- A banner across the top of the viewport names the sketch and reminds you that `N` looks normal to the plane and that the sketch is left from the toolbar.
- The printer bed is muted, because a plate grid and a sketch grid look alike and reading one as the other is how a profile gets drawn against the wrong reference. Press `Ctrl + Shift + B` to bring the bed back.
- Single letters drive the sketch tools for as long as the sketch is open. See [Design Keyboard Shortcuts](design_keyboard_shortcuts).

Press `N` at any time to look straight at the sketch plane, keeping the current zoom.

## Entities

| Entity | Variants |
| --- | --- |
| Line | Single line, polyline |
| Rectangle | Corner, center, oblique, rounded |
| Circle | Center and radius, 2-point, 3-point |
| Arc | Center-point, 3-point, tangent |
| Ellipse | Ellipse, elliptical arc |
| Polygon | Inscribed, circumscribed |
| Slot | Straight, arc |
| Spline | B-spline through control points |
| Point | A single point |
| Text | Text on the sketch plane |

Press `Q` to draw the next entity as **construction geometry**, or to convert a selected entity between construction and real geometry. Construction lines guide the sketch and are ignored when the profile becomes a solid.

## Editing

| Tool | Key | What it does |
| --- | --- | --- |
| Trim | `T` | Cut a segment back to its nearest intersections |
| Extend | `X` | Run a line or arc out to what it would meet |
| Offset | `O` | Copy an entity at a distance |
| Mirror | `M` | Pick an axis, then the entities to reflect |
| Fillet | `F` | Round the corner between two lines |
| Chamfer | `H` | Bevel the corner between two lines |
| Dimension | `D` | Dimension two points or one entity |
| Value | `V` | Type the defining number of the selection — a line's length, an arc's radius, a circle's diameter, or the angle between two entities |

Entities can also be moved, rotated, scaled, and repeated in a linear or polar array from the toolbar.

## Constraints and Dimensions

Press `K` to finish the live tool and enter constraining. The available geometric constraints are coincident, collinear, horizontal, vertical, parallel, perpendicular, tangent, concentric, midpoint, equal length, equal radius, symmetric and fix. The dimensional constraints are distance, horizontal and vertical distance, angle, radius and diameter.

The solver reports the remaining degrees of freedom while you work and tells you when the sketch is fully constrained, or when a new constraint conflicts with one already there.

> [!TIP]
> Constrain the shape before dimensioning it. A profile that is square because it was constrained horizontal and vertical stays square when a dimension changes; one that is square only because it was drawn carefully does not.

## Finishing a Sketch

- **Confirm** in the floating action bar, or press `Enter`, to finish the sketch and keep it.
- **Cancel** in the action bar discards the sketch, and asks first when there is geometry to lose.
- `Esc` never destroys work. It closes an open value field, or drops the entity being drawn, or drops the armed tool back to Select, or clears the selection — one step at a time, in that order. A sketch that holds geometry is only left through Confirm or Cancel.
- `Ctrl + Z` inside a sketch removes the last entity drawn. `Del` or `Backspace` deletes the selected entities.
- A sketch whose entities form no closed wire fails with a message rather than producing a default shape. **Auto-close sketch loops** (Preferences → General → Features) decides how forgiving that check is: on, endpoints within 0.001 mm are welded into one joint; off, only exactly coincident endpoints join, so a loop with a hairline gap is reported as open.

## Reopening a Sketch

Sketches stay editable. Select one in the feature tree to reopen it with its dimensions live; change a value and every feature built on it rebuilds. Double clicking a sketch stroke in the viewport edits that entity directly.
