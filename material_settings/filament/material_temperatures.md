# Material Temperatures

Set the temperatures for the selected material.

> [!TIP]
> Check [Temperature calibration](temp-calib) to find the optimal nozzle temperature for your filament.

- [Standard Temperature Ranges](#standard-temperature-ranges)
- [Nozzle](#nozzle)
- [Bed](#bed)
- [Print Chamber Temperature](#print-chamber-temperature)

## Standard Temperature Ranges

The following table lists the standard temperature ranges for common 3D printing materials.
Actual optimal temperatures may vary based on specific filament brands and printer models.
Always refer to the filament manufacturer's recommendations and [calibrations](temp-calib) for best results.

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

One of the most critical settings for successful 3D printing is the nozzle temperature.
The correct nozzle temperature ensures proper melting and extrusion of the filament, leading to good layer adhesion and overall print quality.
You can set a higher temperature for the first layer to improve bed adhesion but be cautious with deformations as [elephant foot](quality_settings_precision#elephant-foot-compensation).

## Bed

Set the bed temperature for the selected material for First Layer and Other Layers for each Bed type if [Support multi bed types](printer_basic_information_printable_space#support-multi-bed-types) is enabled in printer settings.
Using a higher temperature for the first layer can help improve adhesion to the build surface but be cautious of potential deformations like [elephant foot](quality_settings_precision#elephant-foot-compensation).

Bed temperature plays a crucial role in ensuring proper filament adhesion to the build surface, which directly impacts both print success and quality.
Most materials have a relatively broad optimal range for bed temperature (typically +/-5°C).
In general, following the manufacturer’s recommendations, maintaining a clean bed (free from oils or fingerprints), ensuring a stable [chamber temperature](#print-chamber-temperature), and having a properly leveled bed will produce reliable results.

- If the bed temperature is too low, the filament may fail to adhere properly, leading to warping, weak layer bonding, or complete detachment. In severe cases, the printed part may dislodge entirely and stick to the nozzle or other printer components, potentially causing mechanical damage.
- If the bed temperature is too high, the lower layers can overheat and soften excessively, resulting in deformation such as [elephant foot](quality_settings_precision#elephant-foot-compensation).

> [!TIP]
> As a general guideline, you can use the [glass transition temperature](https://en.wikipedia.org/wiki/Glass_transition) (Tg) of the material and subtract 5–10 °C to estimate a safe upper limit for bed temperature.
> See [this article](https://magigoo.com/blog/prevent-warping-temperature-and-first-layer-adhesion-magigoo/) for a detailed explanation.

> [!NOTE]
> For challenging prints involving materials with **high shrinkage** (e.g., nylons or polycarbonate) or geometries prone to warping, dialed-in settings are critical.
> In these cases, [chamber temperature](#print-chamber-temperature) becomes a **major factor** in preventing detachment and ensuring print success.

## Print Chamber Temperature

Chamber temperature can affect the print quality, especially for high-temperature filaments.
A heated chamber can help to maintain a consistent temperature throughout the print, reducing the risk of warping and improving layer adhesion. However, it is important to monitor the chamber temperature to ensure that it does not exceed the filament's deformation temperature.

> [!IMPORTANT]
> Low temperature Filaments like PLA can clog the nozzle if the chamber temperature is too high.

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
