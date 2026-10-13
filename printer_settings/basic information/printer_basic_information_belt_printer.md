# Belt Printer

> [!IMPORTANT]
> NEW FEATURE: **Belt printer support**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

![belt_printer_settings_group](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/belt/belt_printer_settings_group.png?raw=true)

These settings configure conveyor belt printers and are found in **Printer settings → Basic information → Belt printer**. The group is shown when the settings mode is **Advanced** or higher. The settings below [Enable belt printing](#enable-belt-printing) remain hidden until that option is enabled.

The [Belt Printing](belt_printing) guide explains how these settings work together. The belt profiles included with OrcaSlicer are configured for a typical 45° machine, so most users only need to check the [Tilt angle](#tilt-angle).

- [Enable belt printing](#enable-belt-printing)
- [Infinite Y axis](#infinite-y-axis)
- [Belt tilt](#belt-tilt)
    - [Tilt angle](#tilt-angle)
    - [Tilt axis](#tilt-axis)
- [Support floor Z offset](#support-floor-z-offset)

## Enable belt printing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `belt_printer`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--belt-printer=1`.  
Enables belt printer mode. The model is rotated by the [belt tilt](#belt-tilt) before slicing, and the G-code is transformed for the tilted gantry and moving belt.

Enabling this option also changes how several features behave:

- The [brim](others_settings_brim) is printed on the belt, and additional brim options become available.
- Supports end on the belt surface.
- The [belt purge tower](printer_multimaterial_wipe_tower#belt-purge-tower) replaces the prime tower.
- Features that cannot work on a belt are disabled. See [Features that are not available](belt_printing#features-that-are-not-available).

When this option is disabled, belt-specific processing is inactive and the remaining settings on this page are hidden.

## Infinite Y axis

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `belt_printer_infinite_y`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--belt-printer-infinite-y=1`.  
Removes the build volume limit along Y, allowing a part to extend beyond the plate displayed in Prepare.

The displayed plate size stays the same, but OrcaSlicer ignores the Y boundary when checking whether an object lies outside the printable area. The belt width (X) and the [printable height](printer_basic_information_printable_space#printable-height) are still enforced.

Disable this option to have OrcaSlicer flag parts that extend beyond the plate along Y.

## Belt tilt

[Modes](option_mode):  
`Advanced` [Variable](built_in_placeholders_variables): `belt_slice_rotation_angle`.  
`Developer` [Variable](built_in_placeholders_variables): `belt_slice_rotation`.  
[Type](option_type): `belt_slice_rotation_angle` (Float), `belt_slice_rotation` (Choice: none, x, y, z).  
[CLI Example](cli_mode#setting-overrides): `--belt-slice-rotation-angle=45` (`belt_slice_rotation_angle` shown; other variables above follow their own type).  
Defines the tilt of the gantry relative to the belt. The angle and axis control:

- the rotation applied to the model before slicing,
- the [machine-frame tilt](printer_basic_information_machine_frame_transforms#machine-frame-tilt) applied to the G-code,
- the belt surface used to generate supports and the brim,
- the [build plate tilt](printer_basic_information_advanced#build-plate-tilt) used for support generation,
- the size and position of the [belt purge tower](printer_multimaterial_wipe_tower#belt-purge-tower) and the order in which [Auto arrange](prepare_auto_arrange) packs parts.

Every object is rotated about one common origin, so parts at different positions along the belt share the same set of tilted layers and each part prints at its assigned position.

### Tilt angle

The angle between the belt and the gantry, in degrees. Most belt printers use 45°.

A positive value rotates counter-clockwise when looking down the positive tilt axis. The sign determines the direction in which the layers lean, and the magnitude specifies the physical tilt angle.

> [!NOTE]
> A brim is only generated on a belt printer when the tilt axis is X or Y and the angle is between 1° and 85°.

### Tilt axis

The axis about which the model is rotated. It is part of the printer's kinematics, so it is only shown when the settings [mode](option_mode) is **Developer**; the belt profiles set it once.

![belt_printer_settings_developer](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/belt/belt_printer_settings_developer.png?raw=true)

- **X:** The usual layout. The gantry is tilted about X and the belt travels along Y in Prepare.
- **Y:** The gantry is tilted about Y and the belt travels along X in Prepare.
- **Z:** Rotates the model in the plane of the bed. This is not a tilt: no machine-frame transform is applied and no brim is generated.
- **None:** No rotation. The model is sliced as on a flat bed.

## Support floor Z offset

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `belt_support_floor_offset`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--belt-support-floor-offset=1`.  
Shifts the belt surface used for support generation up or down, in mm. A negative value lowers this support floor, preserving more of the support geometry. A positive value raises it.

This is a diagnostic setting. Leave it at 0 unless supports are cut off above the belt or extend below it.

Supports always stop at the belt surface. Under an overhang at the leading end of a part they reach the belt ahead of the part's first contact with it, so the support can start before the part itself.
