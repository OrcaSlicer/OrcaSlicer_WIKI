# Other layers speed

## Speed limitations

> [!IMPORTANT]
> Every speed setting is limited by several parameters like:
>
> - [Maximum Volumetric Speed](volumetric_speed_calib)
> - Machine / Motion ability
> - [Acceleration](speed_settings_acceleration)
> - [Jerk settings](speed_settings_jerk_xy)
> - [Filament layer cooling time](material_cooling#slow-printing-down-for-better-layer-cooling)

- [Speed limitations](#speed-limitations)
- [Outer wall](#outer-wall)
- [Inner wall](#inner-wall)
- [Small perimeters](#small-perimeters)
    - [Small perimeters threshold](#small-perimeters-threshold)
- [Sparse infill](#sparse-infill)
- [Internal solid infill](#internal-solid-infill)
- [Top surface](#top-surface)
- [Gap infill](#gap-infill)
- [Ironing speed](#ironing-speed)
- [Support](#support)
- [Support interface](#support-interface)
- [Small tree support perimeters](#small-tree-support-perimeters)
    - [Small tree support perimeters threshold](#small-tree-support-perimeters-threshold)

## Outer wall

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `outer_wall_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--outer-wall-speed=1`.  
Speed of the outer wall, which is the outermost, visible wall. It is usually printed slower than the [inner wall](#inner-wall) to get better quality and good layer adhesion.
This setting is also limited by [Machine / Motion ability / Resonance avoidance speed settings](vfa_calib).  
It can be excluded from the [layer cooling slowdown](material_cooling#slow-printing-down-for-better-layer-cooling) with [Don't slow down outer walls](material_cooling#dont-slow-down-outer-walls).

## Inner wall

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `inner_wall_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--inner-wall-speed=1`.  
Speed of the inner walls, which are printed faster than the outer wall to reduce print time. Their flow is still recommended to stay well below the [maximum volumetric speed](volumetric_speed_calib) to ensure good layer adhesion and reduce internal stresses in the material.

## Small perimeters

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `small_perimeter_speed`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--small-perimeter-speed=20%`.  
Speed of walls with a theoretical radius <= [small perimeters threshold](#small-perimeters-threshold).
Any shape (not only circles) will be considered as a small perimeter.

If expressed as a percentage (for example: 80%), it will be calculated on the [outer wall speed](#outer-wall).

> [!NOTE]
> The default is 50% of the [outer wall speed](#outer-wall).

### Small perimeters threshold

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `small_perimeter_threshold`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--small-perimeter-threshold=1`.  
**Radius** in millimeters below which the speed of perimeters will be reduced to the [small perimeters speed](#small-perimeters).  
A perimeter is considered small when:

$$
\frac{\text{Perimeter Length}}{2\pi} \leq \text{Threshold}
$$

For example, if the threshold is set to 5 mm, then the perimeter length must be less than or equal to 31.4 mm `(2 * π * 5 mm)` to be considered a small perimeter.

- A Circle with a diameter of 10 mm will have a perimeter length of approximately 31.4 mm, which is equal to the threshold, so it will be considered a small perimeter.
- A Cube of 10mm x 10mm will have a perimeter length of 40 mm, which is greater than the threshold, so it will not be considered a small perimeter.
- A Cube of 5mm x 5mm will have a perimeter length of 20 mm, which is less than the threshold, so it will be considered a small perimeter.

> [!NOTE]
> Zero will disable [small perimeters speed](#small-perimeters), and walls will use their regular speed, such as the [outer wall speed](#outer-wall).

## Sparse infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `sparse_infill_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--sparse-infill-speed=1`.  
Speed of [sparse infill](strength_settings_infill) which is printed faster than solid infill to reduce print time.  
If you are using your [Infill Pattern](strength_settings_infill) as an aesthetic feature, you may want to set it closer to the [outer wall speed](#outer-wall) to get better quality.

## Internal solid infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `internal_solid_infill_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--internal-solid-infill-speed=1`.  
Speed of internal solid infill, which fills the interior of the model with solid layers.  
This is typically set faster than the [top surface speed](#top-surface) to optimize print time, while still ensuring adequate strength and layer adhesion. Adjusting this speed can help balance print quality and efficiency, especially for models requiring strong internal structures.  
Solid infill is also considered when [infill % is set to 100%](strength_settings_infill#internal-solid-infill).

## Top surface

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `top_surface_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--top-surface-speed=1`.  
Speed of the [topmost solid layers](strength_settings_top_bottom_shells) of the print. This is usually set similar to the [outer wall speed](#outer-wall) to achieve a smoother and higher-quality finish on visible surfaces. Lower speeds help minimize surface defects and improve the appearance of the final printed object.

## Gap infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `gap_infill_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--gap-infill-speed=1`.  
Speed of [gap infill](strength_settings_infill#apply-gap-fill), which is used to fill small gaps or holes in the print.

## Ironing speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `ironing_speed`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--ironing-speed=1`.  
[Ironing](quality_settings_ironing) and [Support Ironing](support_settings_ironing) speed, typically slower than the top surface speed to ensure a smooth finish.  
Each filament can replace this speed with its own Ironing speed in its [setting overrides](material_setting_overrides#ironing).

## Support

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--support-speed=1`.  
Speed at which [support](support_settings_support) material is printed. Slower speeds help ensure that supports are stable and effective during the print process.

## Support interface

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_interface_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--support-interface-speed=1`.  
Speed for the support interface layers, which are the layers directly contacting the model. This is usually set even slower than the main [support speed](#support) to maximize surface quality where the support meets the model and to make support removal easier.

## Small tree support perimeters

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `small_support_perimeter_speed`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--small-support-perimeter-speed=20%`.  

> [!IMPORTANT]
> NEW FEATURE: **Small tree support perimeters** (speed and threshold)  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Same as [Small perimeters](#small-perimeters), but for supports.  
This separate setting affects the speed of support extrusions whose length is within the [small support perimeters threshold](#small-tree-support-perimeters-threshold).  
If expressed as a percentage (for example: 80%), it will be calculated on the [support](#support) or [support interface](#support-interface) speed.  
The default is 50% of the [support](#support) or [support interface](#support-interface) speed.

### Small tree support perimeters threshold

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `small_support_perimeter_threshold`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--small-support-perimeter-threshold=1`.  
Sets the threshold below which the [small support perimeters](#small-tree-support-perimeters) speed is applied. Like the [small perimeters threshold](#small-perimeters-threshold), it is a radius: a support extrusion is considered small when its length is <= 2π × threshold.  
The default threshold is 0 mm, which disables it.
