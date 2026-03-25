# Acceleration

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
- [Top surface](#top-surface)
- [Travel](#travel)

## Normal printing

[Variable](Built-in-placeholders-variables): `default_acceleration`.  
The default acceleration of both normal printing and travel.

> [!NOTE]
> If this value is set to 0, the acceleration will be set to the printer's default acceleration.

## Outer wall

[Variable](Built-in-placeholders-variables): `outer_wall_acceleration`.  
Acceleration for [outer wall](speed_settings_other_layers_speed#outer-wall) printing. This is usually set to a lower value than normal printing to ensure better quality.

## Inner wall

[Variable](Built-in-placeholders-variables): `inner_wall_acceleration`.  
Acceleration for [inner wall](speed_settings_other_layers_speed#inner-wall) printing. This is usually set to a higher value than outer wall printing to improve speed.

## Bridge

[Variable](Built-in-placeholders-variables): `bridge_acceleration`.  
Acceleration of [bridges](speed_settings_overhang_speed#bridge-speed). If the value is expressed as a percentage (e.g. 50%), it will be calculated based on the outer wall acceleration.

## Sparse infill

[Variable](Built-in-placeholders-variables): `sparse_infill_acceleration`.  
Acceleration of [sparse infill](speed_settings_other_layers_speed#sparse-infill). If the value is expressed as a percentage (e.g. 100%), it will be calculated based on the default acceleration.

## Internal solid infill

[Variable](Built-in-placeholders-variables): `internal_solid_infill_acceleration`.  
Acceleration of [internal solid infill](speed_settings_other_layers_speed#internal-solid-infill). If the value is expressed as a percentage (e.g. 100%), it will be calculated based on the default acceleration.

## Initial layer

[Variable](Built-in-placeholders-variables): `initial_layer_acceleration`.  
Acceleration of [initial layer](speed_settings_initial_layer_speed). Using a lower value can improve build plate adhesion.

## Top surface

[Variable](Built-in-placeholders-variables): `top_surface_acceleration`.  
Acceleration of [top surface infill](speed_settings_other_layers_speed#top-surface). Using a lower value may improve top surface quality.  
Recommended to use a similar value to the [outer wall acceleration](#outer-wall).

## Travel

[Variable](Built-in-placeholders-variables): `travel_acceleration`.  
Acceleration of [travel](speed_settings_travel) moves. This is usually set to a higher value than normal printing to reduce travel time.
