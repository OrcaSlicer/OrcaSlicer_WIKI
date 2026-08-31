# Acceleration

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `accel_to_decel_enable`, `accel_to_decel_factor`.  
[Type](option_type): `accel_to_decel_enable` (Boolean), `accel_to_decel_factor` (Percentage).  
[CLI Example](cli_mode#setting-overrides): `--accel-to-decel-enable=1` (`accel_to_decel_enable` shown; other variables above follow their own type).  
Acceleration in 3D printing is usually set on the printer's firmware settings.  
This setting will try to override the acceleration when [normal printing acceleration](#normal-printing) value is different than 0.  
Orca will limit the acceleration to not exceed the acceleration set in the Printer's Motion Ability settings.

- [Normal printing](#normal-printing)
- [Outer wall](#outer-wall)
- [Inner wall](#inner-wall)
- [Bridge](#bridge)
- [Sparse infill](#sparse-infill)
- [Internal solid infill](#internal-solid-infill)
- [Initial layer](#initial-layer)
- [Initial layer travel](#initial-layer-travel)
- [Top surface](#top-surface)
- [Travel](#travel)

## Normal printing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `default_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--default-acceleration=1`.  
The default acceleration of both normal printing and travel.

> [!NOTE]
> If this value is set to 0, the acceleration will be set to the printer's default acceleration.

## Outer wall

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `outer_wall_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--outer-wall-acceleration=1`.  
Acceleration for [outer wall](speed_settings_other_layers_speed#outer-wall) printing. This is usually set to a lower value than normal printing to ensure better quality.

## Inner wall

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `inner_wall_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--inner-wall-acceleration=1`.  
Acceleration for [inner wall](speed_settings_other_layers_speed#inner-wall) printing. This is usually set to a higher value than outer wall printing to improve speed.

## Bridge

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `bridge_acceleration`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--bridge-acceleration=20%`.  
Acceleration of [bridges](speed_settings_overhang_speed#bridge-speed). If the value is expressed as a percentage (e.g. 50%), it will be calculated based on the outer wall acceleration.

## Sparse infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `sparse_infill_acceleration`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--sparse-infill-acceleration=20%`.  
Acceleration of [sparse infill](speed_settings_other_layers_speed#sparse-infill). If the value is expressed as a percentage (e.g. 100%), it will be calculated based on the default acceleration.

## Internal solid infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `internal_solid_infill_acceleration`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--internal-solid-infill-acceleration=20%`.  
Acceleration of [internal solid infill](speed_settings_other_layers_speed#internal-solid-infill). If the value is expressed as a percentage (e.g. 100%), it will be calculated based on the default acceleration.

## Initial layer

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `initial_layer_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--initial-layer-acceleration=1`.  
Acceleration of [initial layer](speed_settings_initial_layer_speed). Using a lower value can improve build plate adhesion.

## Initial layer travel

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `initial_layer_travel_acceleration`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--initial-layer-travel-acceleration=20%`.  
Acceleration of [initial layer travel](speed_settings_initial_layer_speed#initial-layer-travel-speed).
Using a lower value can improve build plate adhesion. If the value is expressed as a percentage (e.g. 50%), it will be calculated based on the [Travel Acceleration](#travel).

## Top surface

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `top_surface_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--top-surface-acceleration=1`.  
Acceleration of [top surface infill](speed_settings_other_layers_speed#top-surface). Using a lower value may improve top surface quality.  
Recommended to use a similar value to the [outer wall acceleration](#outer-wall).

## Travel

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `travel_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--travel-acceleration=1`.  
Acceleration of [travel](speed_settings_travel) moves. This is usually set to a higher value than normal printing to reduce travel time.
