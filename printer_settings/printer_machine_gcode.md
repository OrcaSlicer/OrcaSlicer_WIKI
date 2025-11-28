# Machine G-code

Machine G-code are custom G-code scripts that are executed at specific points during the printing process. These scripts can be used to customize printer behavior, such as setting temperatures, moving the print head, or controlling fans.

- [Machine start G-code](#machine-start-g-code)
- [Machine end G-code](#machine-end-g-code)
- [Printing by object G-code](#printing-by-object-g-code)
- [Before layer change G-code](#before-layer-change-g-code)
- [Layer change G-code](#layer-change-g-code)
- [Timelapse G-code](#timelapse-g-code)
- [Change filament G-code](#change-filament-g-code)
- [Change extrusion role G-code](#change-extrusion-role-g-code)
- [Pause G-code](#pause-g-code)
- [Template Custom G-code](#template-custom-g-code)

## Machine start G-code

This G-code is executed at the beginning of a print job, before any printing starts. It is typically used to prepare the printer for printing, such as homing axes, heating the bed and nozzle, and performing any necessary pre-print checks.

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

## Change filament G-code

This G-code is inserted when filament is changed, including T commands to trigger tool change.

## Change extrusion role G-code

This G-code is inserted when the extrusion role is changed.

## Pause G-code

This G-code will be used as a code for the pause print. Users can insert pause G-code in the G-code viewer.

## Template Custom G-code

This section allows users to define custom G-code templates that can be reused across different print jobs. Users can create and manage their own G-code snippets for various purposes.
