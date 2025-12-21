# Machine G-code

Machine G-code are custom G-code scripts that are executed at specific points during the printing process. These scripts can be used to customize printer behavior, such as setting temperatures, moving the print head, or controlling fans.

> [!TIP]
> See your printer's firmware documentation for supported G-code commands and features.
>
> - [Marlin G-code](https://marlinfw.org/meta/gcode/)
> - [RepRap G-code](https://reprap.org/wiki/G-code)
> - [Klipper G-code](https://www.klipper3d.org/G-Codes)

> [!IMPORTANT]
> Machine G-code scripts are powerful tools for customizing your printing process. However, they can also cause issues if not used correctly.  
> It's recommended to use a known base of G-code commands for your specific printer firmware (e.g., Marlin, RepRap, etc.) and to understand the implications of each command used in the scripts.  
> Always test your G-code scripts thoroughly before using them in production.

- [Machine start G-code](#machine-start-g-code)
- [Machine end G-code](#machine-end-g-code)
- [Printing by object G-code](#printing-by-object-g-code)
- [Before layer change G-code](#before-layer-change-g-code)
- [Layer change G-code](#layer-change-g-code)
- [Timelapse G-code](#timelapse-g-code)
- [Clumping detection G-code](#clumping-detection-g-code)
- [Change filament G-code](#change-filament-g-code)
- [Change extrusion role G-code](#change-extrusion-role-g-code)
- [Pause G-code](#pause-g-code)
- [Template Custom G-code](#template-custom-g-code)

## Machine start G-code

This G-code is executed at the beginning of a print job, before any printing starts. It is typically used to prepare the printer for printing, such as homing axes, heating the bed and nozzle, and performing any necessary pre-print checks.

You can also use it for setting up custom notifications with M300 (play beep sound) or use a custom purge sequence:

```gcode
G90 ; use absolute coordinates
M83 ; extruder relative mode
M140 S[bed_temperature_initial_layer_single] ; set final bed temp
M104 S150 ; set temporary nozzle temp to prevent oozing during homing
G4 S10 ; allow partial nozzle warmup
G28 ; home all axis
G1 Z25 F240 ; lift nozzle
G1 X2 Y10 F3000 ; move to front left
M104 S[nozzle_temperature_initial_layer] ; set final nozzle temp
M190 S[bed_temperature_initial_layer_single] ; wait for bed temp to stabilize
M109 S[nozzle_temperature_initial_layer] ; wait for nozzle temp to stabilize
; Start Beep to indicate ready to print
M300 P136 S622
M300 P136 S0
M300 P136 S311
M300 P136 S466
M300 P273 S0
M300 P136 S415
M300 P409 S0
M300 P136 S622
M300 P136 S0
M300 P545 S466
; Purge Line
G1 Z0.28 F240 ; move to a custom layer height for purge
G1 X{first_layer_print_min[0]-15} Y{first_layer_print_min[1]} Z0.8 F6000.0 ; position 15mm left from the lower left of the first layer
G1 X{first_layer_print_min[0]-15} Y{first_layer_print_min[1]+30} E30 F360.0 ; extrude 30mm of filament in the y direction
G92 E0.0 ; reset extruder
G1 E-0.5 F2100 ; small retraction
G1 Y{first_layer_print_min[1]+40} F6000.0 ; move an additional 10mm without extruding
G92 E0.0 ; reset extruder
```

## Machine end G-code

This G-code is executed at the end of a print job, after all printing is complete. It is typically used to turn off heaters, move the print head away from the print, and perform any necessary post-print actions.

## Printing by object G-code

This G-code is executed at the start of printing each individual object in a multi-object print job. It can be used to set specific parameters or perform actions for each object.

## Before layer change G-code

This G-code is inserted at every layer change before the Z lift.

## Layer change G-code

This G-code is inserted at every layer change after the Z lift.

## Timelapse G-code

This G-code is used for capturing timelapse videos. It typically includes commands to move the print head out of the way for a photo and then return it to the previous position.

## Clumping detection G-code

This G-code is executed when clumping is detected during printing. It can be used to pause the print, retract filament, or perform other actions to address the clumping issue.

## Change filament G-code

This G-code is inserted when filament is changed, including T commands to trigger tool change.

## Change extrusion role G-code

This G-code is inserted when the extrusion role is changed.

Example G-codes:

- Marlin g-code to set fan speed to 10% (S25 out of S255) for BridgeInfill role and 30% (S75 out of S255) for other roles:
  ```gcode
  {if( extrusion_role == "BridgeInfill")}
  M106 S25
  {else}
  M106 S75
  {endif}
  ```
- Marlin g-code to set pressure advance to 0 for InternalInfill role and restore it to previous value for other roles:
  ```gcode
  {if( extrusion_role == "InternalInfill")}
  M900 K0
  {else}
  M900 K{pressure_advance[0]}
  {endif}
  ```

## Pause G-code

This G-code will be used as a code for the pause print. Users can insert pause G-code in the G-code viewer.

## Template Custom G-code

This section allows users to define custom G-code templates that can be reused across different print jobs. Users can create and manage their own G-code snippets for various purposes.
