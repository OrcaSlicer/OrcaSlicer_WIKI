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

Material base type (e.g., PLA, ABS, PETG, etc.).
This setting affects coefficients used in various calculations, such as brim width or temperature warnings.

## Vendor

Vendor of filament. For show only.

## Soluble material

Soluble material is commonly used to print supports and support interfaces.

## Support material

Support material is commonly used to print supports and support interfaces.

## Filament ramming length

When changing the extruder, it is recommended to extrude a certain length of filament from the original extruder. This helps minimize nozzle oozing.

## Required nozzle HRC

Minimum HRC of nozzle required to print the filament. A value of 0 means no checking of the nozzle's HRC.

## Default color

Default filament color.
Right click to reset value to system default.

## Diameter

Filament diameter is used to calculate extrusion variables in G-code, so it is important that this is accurate and precise.

## Adhesiveness Category

Filament category.

## Density

Filament density, for statistical purposes only.

## Shrinkage (XY)

Enter the shrinkage percentage that the filament will get after cooling (94% if you measure 94mm instead of 100mm).
The part will be scaled in XY to compensate. Only the filament used for the perimeter is taken into account.
Be sure to allow enough space between objects, as this compensation is done after the checks.

## Shrinkage (Z)

Enter the shrinkage percentage that the filament will get after cooling (94% if you measure 94mm instead of 100mm). The part will be scaled in Z to compensate.

## Price

Filament price, for statistical purposes only.

## Softening temperature

The material softens at this temperature, so when the bed temperature is equal to or greater than this, it's highly recommended to open the front door and/or remove the upper glass to avoid clogs.

## Idle temperature

Nozzle temperature when the tool is currently not used in multi-tool setups. This is only used when 'Ooze prevention' is active in Print Settings. Set to 0 to disable.

## Recommended nozzle temperature

Min and max recommended nozzle temperature for this filament.
