# Extruder Clearance

Extruder clearance settings define the minimum distances required around the extruder to avoid collisions with the print bed, rods, or lid during printing. These settings are particularly important for printers with complex geometries or when using by-object printing modes.

## Radius

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extruder_clearance_radius`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--extruder-clearance-radius=1`.  
Clearance radius around extruder: used for collision avoidance in by-object printing.

## Height to rod

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extruder_clearance_height_to_rod`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--extruder-clearance-height-to-rod=1`.  
Distance from the nozzle tip to the lower rod. Used for collision avoidance in by-object printing.

## Height to lid

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extruder_clearance_height_to_lid`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--extruder-clearance-height-to-lid=1`.  
Distance from the nozzle tip to the lid. Used for collision avoidance in by-object printing.
