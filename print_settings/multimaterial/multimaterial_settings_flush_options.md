# Flush Options

## Flush into objects' infill

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `flush_into_infill`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--flush-into-infill=1`.  
Purging after a filament change will be done inside the objects' infill. This may lower the amount of waste and decrease the print time. If the walls are printed with transparent filament, the mixed color infill will be visible. It will not take effect unless the prime tower is enabled. With a Type 2 [wipe tower](printer_multimaterial_wipe_tower), purging into objects is only used on single extruder multi-material printers with [Purge in prime tower](printer_multimaterial_wipe_tower#purge-in-prime-tower) enabled.

## Flush into this object

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `flush_into_objects`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--flush-into-objects=1`.  
Purging after a filament change will be done by printing this object's walls and infill with the new filament. This may lower the amount of waste and decrease the print time, but the colors of the object will be mixed as a result. Objects with this option are used for purging before the infill of other objects, and whatever they can't take is still purged on the prime tower. It will not take effect unless the prime tower is enabled. With a Type 2 [wipe tower](printer_multimaterial_wipe_tower), purging into objects is only used on single extruder multi-material printers with [Purge in prime tower](printer_multimaterial_wipe_tower#purge-in-prime-tower) enabled.

This is a per-object setting, so it isn't shown in the global process settings. Right-click the object in the object list or in the 3D view and check **Flush Options** > **Flush into this object**, or switch the process settings from **Global** to **Objects**, select the object and change it there. The **Flush Options** menu only appears when the plate uses more than one filament.

## Flush into objects' support

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `flush_into_support`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--flush-into-support=1`.  
Purging after a filament change will be done inside the objects' support. This may lower the amount of waste and decrease the print time. It will not take effect unless the prime tower is enabled. With a Type 2 [wipe tower](printer_multimaterial_wipe_tower), purging into objects is only used on single extruder multi-material printers with [Purge in prime tower](printer_multimaterial_wipe_tower#purge-in-prime-tower) enabled.
