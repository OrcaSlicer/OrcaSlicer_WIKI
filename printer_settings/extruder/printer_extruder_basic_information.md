# Basic Extruder Information

This section contains the basic information about the extruder.

## Nozzle diameter

[Variable](built_in_placeholders_variables): `nozzle_diameter[extruder_idx]`.  
The diameter of nozzle.

## Nozzle volume

[Variable](built_in_placeholders_variables): `nozzle_volume[extruder_idx]`.  
Volume of nozzle between the filament cutter and the end of the nozzle

## Extruder Layer Height Limits

[Variables](built_in_placeholders_variables): `extruder_printable_height[extruder_idx]`, `min_layer_height[extruder_idx]`, `max_layer_height[extruder_idx]`.  
Min and max layer height limits for the extruder. These settings are used when adaptive layer height is enabled.

## Extruder offset Position

[Variable](built_in_placeholders_variables): `extruder_offset[extruder_idx]`.  
If your firmware doesn't handle the extruder displacement you need the G-code to take it into account. This option lets you specify the displacement of each extruder with respect to the first one. It expects positive coordinates (they will be subtracted from the XY coordinate).
