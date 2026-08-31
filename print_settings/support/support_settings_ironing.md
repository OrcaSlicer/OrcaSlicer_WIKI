# Support Ironing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_ironing`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--support-ironing=1`.  
Ironing is using small flow to print on same height of surface again to make flat surface more smooth. This setting controls which layer being ironed.

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
The amount of material to extrude during ironing. Relative to flow of normal layer height. Too high value results in overextrusion on the surface.

## Line Spacing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_ironing_spacing`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--support-ironing-spacing=1`.  
The distance between the lines of ironing.
