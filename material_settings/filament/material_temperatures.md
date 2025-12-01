# Material Temperatures

Set the temperatures for the selected material.

> [!TIP]
> Check [Temperature calibration](temp-calib) to find the optimal nozzle temperature for your filament.

- [Standard Temperature Ranges](#standard-temperature-ranges)
- [Nozzle](#nozzle)
- [Bed](#bed)
- [Print Chamber Temperature](#print-chamber-temperature)

## Standard Temperature Ranges

|   Material   | [Nozzle Temp (°C)](#nozzle)  | [Bed Temp (°C)](#bed)  | [Chamber Temp (°C)](#print-chamber-temperature)  |
|:------------:|:----------------------------:|:----------------------:|:------------------------------------------------:|
| PLA          | 180-220                      | 50-60                  | Ambient                                          |
| ABS          | 230-250                      | 90-100                 | 50-70                                            |
| ASA          | 240-260                      | 90-100                 | 50-70                                            |
| Nylon 6      | 230-260                      | 90-110                 | 70-100                                           |
| Nylon 12     | 225-260                      | 90-110                 | 70-100                                           |
| TPU          | 220-245                      | 40-60                  | Ambient                                          |
| PC           | 270-310                      | 100-120                | 80-100                                           |
| PC-ABS       | 260-280                      | 95-110                 | 60-80                                            |
| HIPS         | 220-250                      | 90-110                 | 50-70                                            |
| PP           | 220-270                      | 80-105                 | 40-70                                            |
| Acetal (POM) | 210-240                      | 100-130                | 70-100                                           |

## Nozzle

Set the nozzle temperature for the selected material for First Layer and Other Layers.

## Bed

Set the bed temperature for the selected material for First Layer and Other Layers for each Bed type if [Support multi bed types](printer_basic_information_printable_space#support-multi-bed-types) is enabled in printer settings.

## Print Chamber Temperature

This option activates the emitting of an M191 command before the "machine_start_gcode" which sets the chamber temperature and waits until it is reached.  
In addition, it emits an M141 command at the end of the print to turn off the chamber heater, if present.

This option relies on the firmware supporting the M191 and M141 commands either via macros or natively and is usually used when an active chamber heater is installed.

> [!NOTE]
> Check [Support control chamber temperature](printer_basic_information_accessory#support-controlling-chamber-temperature) in your printer settings to enable chamber temperature control.

For high-temperature materials like ABS, ASA, PC, and PA, a higher chamber temperature can help suppress or reduce warping and potentially lead to higher interlayer bonding strength. However, at the same time, a higher chamber temperature will reduce the efficiency of air filtration for ABS and ASA.

For PLA, PETG, TPU, PVA, and other low-temperature materials, this option should be disabled (set to 0) as the chamber temperature should be low to avoid extruder clogging caused by material softening at the heat break.

If enabled, this parameter also sets a G-code variable named chamber_temperature, which can be used to pass the desired chamber temperature to your print start macro, or a heat soak macro like this:

```gcode
PRINT_START (other variables) CHAMBER_TEMP=[chamber_temperature]
```

This may be useful if your printer does not support M141/M191 commands, or if you desire to handle heat soaking in the print start macro if no active chamber heater is installed.