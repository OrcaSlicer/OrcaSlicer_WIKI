# Placeholders Variables

OrcaSlicer fills in placeholders when it expands custom G-code and the file name template. Every print, filament and printer setting is a placeholder, with its config key as the name. This page lists the other placeholders, which OrcaSlicer sets while it slices. To find the key of a setting, hover over its label in OrcaSlicer, or read the *Variable* line in the setting's wiki page.

![variable_name](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/variable_name.png?raw=true)

- [Placeholders by G-code Field](#placeholders-by-g-code-field)
- [Reading the Tables](#reading-the-tables)
- [Expressions and Functions](#expressions-and-functions)
- [Common Errors](#common-errors)
- [Toolhead Position](#toolhead-position)
- [Slicing State](#slicing-state)
- [Print Statistics](#print-statistics)
- [Objects](#objects)
- [Plates](#plates)
- [Dimensions](#dimensions)
- [Temperatures](#temperatures)
- [Timestamps](#timestamps)
- [Environment](#environment)
- [Presets](#presets)
- [File Name Template](#file-name-template)
- [Placeholders for Specific G-code](#placeholders-for-specific-g-code)
    - [Layer Placeholders](#layer-placeholders)
    - [Layer Change G-code](#layer-change-g-code)
    - [Change Filament G-code](#change-filament-g-code)
    - [Filament Start and End G-code](#filament-start-and-end-g-code)
    - [Timelapse and Clumping Detection G-code](#timelapse-and-clumping-detection-g-code)
    - [Change Extrusion Role G-code](#change-extrusion-role-g-code)
    - [Extrusion Roles](#extrusion-roles)
    - [Pause G-code](#pause-g-code)

## Placeholders by G-code Field

Every custom G-code field can use all settings and the placeholders in [Toolhead Position](#toolhead-position), [Slicing State](#slicing-state), [Print Statistics](#print-statistics), [Objects](#objects), [Plates](#plates), [Dimensions](#dimensions), [Temperatures](#temperatures), [Timestamps](#timestamps), [Environment](#environment) and [Presets](#presets). Some fields also have the extra placeholders in this table. The custom G-code editor in OrcaSlicer shows the same list for each field.

| Field | Key | Extra placeholders |
| --- | --- | --- |
| Start G-code (printer) | `machine_start_gcode` | None |
| File header G-code | `file_start_gcode` | None |
| Between Object G-code | `printing_by_object_gcode` | None |
| Pause G-code | `machine_pause_gcode` | None, see [Pause G-code](#pause-g-code) |
| Custom G-code | `template_custom_gcode` | None |
| Before layer change G-code | `before_layer_change_gcode` | [Layer Placeholders](#layer-placeholders) |
| Layer change G-code | `layer_change_gcode` | [Layer Placeholders](#layer-placeholders) and [Layer Change G-code](#layer-change-g-code) |
| Timelapse G-code | `time_lapse_gcode` | [Layer Placeholders](#layer-placeholders) and [Timelapse and Clumping Detection G-code](#timelapse-and-clumping-detection-g-code) |
| Clumping detection G-code | `wrapping_detection_gcode` | [Layer Placeholders](#layer-placeholders), `most_used_physical_extruder_id` and `curr_physical_extruder_id` |
| Change filament G-code | `change_filament_gcode` | [Layer Placeholders](#layer-placeholders) and [Change Filament G-code](#change-filament-g-code) |
| Change extrusion role G-code | `change_extrusion_role_gcode`, `filament_change_extrusion_role_gcode`, `process_change_extrusion_role_gcode` | [Change Extrusion Role G-code](#change-extrusion-role-g-code) |
| Start G-code (filament) | `filament_start_gcode` | [Layer Placeholders](#layer-placeholders) and [Filament Start and End G-code](#filament-start-and-end-g-code) |
| End G-code (filament) | `filament_end_gcode` | [Layer Placeholders](#layer-placeholders) and [Filament Start and End G-code](#filament-start-and-end-g-code) |
| End G-code (printer) | `machine_end_gcode` | [Layer Placeholders](#layer-placeholders) and the filament values in [Filament Start and End G-code](#filament-start-and-end-g-code) |

The file name template, `filename_format`, uses a different set. See [File Name Template](#file-name-template).

## Reading the Tables

- The **Type** column gives the unit of each value, for example `float (mm)`. Counts, text and booleans have no unit.
- `[]` after a name marks a list, for example a list with one value per filament. To pick one value, see [Expressions and Functions](#expressions-and-functions).
- For a filament, extruder or nozzle index, the Type column says which of the three it is. Many older names say *extruder* when they mean a filament, for example `current_extruder`, `previous_extruder` and `is_extruder_used`. Check the Type column.
    - **Filament index**: the position in the filament list, counting from 0.
    - **Extruder index**: the physical extruder or toolhead, counting from 0, as in `current_extruder_id`. `filament_map[]` gives the extruder of each filament.
    - **Nozzle index**: the nozzle. It is the same as the extruder index unless the printer has several nozzles per extruder.
- **Type 1** and **Type 2** prime tower are the two values of the *Wipe tower type* setting. Type 1 is the Bambu Lab style prime tower.

## Expressions and Functions

Inside `{ }`, OrcaSlicer evaluates a small expression language. Placeholder names are case sensitive. Use parentheses to group parts of an expression.

The following operators are available:

- Arithmetic `+`, `-`, `*`, `/` and `%` (remainder). For example, `{filament_diameter[0] / 2}` is the radius of the first filament.
- Comparison `==`, `!=`, `<`, `>`, `<=` and `>=`. The result is a boolean.
- Logical `and` / `&&`, `or` / `||` and `not` / `!`.
- Conditional `condition ? a : b`, which gives `a` when `condition` is true and `b` when it is false.
- Text joining with `+`, for example `{"v" + layer_num}`.
- Regular-expression match `text =~ /pattern/`, which is true when `text` matches, and `!~`, which is true when it does not match. For example, `{if printer_notes =~ /.*BAMBU.*/}bambu{endif}`.

The following functions are available:

| Function | Description |
| --- | --- |
| `int(x)` | `x` without its decimal part. `{int(13.9)}` is `13`. |
| `round(x)`, `floor(x)`, `ceil(x)` | `x` rounded to the nearest, lower or higher whole number. |
| `min(a, b)`, `max(a, b)` | The smaller or larger of two numbers. |
| `digits(value, width [, decimals])` | `value` aligned right in `width` characters, with an optional fixed number of decimals. |
| `zdigits(value, width [, decimals])` | Like `digits`, but padded with leading zeros. `{zdigits(5, 4)}` is `0005`. |
| `random(a, b)` | A random number between `a` and `b`. |
| `interpolate_table(x, (x0, y0), (x1, y1), ...)` | The `y` value for `x` on the straight lines between the given points. |
| `one_of(value, a, b, ...)` | True when `value` matches one of the listed values. A listed value can be a `/regex/` pattern. |
| `regex_replace(text, /pattern/, replacement)` | `text` with every match of `/pattern/` replaced by `replacement`. The replacement can use capture groups (`$1`, `$2`, ...). |
| `size(list)`, `empty(list)` | The number of values in a list, and whether the list is empty. |

`{if}`, `{elsif}`, `{else}` and `{endif}` choose between blocks of text, for example `{if layer_num == 0}first{else}later{endif}`.

You can store values in variables. `{local name = "part"}{name}` defines a variable and then prints it. A `{local}` variable exists only in the custom G-code where it is defined. A `{global}` variable is also available in the custom G-code that runs later in the same print.

To pick one value from a list, give its index, counting from 0. For example, `{nozzle_temperature[1]}` is the value for the second filament. Inside `{ }`, an integer, boolean or string list without an index fails with "Referencing a vector variable when scalar is expected".

OrcaSlicer also accepts an older syntax, `[name]`, which prints one placeholder and does not support expressions. Booleans print as `true` or `false` inside `{ }`, and as `1` or `0` inside `[ ]`.

## Common Errors

When a placeholder in custom G-code fails, slicing stops. The error message starts with "Failed to generate G-code for invalid custom G-code." and then gives the key of the field and the error.

| Error | Cause |
| --- | --- |
| `Not a variable name` (inside `{ }`) or `Variable does not exist` (inside `[ ]`) | The name is misspelled, the field does not have this placeholder (see [Placeholders by G-code Field](#placeholders-by-g-code-field)), or your version of OrcaSlicer does not have it yet. In `filename_format`, only the placeholders in [File Name Template](#file-name-template) exist. |
| `Referencing a vector variable when scalar is expected` | An integer, boolean or string list is used without an index. Add an index, for example `{nozzle_temperature[0]}`. |
| `This value is known only after the G-code is generated. It can be printed, but not used in a calculation or a comparison.` | A value marked *Filled in after generation* is used in a calculation. See [Print Statistics](#print-statistics). |

## Toolhead Position

These values describe the toolhead when a custom G-code starts. Only `zhop` is read-only. If your G-code moves the toolhead, update `position[]`. If it retracts or unretracts, update `e_retracted[]`. OrcaSlicer then continues from the right position.

| Placeholder | Type | Description |
| --- | --- | --- |
| `zhop` | float (mm) | Z-hop height when the custom G-code starts. Read-only. |
| `position[]` | float[3] (mm) | X, Y and Z position of the toolhead when the custom G-code starts. |
| `e_position[]` | float per extruder (mm) | Position of the extruder axis. Used only when the G-code uses absolute E distances. |
| `e_retracted[]` | float per extruder (mm) | How far the filament is retracted when the custom G-code starts. |
| `e_restart_extra[]` | float per extruder (mm) | Extra length to extrude after the next unretraction. |

## Slicing State

| Placeholder | Type | Description |
| --- | --- | --- |
| `current_extruder` / `current_filament_id` | int (filament index) | Filament printing now. Both names give the same value. |
| `current_extruder_id` | int (extruder index) | Extruder printing now. In `change_filament_gcode` it is still the outgoing extruder. |
| `current_nozzle_id` | int (nozzle index) | Nozzle printing now. |
| `current_hotend` | int | On most printers, the extruder printing now. On Bambu Lab printers, the hotend-rack nozzle when the print moves filaments between nozzles, and `-1` otherwise. |
| `current_object_idx` | int | Index of the object printing now, counting from 0. Used when printing by object. |
| `has_wipe_tower` | bool | `true` when the print has a prime tower. |
| `has_single_extruder_multi_material_priming` | bool | `true` when the single-extruder multi-material priming area is used. |
| `initial_extruder` / `initial_tool` / `initial_filament_id` | int (filament index) | First filament used in the print. All three names give the same value. |
| `initial_nozzle_id` | int (nozzle index) | Nozzle of the first filament. |
| `initial_no_support_extruder` / `initial_no_support_tool` / `initial_no_support_filament_id` | int (filament index) | First filament that is not a support filament. |
| `initial_no_support_hotend` | int | Hotend of that filament, with the same rule as `current_hotend`. |
| `is_extruder_used[]` | bool per filament | `true` for each filament that the print uses. |
| `filament_map[]` | int per filament (extruder index + 1) | Extruder of each filament, counting from **1**. In `change_filament_gcode`, `filament_map[next_extruder] - 1` is the incoming extruder. |
| `first_tools[]` / `first_filaments[]` | int per extruder (filament index) | First filament that each extruder prints, or `-1`. Correct on Bambu Lab and IDEX/IQEX printers. On other printers with several extruders, the values are currently wrong. |
| `first_non_support_tools[]` / `first_non_support_filaments[]` / `first_non_support_hotend[]` | int per extruder | Like `first_tools[]`, but without support filaments. The same limitation applies. |
| `num_extruders` | int | Number of physical extruders on the printer, also when the print uses fewer. |
| `nozzle_diameter_at_nozzle_id[]` / `nozzle_volume_types[]` | float (mm) / string per nozzle | Diameter and flow type of each nozzle. Empty on printers without nozzle groups. |
| `flush_temperatures[]` / `flush_volumetric_speeds[]` | int (°C) / float (mm³/s) per filament | Purge temperature and purge speed of each filament. |
| `retraction_distance_when_cut` | float (mm) | Retraction distance when the filament is cut by the AMS or a filament cutter, for the current filament. |
| `long_retraction_when_cut` | bool | `true` when *Long retraction when cut* is on for the current filament. |
| `retraction_distance_when_ec` / `long_retraction_when_ec` | float (mm) / bool | The same two values for an extruder change. |
| `in_head_wrap_detect_zone` | bool | `true` when the first layer of the objects overlaps the head-wrap detection area. |
| `is_all_bbl_filament`, `has_tpu_in_first_layer`, `enable_high_low_temp_mix`, `hold_chamber_temp_for_flat_print`, `max_additional_fan`, `during_print_exhaust_fan_speed_num[]` | various | Values used by the Bambu Lab start G-code. |

## Print Statistics

Most of these values are known only after the whole G-code is generated. In custom G-code, OrcaSlicer first writes a marker, and replaces it with the final value after the G-code is generated. These values are marked *Filled in after generation* below. Decimal values have two decimal places.

You can print these values and join them to text, for example `{"Weight: " + total_weight + " g"}`. You cannot calculate with them. Slicing stops with the error "This value is known only after the G-code is generated. It can be printed, but not used in a calculation or a comparison." when you use one of them:

- In arithmetic. This includes `+` with a number or with another of these values, so `{total_weight + 5}` fails.
- In a comparison, in a condition such as `{if total_weight > 100}`, or in a regular-expression match.
- In a function such as `int()`, `round()`, `min()`, `max()`, `digits()`, `one_of()` or `filament_change()`.

This also applies when you copy the value to a variable or pass it through `regex_replace()`. Text that already contains one of these values works like other text, so `+` with a number adds the number to the end of the text.

| Placeholder | Type | Description |
| --- | --- | --- |
| `normal_print_time` / `print_time` | string | Estimated print time in normal mode, written like `2d3h15m`, `2h15m`, `5m30s` or `45s`. Times of one hour or more are rounded to the minute. Filled in after generation. |
| `silent_print_time` | string | Estimated print time in silent mode, in the same format. `0s` when the printer has no silent mode. Filled in after generation. |
| `print_time_total_sec` | float (s) | Estimated print time in normal mode, in seconds. Filled in after generation. |
| `print_time_day` / `print_time_hour` / `print_time_minute` / `print_time_sec` | int (d / h / min / s) | Days, hours, minutes and seconds of the normal-mode print time. `print_time_sec` is only the seconds, not the total. Filled in after generation. |
| `total_layer_count` | int | Number of layers. |
| `total_toolchanges` | int | Number of filament changes in the print. The filament selected at print start does not count. With a prime tower, this is the prime tower's count. Without one, OrcaSlicer counts the changes in the planned tool order. It is `0` when printing by object without a prime tower. |
| `used_filament` / `used_filament_length` | float (m) | Length of filament that the whole print uses. Filled in after generation. |
| `extruded_volume[]` | float per filament (mm³) | Volume extruded so far with each filament. In custom G-code, this is a running total, so it is `0` in the start G-code. |
| `extruded_volume_total` | float (mm³) | Sum of `extruded_volume[]`. Also a running total. |
| `extruded_weight[]` | float per filament (g) | Weight extruded so far with each filament, from the filament density. Also a running total. |
| `extruded_weight_total` | float (g) | Sum of `extruded_weight[]`. Also a running total. For the weight of the whole print, use `total_weight`. |
| `total_weight` | float (g) | Filament weight of the whole print. Filled in after generation. |
| `total_cost` | float (currency) | Filament cost plus the printer's time cost (`time_cost` per hour of printing). Filled in after generation. |
| `total_wipe_tower_cost` | float (currency) | Filament cost of the prime tower. Filled in after generation. It is currently `0` on Bambu Lab printers, in custom G-code and in the file name. |
| `total_wipe_tower_filament` | float (mm) | Length of filament used for the prime tower. Filled in after generation. It is currently `0` on Bambu Lab printers, in custom G-code and in the file name. |

## Objects

| Placeholder | Type | Description |
| --- | --- | --- |
| `num_objects` | int | Number of objects on the plate. Copies of an object count in `num_instances`. |
| `num_instances` | int | Number of printed instances of all objects. |
| `scale[]` | string per object | Scale of each object as text, for example `x:100% y:50% z:100%`. |
| `input_filename_base` | string | Name of the first printable object, without the extension. If the object has no name, the name of its source file. In `filename_format` for a saved project, the project name. |
| `input_filename` | string | `input_filename_base` followed by `.gcode`. |
| `first_object_name` | string | Name of the first printable object on the plate. |

## Plates

| Placeholder | Type | Description |
| --- | --- | --- |
| `plate_name` | string | Name of the plate. |
| `plate_number` | string | Number of the plate, counting from 1 and padded to two digits, for example `01`. |
| `model_name` | string | Model name saved in the 3MF project, or empty. |
| `imex_mode` | string | Name of the plate's [IDEX/IQEX](printer_multimaterial_idex_iqex) parallel mode, or `primary` in Primary mode. Empty when the printer is not an IDEX/IQEX printer. |
| `imex_mode_index` | int | Index of that mode in the printer's `imex_mode_names`, counting from 0. This is its row in the [Modes](printer_multimaterial_idex_iqex#modes) grid. `0` is Primary. |
| `imex_mode_gcode` | string | The [Mode G-code](printer_multimaterial_idex_iqex#mode-g-code) of that mode, before its placeholders are filled in. |

## Dimensions

| Placeholder | Type | Description |
| --- | --- | --- |
| `first_layer_print_convex_hull` | array of `[x, y]` pairs (mm) | Convex hull of the first layer, as a polygon. |
| `first_layer_print_min` | float[2] (mm) | Smallest X and Y of the first layer. |
| `first_layer_print_max` | float[2] (mm) | Largest X and Y of the first layer. |
| `first_layer_print_size` | float[2] (mm) | Width and depth of the first layer. |
| `first_layer_center_no_wipe_tower` | float[2] (mm) | Center of the first layer, without the prime tower. |
| `first_layer_height` | float (mm) | Height of the first layer. |
| `print_bed_min` | float[2] (mm) | Smallest X and Y of the bed. |
| `print_bed_max` | float[2] (mm) | Largest X and Y of the bed. |
| `print_bed_size` | float[2] (mm) | Width and depth of the bed. |
| `max_print_z` | int (mm) | Height of the tallest object, rounded up. |
| `max_print_height` | int (mm) | Maximum print height of the printer. |
| `adaptive_bed_mesh_min` / `adaptive_bed_mesh_max` | float[2] (mm) | Corners of the area to probe. See [Adaptive Bed Mesh](printer_basic_information_adaptive_bed_mesh#available-g-code-variables-for-adaptive-bed-mesh-command). |
| `bed_mesh_probe_count` / `bed_mesh_algo` | int[2] / string | Number of probe points and interpolation algorithm for that area. |
| `wipe_tower_center_pos_x` / `wipe_tower_center_pos_y` | float (mm) | A point just outside the prime tower, where the nozzle can wait while it heats. |
| `wipe_tower_center_pos_valid` | bool | `true` when the print has a prime tower and the point above is set. |

## Temperatures

| Placeholder | Type | Description |
| --- | --- | --- |
| `bed_temperature[]` | int per filament (°C) | Bed temperature of each filament for the current plate type. |
| `bed_temperature_initial_layer[]` / `first_layer_bed_temperature[]` | int per filament (°C) | First-layer bed temperature of each filament for the current plate type. |
| `bed_temperature_initial_layer_single` | int (°C) | First-layer bed temperature of the first filament. If the bed temperature formula is set to the highest temperature, it is the highest first-layer bed temperature of the filaments used. |
| `first_layer_temperature[]` | int per filament (°C) | First-layer nozzle temperature of each filament. |
| `chamber_temperature[]` | int per filament (°C) | Chamber temperature of each filament. |
| `chamber_minimal_temperature[]` | int per filament (°C) | Minimum chamber temperature of each filament. |
| `overall_chamber_temperature` | int (°C) | Highest `chamber_temperature[]` of the filaments used. |
| `min_vitrification_temperature` | int (°C) | Lowest softening temperature of the filaments used. |

## Timestamps

| Placeholder | Type | Description |
| --- | --- | --- |
| `timestamp` | string (`yyyyMMdd-hhmmss`) | Local time when G-code export started. In `filename_format`, the time when the file name is built. |
| `year` / `month` / `day` | int | Date of `timestamp`. |
| `hour` / `minute` / `second` | int | Time of day of `timestamp`. |

## Environment

| Placeholder | Type | Description |
| --- | --- | --- |
| `user` | string | User name from the `USER` or `USERNAME` environment variable, or `unknown`. |
| `version` | string | OrcaSlicer version. |

## Presets

| Placeholder | Type | Description |
| --- | --- | --- |
| `print_preset` | string | Name of the print preset. |
| `filament_preset[]` | string per filament | Name of the preset of each filament. |
| `filament_type[]` | string per filament | Material type of each filament, for example `PLA` or `PETG`. |
| `printer_preset` | string | Name of the printer preset. |

## File Name Template

The file name has its own set of placeholders, separate from the set that custom G-code uses. In the file name, print statistics are always the final values. If the name is needed before the G-code exists, OrcaSlicer fills them in after export.

These placeholders work in `filename_format`:

- All settings of the active print, filament and printer presets, and `print_preset`, `filament_preset[]` and `printer_preset`.
- Object and plate values: `input_filename`, `input_filename_base`, `first_object_name`, `num_objects`, `num_instances`, `scale[]`, `plate_name`, `plate_number` and `model_name`, the [Timestamps](#timestamps), `user` and `version`.
- `filament_name` (the preset name of the first filament used, cut at `@`), `num_extruders`, `num_filaments`, `initial_tool`, `initial_extruder` and `initial_no_support_extruder`.
- Print statistics: `print_time`, `normal_print_time`, `silent_print_time`, `used_filament`, `total_cost`, `total_toolchanges`, `total_weight`, `total_wipe_tower_cost`, `total_wipe_tower_filament`, `extruded_volume_total` and `extruded_weight_total`. Here `extruded_weight_total` is the same as `total_weight`, and `extruded_volume` is the total volume, not a list.

Placeholders that OrcaSlicer sets while it generates G-code do **not** work in `filename_format`. Using one makes the file name fail. These are all the other placeholders on this page that are not settings:

- [Toolhead Position](#toolhead-position) and [Placeholders for Specific G-code](#placeholders-for-specific-g-code).
- [Slicing State](#slicing-state) and [Dimensions](#dimensions), except the ones listed above.
- Temperatures that are not settings, such as `bed_temperature_initial_layer_single` and `overall_chamber_temperature`.
- `total_layer_count`, `print_time_total_sec`, `print_time_day`, `print_time_hour`, `print_time_minute`, `print_time_sec` and `used_filament_length`.

## Placeholders for Specific G-code

OrcaSlicer sets the placeholders in this section only in the G-code that each section names. [Placeholders by G-code Field](#placeholders-by-g-code-field) lists them by field.

### Layer Placeholders

These placeholders are available in before layer change, layer change, timelapse, clumping detection, change filament, filament start, filament end and printer end G-code.

| Placeholder | Type | Description |
| --- | --- | --- |
| `layer_num` | int | Current layer, counting from 0. `-1` before the first layer, for example in the call of `change_filament_gcode` at print start. `before_layer_change_gcode` and `layer_change_gcode` get the same number, for the layer that is about to print. |
| `layer_z` | float (mm) | Height of the top of the current layer. In filament start, filament end and printer end G-code, the current height of the nozzle. |
| `max_layer_z` | float (mm) | Height of the highest layer printed so far. |

### Layer Change G-code

`layer_change_gcode` also has these placeholders:

| Placeholder | Type | Description |
| --- | --- | --- |
| `current_filament_id` / `current_nozzle_id` | int (filament / nozzle index) | Filament and nozzle printing when the layer starts. |
| `most_used_physical_extruder_id` | int | Physical extruder that prints most of the layer. |
| `curr_layer_mass` / `curr_accumulated_mass` | float (g) | Weight of the previous layer, and weight of everything printed so far. For printers that limit the Y acceleration by the weight on the bed. |
| `curr_y_acceleration_limit` | float (mm/s²) | Y acceleration allowed for that weight. |

### Change Filament G-code

These placeholders are set in `change_filament_gcode`.

`change_filament_gcode` also runs once at the start of the print, when the first filament is selected. In that call, `previous_extruder`, `current_filament_id`, `current_hotend` and `layer_num` are `-1`, and `toolchange_count` is `1`. To skip that call, test `toolchange_count > 1`.

With the Type 2 prime tower and *Enable tower interface features* turned on, a tool change at a tower interface layer changes the temperature of the incoming filament. Its value in `nozzle_temperature[]`, `temperature[]`, `first_layer_temperature[]` and `nozzle_temperature_initial_layer[]` is the interface print temperature. This applies in `change_filament_gcode` and `filament_start_gcode`.

| Placeholder | Type | Description |
| --- | --- | --- |
| `previous_extruder` / `next_extruder` | int (filament index) | Filament that is unloaded, and filament that is loaded. |
| `current_filament_id` / `next_filament_id` | int (filament index) | The same values as `previous_extruder` / `next_extruder`. |
| `current_hotend` / `next_hotend` | int | On most printers, the outgoing and incoming extruder. On Bambu Lab printers, the hotend-rack nozzle when the print moves filaments between nozzles, and `-1` otherwise. |
| `current_nozzle_id` / `next_nozzle_id` | int (nozzle index) | Outgoing and incoming nozzle. |
| `old_extruder_variant` / `new_extruder_variant` | string | Extruder variant of the outgoing and incoming extruder, for example `Direct Drive Standard`. |
| `toolchange_z` | float (mm) | Z height when the change filament G-code starts. |
| `outer_wall_volumetric_speed` | float (mm³/s) | Outer wall volumetric speed of the new filament, limited to its maximum volumetric speed. |
| `relative_e_axis` | bool | `true` when OrcaSlicer uses relative E distances. |
| `toolchange_count` | int | Number of tool changes so far. The selection at print start counts as `1`, so the first real change is `2` and the last one is `total_toolchanges + 1`. |
| `fan_speed` | int | Old placeholder, kept so that old G-code still works. Always `0`. |
| `filament_retract_length_nc` | float (mm) | Nozzle-change retraction length of the outgoing filament, or `0` if there is none. |
| `new_extruder_retracted_length` | float (mm) | How far the filament in the incoming extruder is retracted now. |
| `old_retract_length` / `new_retract_length` | float (mm) | Retraction length of the outgoing and incoming filament. |
| `old_retract_length_toolchange` / `new_retract_length_toolchange` | float (mm) | Tool change retraction length of the outgoing and incoming filament. |
| `old_filament_temp` / `new_filament_temp` | int (°C) | Nozzle temperature of the outgoing and incoming filament. |
| `old_filament_e_feedrate` / `new_filament_e_feedrate` | int (mm/min) | Extrusion feedrate of the outgoing and incoming filament, from its volumetric speed limit. |
| `x_after_toolchange` / `y_after_toolchange` / `z_after_toolchange` | float (mm) | The nozzle position before the change, or the start point on the Type 1 prime tower. Changing them has no effect. To tell OrcaSlicer that the nozzle moved, update `position[]`. |
| `first_flush_volume` / `second_flush_volume` | float (mm of filament) | First and second half of the planned purge length. |
| `flush_length` | float (mm of filament) | Total purge length for the tool change. |
| `flush_length_1` … `flush_length_4` | float (mm of filament) | Parts of the purge. Unused parts are `0`. |
| `wipe_avoid_perimeter` | bool | `true` when the travel avoids the prime tower for this change. Only set by the Type 1 prime tower, and `false` otherwise. |
| `wipe_avoid_pos_x` | float (mm) | X position of the line that the travel avoids around the prime tower. Only used by the Type 1 prime tower. |
| `is_prime_tower_interface` | bool | With the Type 1 prime tower, `true` when this change prints a prime tower interface layer. |
| `filament_tower_interface_purge_volume` / `filament_tower_interface_print_temp` | float (mm of filament) / int (°C) | Interface purge length and interface print temperature of the new filament. |
| `filament_cooling_before_tower[]` | float per filament (°C) | How much the temperature drops before the nozzle enters the prime tower. Only set by the Type 1 prime tower, and `0` on the first layer and on interface layers. |
| `wipe_tower_center_pos_x` / `wipe_tower_center_pos_y` / `wipe_tower_center_pos_valid` | float (mm) / bool | With the Type 1 prime tower, the point next to the tower where the nozzle waits while it heats. |
| `travel_point_1_x` / `travel_point_1_y` | float (mm) | First point of the travel path that the Bambu Lab filament cutter uses. Fixed default values on other printers. |
| `travel_point_2_x` / `travel_point_2_y` | float (mm) | Second point of that travel path. |
| `travel_point_3_x` / `travel_point_3_y` | float (mm) | Third point of that travel path. |

### Filament Start and End G-code

| Placeholder | Type | Description |
| --- | --- | --- |
| `filament_extruder_id` | int | In `filament_start_gcode`, the filament that is loaded. In `filament_end_gcode`, the filament that is unloaded. At a tool change without the Type 1 prime tower, `filament_end_gcode` gets the extruder of that filament instead. Not set in `change_filament_gcode`. |
| `current_filament_id` / `current_nozzle_id` | int (filament / nozzle index) | Filament and nozzle that the G-code runs for. Set for most calls, including calls from the Type 1 prime tower. |
| `retraction_distance_when_cut` / `long_retraction_when_cut` | float (mm) / bool | In `filament_start_gcode`, the values for the filament that is loaded. See [Slicing State](#slicing-state). |

The filament start G-code for the first filament runs before the first layer, so `layer_num` is `-1` there.

At the end of the print, `filament_end_gcode` runs once for each filament in the filament list, and then `machine_end_gcode` runs. With single extruder multi-material, it runs only for the current filament. `machine_end_gcode` gets the `filament_extruder_id`, `current_filament_id`, `current_extruder_id` and `current_nozzle_id` of the last of those calls. This is not always the filament that printed last.

### Timelapse and Clumping Detection G-code

| Placeholder | Type | Description |
| --- | --- | --- |
| `most_used_physical_extruder_id` | int | Physical extruder that prints most of the layer. Available in `time_lapse_gcode` and `wrapping_detection_gcode`. |
| `curr_physical_extruder_id` | int | Physical extruder that is active when the G-code runs. Available in `time_lapse_gcode` and `wrapping_detection_gcode`. |
| `timelapse_pos_x` / `timelapse_pos_y` | int (mm) | X and Y position chosen for the snapshot, rounded down to whole millimeters. Only in `time_lapse_gcode`. |
| `has_timelapse_safe_pos` | bool | `true` when a safe snapshot position was found. Only in `time_lapse_gcode`. |
| `timelapse_inline_photo` | bool | `true` when the snapshot is taken without moving to a chosen position. Only in `time_lapse_gcode`. |
| `farthest_point_timelapse_enabled` | bool | `true` when the farthest-point timelapse is on for this layer. Only in `time_lapse_gcode`. |
| `clear_to_x0` | bool | `true` when the nozzle can travel to X = 0 without crossing the print. Only in `time_lapse_gcode`. |

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

### Pause G-code

`machine_pause_gcode` has no extra placeholders. The old `color_change_extruder` placeholder is no longer set, and using it fails.
