# Design Tab

> [!IMPORTANT]
> NEW FEATURE: **Design Tab**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

The Design tab is a sketch-first parametric CAD environment inside OrcaSlicer. Draw a sketch, constrain it, turn it into a solid, refine it and send it straight to the plate, without leaving for another application and coming back through an STL.

What you build is a **recipe**, not a mesh. Every action becomes a feature in a tree that is replayed from the start whenever anything changes, so editing a dimension you set twenty steps ago rebuilds everything that came after it. The recipe is stored inside the 3MF project file, so reopening the project restores an editable model instead of a frozen mesh.

- [Getting Started](#getting-started)
- [The Status Line](#the-status-line)
- [Selecting](#selecting)
- [The Offer Menu](#the-offer-menu)
- [View Controls](#view-controls)
- [Import and Export](#import-and-export)
- [Commit to Plate](#commit-to-plate)
- [Limitations](#limitations)

The rest of the tab is covered in [Sketching](design_sketching), [Modeling Tools](design_modeling_tools) and [Design Keyboard Shortcuts](design_keyboard_shortcuts).

## Getting Started

1. Open the **Design** tab.
2. Click a face or a reference plane in the viewport, then press `Shift + S` (Sketch). The offer menu opens with the sketch tools on it.
3. Draw a closed profile, then confirm the sketch in the floating action bar.
4. With the sketch selected, press `Shift + E` (Extrude).
5. Press **Commit to Plate** (`Ctrl + Shift + P`) to hand the solid over to [Prepare](home#prepare).

> [!TIP]
> Nothing has to be modeled from scratch. [Import STEP](#import-and-export) brings in a real solid whose faces and edges can be filleted, shelled and cut like anything drawn here.

## The Status Line

The line under the toolbar says what the current tool is waiting for, and it is the first place to look when something does not happen:

- With no plane picked it reads *Click a face or a reference plane in the viewport, then a sketch tool*.
- Once a plane is picked it reads *Sketching on &lt;face&gt; — pick a tool*.
- When an operation refuses, this is where it explains itself.

## Selecting

Selection comes first and the tool consumes it: point at the geometry, then pick the verb.

- One left click selects what is under the cursor. There is no click cycling through face, edge and body.
- A click near a corner takes the corner, not the face behind it.
- Left dragging sweeps a rubber band, and a rubber band takes the whole body.
- An open sketch line can be clicked, even where it bounds a region.
- Double click a sketch stroke to edit it.
- Editing a dimension value updates that dimension instead of adding a second one beside it.
- Clicking empty space clears the selection. It never commits anything.

## The Offer Menu

Right click on the geometry, released without moving the mouse, and the offer menu opens with the verbs that apply to what is selected. A right drag that orbits the camera does not open it, and left click still only selects, so pointing at things stays quiet. The menu can also be opened from the keyboard with the `Menu` key or `Shift + F10`, and it opens by itself when you press Sketch on a face or a plane.

The menu always shows the same eight families in the same order, so a verb keeps the same position everywhere it appears:

| Row | Family | What it holds |
| --- | --- | --- |
| 1 | Create | Sketch on a face, edit text |
| 2 | Add material | Extrude, thicken, combine |
| 3 | Remove | Hole, shell, cut, split, thread |
| 4 | Dress-up | Fillet, chamfer, draft |
| 5 | Repeat | Pattern, mirror |
| 6 | Transform | Move, align, mate |
| 7 | Reference | Plane, axis, project, measure |
| 8 | Modify | Edit, rename, color, delete |

- A family with one applicable verb shows that verb directly; several applicable verbs collapse into a submenu under the family name.
- A family with nothing applicable is shown greyed **in place, with the reason** — for example *Create — Click a face or a reference plane in the viewport, then a sketch tool*. Rows are never hidden or reordered, so the menu is also a map of what the tab can do and what you have to do first.
- Inside a sketch the menu offers the sketch verbs; outside it offers the feature verbs.
- Every row shows its keyboard shortcut, so the menu teaches the key that makes it unnecessary.

Actions that work on the document rather than on a selection stay on the toolbar and never appear in the menu: Import STEP, Import mesh, Text, SVG, Export STEP, Commit to Plate, Undo, Redo, Variables, Section view, Origin planes and World axes.

## View Controls

| Control | Key | What it does |
| --- | --- | --- |
| Fit view | `Home` | Isometric view, fitted to the model |
| Origin planes | `P` | Show or hide the three origin planes |
| World axes | `A` | Show or hide the world axes |
| Section view | `X` | Hide half the model to see inside it |
| Move the cut | `Page Up` / `Page Down` | Move the section plane, while the section is on |
| Flip the cut | `F` | Keep the opposite half, while the section is on |
| Place on Face | `F` | Lay the picked face flat on the bed, when no section is on |
| Show or hide the bed | `Ctrl + Shift + B` | The printer bed is muted while a sketch is open, so a plate grid is never read as a sketch grid |

## Import and Export

**Import STEP** (`Shift + I`) brings in a real B-rep solid rather than a mesh. Its faces and edges can be filleted, shelled and cut like anything modeled in the tab.

**Import mesh** (`Shift + M`) converts an STL or OBJ into a B-rep body and reports what it got: whether the result is a closed solid or an open shell, and how many boundary and non-manifold edges it has.

> [!WARNING]
> A large mesh becomes a body with a large number of faces, which is slow to edit. The importer warns before you commit to it.

**Export STEP** writes the model out for another CAD application, as real B-rep geometry rather than a tessellation.

## Commit to Plate

**Commit to Plate** (`Ctrl + Shift + P`) hands the solid to [Prepare](home#prepare) for slicing. The feature recipe is saved inside the 3MF project, so reopening the project restores the editable model rather than a frozen mesh — a part can be dimensioned again after it has been sliced.

## Limitations

- **Rib** needs a sketch that contains an explicit open line. A parametric rectangle sketch carries no individual entities, so Rib cannot use one.
- **Mates** are applied in the order they were created rather than solved together, because there is no 3D assembly solver behind them. Mate limits are not implemented.
- Moving and replacing a face of an existing solid are not available.
