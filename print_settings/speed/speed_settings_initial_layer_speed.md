# Initial layer speed

Printing the first layer slower than the rest of the print is a widely recommended practice. This helps ensure strong adhesion to the print bed, reduces the chances of warping or curling at the edges, and allows better compensation for minor leveling inconsistencies.

## Initial layer

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `initial_layer_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--initial-layer-speed=1`.  
This setting determines the printing speed of the [outer/inner walls](strength_settings_walls) and the brim on the first layer.  
All other first layer extrusions, such as [solid infill](strength_settings_top_bottom_shells) and the [sparse infill](strength_settings_infill) printed when [bottom layers](strength_settings_top_bottom_shells#shell-layers) is set to 0, use the [First layer infill](#initial-layer-infill) speed.  
Adjusting this speed helps ensure proper adhesion and print quality for the initial layer.

## Initial layer infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `initial_layer_infill_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--initial-layer-infill-speed=1`.  
Defines the speed used for everything on the first layer except walls and brim, mainly the [solid infill](strength_settings_top_bottom_shells#shell-layers) regions. These areas require more precise and consistent extrusion to create a flat and stable surface for subsequent layers. Printing this section too fast may result in high internal stresses (increased risk of warping), poor layer uniformity, or adhesion failures.

## Initial layer travel speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `initial_layer_travel_speed`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--initial-layer-travel-speed=20%`.  
Sets the travel (non-printing movement) speed for the first layer. This doesn't affect print quality and can be set as a percentage of the [travel speed](speed_settings_travel).  
Usually, this is set to 100% of the [travel speed](speed_settings_travel), but it can be reduced if you want to minimize vibrations or if your printer has issues with high-speed travel movements.

## Number of slow layers

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `slow_down_layers`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--slow-down-layers=1`.  
Specifies how many of the first layers should be printed at a reduced speed. Instead of jumping straight to full speed after the first layer, the speed gradually increases in a linear fashion over this number of layers. This gradual ramp-up helps maintain adhesion and gives the print more stability in its early stages, especially on prints with a small contact area or materials prone to warping.

![number-of-slow-layers](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/speed/number-of-slow-layers.png?raw=true)
