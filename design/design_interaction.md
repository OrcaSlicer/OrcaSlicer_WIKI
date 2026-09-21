# Selection and the Offer Menu

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

The [Design tab](design_tab) is **object-driven**: you point at geometry, and the geometry offers the verbs that apply to it. The selection comes first and the tool consumes it — noun, then verb, always in that order. This page covers the rules that hold everywhere in the tab.

- [Selecting](#selecting)
- [The offer menu](#the-offer-menu)
- [Confirm and Cancel](#confirm-and-cancel)
- [What Escape does](#what-escape-does)
- [Undo and Redo](#undo-and-redo)
- [View controls](#view-controls)

## Selecting

- **One left-click selects what is under the cursor.** There is no click-cycling through face, then edge, then body.
- A click near a corner takes the corner, not the face behind it.
- **Left-drag sweeps a rubber band**, and a rubber band takes the whole body.
- An open sketch line can be clicked, even where it bounds a region.
- **Double-click a sketch stroke to edit it** — the gesture belongs on the geometry, not in a panel.
- Editing a dimension's value **updates** that dimension instead of adding a second one beside it.
- Sketching happens on the face you clicked, on the first click.
- The floating chrome that belongs to a sketch leaves with the sketch when it ends.

A refusal is always explained rather than swallowed: a sketch whose entities form no wire **fails** instead of extruding a default box, and a subtraction that removes nothing is reported as an error instead of a silent success. Watch the status line under the toolbar for the reason.

The [Feature tree](design_tab#sidebar) and the Bodies list clear each other's selection, so what "the target" means is never ambiguous.

## The offer menu

Right-click on geometry and release without moving the mouse. The offer opens with the verbs that apply to what is under the cursor.

- A **right-drag orbits the camera** and does not open the menu. The two are told apart by a 3 px drift budget and a 200 ms hold budget — past either, the gesture was navigation. Both have to hold: drift alone still popped a menu at the end of a slow, careful orbit.
- The menu belongs to what you pointed at, so the pick is taken at the **press** position, not the release.
- **Left-click still only selects**, so pointing at things stays quiet.
- The offer also opens by itself the moment you press Sketch on a face or a plane, showing the sketch tools directly.
- `Menu` or `Shift + F10` opens the offer from the keyboard.

### The eight families

The offer always shows the same eight families, in the same fixed order, so a verb's position can be learned:

| Family | What lives there |
| --- | --- |
| Create | Makes new geometry from nothing you have yet — Sketch, and every sketch entity |
| Add material | Grows solid or sheet material — Extrude, Revolve, Sweep, Loft, Thicken, Rib, Boolean, the surface tools |
| Remove | Takes material away — Hole, Thread, Shell, Cut, Split, Trim |
| Dress-up | Finishes faces and edges — Fillet, Chamfer, Draft, Surface Offset |
| Repeat | Copies what exists — linear and circular patterns, Pattern on Curve, Mirror |
| Transform | Moves without changing shape — Move, Align, Mate |
| Reference | Datums, curves and measurements — Plane, Axis, Coord Sys, Helix, Project, Measure, Mass, Interference |
| Modify | Edits or removes what is already there — Edit, Rename, Delete Face, Colour, Delete |

A family with at least one applicable verb shows it; several applicable verbs collapse into a submenu under the family name.

> [!TIP]
> A family with nothing applicable is **shown greyed in place, with the reason** — for example *"Create — Click a face or a reference plane in the viewport, then a sketch tool"*. It is not hidden. If a verb you want is greyed, the menu itself tells you what to select first.

Inside a sketch the offer shows the sketch verbs; outside it, the feature verbs.

### What never enters the offer

Document-level actions act on the document, not on a selection, so they stay in the toolbar and never appear in the offer: Import STEP, Import mesh, Export STEP, Commit to Plate, Undo, Redo, Variables, Section view, Origin planes and World axes.

Text and SVG are *not* in that list — they create a sketch feature on the picked face, so they consume a selection like any other Create verb.

## Confirm and Cancel

Every tool, card and mode confirms through the same pair of buttons at the right end of the toolbar:

- **Confirm** commits the candidate. It greys out while the candidate is invalid, so a tool never commits something the kernel would reject.
- **Cancel** discards it. Cancelling a sketch that holds geometry asks first.

`Enter` also commits the tool or the value that is currently open.

## What Escape does

`Esc` unwinds exactly one level at a time, and **no level of `Esc` ever deletes a feature, discards a sketch that holds geometry, or rolls history back**:

| What is up | One press of `Esc` | What it leaves alone |
| --- | --- | --- |
| A value field or a popup menu | Closes just that | The tool, which stays armed |
| An uncommitted gesture (an entity being drawn, a body being dragged) | Drops the clicks of the entity, or puts the body back where it was when the gizmo appeared | Everything already committed |
| A tool (a feature card, an armed sketch tool, a constrain session) | Discards the card's candidate, drops the sketch tool back to Select, or ends Constrain | Committed features, and entities already drawn |
| Nothing transient | Clears the selection, and leaves a sketch session **only if it is empty** | A sketch that holds geometry — that one is left through Confirm or Cancel |

Destroying work always needs a gesture that says so:

| To destroy | Gesture |
| --- | --- |
| A feature | `Del` or `Backspace` on an explicit selection |
| A drawn sketch | **Cancel** in the action bar, which asks first |
| The last committed change | `Ctrl + Z` |

## Undo and Redo

`Ctrl + Z` undoes and `Ctrl + Shift + Z` (or `Ctrl + Y`) redoes, from Feature, Sketch and Constrain alike, whether or not the viewport has keyboard focus. The toolbar buttons run the same path.

Inside a sketch, `Ctrl + Z` drops the last entity you drew.

## View controls

These are single letters, active when **no sketch is open**:

| Key | Action |
| --- | --- |
| `Home` | Axonometric view, fitted to the model |
| `P` | Origin planes on or off |
| `A` | World axes on or off |
| `X` | Section view on or off |
| `F` | Place on Face — lay the picked face flat on the bed (when no section is active) |
| `Ctrl + Shift + B` | Show or hide the printer bed |

### Section view

<img alt="split_parts_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/split_parts_dark.svg?raw=true" height="22"> Section view hides half the model so you can see inside it. While it is on:

| Key | Action |
| --- | --- |
| `PageUp` / `PageDown` | Move the cut plane |
| `F` | Flip which half is kept |
| `Del` | Remove the section |

> [!NOTE]
> Inside a sketch, `N` looks normal to the sketch plane, keeping the current zoom. That is a sketch-mode key only — in Feature mode the view navigator owns orientation.
