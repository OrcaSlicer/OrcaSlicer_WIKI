# Parts, Modifiers and Per-Object Settings

An object in OrcaSlicer is a set of parts. Besides the printable model, you can add helper bodies that change how a region prints, cut material away, or steer the supports. You can also give a single object, part or height range its own settings, without touching your process preset.

- [Part types](#part-types)
- [Adding a part](#adding-a-part)
- [Settings on an object or part](#settings-on-an-object-or-part)
- [Modifiers](#modifiers)
- [Height Range Modifier](#height-range-modifier)
- [Common workflows](#common-workflows)

## Part types

Right-click an object in the object list to add a part. The type decides what the body does.

| Type | What it does |
|------|--------------|
| Part | An extra printable body, joined to the object. |
| Negative Part | A body that is subtracted from the object. Use it for holes, slots and pockets. |
| Modifier | A body that is never printed. Where it overlaps the object, that region uses the settings you attach to the modifier. |
| Support Blocker | A body that keeps supports out of its volume. |
| Support Enforcer | A body that forces supports inside its volume. |
| [Precise Seam](prepare_precise_seam) | A body that decides where the seam goes. |

> [!TIP]
> Blockers and enforcers do the same job as [Support Painting](prepare_support_painting), but as a shape you can move and resize. Use a body when the area is simple and regular, and painting when it is organic.

## Adding a part

Each type opens a submenu with the same sources:

- **Load...** to import a mesh file.
- **Cube, Cylinder, Sphere, Cone, Disc, Torus** for a ready-made shape.
- **Text** and **SVG** to create a part from text or a vector image. See [Emboss](prepare_emboss).

Select the new part in the object list to move, rotate and scale it like any other body.

## Settings on an object or part

Select an object or one of its parts, then use **Add Settings** in the right-click menu. Pick a category and tick the options to override. They appear under the item in the object list, and the values you set replace the process preset for that item only.

- On an **object**, the options apply to the whole object.
- On a **part or modifier**, the options apply to that body.
- Support options are available on objects only, not on parts.
- Options for extruders and wipe settings only show up when the project uses more than one filament.

The right-click menu also offers a short list of the most common overrides: layer height, wall loops, top and bottom shell layers, sparse infill density and pattern, and the main support options.

> [!NOTE]
> A per-object value always wins over the same option in the process preset. If a print does not match your preset, check the object list for overrides.

## Modifiers

A modifier lets you change settings in only one region of an object. When slicing, the object is split into regions, and a region that overlaps a modifier takes the modifier's settings.

Typical uses:

- Higher infill density inside a bracket's bolt area.
- More walls around a hole.
- A different infill pattern in one section.

Size and place the modifier to cover only the region you want. The modifier is not printed and does not add material.

## Height Range Modifier

Choose **Height Range Modifier** from the object's right-click menu to apply settings between two heights. It adds a height range under the object, and you set its start and end height and the options to override.

The most common reason to use it is a different **layer height** in one band, for example finer layers on a detailed section. For gradual changes along the whole model, use [Variable Layer Height](prepare_variable_layer_height) instead.

## Common workflows

### Stronger area on one object

1. Right-click the object, then **Add Modifier** and **Cube**.
2. Move and scale the cube over the area that needs strength.
3. Right-click the modifier, then **Add Settings** and **Infill**.
4. Raise the sparse infill density for that modifier only.

### Screw holes in a model

1. Right-click the object, then **Add Negative Part** and **Cylinder**.
2. Scale the cylinder to the hole diameter and place it through the model.
3. Slice. The volume of the cylinder is removed from the object.

### Finer layers on a small section

1. Right-click the object and choose **Height Range Modifier**.
2. Set the start and end height of the section.
3. Add **layer height** to the range and enter the finer value.
