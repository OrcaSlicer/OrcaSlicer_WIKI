# Material Volumetric Speed Limitation

Each material profile includes a **maximum volumetric speed** setting, which limits your [print speed](speed_settings_other_layers_speed) to prevent issues like nozzle clogs, under-extrusion, or poor layer adhesion.

> [!TIP]
> Calibrating the maximum volumetric speed for each filament you use is highly recommended. Refer to the [Max Volumetric Speed (FlowRate) Calibration](volumetric_speed_calib) guide for detailed instructions on how to perform this calibration.

## Adaptive volumetric speed

[Mode](option_mode): `Developer`.  
[Variable](built_in_placeholders_variables): `filament_adaptive_volumetric_speed`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-adaptive-volumetric-speed=1`.  
> [!WARNING]
> Experimental and incomplete feature imported from BBS.  
> Functional for some profiles that already have the variable saved.

When enabled, the extrusion flow is limited by the smaller of the fitted value (calculated from line width and layer height) and the user-defined maximum flow. When disabled, only the user-defined maximum flow is applied.

## Max volumetric speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_max_volumetric_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-max-volumetric-speed=1`.  
This setting is the volume of filament that can be melted and extruded per second. Printing speed is limited by max volumetric speed, in case of too high and unreasonable speed setting. This value cannot be zero.  
It is also the reference for [volumetric speeds](speed_settings_other_layers_speed#volumetric-speeds) expressed as a percentage.

## Max external volumetric speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_max_external_volumetric_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-max-external-volumetric-speed=1`.  

> [!IMPORTANT]
> NEW FEATURE: **Max external volumetric speed**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.5.1**.

A lower volumetric speed limit for the visible external features, on top of the [Max volumetric speed](#max-volumetric-speed). It applies to:

- [Outer walls](speed_settings_other_layers_speed#outer-wall).
- Everything printed at the external [bridge speed](speed_settings_overhang_speed#bridge-speed): external bridges and overhang walls.
- [Top surfaces](speed_settings_other_layers_speed#top-surface) that are not [ironed](quality_settings_ironing#type). An ironed top surface is smoothed afterwards, so it keeps the higher limit.

Inner walls, infill, internal bridges and support keep printing up to the [Max volumetric speed](#max-volumetric-speed). It works with speeds in mm/s and with [volumetric speeds](speed_settings_other_layers_speed#volumetric-speeds).

Many materials lose their gloss and turn matte when they are extruded too fast. Set this value to the highest flow at which the material still prints glossy, to keep the surface finish while the rest of the print runs at full flow.

> [!TIP]
> The [Max Volumetric Speed calibration](volumetric_speed_calib) prints at a flow that increases with height. Measure where its surface turns from glossy to matte, the same way you measure where it fails, to get a starting value.

> [!NOTE]
> 0 disables this limit. Calibration prints ignore it.
