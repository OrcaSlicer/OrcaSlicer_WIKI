# Seam Painting

This tool allows you to specify areas on your 3D model where seams should be placed or avoided during printing.  
This is particularly useful for models with visible surfaces where you want to minimize the appearance of seams or direct them to less noticeable areas.

> [!TIP]
> To place the seam at an exact point, or to keep seam zones through model revisions without repainting, use [Precise Seam](prepare_precise_seam) modifiers.

- [Enforce, block and erase](#enforce-block-and-erase)
- [How painting affects the seam](#how-painting-affects-the-seam)
- [Tools](#tools)
- [Common workflows](#common-workflows)

Open the tool from the toolbar or with the `P` key.

## Enforce, block and erase

| Action | Control |
|--------|---------|
| Enforce seam (the seam is placed here when possible) | Left mouse button |
| Block seam (the seam is kept away from here) | Right mouse button |
| Erase | `Shift` + Left mouse button |
| Change brush size | `Ctrl` + Mouse wheel (`Cmd` on macOS) |

**Erase all** clears every painted area on the object. **Done** closes the tool.

Your strokes belong to the project, so they come back when you reopen the 3MF.

## How painting affects the seam

Painting steers the seam but is not an absolute rule. On every layer, the slicer collects candidate points along each outer wall loop and ranks them. A candidate counts as painted when it lies within about one line width of a painted area.

- A loop that crosses an enforced area puts its seam inside that area when it can.
- Blocked candidates rank last, so the seam moves to the nearest unblocked spot. If a loop is blocked all the way around, it still gets a regular seam.
- Layers where the wall does not touch any painted area follow the [Seam position](quality_settings_seam#seam-position) setting, as if nothing was painted.
- With [Aligned](quality_settings_seam#aligned) and [Aligned Back](quality_settings_seam#aligned-back), the center of an enforced patch is preferred and the painted seams line up from layer to layer.

Because unpainted layers fall back to the global setting, check where that default puts the seam. Rotating the model, or choosing Aligned Back, can place it on the side that is hidden from view.

> [!NOTE]
> Candidates are compared by painted state first. Overhang and visibility only break ties between candidates that are equally painted, so a painted spot wins over a better-hidden unpainted one.

## Tools

| Tool | Shortcut | What it does |
|------|----------|--------------|
| Circle | `C` | Marks the faces facing the camera under the circle. Hidden faces are skipped. |
| Sphere | `S` | Marks every face inside the brush volume, including faces hidden behind the surface. It follows contours and reaches into crevices. |

**Brush size** controls how precise the mark is. A small brush draws a thin line the seam can follow. A large one marks a whole region and leaves the slicer more freedom to choose a point inside it.

Tick **Vertical** to lock the stroke to a straight vertical line on the screen while you drag. It is the quickest way to draw a clean seam line down the back of a model.

## Common workflows

### Hide the seam on a single edge

1. Open Seam Painting.
2. Tick **Vertical** and use a small brush.
3. Drag down the edge or corner where the seam should go.
4. Slice and check the seam in the preview.

### Keep the seam off a visible face

1. Open Seam Painting.
2. Right-click to block the face with a large brush.
3. Slice. The seam moves to the nearest unblocked area of each layer.

### Redo a stroke

1. Hold `Shift` and left-click over the stroke to erase it, or press **Erase all**.
2. Paint again.
