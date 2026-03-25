# Advanced Printer Settings

Advanced settings related to the printer configuration.

- [Printer structure](#printer-structure)
- [G-code flavor](#g-code-flavor)
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

[Variable](Built-in-placeholders-variables): `printer_structure`.  
The physical arrangement and components of a printing device.

## G-code flavor

[Variable](Built-in-placeholders-variables): `gcode_flavor`.  
What kind of G-code the printer is compatible with.

## Pellet Modded Printer

[Variables](Built-in-placeholders-variables): `pellet_flow_coefficient`, `pellet_modded_printer`.  
Enable this option if your printer uses pellets instead of filaments.
Large format printers with print volumes in the order of 1m^3 generally use pellets for printing.
The overall tech is very similar to FDM printing.
It is FDM printing, but instead of filaments, it uses pellets.

The difference here is that where filaments have a filament_diameter that is used to calculate the volume of filament ingested, pellets have a particular flow_coefficient that is empirically devised for that particular pellet.

pellet_flow_coefficient is basically a measure of the packing density of a particular pellet.
Shape, material and density of an individual pellet will determine the packing density and the only thing that matters for 3d printing is how much of that pellet material is extruded by one turn of whatever feeding mehcanism/gear your printer uses. You can emperically derive that for your own pellets for a particular printer model.

We are translating the pellet_flow_coefficient into filament_diameter so that everything works just like it does already with very minor adjustments.

$$
\text{filament\_diameter} = \sqrt{\frac{4 \times \text{pellet\_flow\_coefficient}}{\pi}}
$$

sqrt just makes the relationship between flow_coefficient and volume linear.

Higher packing density -> more material extruded by single turn -> higher pellet_flow_coefficient -> treated as if a filament of larger diameter is being used. All other calculations remain the same for slicing.

## Use 3rd-party print host

[Variable](Built-in-placeholders-variables): `bbl_use_printhost`.  
Allow controlling BambuLab's printer through 3rd party print hosts.

## Scan first layer

[Variable](Built-in-placeholders-variables): `scan_first_layer`.  
Enable this to enable the camera on printer to check the quality of first layer.

## Power Loss Recovery

[Variable](Built-in-placeholders-variables): `enable_power_loss_recovery`.  
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

[Variable](Built-in-placeholders-variables): `disable_m73`.  
Disable generating of the M73: Set remaining print time in the final G-code.

## G-code thumbnails

Picture sizes to be stored into a .gcode and .sl1 / .sl1s files, in the following format: "XxY, XxY, ..."

## Use relative E distances

[Variable](Built-in-placeholders-variables): `use_relative_e_distances`.  
Relative extrusion is recommended when using "label_objects" option. Some extruders work better with this option unchecked (absolute extrusion mode). Wipe tower is only compatible with relative mode. It is recommended on most printers. Default is checked.

## Use firmware retraction

[Variable](Built-in-placeholders-variables): `use_firmware_retraction`.  
This experimental setting uses G10 and G11 commands to have the firmware handle the retraction. This is only supported in recent Marlin.

## Bed temperature type

[Variable](Built-in-placeholders-variables): `bed_temperature_formula`.  
This option determines how the bed temperature is set during slicing: based on the temperature of the first filament or the highest temperature of the printed filaments.

## Time cost

[Variable](Built-in-placeholders-variables): `time_cost`.  
The printer cost per hour.
