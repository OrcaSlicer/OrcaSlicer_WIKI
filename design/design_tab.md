# Design Tab

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

<img alt="tab_design_active" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/tab_design_active.svg?raw=true" height="22"> The **Design** tab is a sketch-first parametric CAD workspace built into OrcaSlicer. Draw a sketch, constrain it, turn it into a solid, refine it, and send it straight to Prepare — without exporting to another application and coming back through an STL.

> [!WARNING]
> The Design tab is **experimental** and still under development. It is switched off by default and must be enabled in Preferences before the tab appears. Expect rough edges — see [Known limitations](#known-limitations).

- [The model is a recipe, not a mesh](#the-model-is-a-recipe-not-a-mesh)
- [Enabling the Design tab](#enabling-the-design-tab)
- [The workspace](#the-workspace)
- [Your first part](#your-first-part)
- [Preferences](#preferences)
- [Known limitations](#known-limitations)
- [In this section](#in-this-section)

## The model is a recipe, not a mesh

Every action you take becomes a **feature** in a tree. The tree is replayed from the start whenever anything changes, so editing a dimension you set twenty steps ago rebuilds everything that came after it. A hole stays a hole, a fillet stays a fillet, and the part never collapses into triangles you can no longer edit.

The geometry kernel is **OCCT**, the same kernel OrcaSlicer already ships for STEP import, so imported STEP files are real B-rep solids that can be filleted, shelled and cut exactly like anything you model yourself.

The whole feature recipe is stored inside the project 3MF. Reopening the project restores an editable model rather than a frozen mesh — see [Import, Export and Commit to Plate](design_import_export).

Because the design lives in the slicer, the nozzle diameter, build volume and material are known while you are still modelling: the printer bed is available as the first sketch plane, so a part is sized against the machine that will print it from the first line you draw.

## Enabling the Design tab

The tab is not created at all until the feature is turned on, so nothing it builds can reach a user who has not asked for it.

1. Open **Preferences** (`Ctrl + P`).
2. Go to **General > Features**.
3. Tick **CAD feature (experimental)**.
4. Restart OrcaSlicer.

The **Design** tab then appears in the top tab bar, between **Home** and **Prepare**.

> [!NOTE]
> The Design tab is compiled into the official builds (the `SLIC3R_CAD` build option defaults to on). If you build OrcaSlicer yourself with `-DSLIC3R_CAD=OFF`, the tab is not compiled and the preference does not appear.

## The workspace

### Toolbar

The toolbar runs across the top of the tab. **Almost every modelling verb is reached from the [offer menu](design_interaction#the-offer-menu) or from the keyboard, not from a button** — the toolbar deliberately carries only what acts on the document or on the view:

| Group | Contents |
| --- | --- |
| Document | <img alt="add" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/add.svg?raw=true" height="18"> New Design, <img alt="design_step" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_step.svg?raw=true" height="18"> Import STEP, Import mesh, <img alt="save" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/save.svg?raw=true" height="18"> Export STEP, and a **Bed** checkbox that shows or hides the printer bed |
| History | <img alt="menu_undo" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/menu_undo.svg?raw=true" height="18"> Undo and <img alt="menu_redo" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/menu_redo.svg?raw=true" height="18"> Redo, available in every mode |
| View | <img alt="toolbar_flatten_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_flatten_dark.svg?raw=true" height="18"> Place on Face, <img alt="split_parts_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/split_parts_dark.svg?raw=true" height="18"> Section View and <img alt="design_mirror" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_mirror.svg?raw=true" height="18"> Flip Section |
| Sketch | The sketch entity palette, shown only while a sketch is open |
| Constrain | The geometric and dimensional constraint buttons, shown while a sketch or a constrain session is open |
| Commit | <img alt="toolbar_add_plate_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_add_plate_dark.svg?raw=true" height="18"> **Commit to Plate**, the tab's primary action, at the right end |
| Action bar | **Confirm** and **Cancel** — the single confirm/cancel surface for every tool and mode |

### Sidebar

| Card | What it holds |
| --- | --- |
| <img alt="design_sketch" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_sketch.svg?raw=true" height="18"> Feature tree | Every feature in the order it is replayed. Double-click a row to edit it, `F2` or right-click to rename it. The right-click menu also moves a row up or down, shows or hides it, and deletes it. |
| <img alt="design_extrude" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_extrude.svg?raw=true" height="18"> Bodies | One row per solid or sheet body, with buttons to move, boolean, show or hide, delete and recolour the selected body. |
| <img alt="design_constrain" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_constrain.svg?raw=true" height="18"> Variables | Named values and expressions that drive dimensions — see [Variables and Expressions](design_variables). |

### Status line

The line under the toolbar is the thing to watch: it says what the current tool is waiting for, and it is where a refusal explains itself. With no plane picked it reads *"Click a face or a reference plane in the viewport, then a sketch tool"*; once one is picked it names the face you are sketching on.

A second, bold line reports the sketch solver's state: the remaining degrees of freedom, whether the sketch is fully constrained, and whether a constraint conflicts with one already there.

## Your first part

1. Open the **Design** tab.
2. Click a face or a reference plane in the viewport, then press `Shift + S` (Sketch). The offer opens with the sketch tools on it.
3. Draw a closed profile, then press **Confirm** in the action bar.
4. With the sketch selected, press `Shift + E` (Extrude) and set a depth.
5. Press **Commit to Plate** (`Ctrl + Shift + P`) to hand the solid to Prepare.

From there, keep going: [sketch](design_sketching) on a face of the new solid, add [features](design_features), drop in [reference geometry](design_reference_geometry), and [commit](design_import_export#commit-to-plate) again whenever you want to slice what you have.

## Preferences

| Preference | Location | Default | What it does |
| --- | --- | --- | --- |
| CAD feature (experimental) | General > Features | Off | Shows the Design tab. Requires a restart. |
| Auto-close sketch loops | General > Features | On | Treats sketch endpoints within 0.001 mm as one joint and welds the loop shut. When off, only exactly coincident endpoints join, so a loop with a tiny gap is reported as open instead of being closed for you. |
| Draw mate connectors as a face | General > Camera | On | Draws a mate connector as a small face instead of the conventional disc with a roll quadrant. Turn it off for the conventional CAD representation. Only shown when the CAD feature is enabled. |

## Known limitations

These are the edges as the feature shipped, so nobody has to find them the hard way:

- **Rib** needs a sketch that contains an explicit open line. A parametric rectangle sketch carries no individual entities, so Rib cannot use one.
- **Surface Loft** and **Surface Fill** have kernel tests but have not been exercised by hand.
- Card wiring for 9 of the 16 late-wired tools has never been click-tested.
- **Mate** resolves by composing transforms directly. There is no 3D assembly solver, so mates are applied in order rather than solved simultaneously, and mate limits are not implemented.
- **Move face** and **replace face** are not implemented — OCCT offers no clean primitive for them.
- There is no automated GUI test in CI. Every behaviour documented here is traced to the code and to a hand pass, not to a synthetic click.

## In this section

- [Selection and the Offer Menu](design_interaction) — how picking works, the right-click offer, `Esc`, and the view controls
- [Sketching](design_sketching) — entities, snapping, editing tools, dimensions and constraints
- [Solid and Surface Features](design_features) — extrude, revolve, sweep, loft, dress-up, holes, threads, booleans and patterns
- [Reference Geometry](design_reference_geometry) — datum planes, axes, coordinate systems, helices, and the measurement tools
- [Assemblies](design_assemblies) — mates between bodies and the interference check
- [Variables and Expressions](design_variables) — named values that drive the model
- [Import, Export and Commit to Plate](design_import_export) — STEP, mesh, SVG and text in; STEP and the plate out
- [Design Keyboard Shortcuts](design_keyboard_shortcuts) — the full key map for both modes
