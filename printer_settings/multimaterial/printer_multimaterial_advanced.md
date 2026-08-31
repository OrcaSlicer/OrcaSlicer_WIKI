# Advanced Multi-Material Settings

This section describes advanced settings for multi-material printing.

## Filament load time

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `machine_load_filament_time`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--machine-load-filament-time=1`.  
Time to load new filament when switch filament. It's usually applicable for single-extruder multi-material machines. For tool changers or multi-tool machines, it's typically 0. For statistics only.

## Filament unload time

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `machine_unload_filament_time`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--machine-unload-filament-time=1`.  
Time to unload old filament when switch filament. It's usually applicable for single-extruder multi-material machines. For tool changers or multi-tool machines, it's typically 0. For statistics only.

## Tool change time

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `machine_tool_change_time`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--machine-tool-change-time=1`.  
Time taken to switch tools. It's usually applicable for tool changers or multi-tool machines. For single-extruder multi-material machines, it's typically 0. For statistics only.
