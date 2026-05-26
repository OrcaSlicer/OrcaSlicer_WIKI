# Basic Extruder Information

This section contains the basic information about the extruder.  
When using multiple extruders, you can set different values for each extruder.

- [Nozzle diameter](#nozzle-diameter)
- [Nozzle volume](#nozzle-volume)
- [Extruder Layer Height Limits](#extruder-layer-height-limits)
- [Extruder offset Position](#extruder-offset-position)

## Nozzle diameter

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `nozzle_diameter[extruder_idx]`.  
The diameter of the nozzle for each extruder.  

> [!TIP]
> You can use different nozzle diameters for each extruder to achieve different print qualities and speeds.  
> Follow the [Mixed Nozzle Sizes](mixed_nozzle_sizes) guide for more information on how to use this feature.

## Nozzle volume

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `nozzle_volume[extruder_idx]`.  
Volume of nozzle between the filament cutter and the end of the nozzle

## Extruder Layer Height Limits

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `extruder_printable_height[extruder_idx]`, `min_layer_height[extruder_idx]`, `max_layer_height[extruder_idx]`.  
Min and max layer height limits for the extruder. These settings are used when adaptive layer height is enabled.

## Extruder offset Position

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extruder_offset[extruder_idx]`.  
If your firmware doesn't handle the extruder displacement you need the G-code to take it into account. This option lets you specify the displacement of each extruder with respect to the first one. It expects positive coordinates (they will be subtracted from the XY coordinate).
