# Material Basic Information

This section contains basic information about the filament material.

- [Type](#type)
- [Vendor](#vendor)
- [Soluble material](#soluble-material)
- [Support material](#support-material)
- [Filament ramming length](#filament-ramming-length)
- [Required nozzle HRC](#required-nozzle-hrc)
- [Default color](#default-color)
- [Diameter](#diameter)
- [Adhesiveness Category](#adhesiveness-category)
- [Density](#density)
- [Shrinkage (XY)](#shrinkage-xy)
- [Shrinkage (Z)](#shrinkage-z)
- [Price](#price)
- [Softening temperature](#softening-temperature)
- [Idle temperature](#idle-temperature)
- [Recommended nozzle temperature](#recommended-nozzle-temperature)

## Type

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `filament_type`.  
[Type](option_type#list-types): `Text list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-type=value`.  
Material base type (e.g., PLA, ABS, PETG, etc.).  
This setting affects coefficients used in various calculations, such as brim width or temperature warnings.

## Vendor

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_vendor`.  
[Type](option_type#list-types): `Text list`.  
Not available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  
Vendor of filament. For show only.

## Soluble material

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_soluble`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-soluble=1`.  
Soluble material is commonly used to print supports and support interfaces.

## Support material

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_is_support`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-is-support=1`.  
Support material is commonly used to print supports and support interfaces.

## Filament ramming length

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_change_length`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-change-length=1`.  
When changing the extruder, it is recommended to extrude a certain length of filament from the original extruder. This helps minimize nozzle oozing.

## Required nozzle HRC

[Mode](option_mode): `Developer`.  
[Variable](built_in_placeholders_variables): `required_nozzle_HRC`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--required-nozzle-HRC=1`.  
Minimum HRC of nozzle required to print the filament. A value of 0 means no checking of the nozzle's HRC.

## Default color

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `default_filament_colour`.  
[Type](option_type#list-types): `Text list`.  
[CLI Example](cli_mode#setting-overrides): `--default-filament-colour=value`.  
Default filament color.  
Right click to reset value to system default.

## Diameter

[Variable](built_in_placeholders_variables): `filament_diameter`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-diameter=1`.  
Filament diameter is used to calculate extrusion variables in G-code, so it is important that this is accurate and precise.

## Adhesiveness Category

[Mode](option_mode): `Developer`.  
[Variable](built_in_placeholders_variables): `filament_adhesiveness_category`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-adhesiveness-category=1`.  
Filament category.

## Density

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_density`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-density=1`.  
Filament density, for statistical purposes only.

## Shrinkage (XY)

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_shrink`.  
[Type](option_type#list-types): `Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-shrink=20%`.  
Enter the shrinkage percentage that the filament will get after cooling (94% if you measure 94mm instead of 100mm).  
The part will be scaled in XY to compensate. Only the filament used for the perimeter is taken into account.  
Be sure to allow enough space between objects, as this compensation is done after the checks.

## Shrinkage (Z)

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_shrinkage_compensation_z`.  
[Type](option_type#list-types): `Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-shrinkage-compensation-z=20%`.  
Enter the shrinkage percentage that the filament will get after cooling (94% if you measure 94mm instead of 100mm). The part will be scaled in Z to compensate.

## Price

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_cost`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-cost=1`.  
Filament price, for statistical purposes only.

## Softening temperature

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `temperature_vitrification`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--temperature-vitrification=1`.  
The material softens at this temperature, so when the bed temperature is equal to or greater than this, it's highly recommended to open the front door and/or remove the upper glass to avoid clogs.

## Idle temperature

[Variable](built_in_placeholders_variables): `idle_temperature`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--idle-temperature=1`.  
Nozzle temperature when the tool is currently not used in multi-tool setups. This is only used when 'Ooze prevention' is active in Print Settings. Set to 0 to disable.

## Recommended nozzle temperature

Min and max recommended nozzle temperature for this filament.
