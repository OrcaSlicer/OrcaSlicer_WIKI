# Texture Displacement

> [!IMPORTANT]
> NEW FEATURE: **Texture displacement**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Texture Displacement is a painting tool that stamps height-map images onto a model's surface and turns them into real relief - embossed or engraved detail that is part of the mesh, so it slices and prints like any other geometry. You paint where the texture applies, stack several textures as blended layers, choose how each one is wrapped onto the surface, and press **Bake** when the preview looks right.

A height map is an ordinary image read as heights: white lifts the surface, black leaves it where it is. The shipped library is greyscale, but a colour image can also drive the print's colours - see [Colours](#colours).

- [Quick start](#quick-start)
- [Opening the tool](#opening-the-tool)
- [Standard and Pro](#standard-and-pro)
- [Painting the area](#painting-the-area)
- [View](#view)
- [Texture layers](#texture-layers)
- [Layer settings](#layer-settings)
- [Colours](#colours)
- [Mapping](#mapping)
- [Adjust placement](#adjust-placement)
- [Baking](#baking)
- [Tips and limitations](#tips-and-limitations)

Two more pages cover the parts that have their own panel:

- [Texture Displacement UV Editor](prepare_texture_displacement_uv_editor) - the 2D unwrap pane, seams and islands, used by the **Unwrap (LSCM)** mapping.
- [Texture Displacement Pro Mode](prepare_texture_displacement_pro) - the mesh preparation and result controls that Pro mode exposes.

## Quick start

1. Select an object and open **Texture displacement** from the left toolbar.
2. A texture layer is added for you. Pick an image from the layer's texture picker, or import your own.
3. Paint the area the texture should cover, or press **Select whole model**.
4. The relief appears on the model straight away. Adjust **Depth**, **Tile size** and **Rotation**.
5. Press **Bake** to turn the preview into real geometry.

Nothing outside the painted area is touched, and nothing is permanent until you bake.

## Opening the tool

Select a single object and click the texture displacement icon on the left toolbar. The settings panel opens beside it.

- **Dock panel / Undock panel** - at the top of the panel, pins it to the toolbar or lets it float over the 3D view.
- **Close** - at the bottom, leaves the tool without baking. Your paint, layers and settings stay with the model.

## Standard and Pro

A two-position switch at the top of the panel.

| Mode | What it shows |
| --- | --- |
| **Standard** | Painting, layers, mapping and **Bake**. Everything about preparing the mesh is handled for you. |
| **Pro** | The same, plus subdivision, remeshing and result smoothing as separate steps you run yourself. See [Texture Displacement Pro Mode](prepare_texture_displacement_pro). |

Standard is the right choice unless a model needs hand-holding: a height map can only move vertices that already exist, and Standard's Bake refines the painted area for you before displacing it.

## Painting the area

Every layer has its own paint. What you paint goes into the **active layer** - the highlighted one in the layer list.

| Control | What it does |
| --- | --- |
| **Paint** | Adds to the active layer where you click or drag. The right mouse button erases. |
| **Erase** | Removes the active layer where you click or drag. The right mouse button paints. |
| **Brush** | Free-hand painting. **Brush size** sets the radius; **Circle** paints everything under the brush as seen from the camera, **Sphere** paints only within a ball around the point under the cursor. |
| **Face** | Click individual triangles. |
| **Connected area** | Click to flood-fill a region. **Angle threshold** stops the fill at edges sharper than the given angle. |
| **Select whole model** | Paints every face of the model with the active layer. |
| **Erase whole model** | Clears the active layer's paint from every face. |

Hold **Ctrl** and drag to rotate or pan the camera without painting.

## View

A row of icons that decides what the 3D view shows. The first four are alternatives; **Wireframe** is an independent toggle.

| View | Meaning |
| --- | --- |
| **Normal** | The real displaced geometry, exactly what Bake will produce. Slower to update. |
| **Fast** | A shaded approximation of the active layer only, with no real geometry movement. Best while tuning sliders or dragging islands. |
| **Checker** | A test grid over the unwrap: squares stay square where the unwrap does not stretch. Needs a layer mapped with **Unwrap (LSCM)**. |
| **Distortion** | A blue-to-red heatmap of how much the unwrap stretches each area. Also needs **Unwrap (LSCM)**. |
| **Wireframe** | Overlays the mesh edges. Independent of the view above. |

**Auto** (on by default) rebuilds the Normal view as soon as anything changes. Turn it off on a heavy model to rebuild only when you release a slider or finish a stroke.

## Texture layers

Up to **8** layers can be stacked. Each one has its own paint, its own image and its own settings, and they combine in list order like layers in an image editor.

- **Add layer** - the button under the list. Disabled once all 8 are used.
- **Move up / Move down** - reorder the stack. Up is applied earlier, down later.
- **Remove this layer** - the cross on the layer's header row.
- Click a layer to make it active. Only the active layer receives paint.
- A layer with no paint is marked **not painted** and is skipped by Bake.
- **More settings / Fewer settings** expands a layer to everything below **Rotation**.

Each layer shows its image. Click it to open the picker:

- **Built-in** - the shipped library of seamless greyscale height maps (bricks, knurls, weaves, stone, wood and so on), all of which tile without a visible join.
- **My textures** - your own images. Import a PNG, JPG or BMP and it is converted to a height map and copied into your own texture folder, where application updates cannot overwrite it. Hover one of your own to remove it.

Changing a layer's image keeps its paint, depth and tiling as they are.

## Layer settings

| Control | What it does |
| --- | --- |
| **Depth** | Height of the relief: how far white in the texture lifts the surface, in millimetres. Black does not move it at all, unless Midlevel says otherwise. |
| **Tile size** | How wide one copy of the texture is on the model. Smaller repeats the pattern more often and makes its detail finer. With **Tile** off, this is the size of the single copy. |
| **Rotation** | Turns the texture on the surface, for lining a pattern up with an edge of the model. |
| **Midlevel** | Which grey stays where the surface already is. At 0 the texture only pushes outwards; at 0.5 mid-grey stays put, so darker greys cut in and lighter ones still push out - one image both embosses and engraves. |
| **Smoothing** | Blurs the image before it is used, which rounds off hard steps and removes speckle from a noisy photo. It costs fine detail. |
| **Edge fade** | Flattens the relief as it approaches the edge of the painted area, so it blends into the bare surface instead of stopping at a step. The slider beside it sets how far in the fade reaches, as a share of the painted area. |
| **Invert** | Turns the relief inside out: what stood out is cut in, and the other way round. |
| **Colours** | Prints the painted area in the texture's colours as well as its relief. Only available for a colour image - see [Colours](#colours). |
| **Tile** | Whether the texture repeats. **Repeat** tiles it plainly; **Mirrored repeat** flips every other tile, so edges meet seamlessly. With Tile off the texture is placed once, like a decal. |
| **Blend** | How this layer combines with the layers below it where they overlap: **Add**, **Subtract**, **Multiply** or **Divide**. Add and Subtract pile relief on or carve it away; Multiply and Divide scale the relief underneath, which is what makes a layer usable as a mask. |

The lowest painted layer is the base layer: it has nothing beneath it to combine with, so it always adds, and the panel says so instead of offering a control that would do nothing.

> [!WARNING]
> Raising **Midlevel** makes dark areas cut inwards, and what cuts in has to fit. Inside a sharp corner or through a thin wall, a deep cut can pass through the other side. The panel warns when Depth is large and Midlevel is above 0.

## Colours

A greyscale height map has no colours to apply, so the **Colours** checkbox is only available on a layer whose image is in colour. With it on, the painted area is printed in the texture's colours as well as its relief: each colour is matched to the nearest of the filaments loaded on the plate, and anything you did not paint keeps the object's own filament.

The result is written into the object's [Color Painting](prepare_color_painting) data when you bake, so it slices, previews and prints exactly like hand-painted colour - and can be touched up with that tool afterwards.

The remaining colour controls belong to the whole stack, so they appear once, under whichever layer turned colour on.

| Control | What it does |
| --- | --- |
| **Mix filaments** | Interleaves two filaments to fake the colours in between, so a handful of filaments can cover a photo or a gradient. An image of flat colours prints the same either way. Off uses one filament per area. |
| **Mix by** | **Layers** alternates the two filaments between print layers, which blends smoothly on upright surfaces but disappears on flat-facing ones. **Surface** uses a fine checkerboard across the surface, which works at any angle but can read as texture rather than as a blend. **Automatic** uses layers on upright faces and the nearer single filament on flat-facing ones. |
| **Denoise** | Cleans up single stray triangles of the wrong colour, which detail finer than the mesh leaves behind. Raise it if the result looks speckled, lower it if small features are being swallowed. |

A line under the controls reports how many printable colours the current filaments produce.

## Mapping

How the flat image is wrapped onto the painted area. Five icons, one per method.

| Method | Best for | Notes |
| --- | --- | --- |
| **Triplanar (blended)** | Patches that wrap around edges | Projects the texture from all three axes at once and blends between them, so a patch crossing a sharp edge has no seam. The default. |
| **Cylindrical** | Round, tube-like areas | Wraps the texture around the painted area's own centre. |
| **Spherical** | Ball-like areas | Wraps around the painted area's own centre in both directions. |
| **Unwrap (LSCM)** | Flat, controlled layout | Flattens the painted area and maps the texture onto it with as little stretching as possible, cutting it into pieces at its sharp edges first. Opens the [UV Editor](prepare_texture_displacement_uv_editor), where the pieces can be laid out by hand. |
| **From view** | Decals, slide-projector looks | Projects straight onto the painted area from where you are looking. |

**From view** adds its own controls:

- **Capture current view** - re-takes the projection direction from wherever the camera is now.
- **Project only on visible** - repaints the layer with exactly the faces the camera can see, so the projected area matches the viewpoint it was captured from. It replaces the layer's paint rather than adding to it.
- **Projection frame** - opens a semi-transparent window you drag over the 3D view, like a slide projector's gate. **Opacity** sets how much of the model shows through it; **Apply projection frame** commits the window's rectangle as the exact edge of the projection, and **Clear** goes back to the plain projection, where tiling, rotation and offset mean something again.

## Adjust placement

**Adjust placement** replaces painting with a handle on the model: drag the flat panel to move the texture freely, or one of the two arrows to move it along a single axis. Paint something with the layer first - the handle is anchored to the painted area.

## Baking

Baking turns the preview into real geometry. The panel's footer holds everything that decides what comes out.

| Control | What it does |
| --- | --- |
| **Resolution** | How fine the mesh is made under the paint, in millimetres. It has to be smaller than the detail you want out of the texture - a 0.5 mm groove needs triangles well under 0.5 mm. Leave the **Auto** tick on to have it follow the size of the model, or untick it to set the resolution and the budget yourself. |
| **Budget** | How many thousand triangles this bake may spend on the area you painted. Relief already baked elsewhere on the model is kept on top of it, so a second bake gets the same budget as the first. 0 keeps every triangle the refinement produced. |
| **Bake** | Turns the painted height maps into real geometry. Runs in the background; the button reads *Baking...* while it works. |
| **Stop** | Stops a bake in progress. Whatever it had already finished stays on the model, and can be undone. |

A line under the button reports the model's triangle count and names any layers that are not painted and will be skipped. If the resolution asks for far more triangles than the budget allows, a warning says so before you start: the bake still runs, but it simplifies back down to the budget and loses detail on the way, so the fix is to raise the budget or coarsen the resolution.

After a bake:

- The relief is part of the mesh. It slices, previews and exports like any other geometry.
- The paint of each baked layer is cleared, because those triangles no longer describe the same unbaked surface. The layers themselves, with their textures and settings, stay, so you can carry on painting elsewhere with them.
- Colours land in the object's [Color Painting](prepare_color_painting) data.
- The whole bake is a single undo step.

## Tips and limitations

> [!IMPORTANT]
> Paint, layers and their settings are held with the model in memory but are **not yet stored in project files**. Bake before saving a `.3mf`, or the relief will not be there when the project is reopened. Baked geometry and baked colours are ordinary model data and are saved normally.

- **Paint first, bake last.** The preview costs nothing to explore; only Bake changes the mesh.
- **Fast view is an approximation** and shows only the active layer. Trust **Normal** and Bake for the real result.
- **Deep inward cuts** (a raised Midlevel with a large Depth) can pass through a thin wall or fold a sharp concave corner into itself. Keep Depth modest there.
- **Anything that replaces the geometry drops unbaked paint** - Simplify, and the Pro mode Subdivide and Remesh tools, rebuild the triangle list, and paint that has not been baked cannot be carried across all of them. Relief that is already baked in is unaffected.
- **Fine relief costs triangles, and triangles cost slicing time.** A texture finer than the resolution the budget can pay for will not come out however the sliders are set; a coarser tile size or a shallower depth is often the better answer.
- **Island placements are tied to the current unwrap.** Repainting or changing the seam angle can re-cut the pieces, which discards hand placements made before it.
