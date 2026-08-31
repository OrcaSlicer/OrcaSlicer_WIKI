# Overhangs

Overhangs are areas of a print that extend outward without full support underneath.  
Low overhang angles can be printed without support, while higher angles may require support, speed reduction, or specific settings to ensure good print quality.

- [Detect overhang wall](#detect-overhang-wall)
- [Make overhang printable](#make-overhang-printable)
    - [Maximum angle](#maximum-angle)
    - [Hole area](#hole-area)
- [Extra perimeters on overhangs](#extra-perimeters-on-overhangs)
- [Reverse on even](#reverse-on-even)
    - [Reverse internal only](#reverse-internal-only)
    - [Reverse threshold](#reverse-threshold)

## Detect overhang wall

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `detect_overhang_wall`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--detect-overhang-wall=1`.  
Detect the overhang percentage relative to line width and use different speed to print.
When detecting line width with 100% overhang, bridge options are used.

![overhang](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/overhangs/overhang.png?raw=true)

## Make overhang printable

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `make_overhang_printable`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--make-overhang-printable=1`.  
This setting will modify the geometry to print overhangs without support material.  
Every overhang exceeding the [maximum angle](#maximum-angle) will be modified to be printable.

### Maximum angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `make_overhang_printable_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--make-overhang-printable-angle=1`.  
Maximum angle of overhangs to allow after making more steep overhangs printable.  
90° will not change the model at all and allow any overhang, while 0 will replace all overhangs with conical material.

![overhang-printable](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/overhangs/overhang-printable.png?raw=true)

> [!TIP]
> Usually, a value between 45° and 60° works well for most printers and models.

### Hole area

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `make_overhang_printable_hole_size`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--make-overhang-printable-hole-size=1`.  
Maximum area of a hole in the base of the model before it's filled by conical material.  
A value of 0 will fill all the holes in the model base.

## Extra perimeters on overhangs

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extra_perimeters_on_overhangs`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--extra-perimeters-on-overhangs=1`.  
Create additional perimeter (overhang wall) paths over steep overhangs and areas where bridges cannot be anchored.

![extra-perimeters-on-overhangs](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/overhangs/extra-perimeters-on-overhangs.png?raw=true)

## Reverse on even

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `overhang_reverse`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--overhang-reverse=1`.  
Extrude perimeters in the reverse direction on even layers. This alternating pattern can drastically improve steep overhangs thanks to material squishing direction.

This setting can also help reduce part warping due to the reduction of stresses as they are now distributed in alternating directions. Useful for warp prone material, like ABS/ASA, and also for elastic filaments, like TPU and Silk PLA.  
It can also help reduce warping on floating regions over supports.

For this setting to be the most effective, it is recommended to set the [Reverse Threshold](#reverse-threshold) to 0 so that all walls print in alternating directions on even layers irrespective of their overhang degree.
A disadvantage of this setting is that the outer wall may show a texture due to the alternating extrusion direction.

![reverse-odd-texture](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/reverse-odd-texture.png?raw=true)

### Reverse internal only

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `overhang_reverse_internal_only`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--overhang-reverse-internal-only=1`.  
A simple way to reduce the texture on the outer wall is to only reverse the internal walls.
This will still provide almost all of the benefits of alternating extrusion direction on even layers (if using [inner/outer](quality_settings_wall_and_surfaces#innerouter)), but the outer wall will be printed in the same direction, resulting in a smoother surface finish.

### Reverse threshold

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `overhang_reverse_threshold`.  
[Type](option_type#integer-float-percentage): `Float or Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--overhang-reverse-threshold=20%`.  
You can set a threshold for the overhang reversal to be considered useful.
Can be set as:

- **0**: Disables the threshold, meaning that all walls will be reversed on even layers.
- **mm**: A fixed distance in millimeters.
- **%**: A percentage of the perimeter width.

When using this setting, the walls will make the reversal texture in the layers where the overhang is above the threshold, and the rest of the walls will be printed in the normal direction.
This could result in uneven texture, sometimes considered worse than the full reversal texture, so it is recommended to use this setting only if you are sure that the overhang reversal will not be useful for your model.

> [!NOTE]
> Only available when:
>
> - [Detect overhang wall](#detect-overhang-wall) is enabled
> - [Reverse internal only](#reverse-internal-only) is disabled
> If those conditions are not met, this setting will be hidden.
