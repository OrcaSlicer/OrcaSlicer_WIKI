# Variable Layer Height

The Variable Layer Height feature allows for dynamic adjustment of layer heights throughout the print, optimizing both print quality and speed.  
As we know from [Layer Height](quality_settings_layer_height), smaller layer heights yield better detail but increase print time, while larger layer heights speed up printing at the cost of detail. With Variable Layer Height, we can strategically use different layer heights in different parts of the model.

> [!NOTE]
> The Min and Max layer heights are defined in the [Machine/Extruder settings](printer_extruder_basic_information#extruder-layer-height-limits).

## Adaptive

The Quality / Speed slider in the Adaptive Variable Layer Height settings allows users to balance print quality and speed dynamically:

- **Quality:** Prioritizes finer details by using smaller layer heights in intricate areas, resulting in higher print quality but longer print times.
- **Speed:** Focuses on faster printing by utilizing larger layer heights in less detailed areas, reducing print time but potentially sacrificing some detail.

## Smooth

This setting allows you to set a Radius of the width of the Gaussian filter that smooths the transition between different layer heights. A larger radius results in a smoother transition, which can help reduce visible layer lines and improve overall print quality.

## Manual

This tool enables a vertical bar with a preview of the layer heights along the model. You click with left mouse button to reduce the layer height at a specific point, or with right mouse button to increase it.
