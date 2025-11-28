# Advanced Printer Settings

Advanced settings related to the printer configuration.

- [Printer structure](#printer-structure)
- [G-code flavor](#g-code-flavor)
- [Pellet Modded Printer](#pellet-modded-printer)
- [Disable set remaining print time](#disable-set-remaining-print-time)
- [G-code thumbnails](#g-code-thumbnails)
- [Use relative E distances](#use-relative-e-distances)
- [Use firmware retraction](#use-firmware-retraction)
- [Bed temperature type](#bed-temperature-type)
- [Time cost](#time-cost)

## Printer structure

The physical arrangement and components of a printing device.

## G-code flavor

What kind of G-code the printer is compatible with.

## Pellet Modded Printer

Enable this option if your printer uses pellets instead of filaments.
Large format printers with print volumes in the order of 1m^3 generally use pellets for printing.
The overall tech is very similar to FDM printing.
It is FDM printing, but instead of filaments, it uses pellets.

The difference here is that where filaments have a filament_diameter that is used to calculate the volume of filament ingested, pellets have a particular flow_coefficient that is empirically devised for that particular pellet.

pellet_flow_coefficient is basically a measure of the packing density of a particular pellet.
Shape, material and density of an individual pellet will determine the packing density and the only thing that matters for 3d printing is how much of that pellet material is extruded by one turn of whatever feeding mehcanism/gear your printer uses. You can emperically derive that for your own pellets for a particular printer model.

We are translating the pellet_flow_coefficient into filament_diameter so that everything works just like it does already with very minor adjustments.

```math
\text{filament\_diameter} = \sqrt{\frac{4 \times \text{pellet\_flow\_coefficient}}{\pi}}
```

sqrt just makes the relationship between flow_coefficient and volume linear.

Higher packing density -> more material extruded by single turn -> higher pellet_flow_coefficient -> treated as if a filament of larger diameter is being used. All other calculations remain the same for slicing.

## Disable set remaining print time

Disable generating of the M73: Set remaining print time in the final G-code.

## G-code thumbnails

Picture sizes to be stored into a .gcode and .sl1 / .sl1s files, in the following format: "XxY, XxY, ..."

## Use relative E distances

Relative extrusion is recommended when using "label_objects" option. Some extruders work better with this option unchecked (absolute extrusion mode). Wipe tower is only compatible with relative mode. It is recommended on most printers. Default is checked.

## Use firmware retraction

This experimental setting uses G10 and G11 commands to have the firmware handle the retraction. This is only supported in recent Marlin.

## Bed temperature type

This option determines how the bed temperature is set during slicing: based on the temperature of the first filament or the highest temperature of the printed filaments.

## Time cost

The printer cost per hour.
