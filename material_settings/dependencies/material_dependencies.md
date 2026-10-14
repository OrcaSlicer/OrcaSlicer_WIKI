# Material Dependencies

Material dependencies help ensure that a material profile is only used with compatible printer and process profiles, preventing potential printing issues.

## Compatible printers

Set of printers that this material profile is compatible with if you want to limit its usage to specific printers.

### Printer Condition

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `compatible_printers_condition`.  
[Type](option_type#text): `Text`.  
Not available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  
 boolean expression using the configuration values of an active printer profile.  
 If this expression evaluates to true, this profile is considered compatible with the active printer profile.

## Compatible process profiles

Set of process profiles that this material profile is compatible with if you want to limit its usage to specific process profiles.

### Process Condition

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `compatible_prints_condition`.  
[Type](option_type#text): `Text`.  
Not available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  
A boolean expression using the configuration values of an active print profile.  
If this expression evaluates to true, this profile is considered compatible with the active print profile.
