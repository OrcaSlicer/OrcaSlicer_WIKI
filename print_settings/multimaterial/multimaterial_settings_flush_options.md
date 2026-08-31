# Flush Options

[Variable](built_in_placeholders_variables): `flush_into_objects`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--flush-into-objects=1`.  

## Flush into objects' infill

[Variable](built_in_placeholders_variables): `flush_into_infill`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--flush-into-infill=1`.  
Purging after filament change will be done inside objects' infills. This may lower the amount of waste and decrease the print time. If the walls are printed with transparent filament, the mixed color infill will be seen outside. It will not take effect, unless the prime tower is enabled.

## Flush into objects' support

[Variable](built_in_placeholders_variables): `flush_into_support`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--flush-into-support=1`.  
Purging after filament change will be done inside objects' support. This may lower the amount of waste and decrease the print time. It will not take effect, unless the prime tower is enabled.
