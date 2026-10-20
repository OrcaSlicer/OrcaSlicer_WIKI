# Support Painting

This tool allows you to paint areas on your 3D model where you want to add or remove support structures during printing.  
This is particularly useful for models with overhangs or complex geometries where you want to control the placement of supports for better print quality and easier removal.

- [Enforce, block and erase](#enforce-block-and-erase)
- [Before you paint](#before-you-paint)
- [Tools](#tools)
- [Highlight overhangs](#highlight-overhangs)
- [Common workflows](#common-workflows)

Open the tool from the toolbar, from the right-click menu of an object, or with the `L` key.

## Enforce, block and erase

| Action | Control |
|--------|---------|
| Enforce supports (painted areas always get support) | Left mouse button |
| Block supports (painted areas never get support) | Right mouse button |
| Erase | `Shift` + Left mouse button |
| Change brush size (Circle and Sphere) | `Ctrl` + Mouse wheel (`Cmd` on macOS) |

**Erase all** removes every painted area on the object. **Done** closes the tool.

Your strokes belong to the project, so they come back when you reopen the 3MF.

## Before you paint

Painting does nothing on its own. Support must be enabled, and the support [Type](support_settings_support#type) decides what your strokes do:

| Support type | Enforcers (left click) | Blockers (right click) |
|--------------|------------------------|------------------------|
| [Normal (auto)](support_settings_support#auto) or Tree (auto) | Add support where the automatic detection found none | Keep support away from places where it would be generated |
| [Normal (manual)](support_settings_support#manual) or Tree (manual) | The only places that get support | Not needed, as nothing is generated automatically |

> [!NOTE]
> If a model has painted enforcers but **Enable support** is off, slicing shows a warning asking you to enable support.

> [!TIP]
> To get supports only where you painted, use a manual type. Choose Normal for flat, blocky supports and Tree for branches that touch the model less.

The tool reads the [Threshold angle](support_settings_support#threshold-angle) and the support type of the selected object, including any per-object override.

## Tools

Pick a tool from the **Tool type** row. Each one has a shortcut that works while the tool is open.

| Tool | Shortcut | What it does |
|------|----------|--------------|
| Circle | `C` | Marks the faces facing the camera under the circle. Hidden faces are skipped, so a stroke may need a second pass from another angle. |
| Sphere | `S` | Marks every face that falls inside the brush volume, including faces hidden behind the surface. Useful to cover a whole overhang in one pass. |
| Fill | `F` | Paints a connected area in one click. The **Smart fill angle** (0° to 90°) sets how much the surface angle may change before the fill stops. |
| Gap Fill | `G` | Merges small painted patches into their neighbours. Set the **Gap area** (0 to 5) and press **Apply**. |

**Brush size** (Circle and Sphere) ranges from 0.4 to 8.

With Circle or Sphere you can also tick **Vertical** or **Horizontal**. While you drag, the stroke is locked to a straight vertical or horizontal line on the screen. These two are mutually exclusive.

### On highlighted overhangs only

Tick **On highlighted overhangs only** to paint only on the faces that the [Highlight overhangs](#highlight-overhangs) slider marks. Strokes that cross other faces leave them untouched, which makes it easy to enforce support on steep overhangs without touching the rest of the model.

## Highlight overhangs

The **Highlight overhangs** slider (0° to 90°) colors the faces that fall under the chosen overhang angle, so you can preview which faces a given threshold would treat as overhangs.

- With an automatic support type, the slider starts at the object's [Threshold angle](support_settings_support#threshold-angle). Hover over the slider to read that value.
- With a manual type, there is no automatic support. The tooltip reads **No auto support**.
- Moving the slider only changes the preview and the **On highlighted overhangs only** filter. It does not change the Threshold angle in the print settings.

## Common workflows

### Support only where you choose

1. Set the support type to **Normal (manual)** or **Tree (manual)** and enable support.
2. Open Support Painting.
3. Use Sphere to enforce the overhangs that need support.
4. Slice and check the preview.

### Automatic support, with exceptions

1. Keep an automatic type and enable support.
2. Open Support Painting.
3. Right-click to block areas where support is hard to remove or would mark a visible surface.
4. Left-click to enforce areas the detection missed.

### Keep the rest of the model clean

1. Raise the **Highlight overhangs** slider until only the problem faces are colored.
2. Tick **On highlighted overhangs only**.
3. Paint over the region with a large brush. Only the highlighted faces receive the stroke.

> [!TIP]
> Check the result in the preview after slicing. Painting marks faces, and the generated support is still shaped by the support settings, such as the XY and Z distances.
