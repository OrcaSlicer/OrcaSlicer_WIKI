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
- [Volumetric speeds](#volumetric-speeds)
    - [How the speed of each line is calculated](#how-the-speed-of-each-line-is-calculated)
    - [Why use volumetric speeds](#why-use-volumetric-speeds)
    - [Speeds that are not replaced](#speeds-that-are-not-replaced)
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

## Volumetric speeds

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `enable_volumetric_speeds`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--enable-volumetric-speeds=1`.  

> [!IMPORTANT]
> NEW FEATURE: **Volumetric speeds**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.5.1**.

When enabled, the speed in mm/s of each feature is hidden and replaced by a volumetric speed: the flow of plastic, in mm³/s, that every line of the feature prints at.

- A value in mm³/s is the flow of every line of the feature.
- A percentage is calculated on the filament's [Max volumetric speed](material_volumetric_speed_limitation#max-volumetric-speed). For example, 50% prints at 10 mm³/s with a filament limited to 20 mm³/s, and at 15 mm³/s with one limited to 30 mm³/s.

Each feature below has its volumetric speed next to its speed in mm/s, as do the [Initial layer speeds](speed_settings_initial_layer_speed) and the [Bridge speeds](speed_settings_overhang_speed#bridge-speed).

### How the speed of each line is calculated

Each line is printed at its feature's volumetric speed divided by the line's cross section:

$$
\text{Speed (mm/s)} = \frac{\text{Volumetric speed (mm³/s)}}{\text{Line cross section (mm²)}}
$$

The cross section comes from the [line width](quality_settings_line_width) and [layer height](quality_settings_layer_height), adjusted by the [flow ratio](material_flow_ratio_and_pressure_advance#flow-ratio). For example, with a volumetric speed of 12 mm³/s:

- A 0.45 mm wide wall on a 0.2 mm layer (about 0.081 mm²) prints at about 147 mm/s.
- A 0.5 mm wide wall on a 0.3 mm first layer (about 0.131 mm²) prints at about 92 mm/s.

Both extrude the same 12 mm³/s, so the hotend melts the same amount of plastic per second whatever the line width or layer height. The same goes for gap infill, for Arachne walls, whose width changes along the wall, and for [variable layer heights](quality_settings_layer_height).

The resulting speed is still limited by the filament's [Max volumetric speed](material_volumetric_speed_limitation#max-volumetric-speed).

### Why use volumetric speeds

- **Faster prints with constant quality:** A speed in mm/s must be safe for the line that needs the most flow, such as a wide gap infill or a thick first layer, so most lines print below what the hotend can melt. With volumetric speeds every line of a feature gets the same flow: the print runs close to the hotend's limit, and each feature keeps the same melting, cooling and surface finish at any line width or layer height.
- **Multi-material prints:** A volumetric speed expressed as a percentage follows each filament's own [Max volumetric speed](material_volumetric_speed_limitation#max-volumetric-speed). A fast-flowing filament is no longer held to speeds tuned for a slower one, and a slower filament is never pushed past its limit, all with the same process profile.

### Speeds that are not replaced

These speeds have no volumetric version and apply over the resulting speeds:

- [Small perimeters](#small-perimeters) and [Small tree support perimeters](#small-tree-support-perimeters): a percentage applies to the resulting outer wall or support speed, while an absolute value stays in mm/s.
- [Overhang speeds](speed_settings_overhang_speed#speed) and [Scarf joint speed](quality_settings_seam#scarf-joint-speed): they slow down the resulting wall speed.
- [Ironing speed](#ironing-speed): ironing extrudes a small fraction of a full line, so a flow target would give meaningless speeds.
- [Travel speed](speed_settings_travel) and [Skirt speed](others_settings_skirt#speed): travel does not extrude, and the skirt speed overrides the feature speed.

> [!NOTE]
> Calibration prints ignore this option and use the speeds the calibration sets.

## Outer wall

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `outer_wall_speed`, `outer_wall_volumetric_flow`.  
[Type](option_type): `outer_wall_speed` (Float list), `outer_wall_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--outer-wall-speed=1` (`outer_wall_speed` shown; other variables above follow their own type).  
Speed of the outer wall, which is the outermost, visible wall. It is usually printed slower than the [inner wall](#inner-wall) to get better quality and good layer adhesion.
This setting is also limited by [Machine / Motion ability / Resonance avoidance speed settings](vfa_calib).  
It can be excluded from the [layer cooling slowdown](material_cooling#slow-printing-down-for-better-layer-cooling) with [Don't slow down outer walls](material_cooling#dont-slow-down-outer-walls).  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 50% by default.

## Inner wall

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `inner_wall_speed`, `inner_wall_volumetric_flow`.  
[Type](option_type): `inner_wall_speed` (Float list), `inner_wall_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--inner-wall-speed=1` (`inner_wall_speed` shown; other variables above follow their own type).  
Speed of the inner walls, which are printed faster than the outer wall to reduce print time. Their flow is still recommended to stay well below the [maximum volumetric speed](volumetric_speed_calib) to ensure good layer adhesion and reduce internal stresses in the material.  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 100% by default.

## Small perimeters

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `small_perimeter_speed`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--small-perimeter-speed=20%`.  
Speed of walls with a theoretical radius <= [small perimeters threshold](#small-perimeters-threshold).
Any shape (not only circles) will be considered as a small perimeter.

If expressed as a percentage (for example: 80%), it will be calculated on the [outer wall speed](#outer-wall), which with [Volumetric speeds](#volumetric-speeds) is the speed resulting from the outer wall volumetric speed.

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
[Variables](built_in_placeholders_variables): `sparse_infill_speed`, `sparse_infill_volumetric_flow`.  
[Type](option_type): `sparse_infill_speed` (Float list), `sparse_infill_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--sparse-infill-speed=1` (`sparse_infill_speed` shown; other variables above follow their own type).  
Speed of [sparse infill](strength_settings_infill) which is printed faster than solid infill to reduce print time.  
If you are using your [Infill Pattern](strength_settings_infill) as an aesthetic feature, you may want to set it closer to the [outer wall speed](#outer-wall) to get better quality.  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 100% by default.

## Internal solid infill

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `internal_solid_infill_speed`, `internal_solid_infill_volumetric_flow`.  
[Type](option_type): `internal_solid_infill_speed` (Float list), `internal_solid_infill_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--internal-solid-infill-speed=1` (`internal_solid_infill_speed` shown; other variables above follow their own type).  
Speed of internal solid infill, which fills the interior of the model with solid layers.  
This is typically set faster than the [top surface speed](#top-surface) to optimize print time, while still ensuring adequate strength and layer adhesion. Adjusting this speed can help balance print quality and efficiency, especially for models requiring strong internal structures.  
Solid infill is also considered when [infill % is set to 100%](strength_settings_infill#internal-solid-infill).  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 100% by default.

## Top surface

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `top_surface_speed`, `top_surface_volumetric_flow`.  
[Type](option_type): `top_surface_speed` (Float list), `top_surface_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--top-surface-speed=1` (`top_surface_speed` shown; other variables above follow their own type).  
Speed of the [topmost solid layers](strength_settings_top_bottom_shells) of the print. This is usually set similar to the [outer wall speed](#outer-wall) to achieve a smoother and higher-quality finish on visible surfaces. Lower speeds help minimize surface defects and improve the appearance of the final printed object.  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 50% by default.

## Gap infill

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `gap_infill_speed`, `gap_infill_volumetric_flow`.  
[Type](option_type): `gap_infill_speed` (Float list), `gap_infill_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--gap-infill-speed=1` (`gap_infill_speed` shown; other variables above follow their own type).  
Speed of [gap infill](strength_settings_infill#apply-gap-fill), which is used to fill small gaps or holes in the print.  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 50% by default.

## Ironing speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `ironing_speed`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--ironing-speed=1`.  
[Ironing](quality_settings_ironing) and [Support Ironing](support_settings_ironing) speed, typically slower than the top surface speed to ensure a smooth finish.  
Each filament can replace this speed with its own Ironing speed in its [setting overrides](material_setting_overrides#ironing).

## Support

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `support_speed`, `support_volumetric_flow`.  
[Type](option_type): `support_speed` (Float list), `support_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--support-speed=1` (`support_speed` shown; other variables above follow their own type).  
Speed at which [support](support_settings_support) material is printed. Slower speeds help ensure that supports are stable and effective during the print process.  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 100% by default.

## Support interface

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `support_interface_speed`, `support_interface_volumetric_flow`.  
[Type](option_type): `support_interface_speed` (Float list), `support_interface_volumetric_flow` (Float or Percentage list).  
[CLI Example](cli_mode#setting-overrides): `--support-interface-speed=1` (`support_interface_speed` shown; other variables above follow their own type).  
Speed for the support interface layers, which are the layers directly contacting the model. This is usually set even slower than the main [support speed](#support) to maximize surface quality where the support meets the model and to make support removal easier.  
With [Volumetric speeds](#volumetric-speeds) enabled, it is set as a volumetric speed instead, 50% by default.

## Small tree support perimeters

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `small_support_perimeter_speed`.  
[Type](option_type#list-types): `Float or Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--small-support-perimeter-speed=20%`.  

Same as [Small perimeters](#small-perimeters), but for supports.  
This separate setting affects the speed of support extrusions whose length is within the [small support perimeters threshold](#small-tree-support-perimeters-threshold).  
If expressed as a percentage (for example: 80%), it will be calculated on the [support](#support) or [support interface](#support-interface) speed, which with [Volumetric speeds](#volumetric-speeds) is the speed resulting from their volumetric speed.  
The default is 50% of the [support](#support) or [support interface](#support-interface) speed.

### Small tree support perimeters threshold

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `small_support_perimeter_threshold`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--small-support-perimeter-threshold=1`.  
Sets the threshold below which the [small support perimeters](#small-tree-support-perimeters) speed is applied. Like the [small perimeters threshold](#small-perimeters-threshold), it is a radius: a support extrusion is considered small when its length is <= 2π × threshold.  
The default threshold is 0 mm, which disables it.
