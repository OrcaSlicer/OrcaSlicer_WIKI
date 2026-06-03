# Strength Advanced

- [Align infill direction to model](#align-infill-direction-to-model)
- [Bridge infill direction](#bridge-infill-direction)
- [Relative Bridge Angle](#relative-bridge-angle)
- [Minimum sparse infill threshold](#minimum-sparse-infill-threshold)
- [Infill Combination](#infill-combination)
    - [Max layer height](#max-layer-height)
- [Detect narrow internal solid infill](#detect-narrow-internal-solid-infill)
- [Ensure vertical shell thickness](#ensure-vertical-shell-thickness)

## Align infill direction to model

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `align_infill_direction_to_model`.  
Aligns [infill](strength_settings_infill#direction), [bridge](#bridge-infill-direction), [ironing](quality_settings_ironing#angle-offset) and [surface fill](strength_settings_top_bottom_shells#surface-pattern) directions to follow the model's orientation on the build plate.  
When enabled, directions rotate with the model to maintain optimal strength characteristics.

![fill-direction-to-model](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/fill-direction-to-model.png?raw=true)

## Bridge infill direction

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `bridge_angle`, `internal_bridge_angle`.  
If left to zero, the bridging angle will be calculated automatically for each specific bridge.  
Otherwise the provided angle will be used according to:
    - The absolute coordinates
    - The absolute coordinates + Model rotation: If [Align infill direction to model](#align-infill-direction-to-model) is enabled
    - The optimal automatic angle + this value: If [Relative Bridge Angle](#relative-bridge-angle) is enabled

> [!NOTE]
> Use 180° for zero absolute angle.

## Relative Bridge Angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `relative_bridge_angle`.  
When enabled, the bridge angle values are added to the automatically calculated bridge direction instead of overriding it.  
Recommended to add a small angle (<10°) to improve bridge covering in closed shapes.

![bridge-angle-0](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/bridging/bridge-angle-0.png?raw=true)
![bridge-angle-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/bridging/bridge-angle-2.png?raw=true)
![bridge-angle-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/bridging/bridge-angle-8.png?raw=true)

> [!IMPORTANT]
> NEW FEATURE: **Relative Bridge Angle**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.3.2**.

## Minimum sparse infill threshold

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `minimum_sparse_infill_area`.  
Sparse infill areas smaller than the threshold value are replaced by [internal solid infill](strength_settings_infill#internal-solid-infill).
This setting helps to ensure that small areas of sparse infill do not compromise the strength of the print. It is particularly useful for models with intricate designs or small features where sparse infill may not provide sufficient support.

## Infill Combination

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `infill_combination`.  
Automatically combine [sparse infill](strength_settings_infill) of several layers so they print together and reduce print time and while increasing strength. While walls are still printed with the original [layer height](quality_settings_layer_height).

![fill-combination](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/fill-combination.png?raw=true)

### Max layer height

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `infill_combination_max_layer_height`.  
Maximum layer height for the combined sparse infill.  
Set it to 0 or 100% to use the nozzle diameter (for maximum reduction in print time), or to a value of ~80% to maximize sparse infill strength.

The number of layers over which infill is combined is derived by dividing this value by the layer height and rounding down to the nearest decimal.

Use either absolute mm values (e.g., 0.32mm for a 0.4mm nozzle) or percentages (e.g., 80%). This value must not be larger than the nozzle diameter.

## Detect narrow internal solid infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `detect_narrow_internal_solid_infill`.  
This option auto-detects narrow internal solid infill areas. If enabled, the [concentric pattern](strength_settings_patterns#concentric) will be used in those areas to speed up printing. Otherwise, the [rectilinear pattern](strength_settings_patterns#rectilinear) will be used by default.

## Ensure vertical shell thickness

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `ensure_vertical_shell_thickness`.  
Add solid infill near sloping surfaces to guarantee the vertical shell thickness (top and bottom solid layers).

- **None**: No solid infill will be added anywhere. **Caution:** Use this option carefully if your model has sloped surfaces.
- **Critical Only**: Avoid adding solid infill for walls.
- **Moderate**: Add solid infill for heavily sloping surfaces only.
- **All (default)**: Add solid infill for all suitable sloping surfaces.
