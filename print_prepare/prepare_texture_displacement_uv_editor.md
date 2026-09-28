# Texture Displacement UV Editor

> [!IMPORTANT]
> NEW FEATURE: **Texture displacement**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

The UV Editor is the 2D pane that belongs to the **Unwrap (LSCM)** mapping of [Texture Displacement](prepare_texture_displacement). Unwrapping flattens the painted area into one or more **islands** and lays the texture over them; this pane is where you see that layout and change it by hand.

The other mappings project the texture onto the surface from outside and need no layout, so the pane only applies to a layer whose mapping is **Unwrap (LSCM)**.

- [Opening the pane](#opening-the-pane)
- [Unwrapping](#unwrapping)
- [Seams](#seams)
- [Editing the layout](#editing-the-layout)
- [Tools](#tools)
- [Navigation and shortcuts](#navigation-and-shortcuts)

## Opening the pane

Choose **Unwrap (LSCM)** as a layer's mapping and the pane opens beside the 3D view. Until a layer is mapped that way it reports *No layer mapped with Unwrap*, and until something is painted it asks you to paint the area on the model first.

Along the top are the layer's texture and name, the current tile size, and three background buttons:

| Background | Shows |
| --- | --- |
| **Height map** | The layer's own texture under the islands, repeating exactly as it will when baked. |
| **Checker** | A test grid. Squares stay square where the unwrap does not stretch. |
| **Distortion** | Each island coloured by how much the unwrap stretches it. |

Choosing **Checker** or **Distortion** here also colours the model in the 3D view, so stretch can be judged in both places at once.

## Unwrapping

The **Unwrap** button computes the layout. Two settings decide what it produces, and both take effect at the next unwrap:

- **Seam angle** - edges sharper than this are cut, and the pieces either side of them are flattened separately. Lower it to cut more: each piece then lies flat with less stretching, at the cost of the texture not running continuously across the cut. Once you have marked any seam by hand, your seams define the pieces instead and this is ignored.
- **Connect islands** - lays the unwrap out as a connected net: pieces that share an edge are unfolded next to each other, so a cube becomes a joined net rather than six loose squares. They stay separate islands, so any of them can still be moved by hand afterwards. Turn it off for a plain packed layout.

A summary along the bottom reports how many islands and faces the unwrap produced. If the paint, the seams or the seam angle change afterwards, the pane marks the layout **out of date** - press **Unwrap** again to rebuild it.

> [!NOTE]
> Re-unwrapping re-cuts and re-places the islands, so placements made by hand before it are discarded.

## Seams

Seams are edges the unwrap is forced to cut along, on top of whatever the seam angle cuts. They are how you decide exactly where the flattened pieces split - the same idea as marking a seam in a 3D modelling package.

- **Mark seams** - click edges on the model to cut the unwrap along them. The edge under the cursor is highlighted yellow; click to mark it red, and click a red edge again to unmark it. Painting is paused while this is on.
- **Path** - instead of clicking every edge, click a start point and then an end point: the whole shortest path between them is seamed at once. Each further click continues from the last point. Available while marking seams.
- **Clear seams** - removes every seam marked on this layer.

Hold **Ctrl** and drag to move the camera while marking seams.

## Editing the layout

Three selection modes decide what a drag in the pane moves:

| Mode | What it edits |
| --- | --- |
| **Island** | Whole islands - move, rotate and scale them. |
| **Vertex** | Individual vertices, to reshape an island. |
| **Edge** | Island edges, to reshape an island. |

**Shift** or **Ctrl** with a click adds to or removes from the selection in any of the three modes, and a drag then moves everything selected together. The model updates as you drag, so the effect of a placement is visible immediately.

**Clear UV edits** discards all manual vertex and edge moves and returns the unwrap to its automatic shape.

## Tools

| Tool | What it does |
| --- | --- |
| **Average scale** | Gives every island the same texel density, so an island scaled by hand can be matched back to its neighbours. |
| **Cut** | Splits the selected island across its long axis - useful for a long, curved island that cannot lie flat in one piece. |
| **Join** | Unfolds the selected island onto its nearest neighbour along their shared edge. Both stay separate islands with their own borders. |
| **Unjoin** | Sends the selected island back to its own packed position. |
| **Snap** | Sticks islands together when dragging one against another. |
| **Frame** | Frames all islands in the pane. |

## Navigation and shortcuts

| Input | Action |
| --- | --- |
| Left-click | Select |
| Shift or Ctrl + left-click | Add to or remove from the selection |
| Left-drag | Move the selection |
| Right-drag | Rotate the selected island |
| **R** | Rotate with the mouse; click or **Enter** confirms, **Esc** cancels |
| **S** | Scale with the mouse; click or **Enter** confirms, **Esc** cancels |
| **Shift** while rotating | Snap to 15 degree steps |
| Middle-drag | Pan |
| Mouse wheel | Zoom about the cursor |
| **Home** or **F** | Frame all islands |
| **Ctrl+Z** / **Ctrl+Y** | Undo / redo the layout change |

A status line along the bottom of the pane always names the gesture in progress and the keys that apply to it.
