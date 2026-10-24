# Placeholders and Expressions

OrcaSlicer fills in placeholders when it expands custom G-code and the file name template.

Write a placeholder inside curly braces, for example `{layer_num}`. Every print, filament and printer setting is a placeholder, with its config key as the name. This page lists the other placeholders, which OrcaSlicer sets while it slices.

- [Placeholders by G-code Field](#placeholders-by-g-code-field)
- [Reading the Tables](#reading-the-tables)
- [Expressions and Functions](#expressions-and-functions)
- [Common Errors](#common-errors)
- [Filaments, Extruders and Nozzles](#filaments-extruders-and-nozzles)
- [Temperatures](#temperatures)
- [Dimensions](#dimensions)
- [Print Statistics](#print-statistics)
- [Objects](#objects)
- [Plates](#plates)
- [Presets](#presets)
- [Timestamps](#timestamps)
- [Environment](#environment)
- [Toolhead Position](#toolhead-position)
- [Placeholders for Specific G-code](#placeholders-for-specific-g-code)
    - [Layer Placeholders](#layer-placeholders)
    - [Filament Start and End G-code](#filament-start-and-end-g-code)
    - [Layer Change G-code](#layer-change-g-code)
    - [Timelapse and Clumping Detection G-code](#timelapse-and-clumping-detection-g-code)
    - [Change Filament G-code](#change-filament-g-code)
    - [Change Extrusion Role G-code](#change-extrusion-role-g-code)
    - [Extrusion Roles](#extrusion-roles)
- [File Name Template](#file-name-template)
- [Examples](#examples)

> [!TIP]
> To find the key of a setting, hover over its label in OrcaSlicer, or read the *Variable* line in the setting's wiki page.
>
> ![variable_name](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/variable_name.png?raw=true)

## Placeholders by G-code Field

Every custom G-code field can use all settings and the placeholders in [Filaments, Extruders and Nozzles](#filaments-extruders-and-nozzles), [Temperatures](#temperatures), [Dimensions](#dimensions), [Print Statistics](#print-statistics), [Objects](#objects), [Plates](#plates), [Presets](#presets), [Timestamps](#timestamps), [Environment](#environment) and [Toolhead Position](#toolhead-position). Some fields also have the extra placeholders in this table.

| Field | Key | Extra placeholders |
| --- | --- | --- |
| File header G-code | `file_start_gcode` | None |
| Start G-code (printer) | `machine_start_gcode` | None |
| Start G-code (filament) | `filament_start_gcode` | [Layer Placeholders](#layer-placeholders) and [Filament Start and End G-code](#filament-start-and-end-g-code) |
| Before layer change G-code | `before_layer_change_gcode` | [Layer Placeholders](#layer-placeholders) |
| Layer change G-code | `layer_change_gcode` | [Layer Placeholders](#layer-placeholders) and [Layer Change G-code](#layer-change-g-code) |
| Timelapse G-code | `time_lapse_gcode` | [Layer Placeholders](#layer-placeholders) and [Timelapse and Clumping Detection G-code](#timelapse-and-clumping-detection-g-code) |
| Clumping detection G-code | `wrapping_detection_gcode` | [Layer Placeholders](#layer-placeholders), `most_used_physical_extruder_id` and `curr_physical_extruder_id` |
| Change filament G-code | `change_filament_gcode` | [Layer Placeholders](#layer-placeholders) and [Change Filament G-code](#change-filament-g-code) |
| Change extrusion role G-code | `change_extrusion_role_gcode`<br>`filament_change_extrusion_role_gcode`<br>`process_change_extrusion_role_gcode` | *`filament_change_extrusion_role_gcode` and `process_change_extrusion_role_gcode` added in 2.4.0.* [Change Extrusion Role G-code](#change-extrusion-role-g-code) |
| Pause G-code | `machine_pause_gcode` | None |
| IDEX/IQEX Mode G-codes | `imex_mode_gcodes` | *Added in 2.5.0.* None. It runs before the printer start G-code. Errors in it are shown under the name `imex_mode_gcode`. |
| Custom G-code | `template_custom_gcode` | None |
| Between Object G-code | `printing_by_object_gcode` | None |
| End G-code (filament) | `filament_end_gcode` | [Layer Placeholders](#layer-placeholders) and [Filament Start and End G-code](#filament-start-and-end-g-code) |
| End G-code (printer) | `machine_end_gcode` | [Layer Placeholders](#layer-placeholders) and the filament values in [Filament Start and End G-code](#filament-start-and-end-g-code) |
| File name template | `filename_format` | A different set: all settings, and the placeholders marked *Also works in the file name*. See [File Name Template](#file-name-template). |

`machine_pause_gcode` has no extra placeholders. The old `color_change_extruder` placeholder is no longer set, and using it fails.

## Reading the Tables

- The **Type** column gives the unit of each value, for example `float (mm)`. Counts, text and booleans have no unit.
- `[]` after a name marks a list, for example a list with one value per filament. To pick one value, see [Expressions and Functions](#expressions-and-functions).
- For a filament, extruder or nozzle index, the Type column says which of the three it is. Many older names say *extruder* when they mean a filament, for example `current_extruder`, `previous_extruder` and `is_extruder_used`. Check the Type column.
    - **Filament index**: the position in the filament list, counting from 0.
    - **Extruder index**: the physical extruder or toolhead, counting from 0, as in `current_extruder_id`. `filament_map[]` gives the extruder of each filament.
    - **Nozzle index**: the nozzle. It is the same as the extruder index unless the printer has several nozzles per extruder.
- **Type 1** and **Type 2** prime tower are the two values of the *Wipe tower type* setting. Type 1 is the Bambu Lab style prime tower. Bambu Lab printers always use Type 1.

## Expressions and Functions

Inside `{ }`, OrcaSlicer evaluates a small expression language. Placeholder names are case sensitive. Use parentheses to group parts of an expression.

The following operators are available:

- Arithmetic `+`, `-`, `*`, `/` and `%` (remainder). For example, `{filament_diameter[0] / 2}` is the radius of the first filament.
- Comparison `==`, `!=`, `<`, `>`, `<=` and `>=`. The result is a boolean.
- Logical `and` / `&&`, `or` / `||` and `not` / `!`.
- Conditional `condition ? a : b`, which gives `a` when `condition` is true and `b` when it is false.
- Text joining with `+`, for example `{"v" + layer_num}`.
- Regular-expression match `text =~ /pattern/`, which is true when the whole text matches the pattern, and `!~`, which is true when it does not match. To find a part of the text, put `.*` before and after the pattern, for example `{if printer_notes =~ /.*BAMBU.*/}bambu{endif}`.

The following functions are available:

| Function | Description |
| --- | --- |
| `int(x)` | `x` without its decimal part. `{int(13.9)}` is `13`. |
| `round(x)`<br>`floor(x)`<br>`ceil(x)` | `x` rounded to the nearest, lower or higher whole number. |
| `min(a, b)`<br>`max(a, b)` | The smaller or larger of two numbers. |
| `digits(value, width [, decimals])` | `value` aligned right in `width` characters, with an optional fixed number of decimals. |
| `zdigits(value, width [, decimals])` | Like `digits`, but padded with leading zeros. `{zdigits(5, 4)}` is `0005`. |
| `random(a, b)` | A random number between `a` and `b`. |
| `interpolate_table(x, (x0, y0), (x1, y1), ...)` | The `y` value for `x` on the straight lines between the given points. The x values must increase, and `x` must be between the first and the last x value. |
| `one_of(value, a, b, ...)` | True when the text `value` is equal to one of the listed texts. A listed value can be a `/regex/` pattern, which must match the whole text. `value` must be text, not a number. |
| `regex_replace(text, /pattern/, replacement)` | *Added in 2.5.0.* `text` with every match of `/pattern/` replaced by `replacement`. The replacement can use capture groups (`$1`, `$2`, ...). |
| `size(list)`<br>`empty(list)` | The number of values in a list, and whether the list is empty. |
| `is_nil(name)` | True when the value is not set, for example a filament override that is left empty. For a list, give an index. |
| `filament_change(n)` | From this point in the custom G-code, a list of decimal numbers without an index gives the value for filament `n`. |

`{if}`, `{elsif}`, `{else}` and `{endif}` choose between blocks of text, for example `{if layer_num == 0}first{else}later{endif}`.

You can store values in variables. `{local name = "part"}{name}` defines a variable and then prints it. A `{local}` variable exists only in the custom G-code where it is defined. A `{global}` variable is also available in the custom G-code that runs later in the same print. A variable can also hold a list. `{local temps = (200, 210)}` makes a list of two values, and `{local zeros = repeat(4, 0)}` makes a list of four zeros.

To pick one value from a list, give its index, counting from 0. For example, `{nozzle_temperature[1]}` is the value for the second filament. Inside `{ }`, a list of decimal numbers without an index gives the value for the current filament. A list of integers, booleans, text or points without an index fails with "Referencing a vector variable when scalar is expected".

OrcaSlicer also accepts an older syntax, `[name]`, which prints one placeholder and does not support expressions. Booleans print as `true` or `false` inside `{ }`, and as `1` or `0` inside `[ ]`.

## Common Errors

When a placeholder in custom G-code fails, the G-code export fails. The message starts with "Failed to generate G-code for invalid custom G-code." For each field that failed, it gives the key of the field and the first error in that field. An error in `filename_format` starts with "Processing of the filename_format template failed." instead.

| Error | Cause |
| --- | --- |
| `Not a variable name` (inside `{ }`) or `Variable does not exist` (inside `[ ]`) | The name is misspelled, the field does not have this placeholder (see [Placeholders by G-code Field](#placeholders-by-g-code-field)), or your version of OrcaSlicer does not have it yet. In `filename_format`, only settings and the placeholders marked *Also works in the file name* exist, see [File Name Template](#file-name-template). |
| `Referencing a vector variable when scalar is expected` | A list of integers, booleans, text or points is used without an index. Add an index, for example `{nozzle_temperature[0]}`. |
| `This value is known only after the G-code is generated. It can be printed, but not used in a calculation or a comparison.` | A value marked *Filled in after generation* is used in a calculation. See [Print Statistics](#print-statistics). |

## Filaments, Extruders and Nozzles

| Placeholder | Type | Description |
| --- | --- | --- |
| `current_extruder`<br>`current_filament_id` | int (filament index) | *`current_filament_id` added in 2.5.0.* Filament printing now. The two names usually give the same value. In the printer end G-code, and in the first filament start G-code on Bambu Lab printers, `current_filament_id` can be different. See [Filament Start and End G-code](#filament-start-and-end-g-code). |
| `current_extruder_id` | int (extruder index) | *Added in 2.5.0.* Extruder printing now. In `change_filament_gcode` it is still the outgoing extruder. |
| `current_nozzle_id` | int (nozzle index) | *Added in 2.5.0.* Nozzle printing now. |
| `current_hotend` | int | *Added in 2.4.0.* On most printers, the extruder printing now. On Bambu Lab printers, the hotend-rack nozzle when the print moves filaments between nozzles, and `-1` otherwise. |
| `has_single_extruder_multi_material_priming` | bool | `true` when the single-extruder multi-material priming area is used. |
| `initial_extruder`<br>`initial_tool`<br>`initial_filament_id` | int (filament index) | *`initial_filament_id` added in 2.5.0.* First filament used in the print. All three names give the same value. `initial_extruder` and `initial_tool` also work in the file name. |
| `initial_nozzle_id` | int (nozzle index) | *Added in 2.5.0.* Nozzle of the first filament. |
| `initial_no_support_extruder`<br>`initial_no_support_tool`<br>`initial_no_support_filament_id` | int (filament index) | *`initial_no_support_filament_id` added in 2.5.0.* First filament that is not a support filament. `initial_no_support_extruder` also works in the file name. |
| `initial_no_support_hotend` | int | *Added in 2.4.0.* Hotend of that filament, with the same rule as `current_hotend`. |
| `is_extruder_used[]` | bool per filament | `true` for each filament that the print uses. |
| `filament_map[]` | int per filament (extruder index + 1) | Extruder of each filament, counting from **1**. In `change_filament_gcode`, `filament_map[next_extruder] - 1` is the incoming extruder. Also works in the file name. |
| `first_tools[]`<br>`first_filaments[]` | int per extruder (filament index) | First filament that each extruder prints, or `-1`. Correct on Bambu Lab and IDEX/IQEX printers. On other printers with several extruders, the values are currently wrong. |
| `first_non_support_tools[]`<br>`first_non_support_filaments[]`<br>`first_non_support_hotend[]` | int per extruder | *`first_non_support_hotend` added in 2.5.0.* Like `first_tools[]`, but without support filaments. `first_non_support_hotend[]` gives the hotend of that filament instead, with the same rule as `current_hotend`. The same limitation applies. |
| `num_extruders` | int | Number of physical extruders on the printer, also when the print uses fewer. Also works in the file name. |
| `nozzle_diameter_at_nozzle_id[]`<br>`nozzle_volume_types[]` | float (mm)<br>string | *Added in 2.5.0.* Diameter and flow type of each nozzle. On printers with one nozzle per extruder, there is one value per extruder. |
| `flush_temperatures[]`<br>`flush_volumetric_speeds[]` | int (°C)<br>float (mm³/s) | Purge temperature and purge speed of each filament. |
| `retraction_distance_when_cut` | float (mm) | Retraction distance when the filament is cut by the AMS or a filament cutter, for the current filament. |
| `long_retraction_when_cut` | bool | `true` when *Long retraction when cut* is on for the current filament. |
| `retraction_distance_when_ec`<br>`long_retraction_when_ec` | float (mm)<br>bool | The same two values for an extruder change. |
| `is_all_bbl_filament`<br>`has_tpu_in_first_layer`<br>`enable_high_low_temp_mix`<br>`hold_chamber_temp_for_flat_print`<br>`max_additional_fan`<br>`during_print_exhaust_fan_speed_num[]` | various | Values used by the Bambu Lab start G-code. |

## Temperatures

| Placeholder | Type | Description |
| --- | --- | --- |
| `bed_temperature[]` | int per filament (°C) | Bed temperature of each filament for the current plate type. |
| `bed_temperature_initial_layer[]`<br>`first_layer_bed_temperature[]` | int per filament (°C) | First-layer bed temperature of each filament for the current plate type. |
| `bed_temperature_initial_layer_single` | int (°C) | First-layer bed temperature of the filament that prints first (`initial_extruder`). If the bed temperature formula is set to the highest temperature, it is the highest first-layer bed temperature of the filaments used on the first layer. |
| `first_layer_temperature[]` | int per filament (°C) | First-layer nozzle temperature of each filament. |
| `chamber_temperature[]` | int per filament (°C) | Chamber temperature of each filament. Also works in the file name. |
| `chamber_minimal_temperature[]` | int per filament (°C) | *Added in 2.4.1.* Minimum chamber temperature of each filament. Also works in the file name. |
| `overall_chamber_temperature` | int (°C) | Highest `chamber_temperature[]` of the filaments used. |
| `min_vitrification_temperature` | int (°C) | Lowest softening temperature of the filaments used. |

## Dimensions

| Placeholder | Type | Description |
| --- | --- | --- |
| `first_layer_print_convex_hull` | array of `[x, y]` pairs (mm) | Convex hull of the first layer, as a polygon. |
| `first_layer_print_min` | float[2] (mm) | Smallest X and Y of the first layer. |
| `first_layer_print_max` | float[2] (mm) | Largest X and Y of the first layer. |
| `first_layer_print_size` | float[2] (mm) | Width and depth of the first layer. |
| `first_layer_center_no_wipe_tower` | float[2] (mm) | Center of the objects on the first layer, including their brim. Only the first copy of each object counts. The prime tower and the skirt are not included. |
| `in_head_wrap_detect_zone` | bool | `true` when the objects, seen from above, or the first layer touch the head-wrap detection area. |
| `first_layer_height` | float (mm) | Height of the first layer. |
| `print_bed_min` | float[2] (mm) | Smallest X and Y of the bed. |
| `print_bed_max` | float[2] (mm) | Largest X and Y of the bed. |
| `print_bed_size` | float[2] (mm) | Width and depth of the bed. |
| `max_print_z` | int (mm) | Height of the tallest object, rounded up. |
| `max_print_height` | int (mm) | Maximum print height of the printer. |
| `adaptive_bed_mesh_min`<br>`adaptive_bed_mesh_max` | float[2] (mm) | Corners of the area to probe. See [Adaptive Bed Mesh](printer_basic_information_adaptive_bed_mesh#available-g-code-variables-for-adaptive-bed-mesh-command). |
| `bed_mesh_probe_count`<br>`bed_mesh_algo` | int[2]<br>string | Number of probe points and interpolation algorithm for that area. |
| `has_wipe_tower` | bool | `true` when the print has a prime tower. |
| `wipe_tower_wait_pos_x`<br>`wipe_tower_wait_pos_y` | float (mm) | *Added in 2.5.0.* A point just outside the prime tower, where the nozzle can wait while it heats. `wipe_tower_center_pos_x` and `wipe_tower_center_pos_y` hold the same values under the names Bambu Studio uses. |
| `wipe_tower_wait_pos_valid` | bool | *Added in 2.5.0.* `true` when the print has a prime tower and the point above is set. `wipe_tower_center_pos_valid` holds the same value under the name Bambu Studio uses. |

## Print Statistics

> [!IMPORTANT]
> NEW FEATURE: **Print statistics in custom G-code**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds). In 2.5.0-alpha and older, `print_time`, `normal_print_time`, `silent_print_time`, `used_filament`, `total_weight`, `total_cost`, `total_wipe_tower_cost` and `total_wipe_tower_filament` work only in the file name. In custom G-code, they stop slicing with "Not a variable name". The error for calculations is also only in nightly builds. Older versions give a wrong result or a different error.

Some of these values are marked *Filled in after generation*. OrcaSlicer knows them only after the whole G-code is generated. In custom G-code, it first writes a marker, and replaces the marker with the value at the end. In custom G-code, these values have two decimal places. In the file name, they can have more digits.

Because the value is not known yet, you can print it and join it to text, but you cannot calculate with it:

| Works | Fails |
| --- | --- |
| `{total_weight}` | `{total_weight * 2}` |
| `{"Weight: " + total_weight + " g"}` | `{total_weight + 5}` |
| `{local w = total_weight}{w}` | `{if total_weight > 100}heavy{endif}` |
| | `{int(total_weight)}` |

An expression in the Fails column stops slicing with "This value is known only after the G-code is generated. It can be printed, but not used in a calculation or a comparison." The same error comes from functions such as `round()`, `min()` and `one_of()`, from regular-expression matches, and from a copy of the value in a variable.

OrcaSlicer reads `+` from left to right, and text joined with a number stays text. So `{"W: " + total_weight + 5}` prints `W: 123.455` for a weight of 123.45 g. It does not add 5.

| Placeholder | Type | Description |
| --- | --- | --- |
| `normal_print_time`<br>`print_time` | string | Estimated print time in normal mode, written like `2d3h15m`, `2h15m`, `5m30s` or `45s`. Times of one hour or more are rounded to the minute. Filled in after generation. Also works in the file name. |
| `silent_print_time` | string | Estimated print time in silent mode, in the same format. `0s` unless the G-code flavor is Marlin and *Silent Mode* is on. Filled in after generation. Also works in the file name. |
| `print_time_total_sec` | float (s) | *Added in 2.5.0.* Estimated print time in normal mode, in seconds. Filled in after generation. |
| `print_time_day`<br>`print_time_hour`<br>`print_time_minute`<br>`print_time_sec` | int (d)<br>int (h)<br>int (min)<br>int (s) | *`print_time_day`, `print_time_hour` and `print_time_minute` added in 2.5.0.* Days, hours, minutes and seconds of the normal-mode print time. `print_time_sec` is only the seconds, not the total. Filled in after generation. |
| `total_layer_count` | int | Number of layers. |
| `total_toolchanges` | int | Number of filament changes in the print. The filament selected at print start does not count. With a prime tower, this is the prime tower's count. Without one, OrcaSlicer counts the changes in the planned tool order. It is `0` when printing by object without a prime tower. Also works in the file name. |
| `used_filament`<br>`used_filament_length` | float (m) | Length of filament that the whole print uses. Filled in after generation. `used_filament` also works in the file name. |
| `extruded_volume[]` | float per filament (mm³) | Volume extruded so far with each filament. In custom G-code, this is a running total, so it is `0` in the start G-code. `extruded_volume` also works in the file name, as the total volume. |
| `extruded_volume_total` | float (mm³) | Sum of `extruded_volume[]`. Also a running total. Also works in the file name, as the total of the whole print. |
| `extruded_weight[]` | float per filament (g) | Weight extruded so far with each filament, from the filament density. Also a running total. |
| `extruded_weight_total` | float (g) | Sum of `extruded_weight[]`. Also a running total. For the weight of the whole print, use `total_weight`. Also works in the file name, as the total of the whole print. |
| `total_weight` | float (g) | Filament weight of the whole print. Filled in after generation. Also works in the file name. |
| `total_cost` | float (currency) | Filament cost plus the printer's time cost (`time_cost` per hour of printing). Filled in after generation. Also works in the file name. |
| `total_wipe_tower_cost` | float (currency) | Filament cost of the prime tower. Filled in after generation. It is currently `0` with the Type 1 prime tower. Also works in the file name. |
| `total_wipe_tower_filament` | float (mm) | Length of filament used for the prime tower. Filled in after generation. It is currently `0` with the Type 1 prime tower. Also works in the file name. |

## Objects

| Placeholder | Type | Description |
| --- | --- | --- |
| `num_objects` | int | Number of objects on the plate. Copies of an object count in `num_instances`. Also works in the file name. |
| `num_instances` | int | Number of printed instances of all objects. Also works in the file name. |
| `current_object_idx` | int | Position of the object printing now in the print order, counting from 0. Each copy of an object counts. It changes only when printing by object. |
| `scale[]` | string per object | Scale of each object as text, for example `x:100% y:50% z:100%`. Also works in the file name. |
| `input_filename_base` | string | Name of the first printable object, without the extension. If the object has no name, the name of its source file. Also works in the file name, where it is the project name for a saved project. |
| `input_filename` | string | `input_filename_base` followed by `.gcode`. Also works in the file name. |
| `first_object_name` | string | *Added in 2.4.2.* Name of the first printable object on the plate. Also works in the file name. |

## Plates

| Placeholder | Type | Description |
| --- | --- | --- |
| `plate_name` | string | Name of the plate. Also works in the file name. |
| `plate_number` | string | Number of the plate, counting from 1 and padded to two digits, for example `01`. Also works in the file name. |
| `model_name` | string | Model name saved in the 3MF project, or empty. Also works in the file name. |
| `imex_mode` | string | *Added in 2.5.0.* Name of the plate's [IDEX/IQEX](printer_multimaterial_idex_iqex) parallel mode, or `primary` in Primary mode. Empty when the printer is not an IDEX/IQEX printer. |
| `imex_mode_index` | int | *Added in 2.5.0.* Index of that mode in the printer's `imex_mode_names`, counting from 0. This is its row in the [Modes](printer_multimaterial_idex_iqex#modes) grid. `0` is Primary. |
| `imex_mode_gcode` | string | *Added in 2.5.0.* The [Mode G-code](printer_multimaterial_idex_iqex#mode-g-code) of that mode, before its placeholders are filled in. |

## Presets

| Placeholder | Type | Description |
| --- | --- | --- |
| `print_preset` | string | Name of the print preset. Also works in the file name. |
| `filament_preset[]` | string per filament | Name of the preset of each filament. Also works in the file name. |
| `filament_type[]` | string per filament | Material type of each filament, for example `PLA` or `PETG`. Also works in the file name. |
| `printer_preset` | string | Name of the printer preset. Also works in the file name. |

## Timestamps

| Placeholder | Type | Description |
| --- | --- | --- |
| `timestamp` | string (`yyyyMMdd-hhmmss`) | Local time when G-code export started. Also works in the file name, as the time when the name is built. |
| `year`<br>`month`<br>`day` | int | Date of `timestamp`. Also works in the file name. |
| `hour`<br>`minute`<br>`second` | int | Time of day of `timestamp`. Also works in the file name. |

## Environment

| Placeholder | Type | Description |
| --- | --- | --- |
| `user` | string | User name from the `USER` or `USERNAME` environment variable, or `unknown`. Also works in the file name. |
| `version` | string | OrcaSlicer version. Also works in the file name. |

## Toolhead Position

These values describe the toolhead when a custom G-code starts. Only `zhop` is read-only. If your G-code moves the toolhead, update `position[]`, and OrcaSlicer continues from the new position.

`e_position[]` and `e_retracted[]` are correct, and OrcaSlicer reads back your changes, only when *Single Extruder Multi Material* is off. This setting is on by default. When it is on, do not use these two values.

| Placeholder | Type | Description |
| --- | --- | --- |
| `zhop` | float (mm) | Z-hop height when the custom G-code starts. Read-only. |
| `position[]` | float[3] (mm) | X, Y and Z position of the toolhead when the custom G-code starts. |
| `e_position[]` | float per filament (mm) | Position of the extruder axis. Used only when the G-code uses absolute E distances. |
| `e_retracted[]` | float per filament (mm) | How far the filament is retracted when the custom G-code starts. |
| `e_restart_extra[]` | float per filament (mm) | Extra length to extrude after the next unretraction. |

## Placeholders for Specific G-code

OrcaSlicer sets the placeholders in this section only in the G-code that each section names. [Placeholders by G-code Field](#placeholders-by-g-code-field) lists them by field.

> [!IMPORTANT]
> NEW FEATURE: **Placeholders on every path**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds). In 2.5.0-alpha and older, these placeholders are missing, and using one stops slicing with "Not a variable name":
>
> - `max_layer_z` in `layer_change_gcode`.
> - `layer_num`, `layer_z` and `max_layer_z` in filament start G-code run by the Type 1 prime tower, and `max_layer_z` and `filament_extruder_id` in its filament end G-code.
> - `layer_z` and `max_layer_z` in the first filament start G-code on Bambu Lab printers.
> - The [Layer Change G-code](#layer-change-g-code) placeholders on the brim layers of belt printers.
> - The timelapse placeholders other than the layer placeholders, except on Bambu Lab printers, printers with several extruders, and bed slingers outside spiral vase mode.

### Layer Placeholders

These placeholders are available in before layer change, layer change, timelapse, clumping detection, change filament, filament start, filament end and printer end G-code.

| Placeholder | Type | Description |
| --- | --- | --- |
| `layer_num` | int | Current layer, counting from 0. `-1` before the first layer, for example in the call of `change_filament_gcode` at print start. `before_layer_change_gcode` and `layer_change_gcode` get the same number, for the layer that is about to print. |
| `layer_z` | float (mm) | Height of the top of the current layer. In filament start, filament end and printer end G-code, the current height of the nozzle. With the Type 1 prime tower, filament start and end G-code get the height of the prime tower layer instead. |
| `max_layer_z` | float (mm) | Height of the highest layer printed so far. |

### Filament Start and End G-code

| Placeholder | Type | Description |
| --- | --- | --- |
| `filament_extruder_id` | int | In `filament_start_gcode`, the filament that is loaded. In `filament_end_gcode`, the filament that is unloaded. At a tool change without the Type 1 prime tower, `filament_end_gcode` gets the extruder of that filament instead. Not set in `change_filament_gcode`. |
| `current_filament_id`<br>`current_nozzle_id` | int (filament index)<br>int (nozzle index) | *Added in 2.5.0.* Filament and nozzle that the G-code runs for. Set for most calls, including calls from the Type 1 prime tower. |
| `retraction_distance_when_cut`<br>`long_retraction_when_cut` | float (mm)<br>bool | In `filament_start_gcode`, the values for the filament that is loaded. See [Filaments, Extruders and Nozzles](#filaments-extruders-and-nozzles). |

The filament start G-code for the first filament runs before the first layer, so `layer_num` is `-1` there. On Bambu Lab printers, this filament start G-code runs right after the printer start G-code, for the first filament that is not a support filament.

At the end of the print, `filament_end_gcode` runs once for each filament in the filament list, and then `machine_end_gcode` runs. With single extruder multi-material, it runs only for the current filament. `machine_end_gcode` gets the `filament_extruder_id`, `current_filament_id`, `current_extruder_id` and `current_nozzle_id` of the last of those calls. This is not always the filament that printed last.

### Layer Change G-code

`layer_change_gcode` also has these placeholders:

| Placeholder | Type | Description |
| --- | --- | --- |
| `current_filament_id`<br>`current_nozzle_id` | int (filament index)<br>int (nozzle index) | *Added in 2.5.0.* Filament and nozzle printing when the layer starts. |
| `most_used_physical_extruder_id` | int | Physical extruder that is used on the most layers of the print. It has the same value on every layer. |
| `previous_layer_mass`<br>`curr_accumulated_mass` | float (g) | *Added in 2.5.0.* Weight of the previous layer, and weight of everything printed so far. For printers that limit the Y acceleration by the weight on the bed. With a prime tower, the weight includes the filament of the whole prime tower. `curr_layer_mass` holds the same value as `previous_layer_mass` under the name Bambu Studio uses. |
| `curr_y_acceleration_limit` | float (mm/s²) | *Added in 2.5.0.* Y acceleration allowed for that weight. |

### Timelapse and Clumping Detection G-code

| Placeholder | Type | Description |
| --- | --- | --- |
| `most_used_physical_extruder_id` | int | Physical extruder that is used on the most layers of the print. Available in `time_lapse_gcode` and `wrapping_detection_gcode`. |
| `curr_physical_extruder_id` | int | Physical extruder that is active when the G-code runs. Available in `time_lapse_gcode` and `wrapping_detection_gcode`. |
| `timelapse_pos_x`<br>`timelapse_pos_y` | int (mm) | X and Y position chosen for the snapshot, rounded to whole millimeters. Only in `time_lapse_gcode`. |
| `has_timelapse_safe_pos` | bool | `true` when a safe snapshot position was found. Only in `time_lapse_gcode`. |
| `timelapse_inline_photo` | bool | *Added in 2.5.0.* `true` when the snapshot is taken without moving to a chosen position. Only in `time_lapse_gcode`. |
| `farthest_point_timelapse_enabled` | bool | *Added in 2.5.0.* `true` when the farthest-point timelapse is on for this layer. Only in `time_lapse_gcode`. |
| `clear_to_x0` | bool | *Added in 2.5.0.* `true` when the nozzle can travel to X = 0 without crossing the print. Only in `time_lapse_gcode`. |

### Change Filament G-code

These placeholders are set in `change_filament_gcode`.

On most printers that are not Bambu Lab printers, `change_filament_gcode` also runs once at the start of the print, when the first filament is selected. This call does not happen on Bambu Lab printers or when the print uses only the first filament. In that call, `layer_num` is `-1` and `toolchange_count` is `1`. `previous_extruder`, `current_filament_id` and `current_hotend` are `-1`, unless the printer start G-code selects a tool with a `T` command. To skip that call, test `layer_num >= 0`.

With *Enable tower interface features* turned on, a tool change at a prime tower interface layer uses the interface print temperature for the incoming filament. In `change_filament_gcode`, `new_filament_temp` and the incoming filament's value in `temperature[]` and `first_layer_temperature[]` are that temperature. With the Type 2 prime tower, the same is true for `nozzle_temperature[]` and `nozzle_temperature_initial_layer[]`, and for these values in `filament_start_gcode`.

| Placeholder | Type | Description |
| --- | --- | --- |
| `previous_extruder`<br>`next_extruder` | int (filament index) | Filament that is unloaded, and filament that is loaded. |
| `current_filament_id`<br>`next_filament_id` | int (filament index) | *Added in 2.5.0.* The same values as `previous_extruder` / `next_extruder`. |
| `current_hotend`<br>`next_hotend` | int | *Added in 2.4.0.* On most printers, the outgoing and incoming extruder. On Bambu Lab printers, the hotend-rack nozzle when the print moves filaments between nozzles, and `-1` otherwise. |
| `current_nozzle_id`<br>`next_nozzle_id` | int (nozzle index) | *Added in 2.5.0.* Outgoing and incoming nozzle. |
| `old_extruder_variant`<br>`new_extruder_variant` | string | *Added in 2.5.0.* Extruder variant of the outgoing and incoming extruder, for example `Direct Drive Standard`. |
| `toolchange_z` | float (mm) | Print height of the layer where the change happens. With the Type 1 prime tower, the height of the prime tower layer. It does not include the Z-hop. |
| `outer_wall_volumetric_speed` | float (mm³/s) | Outer wall volumetric speed of the new filament, limited to its maximum volumetric speed. |
| `relative_e_axis` | bool | `true` when OrcaSlicer uses relative E distances. |
| `toolchange_count` | int | Number of tool changes so far, including this one. When `change_filament_gcode` runs at print start, that call counts as `1`, so the first real change is `2` and the last one is `total_toolchanges + 1`. Without that call, for example on Bambu Lab printers, the first real change is `1`. |
| `fan_speed` | int | Old placeholder, kept so that old G-code still works. Always `0`. |
| `filament_retract_length_nc` | float (mm) | *Added in 2.5.0.* Nozzle-change retraction length of the outgoing filament, or `0` if there is none. |
| `new_extruder_retracted_length` | float (mm) | *Added in 2.5.0.* How far the filament in the incoming extruder is retracted now. |
| `old_retract_length`<br>`new_retract_length` | float (mm) | Retraction length of the outgoing and incoming filament. |
| `old_retract_length_toolchange`<br>`new_retract_length_toolchange` | float (mm) | Tool change retraction length of the outgoing and incoming filament. |
| `old_filament_temp`<br>`new_filament_temp` | int (°C) | Nozzle temperature of the outgoing and incoming filament. |
| `old_filament_e_feedrate`<br>`new_filament_e_feedrate` | int (mm/min) | Extrusion feedrate of the outgoing and incoming filament, from its volumetric speed limit. |
| `x_after_toolchange`<br>`y_after_toolchange`<br>`z_after_toolchange` | float (mm) | The nozzle position before the change, or the start point on the Type 1 prime tower. Changing them has no effect. To tell OrcaSlicer that the nozzle moved, update `position[]`. |
| `first_flush_volume`<br>`second_flush_volume` | float (mm of filament) | First and second half of the planned purge length. |
| `flush_length` | float (mm of filament) | Total purge length for the tool change. |
| `flush_length_1` … `flush_length_4` | float (mm of filament) | Parts of the purge. Unused parts are `0`. |
| `wipe_avoid_perimeter` | bool | `true` when the travel avoids the prime tower for this change. Only set by the Type 1 prime tower, and `false` otherwise. |
| `wipe_avoid_pos_x` | float (mm) | X position of the line that the travel avoids around the prime tower. Only used by the Type 1 prime tower. |
| `is_prime_tower_interface` | bool | With the Type 1 prime tower, `true` when this change prints a prime tower interface layer. |
| `filament_tower_interface_purge_volume`<br>`filament_tower_interface_print_temp` | float (mm of filament)<br>int (°C) | Interface purge length and interface print temperature of the new filament. |
| `filament_cooling_before_tower[]` | float per filament (°C) | *Added in 2.4.0.* How much the temperature drops before the nozzle enters the prime tower. Only set by the Type 1 prime tower, and `0` on the first layer and on interface layers. |
| `wipe_tower_wait_pos_x`<br>`wipe_tower_wait_pos_y`<br>`wipe_tower_wait_pos_valid` | float (mm)<br>float (mm)<br>bool | *Added in 2.5.0.* The same point as in [Dimensions](#dimensions). With the Type 1 prime tower, the point is next to where this tool change starts. Bambu Studio's names, `wipe_tower_center_pos_x`, `wipe_tower_center_pos_y` and `wipe_tower_center_pos_valid`, hold the same values. |
| `travel_point_1_x`<br>`travel_point_1_y` | float (mm) | First point of the travel path that the Bambu Lab filament cutter uses. Fixed default values on other printers. |
| `travel_point_2_x`<br>`travel_point_2_y` | float (mm) | Second point of that travel path. |
| `travel_point_3_x`<br>`travel_point_3_y` | float (mm) | Third point of that travel path. |

### Change Extrusion Role G-code

These placeholders are available in `change_extrusion_role_gcode`, `filament_change_extrusion_role_gcode` and `process_change_extrusion_role_gcode`.

| Placeholder | Type | Description |
| --- | --- | --- |
| `extrusion_role` | string | The [extrusion role](#extrusion-roles) that OrcaSlicer is about to print, for example `Perimeter`. |
| `last_extrusion_role` | string | The previous [extrusion role](#extrusion-roles). |
| `layer_num` | int | Current layer, counting from **1** in this G-code. |
| `layer_z` | float (mm) | Height of the current layer. |

### Extrusion Roles

`extrusion_role` and `last_extrusion_role` have one of these values. Compare them as text, for example `{if extrusion_role == "Perimeter"}...{endif}`.

| Value | Description |
| --- | --- |
| `Perimeter` | Inner wall. |
| `ExternalPerimeter` | Outer wall. |
| `OverhangPerimeter` | Overhang wall. |
| `InternalInfill` | Sparse infill. |
| `SolidInfill` | Internal solid infill. |
| `TopSolidInfill` | Top surface. |
| `BottomSurface` | Bottom surface. |
| `Ironing` | Ironing. |
| `BridgeInfill` | Bridge, including internal bridges. |
| `GapFill` | Gap infill. |
| `Skirt` | Skirt. |
| `Brim` | Brim. |
| `SupportMaterial` | Support. |
| `SupportMaterialInterface` | Support interface. |
| `SupportTransition` | Support transition. |
| `WipeTower` | Prime tower. |
| `Mixed` | Several roles, or any other role. |

## File Name Template

The file name template, `filename_format`, has its own set of placeholders. It can use all settings, and the placeholders marked *Also works in the file name* in the tables above. Any other placeholder makes the file name fail with "Processing of the filename_format template failed."

In the file name:

- Print statistics are always the final values. If the name is needed before the G-code exists, OrcaSlicer fills them in after export.
- `extruded_volume`, `extruded_volume_total` and `extruded_weight_total` are totals for the whole print. `extruded_volume` is one value, not a list.
- `extruded_volume_total`, `extruded_weight_total` and `initial_extruder` work since 2.4.0, and `initial_no_support_extruder` works since 2.5.0.

These placeholders work only in the file name:

| Placeholder | Type | Description |
| --- | --- | --- |
| `filament_name` | string | *Added in 2.4.0.* Preset name of the lowest-numbered filament that the plate uses, cut at `@`. |
| `num_filaments` | int | Number of extruders. It is the same as `num_extruders`. |

## Examples

### Start Macro with Temperatures

In the printer start G-code, pass the first-layer temperatures to a Klipper macro. `first_layer_temperature[]` has one value per filament, so the index `initial_extruder` picks the filament that prints first.

```gcode
PRINT_START BED={bed_temperature_initial_layer_single} EXTRUDER={first_layer_temperature[initial_extruder]}
```

### Layer Progress

In the layer change G-code, show the layer on the printer screen. `layer_num` counts from 0, so add 1.

```gcode
M117 Layer {layer_num + 1} of {total_layer_count}
```

### Real Tool Changes Only

In the change filament G-code, skip the call at print start. `layer_num` is `-1` before the first layer.

```gcode
{if layer_num >= 0}
; From filament {previous_extruder + 1} to filament {next_extruder + 1}
M109 S{new_filament_temp}
{endif}
```

### Settings for One Extrusion Role

In the change extrusion role G-code, use a lower acceleration for outer walls.

```gcode
{if extrusion_role == "ExternalPerimeter"}
M204 S1000
{else}
M204 S3000
{endif}
```

### Value from a Table

Choose a purge length from the nozzle diameter, and store it in a variable. This example uses relative E distances.

```gcode
{local purge = interpolate_table(nozzle_diameter[0], (0.2, 10), (0.4, 20), (0.8, 40))}
G1 E{purge} F300
```

### Print Summary in the File Header

In the file header G-code, write the print time and the filament use. This works only in [nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds), see [Print Statistics](#print-statistics).

```gcode
; Print time: {print_time}
; Filament: {used_filament} m, {total_weight} g
```

### File Name

This is the default file name template. To add the plate number, add `_plate{plate_number}` before `.gcode`.

```text
{input_filename_base}_{filament_type[initial_tool]}_{print_time}.gcode
```
