# Advanced Printer Settings

Advanced settings related to the printer configuration.

- [Printer structure](#printer-structure)
- [G-code flavor](#g-code-flavor)
- [Skip G-code config block](#skip-g-code-config-block)
- [Pellet Modded Printer](#pellet-modded-printer)
- [Use 3rd-party print host](#use-3rd-party-print-host)
- [Scan first layer](#scan-first-layer)
- [Power Loss Recovery](#power-loss-recovery)
- [Disable set remaining print time](#disable-set-remaining-print-time)
- [G-code thumbnails](#g-code-thumbnails)
- [Use relative E distances](#use-relative-e-distances)
- [Use firmware retraction](#use-firmware-retraction)
- [Bed temperature type](#bed-temperature-type)
- [Time cost](#time-cost)

## Printer structure

[Mode](option_mode): `Developer`.  
[Variable](built_in_placeholders_variables): `printer_structure`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `undefine, corexy, i3, hbot, delta`.  
[CLI Example](cli_mode#setting-overrides): `--printer-structure=undefine`.  
The physical arrangement and components of a printing device.

## G-code flavor

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `gcode_flavor`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `marlin, klipper, reprapfirmware, repetier, marlin2`.  
[CLI Example](cli_mode#setting-overrides): `--gcode-flavor=marlin`.  
What kind of G-code the printer is compatible with.

## Skip G-code config block

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `gcode_skip_config_block`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--gcode-skip-config-block=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Skip G-code config block**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Removes the `CONFIG_BLOCK` (the commented-out block listing every resolved slicer setting) from the exported G-code file.

Some printer firmware parsers crash when reading certain lines in this block, most notably Anycubic's go-klipper choking on `; filament_colour_type = 1;1;1;1`. Enabling this option avoids those upload/parsing failures by not writing the block at all.

> [!CAUTION]
> The G-code file will no longer contain the resolved slicer settings, so it can no longer be used to recover the print configuration afterward.

## Pellet Modded Printer

[Mode](option_mode): `Simple`.  
[Variables](built_in_placeholders_variables): `pellet_flow_coefficient`, `pellet_modded_printer`.  
[Type](option_type): `pellet_flow_coefficient` (Float list), `pellet_modded_printer` (Boolean).  
[CLI Example](cli_mode#setting-overrides): `--pellet-flow-coefficient=1` (`pellet_flow_coefficient` shown; other variables above follow their own type).  
Enable this option if your printer uses pellets instead of filaments.
Large format printers with print volumes in the order of 1m^3 generally use pellets for printing.
The overall tech is very similar to FDM printing.
It is FDM printing, but instead of filaments, it uses pellets.

The difference here is that where filaments have a filament_diameter that is used to calculate the volume of filament ingested, pellets have a particular flow_coefficient that is empirically devised for that particular pellet.

pellet_flow_coefficient is basically a measure of the packing density of a particular pellet.
Shape, material and density of an individual pellet will determine the packing density and the only thing that matters for 3d printing is how much of that pellet material is extruded by one turn of whatever feeding mehcanism/gear your printer uses. You can emperically derive that for your own pellets for a particular printer model.

We are translating the pellet_flow_coefficient into filament_diameter so that everything works just like it does already with very minor adjustments.

$$
\text{filament\_diameter} = \sqrt{\frac{4}{\text{pellet\_flow\_coefficient} \cdot \pi}}
$$

sqrt just makes the relationship between flow_coefficient and volume linear.

Higher packing density -> more material extruded by single turn -> higher pellet_flow_coefficient -> treated as if a filament of larger diameter is being used. All other calculations remain the same for slicing.

## Use 3rd-party print host

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `bbl_use_printhost`.  
[Type](option_type#boolean): `Boolean`.  
Not available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  
Allow controlling BambuLab's printer through 3rd party print hosts.

## Scan first layer

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `scan_first_layer`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--scan-first-layer=1`.  
Enable this to enable the camera on printer to check the quality of first layer.

## Power Loss Recovery

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `enable_power_loss_recovery`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `printer_configuration, enable, disable`.  
[CLI Example](cli_mode#setting-overrides): `--enable-power-loss-recovery=printer_configuration`.  
Enable or Disable power loss recovery by inserting commands in generated G-code.  
Set `Printer configuration` to use the current printer's power loss recovery configuration.

> [!NOTE]
> Only for [Bambu Lab](https://wiki.bambulab.com/en/knowledge-sharing/power-loss-recovery) or [Marlin 2 firmware](https://marlinfw.org/docs/gcode/M413.html) based printers.

Power loss recovery saves the current execution point to non-volatile memory (SD card) but this can introduce some issues:

- When the slicer generates many short moves (e.g. curves), frequent save/read operations can introduce pauses that may leave blobs.
- Repeated writes also increase wear on the memory device and its Terabytes Written (TBW).

> [!TIP]
> If enabled, it's recommended to enable [Arc fitting](quality_settings_precision#arc-fitting) in `Quality Settings > Precision` to reduce the number of G-code commands.

> [!CAUTION]
> High warping models or materials will not be recovered properly due to bed adhesion loss after power-off.

## Disable set remaining print time

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `disable_m73`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--disable-m73=1`.  
Disable generating of the M73: Set remaining print time in the final G-code.

## G-code thumbnails

Picture sizes to be stored into a .gcode and .sl1 / .sl1s files, in the following format: "XxY, XxY, ..."

## Use relative E distances

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `use_relative_e_distances`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--use-relative-e-distances=1`.  
Relative extrusion is recommended when using "label_objects" option. Some extruders work better with this option unchecked (absolute extrusion mode). Wipe tower is only compatible with relative mode. It is recommended on most printers. Default is checked.

## Use firmware retraction

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `use_firmware_retraction`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--use-firmware-retraction=1`.  
This experimental setting uses G10 and G11 commands to have the firmware handle the retraction. This is only supported in recent Marlin.

## Bed temperature type

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `bed_temperature_formula`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `by_first_filament, by_highest_temp`.  
[CLI Example](cli_mode#setting-overrides): `--bed-temperature-formula=by_first_filament`.  
This option determines how the bed temperature is set during slicing: based on the temperature of the first filament or the highest temperature of the printed filaments.

## Time cost

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `time_cost`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--time-cost=1`.  
The printer cost per hour.
