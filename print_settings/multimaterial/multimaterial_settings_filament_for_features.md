# Filament for Features

These settings allow you to specify which extruder to use for different features of the print, such as walls, infill, and wipe tower.

![filament_for_features](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/multi-tool/filament_for_features.png?raw=true)

> [!IMPORTANT]
> NEW FEATURE: **Filament for Features for [Single Extruder Multi Material](printer_multimaterial_setup#single-extruder-multi-material)**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.3.2**.

## Walls

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wall_filament`.  
Filament to print walls.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), it's recommended to use the smaller nozzle for walls to achieve better surface quality and detail.

## Infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `sparse_infill_filament`.  
Filament to print internal sparse infill.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), you can use a larger nozzle for infill to speed up printing while maintaining good layer adhesion.

## Solid infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `solid_infill_filament`.  
Filament to print solid infill.
When using a [mixed nozzle size setup](mixed_nozzle_sizes), you can use a larger nozzle for solid infill to speed up printing while maintaining good layer adhesion.

## Wipe Tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_filament`.  
The extruder to use when printing perimeter of the wipe tower. Set to 0 to use the one that is available (non-soluble would be preferred).
