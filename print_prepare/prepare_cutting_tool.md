# Cutting Tool

This tool is used to cut 3D models into smaller parts for easier printing or assembly.

You can cut a model with a flat plane or with a dovetail profile, decide what to do with each half, and add connectors so the pieces can be glued or snapped back together after printing.

- [Open the tool](#open-the-tool)
- [Position the cut](#position-the-cut)
- [Cut modes](#cut-modes)
- [After the cut](#after-the-cut)
- [Connectors](#connectors)
- [Common workflows](#common-workflows)
- [Warnings](#warnings)

## Open the tool

Select an object and press `C` (the default shortcut, which you can change in [Keyboard Shortcuts](keyboard_shortcuts)), or choose the cutting tool from the toolbar. A cut plane appears on the model, with the upper part and the lower part drawn in different colors.

| Action | Control |
|--------|---------|
| Move the cut line | Drag |
| Draw a new cut line | `Shift` + Drag |
| Flip the cut plane | **Flip cut plane** button |

Use **Cut position** to type the height of the plane. **Reset cutting plane** puts it back at the center of the model. The panel also shows the size of the model in each axis.

**Hide cut plane and grabbers** clears the handles so you can inspect the model.

## Position the cut

Move and tilt the plane until it passes where you want to split the model. Cutting through a thin neck or a flat area gives the cleanest joint. Think about how each half will sit on the bed, as the next section lets you rotate the halves for printing.

## Cut modes

Choose the mode with the **Mode** selector. It is locked while connectors exist.

### Planar

A flat cut. This is the default and the only mode that supports [connectors](#connectors).

### Dovetail

A cut with a tongue-and-groove profile, so the two halves lock together without connectors. The options shape the groove:

| Option | What it controls |
|--------|------------------|
| Depth | How deep the groove goes. |
| Width | How wide the groove is. |
| Flap Angle | The angle of the groove flaps, from 30° to 120°. |
| Groove Angle | A draft on the groove walls, from 0° to 15°. |
| Count | How many grooves are cut along the plane. |
| Gap | The distance between grooves. Only used when Count is above 1. |
| Spacing | The center-to-center distance, calculated from the groove width and the gap. |

Depth and Width each have a second **Tolerance** value that adds clearance, so the printed tongue fits the printed groove.

## After the cut

The **After cut** section sets what happens to each half. Each row has three options:

| Option | What it does |
|--------|--------------|
| Keep | Keep this half. Untick it to discard the half. |
| Place on cut | Rotate the half so its cut face lies on the bed. |
| Flip | Turn the half upside down. |

**Place on cut** and **Flip** are mutually exclusive. You must keep at least one half.

**Cut to parts** keeps both halves in the same object as separate parts, instead of two objects. It is not available with connectors or in Dovetail mode.

After you press **Perform cut**, the tool can detect non-manifold edges caused by the cut and offer to repair them.

## Connectors

Connectors are small pegs, pins or clips that you add to the cut face of a Planar cut, so the pieces align and join.

Press **Add connectors** to open the connector editor. The button is disabled unless both halves are kept and **Cut to parts** is off.

### Edit connectors

| Action | Control |
|--------|---------|
| Add a connector | Left mouse button on the cut face |
| Remove a connector | Right mouse button on it |
| Move a connector | Drag |
| Add to selection | `Shift` + Left mouse button |
| Remove from selection | `Alt` + Left mouse button |
| Select all connectors | `Ctrl` + `A` |

Changes apply to every selected connector, so you can place several and then change their type or size together. **Remove connectors** deletes them all. **Confirm connectors** returns to the cut panel and **Cancel** discards your edits.

### Connector type

| Type | Result |
|------|--------|
| Plug | The lower part gets a solid peg, and the upper part gets a matching hole. |
| Dowel | A separate pin is created as its own object, printed on its own. |
| Snap | A snap-fit connector. It adds the **Bulge** and **Space** options. |

### Connector options

| Option | What it controls |
|--------|------------------|
| Style | Prism or Frustum. Only used by Plug connectors. |
| Shape | Triangle, Square, Hexagon or Circle. Not used by Snap, which is always round. |
| Depth | How far the connector reaches into the part. |
| Size | The diameter of the connector. |
| Rotation | Turns the connector around its axis, from 0° to 180°. |
| Bulge | Snap only. The bulge height as a proportion of the radius. |
| Space | Snap only. The gap proportion, related to the radius. |

**Depth** and **Size** each have a second **Tolerance** value. For a Plug or Snap, the tolerance makes the hole in the upper part wider and deeper than the peg, so the two pieces fit after printing. A tolerance of zero gives a hole the same size as the peg, which is often too tight for a printer.

> [!TIP]
> Print a small test cut first and adjust the Tolerance until the pieces fit by hand. The right value depends on your printer, your material and the connector size.

## Common workflows

### Split a tall model to fit the bed

1. Select the object and press `C`.
2. Enter a **Cut position** that splits the model into pieces that fit your build plate.
3. Under **After cut**, tick **Place on cut** for the halves that should print on their cut faces.
4. Press **Perform cut**.

### Join the halves with plugs

1. Open the tool and position a Planar cut.
2. Press **Add connectors**.
3. Left-click on the cut face where each plug should go, away from the edges.
4. Choose **Plug** and set **Size**, **Depth** and a **Tolerance** for the fit.
5. Press **Confirm connectors**, then **Perform cut**.

### Make a model that locks without glue

1. Open the tool and switch **Mode** to **Dovetail**.
2. Set the groove **Depth**, **Width** and **Tolerance**.
3. Press **Perform cut**, then print both halves and slide them together.

### Cut, scale and reassemble

1. Cut the object with **Cut to parts** ticked, so the halves stay in one object.
2. Scale or edit each part on its own in the object list.
3. The parts stay together as one assembly for slicing.

## Warnings

The panel shows a warning when the cut cannot be performed:

- **Select at least one object to keep after cutting.** Both halves are unticked under Keep.
- **Cut plane is placed out of object.** The plane does not touch the model.
- **Cut plane with groove is invalid.** The Dovetail settings do not fit the model.
- **Invalid connectors detected.** A connector is outside the cut contour, outside the object, or overlaps another connector.
