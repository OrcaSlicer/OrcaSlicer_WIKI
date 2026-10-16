# Support Ironing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_ironing`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--support-ironing=1`.  
Ironing uses a small flow to print over the top support interface again at the same height to make it smoother. This setting controls whether the support interface is ironed. When enabled, the top support interface and the raft interface are also printed solid.

This option is available only when the support has [top interface layers](support_settings_advanced#interface-layers) or a [raft](support_settings_raft) is used.

## Pattern

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_ironing_pattern`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `rectilinear, concentric`.  
[CLI Example](cli_mode#setting-overrides): `--support-ironing-pattern=rectilinear`.  
Select the ironing pattern to use.

## Flow

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_ironing_flow`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--support-ironing-flow=20%`.  
The amount of material to extrude during ironing, relative to the flow of a normal support interface layer. Too high a value results in over-extrusion on the surface.

## Line Spacing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_ironing_spacing`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--support-ironing-spacing=1`.  
The distance between the lines of ironing.
