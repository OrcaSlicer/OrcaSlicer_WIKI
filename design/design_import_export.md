# Import, Export and Commit to Plate

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

The [Design tab](design_tab) is not a closed world: existing CAD comes in, artwork comes in, the model goes out to another tool, and the finished solid goes to [Prepare](prepare_basic) for slicing. These actions act on the document rather than on a selection, so they live in the toolbar and never appear in the [offer menu](design_interaction#the-offer-menu).

- [Import STEP](#import-step)
- [Import mesh](#import-mesh)
- [Text and SVG](#text-and-svg)
- [Export STEP](#export-step)
- [Commit to Plate](#commit-to-plate)
- [What the 3MF keeps](#what-the-3mf-keeps)

## Import STEP

<img alt="design_step" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_step.svg?raw=true" height="22"> **Import STEP** (`Shift + I`) brings in a real B-rep solid, not a mesh. Its faces and edges can be filleted, shelled, drafted and cut exactly like anything modelled in the tab, because it is the same kind of geometry.

Accepts `.step` and `.stp`. The imported solid arrives as its own body, coexisting with whatever is already in the document.

## Import mesh

**Import mesh** (`Shift + M`) accepts `.stl` and `.obj`, and converts the triangles into a B-rep body.

It then tells you honestly what it got, on the status line:

- Whether the result is a **closed solid** or an **open shell**
- For an open shell, the **boundary edge** and **non-manifold edge** counts — a defect in the source mesh you need to know about before cutting features into it
- The triangle count, the resulting face count, and the volume

> [!WARNING]
> Every triangle becomes a B-rep face before coplanar merging, so a dense mesh becomes a very large number of faces and a body that is slow to edit. Above a threshold the importer asks before going ahead, and suggests decimating the mesh first. A dense organic scan has few coplanar neighbours to merge away and stays heavy afterwards.

## Text and SVG

<img alt="design_text" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_text.svg?raw=true" height="22"> **Text** and <img alt="design_svg" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_svg.svg?raw=true" height="22"> **SVG** add an outline to the **current sketch** as editable lines, so an emblem or a label can be extruded, embossed or cut like any other profile.

Unlike the other imports, these consume a selection — they create a sketch feature on the picked face — so they behave like any other Create verb and do appear in the offer. Accepts `.svg`.

Once imported, the outline can be resized from the feature tree: right-click its row and choose **Scale artwork**.

> [!NOTE]
> For text applied to a model that is already on the plate, Prepare has its own [Emboss](prepare_emboss) tool. Use the Design tab's Text when you want the lettering to be part of the parametric model.

## Export STEP

<img alt="save" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/save.svg?raw=true" height="22"> **Export STEP** writes the model out as `.step` or `.stp` for another CAD tool. This is the route out to a colleague, a manufacturer, or a package with a capability the Design tab does not have.

## Commit to Plate

<img alt="toolbar_add_plate_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_add_plate_dark.svg?raw=true" height="22"> **Commit to Plate** (`Ctrl + Shift + P`) is the tab's primary action: it hands the solid to Prepare and switches to that tab, ready to slice. No export, no re-import, no lost design intent.

A few things worth knowing about what it ships:

- **A tool that is open with a live preview is applied first**, so what you commit is exactly what is on screen and not the pre-feature solid.
- **What you see on the Design plate is what gets committed.** Hidden bodies are skipped, so the Bodies list doubles as the commit selection.
- **A multi-body document ships each visible body as its own plate object**, so the parts arrive in Prepare as independent, separately arrangeable objects.
- Bodies that have been moved with the Move gizmo are shipped at their current positions.
- Committing with nothing built, or with every body hidden, is refused with a message on the status line rather than producing an empty object.

## What the 3MF keeps

Saving the project writes the whole feature recipe into the 3MF, alongside the committed meshes, as `Metadata/orca_cad.bin`. Reopening the project restores the **editable feature tree**, not just the baked solid — the part you designed an hour ago comes back as a design, not as a mesh.

Both 3MF writers carry it, and a project with no CAD content writes no recipe, so non-CAD projects stay clean.

> [!NOTE]
> A CAD project can legitimately contain no mesh at all: the model lives in the feature tree until it is committed. Opening such a project does **not** warn that the file contains no geometry — the recipe counts as geometry, and the Design tab rehydrates it.

Starting a new project clears both the recipe and the Design tab's document, so the next project never inherits the previous one's feature tree.
