# Ooze prevention

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `ooze_prevention`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--ooze-prevention=1`.  
This option will drop the temperature of the inactive extruders to prevent oozing.

## Temperature variation

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `standby_temperature_delta`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--standby-temperature-delta=1`.  
Temperature difference to be applied when an extruder is not active. The value is not used when 'idle_temperature' in filament settings is set to non-zero value.

## Preheat time

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `preheat_time`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--preheat-time=1`.  
To reduce the waiting time after tool change, Orca can preheat the next tool while the current tool is still in use. This setting specifies the time in seconds to preheat the next tool. Orca will insert a M104 command to preheat the tool in advance.

## Preheat steps

[Mode](option_mode): `Developer`.  
[Variable](built_in_placeholders_variables): `preheat_steps`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--preheat-steps=1`.  
Insert multiple preheat commands (e.g. M104.1). Only useful for Prusa XL. For other printers, please set it to 1.
