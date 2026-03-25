# Single Extruder Multi-Material Parameters

This section describes the parameters specific to single extruder multi-material (SEMM) printing.

## Cooling tube position

[Variable](Built-in-placeholders-variables): `cooling_tube_retraction`.  
Distance of the center-point of the cooling tube from the extruder tip.

## Cooling tube length

[Variable](Built-in-placeholders-variables): `cooling_tube_length`.  
Length of the cooling tube to limit space for cooling moves inside it.

## Filament parking position

[Variable](Built-in-placeholders-variables): `parking_pos_retraction`.  
Distance of the extruder tip from the position where the filament is parked when unloaded. This should match the value in printer firmware.

## Extra loading distance

[Variable](Built-in-placeholders-variables): `extra_loading_move`.  
 When set to zero, the distance the filament is moved from parking position during load is exactly the same as it was moved back during unload. When positive, it is loaded further, if negative, the loading move is shorter than unloading.

## High extruder current on filament swap

[Variable](Built-in-placeholders-variables): `high_current_on_filament_swap`.  
 It may be beneficial to increase the extruder motor current during the filament exchange sequence to allow for rapid ramming feed rates and to overcome resistance when loading a filament with an ugly shaped tip.
