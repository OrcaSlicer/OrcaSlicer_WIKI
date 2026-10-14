# Acceleration

Acceleration in 3D printing is usually set in the printer's firmware.  
These settings override the firmware acceleration when the [normal printing acceleration](#normal-printing) is greater than 0.  
Orca limits the acceleration so it doesn't exceed the maximum set in the printer's Motion Ability settings.

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
- [Enable accel to decel](#enable-accel-to-decel)
    - [Accel to decel](#accel-to-decel)

## Normal printing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `default_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--default-acceleration=1`.  
The default acceleration for both normal printing and travel after the first layer.

> [!NOTE]
> If this value is set to 0, Orca doesn't send acceleration commands, so the printer's own acceleration is used and the other acceleration settings are disabled.

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
A value similar to the [outer wall acceleration](#outer-wall) is recommended.

## Travel

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `travel_acceleration`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--travel-acceleration=1`.  
Acceleration of [travel](speed_settings_travel) moves. This is usually set to a higher value than normal printing to reduce travel time.

## Enable accel to decel

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `accel_to_decel_enable`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--accel-to-decel-enable=1`.  
Adjusts Klipper's `max_accel_to_decel` automatically. Each time Orca sets the acceleration with `SET_VELOCITY_LIMIT ACCEL=`, it adds `ACCEL_TO_DECEL=` at the [accel to decel](#accel-to-decel) percentage of that acceleration. When disabled, `ACCEL_TO_DECEL` is not sent.  
This option is only shown when the [G-code flavor](printer_basic_information_advanced#g-code-flavor) is Klipper, and it is enabled by default.

### Accel to decel

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `accel_to_decel_factor`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--accel-to-decel-factor=20%`.  
Percentage of the acceleration that Klipper's `max_accel_to_decel` is set to, from 1% to 100% (default 50%).  
For example, at 5000 mm/s² and 50%, Orca sends `SET_VELOCITY_LIMIT ACCEL=5000 ACCEL_TO_DECEL=2500`.  
It can only be edited when [Enable accel to decel](#enable-accel-to-decel) is checked.
