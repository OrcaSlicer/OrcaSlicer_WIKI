# G-Code Output

These settings control how G-code is generated and formatted. They impact readability, file size, print behavior, and compatibility with firmware and post-processing tools.

- [Reduce Infill Retraction](#reduce-infill-retraction)
- [Add line number](#add-line-number)
- [Verbose G-code](#verbose-g-code)
- [Label Objects](#label-objects)
- [Exclude Objects](#exclude-objects)
- [Filename Format](#filename-format)
- [Change extrusion role G-code](#change-extrusion-role-g-code)

## Reduce Infill Retraction

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `reduce_infill_retraction`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--reduce-infill-retraction=1`.  
When enabled, the slicer will skip retractions for travel moves that occur entirely inside infill regions. This reduces the number of retractions and can speed up printing for complex models, but it may increase oozing or stringing inside infill. Slicing time may also increase slightly.

Each retraction adds moves that print nothing, and a travel that skips it skips all of them, keeping only the travel itself:

- The [retraction](printer_extruder_retraction#length) pulls the filament back at the [Retraction speed](printer_extruder_retraction#retraction-speed) before the travel, and the [deretraction](printer_extruder_retraction#deretraction-speed) pushes it back, plus any [Extra length on restart](printer_extruder_retraction#extra-length-on-restart), before the next line starts. With the default 0.8 mm at 30 mm/s, each of the two takes about 27 ms.
- With [Wipe while retracting](printer_extruder_retraction#wipe-while-retracting), the nozzle also moves back along the last line for the [Wipe distance](printer_extruder_retraction#wipe-distance) while it retracts.
- With a [Z-hop](printer_extruder_z_hop#z-hop-height), the nozzle lifts before the travel and lowers after it, on the Z axis, which on most printers is much slower than X and Y.

Tens of milliseconds per travel can add up to minutes over the thousands of infill travels of a large print.

Travels shorter than the [Travel distance threshold](printer_extruder_retraction#travel-distance-threshold) never retract, with or without this option. Infill lines whose ends are next to each other are joined into one path (see [Anchor](strength_settings_infill#anchor)), so there is no travel to retract for between them.

**Recommended** when internal cosmetic quality is not critical and you want fewer retractions.

## Add line number

[Mode](option_mode): `Developer`.  
[Variable](built_in_placeholders_variables): `gcode_add_line_number`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--gcode-add-line-number=1`.  
Prefix each G-code line with a sequential line number (N1, N2, ...). Useful for debugging or tools that expect numbered G-code.

## Verbose G-code

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `gcode_comments`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--gcode-comments=1`.  
Include descriptive comments for G-code lines and blocks to make the file human-readable and easier to debug.  
Verbose mode produces much larger files and may slow down SD-card printing on some printers.

## Label Objects

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `gcode_label_objects`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--gcode-label-objects=1`.  
Insert comments that label moves with the object they belong to (object index or name). This is useful for integrations such as OctoPrint's Cancel Object plugin and for human inspection of the G-code.

## Exclude Objects

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `exclude_object`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--exclude-object=1`.  
Add commands to the G-code that define each object and mark where it starts and ends, so the printer firmware can skip (cancel) individual objects during the print: `EXCLUDE_OBJECT_DEFINE`, `EXCLUDE_OBJECT_START` and `EXCLUDE_OBJECT_END` for Klipper, and `M486` for Marlin and RepRapFirmware.

### Outline Tolerance

[Mode](option_mode): `Expert`.  
[Variable](built_in_placeholders_variables): `exclude_object_tolerance`.  
[Type](option_type#integer-float-percentage): `Float (mm)`.  
[CLI Example](cli_mode#setting-overrides): `--exclude-object-tolerance=0.2`.  

Controls the precision of the exclude-object outlines simplified via the Douglas-Peucker algorithm. This setting only applies to **Klipper** firmware (`EXCLUDE_OBJECT_DEFINE` lines), as Marlin and RepRapFirmware use `M486` commands without polygon definitions.

* **Default:** `0.1 mm`.
* **When to adjust:** If your printer has a limited CPU capacity and you are printing a full plate with many objects, highly detailed outlines can generate very large arrays. Processing these lines or running macros that iterate over them (such as KAMP adaptive meshing) can cause Klipper to trigger a `Timer too close` error.
* **Recommendation:** Raising this value to `0.2 mm` - `0.4 mm` significantly reduces the total number of points and prevents printer timeouts, with a negligible impact on outline precision. Setting it to `0` retains every point of the convex hull.

## Filename Format

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filename_format`.  
[Type](option_type#text): `Text`.  
[CLI Example](cli_mode#setting-overrides): `--filename-format={input_filename_base}_{filament_type[initial_tool]}_{print_time}.gcode`.  
Define a filename template for exported G-code. Templates may include tokens like project name, date, or other metadata to produce consistent and informative filenames on export.

For example:

```c++
{input_filename_base}_{filament_type[initial_tool]}_{print_time}.gcode
```

This can be used to generate filenames like `OrcaCube_PLA_1h15m.gcode`.

> [!TIP]
> Check [File Name Template](built_in_placeholders_variables#file-name-template) for available tokens and their meanings.

## Change extrusion role G-code

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `process_change_extrusion_role_gcode`.  
[Type](option_type#text): `Text`.  
[CLI Example](cli_mode#setting-overrides): `--process-change-extrusion-role-gcode=value`.  
This G-code is inserted when the [extrusion role](built_in_placeholders_variables#extrusion-roles) is changed.  
This is the process version of the **Change extrusion role G-code** that is also available in the [Material settings](material_advanced#change-extrusion-role-g-code) and [Printer settings](printer_machine_gcode#change-extrusion-role-g-code), and it runs after both of them.

> [!TIP]
> Read the [Printer settings](printer_machine_gcode#change-extrusion-role-g-code) for more details and examples.
