# Single Extruder Multi-Material Parameters

This section describes the parameters specific to single extruder multi-material (SEMM) printing.

## Cooling tube position

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `cooling_tube_retraction`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--cooling-tube-retraction=1`.  
Distance of the center-point of the cooling tube from the extruder tip.

## Cooling tube length

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `cooling_tube_length`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--cooling-tube-length=1`.  
Length of the cooling tube to limit space for cooling moves inside it.

## Filament parking position

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `parking_pos_retraction`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--parking-pos-retraction=1`.  
Distance of the extruder tip from the position where the filament is parked when unloaded. This should match the value in printer firmware.

## Extra loading distance

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extra_loading_move`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--extra-loading-move=1`.  
 When set to zero, the distance the filament is moved from parking position during load is exactly the same as it was moved back during unload. When positive, it is loaded further, if negative, the loading move is shorter than unloading.

## High extruder current on filament swap

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `high_current_on_filament_swap`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--high-current-on-filament-swap=1`.  
 It may be beneficial to increase the extruder motor current during the filament exchange sequence to allow for rapid ramming feed rates and to overcome resistance when loading a filament with an ugly shaped tip.
