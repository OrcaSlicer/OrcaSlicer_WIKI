# Basic Extruder Information

This section contains the basic information about the extruder.  
When using multiple extruders, you can set different values for each extruder.

- [Nozzle diameter](#nozzle-diameter)
- [Nozzle volume](#nozzle-volume)
- [Extruder Layer Height Limits](#extruder-layer-height-limits)
- [Extruder printable area](#extruder-printable-area)
- [Extruder offset Position](#extruder-offset-position)

## Nozzle diameter

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `nozzle_diameter[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--nozzle-diameter=1`.  
The diameter of the nozzle for each extruder.  

> [!TIP]
> You can use different nozzle diameters for each extruder to achieve different print qualities and speeds.  
> Follow the [Mixed Nozzle Sizes](mixed_nozzle_sizes) guide for more information on how to use this feature.

## Nozzle volume

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `nozzle_volume[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--nozzle-volume=1`.  
Volume of nozzle between the filament cutter and the end of the nozzle

## Extruder Layer Height Limits

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `extruder_printable_height[extruder_idx]`, `min_layer_height[extruder_idx]`, `max_layer_height[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--extruder-printable-height=1` (same pattern for the other variables above).  
Min and max layer height limits for the extruder. These settings are used when adaptive layer height is enabled.

## Extruder printable area

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extruder_printable_area[extruder_idx]`.  
[Type](option_type#list-types): `Point group list`.  
[CLI Example](cli_mode#setting-overrides): `--extruder-printable-area=value`.  
The area of the bed that each extruder can reach, on printers whose extruders can't all cover the whole bed. On the Bambu Lab H2D, for example, the left nozzle reaches X 0 to 325 mm and the right nozzle X 25 to 350 mm of the 350 mm wide bed, so a 25 mm strip on each side can only be printed by one nozzle.

Orca uses these areas to:

- Show the left and right nozzle-only areas on the plate.
- Warn before slicing when an object extends beyond the printable range of the nozzle that has to print one of its filaments.
- Keep a filament off an extruder that can't reach every part printed with it when filaments are grouped automatically.
- Clip the brim to the area of the extruder that prints it.
- Keep the prime tower inside the area that every extruder can reach.
- Report an error after slicing when a filament's G-code path leaves the printable range of its extruder.

When the profile leaves it empty, every extruder can reach the whole [printable area](printer_basic_information_printable_space#printable-area-bed-shape).

This value comes from the printer profile and can't be edited. It is only shown for printers with two extruders.

## Extruder offset Position

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extruder_offset[extruder_idx]`.  
[Type](option_type#list-types): `Point list`.  
[CLI Example](cli_mode#setting-overrides): `--extruder-offset=100,100`.  
If your firmware doesn't handle the extruder displacement you need the G-code to take it into account. This option lets you specify the displacement of each extruder with respect to the first one. It expects positive coordinates (they will be subtracted from the XY coordinate).
