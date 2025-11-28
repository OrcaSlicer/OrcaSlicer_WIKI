# Multimaterial setup

Basic setup for multimaterial printing.

## Single Extruder Multi Material

Use single nozzle to print multi filament.

## Extruders

Number of extruders of the printer.

## Manual Filament Change

Manual filament change is a feature that allows the user to change the filament during the print. This can be useful for multi-material prints or when changing colors. The user can specify the position and timing of the filament change, as well as the speed and distance of the ramming process.  
Enable this option to omit the custom Change filament G-code only at the beginning of the print. The tool change command (e.g., T0) will be skipped throughout the entire print. This is useful for manual multi-material printing, where we use M600/PAUSE to trigger the manual filament change action.
