# Placeholders Variables

OrcaSlicer fills in placeholders when it expands custom G-code and the file name template. Every print, filament and printer setting is a placeholder, under its config key. This page lists the other placeholders, which OrcaSlicer sets while it slices. To find the key of a setting, hover its label in the UI, or read the *Variable* line in the setting's wiki description.

![variable_name](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/variable_name.png?raw=true)

- [Reading the tables](#reading-the-tables)
- [Expressions and functions](#expressions-and-functions)
- [Global Slicing State](#global-slicing-state)
    - [Read Only](#read-only)
    - [Read Write](#read-write)
- [Slicing State](#slicing-state)
- [Print Statistics](#print-statistics)
- [Objects](#objects)
- [Plates](#plates)
- [Dimensions](#dimensions)
- [Temperatures](#temperatures)
- [Timestamps](#timestamps)
- [Environment](#environment)
- [Preset Metadata](#preset-metadata)
- [Filename Templates](#filename-templates)
- [Custom G-code Contexts](#custom-g-code-contexts)
    - [Layer-aware placeholders](#layer-aware-placeholders)
    - [Toolchange and wipe tower placeholders](#toolchange-and-wipe-tower-placeholders)
    - [Filament start/end placeholders](#filament-startend-placeholders)
    - [Timelapse and wrapping detection](#timelapse-and-wrapping-detection)
    - [Extrusion roles](#extrusion-roles)
    - [Extrusion role changes](#extrusion-role-changes)
    - [Pause / color change helpers](#pause--color-change-helpers)

## Reading the tables

- The **Type** column gives the unit of each value, for example `float (mm)`. Counts, text and booleans have no unit.
- `[]` after a name marks a list, for example one value per filament. See [Expressions and functions](#expressions-and-functions) for how to pick one value.
- For a filament, extruder or nozzle index, the Type column says which of the three it is. Many older names say *extruder* for a filament, for example `current_extruder`, `previous_extruder` and `is_extruder_used`, so check the Type column.
    - **Filament index**: the position in the filament list, starting at 0.
    - **Extruder index**: the physical extruder or toolhead, starting at 0, as in `current_extruder_id`. `filament_map[]` gives the extruder of each filament.
    - **Nozzle index**: the nozzle, which equals the extruder number unless the printer has several nozzles per extruder.

## Expressions and functions

Inside `{ }`, OrcaSlicer evaluates a small expression language. Parentheses group sub-expressions. Placeholder names are case sensitive.

The following operators are available:

- Arithmetic `+`, `-`, `*`, `/`, `%` (modulo). For example `{filament_diameter[0] / 2}` is the radius of the first filament.
- Comparison `==`, `!=`, `<`, `>`, `<=`, `>=`, producing a boolean.
- Logical `and` / `&&`, `or` / `||`, `not` / `!`.
- Ternary `condition ? a : b`.
- String concatenation with `+`, for example `{"v" + layer_num}`.
- Regular-expression match `text =~ /pattern/` (true when `text` matches) and its negation `!~`, for example `{if printer_notes =~ /.*BAMBU.*/}bambu{endif}`.

The following functions are available:

| Function | Description |
| --- | --- |
| `int(x)` | Truncate toward zero. `{int(13.9)}` is `13`. |
| `round(x)`, `floor(x)`, `ceil(x)` | Nearest, lower, or higher integer. |
| `min(a, b)`, `max(a, b)` | Smaller or larger of two numbers. |
| `digits(value, width [, decimals])` | Number right-justified in `width` characters, optionally with a fixed number of decimals. |
| `zdigits(value, width [, decimals])` | Like `digits`, padded with leading zeros. `{zdigits(5, 4)}` is `0005`. |
| `random(a, b)` | A random number between `a` and `b`. |
| `interpolate_table(x, (x0, y0), (x1, y1), ...)` | Piecewise-linear interpolation of `x` through the given points. |
| `one_of(value, a, b, ...)` | True when `value` matches one of the listed entries, which may be `/regex/` patterns. |
| `regex_replace(text, /pattern/, replacement)` | Replace every match of `/pattern/` in `text` with `replacement`, which may reference capture groups (`$1`, `$2`, ...). |
| `size(vec)`, `empty(vec)` | Length of a vector option, and whether it is empty. |

`{if}` / `{elsif}` / `{else}` / `{endif}` choose between blocks of text, for example `{if layer_num == 0}first{else}later{endif}`.

Intermediate values can be stored in variables. `{local name = "part"}{name}` defines one and reuses it. A `{local}` value is scoped to the current template, while a `{global}` value stays available to the other templates evaluated during the same print.

Pick one value of a list with a zero-based index, for example `{nozzle_temperature[1]}`. Inside `{ }`, an integer, boolean or string list without an index fails with "Referencing a vector variable when scalar is expected".

Booleans print as `true`/`false` inside `{ }` and as `1`/`0` in the older `[ ]` syntax.

## Global Slicing State

The toolhead state when a custom G-code block starts.

### Read Only

| Placeholder | Type | Description |
| --- | --- | --- |
| `zhop` | float (mm) | Z-hop height present when the custom block starts. |

### Read Write

| Placeholder | Type | Description |
| --- | --- | --- |
| `position[]` | float[3] (mm) | XYZ position of the tool when the custom block starts. If you move the tool, update this so OrcaSlicer knows where it is. |
| `e_position[]` | float per extruder (mm) | Absolute extruder axis position, used only when the G-code uses absolute E coordinates. |
| `e_retracted[]` | float per extruder (mm) | Retraction state at block entry. Update when you manually retract or unretract so OrcaSlicer can compensate afterwards. |
| `e_restart_extra[]` | float per extruder (mm) | Planned extra priming after the next de-retraction. |

## Slicing State

| Placeholder | Type | Description |
| --- | --- | --- |
| `current_extruder` / `current_filament_id` | int (filament index) | Filament printing now. Both placeholders expose the same value. |
| `current_extruder_id` | int (extruder index) | Extruder printing now. During `change_filament_gcode` it is still the outgoing extruder. |
| `current_nozzle_id` | int (nozzle index) | Nozzle printing now. |
| `current_hotend` | int | Extruder printing now on most printers. On Bambu Lab printers it is the hotend-rack nozzle when the print moves filaments between nozzles, and `-1` otherwise. |
| `current_object_idx` | int | Zero-based index of the object being printed (used by sequential printing). |
| `has_wipe_tower` | bool | `true` when a wipe tower is present in the job. |
| `has_single_extruder_multi_material_priming` | bool | `true` when the single-extruder MMU priming area is in use. |
| `initial_extruder` / `initial_tool` / `initial_filament_id` | int (filament index) | First filament used in the print. All three expose the same value. |
| `initial_nozzle_id` | int (nozzle index) | Nozzle of the first filament. |
| `initial_no_support_extruder` / `initial_no_support_tool` / `initial_no_support_filament_id` | int (filament index) | First filament that is not a support filament. |
| `initial_no_support_hotend` | int | Hotend of that filament, using the same rule as `current_hotend`. |
| `is_extruder_used[]` | bool per filament | Whether each filament is used in the print. |
| `filament_map[]` | int per filament (extruder index + 1) | Extruder each filament prints with, counting from **1**. `filament_map[next_extruder] - 1` is the incoming extruder in `change_filament_gcode`. |
| `first_tools[]` / `first_filaments[]` | int per extruder (filament index) | First filament each extruder prints, or `-1`. Correct on Bambu Lab and IDEX/IQEX printers. On other printers with several extruders the values are currently wrong. |
| `first_non_support_tools[]` / `first_non_support_filaments[]` / `first_non_support_hotend[]` | int per extruder | Same as `first_tools[]`, skipping support filaments, with the same limitation. |
| `num_extruders` | int | Number of physical extruders, regardless of how many the print uses. |
| `nozzle_diameter_at_nozzle_id[]` / `nozzle_volume_types[]` | float (mm) / string per nozzle | Diameter and flow type of each nozzle. Empty on printers without nozzle grouping. |
| `flush_temperatures[]` / `flush_volumetric_speeds[]` | int (°C) / float (mm³/s) per filament | Purge temperature and purge speed of each filament. |
| `retraction_distance_when_cut` | float (mm) | Distance used when cutting filament (AMS / cutter retraction) for the current filament. |
| `long_retraction_when_cut` | bool | `true` when the “long retraction when cut” behavior is enabled for the current filament. |
| `retraction_distance_when_ec` / `long_retraction_when_ec` | float (mm) / bool | The same two values for an extruder change. |
| `in_head_wrap_detect_zone` | bool | `true` if the footprint of the objects on the first layer intersects the head-wrap detection area. |
| `is_all_bbl_filament`, `has_tpu_in_first_layer`, `enable_high_low_temp_mix`, `hold_chamber_temp_for_flat_print`, `max_additional_fan`, `during_print_exhaust_fan_speed_num[]` | various | Values used by the Bambu Lab start G-code. |

## Print Statistics

Most of these values are only known once the whole G-code exists. In custom G-code, OrcaSlicer writes a marker and replaces it with the final value after the G-code is generated. These are marked *filled in after generation* below. Decimal values are written with two decimals.

You can print these values and join them to text, for example `{"Weight: " + total_weight + " g"}`. You cannot calculate with them. Slicing stops with the error "This value is known only after the G-code is generated. It can be printed, but not used in a calculation or a comparison." when you use one of them:

- In arithmetic. This includes `+` with a number or with another of these values, so `{total_weight + 5}` fails.
- In a comparison, a condition such as `{if total_weight > 100}`, or a regular-expression match.
- In a function such as `int()`, `round()`, `min()`, `max()`, `digits()`, `one_of()` or `filament_change()`.

This also applies after you copy the value to a variable or pass it through `regex_replace()`. Text that already contains one of these values works like any other text, so adding a number to it appends the number.

| Placeholder | Type | Description |
| --- | --- | --- |
| `normal_print_time` / `print_time` | string | Estimated print time in normal mode, written like `2d3h15m`, `2h15m`, `5m30s` or `45s`. Times of an hour or more are rounded to the minute. Filled in after generation. |
| `silent_print_time` | string | Estimated print time in silent mode, in the same format. `0s` when the printer has no silent mode. Filled in after generation. |
| `print_time_total_sec` | float (s) | Estimated print time in normal mode, in seconds. Filled in after generation. |
| `print_time_day` / `print_time_hour` / `print_time_minute` / `print_time_sec` | int (d / h / min / s) | The parts of the normal-mode print time. `print_time_sec` is the seconds part, not the total. Filled in after generation. |
| `total_layer_count` | int | Number of sliced layers. |
| `total_toolchanges` | int | Number of filament changes during the print. The tool selected at print start is not counted. With a prime tower this is the tower's count. Without one it is counted from the planned tool order. It is `0` for prints by object without a prime tower. |
| `used_filament` / `used_filament_length` | float (m) | Total filament length used by the print. Filled in after generation. |
| `extruded_volume[]` | float per filament (mm³) | Volume extruded so far with each filament. In custom G-code this is a running total, so it is `0` in the start G-code. |
| `extruded_volume_total` | float (mm³) | Sum of `extruded_volume[]`, also a running total. |
| `extruded_weight[]` | float per filament (g) | Weight extruded so far with each filament (via filament density). A running total. |
| `extruded_weight_total` | float (g) | Sum of `extruded_weight[]`, also a running total. Use `total_weight` for the weight of the whole print. |
| `total_weight` | float (g) | Filament weight of the whole print. Filled in after generation. |
| `total_cost` | float (currency) | Filament cost plus the printer's time cost (`time_cost` per hour of printing). Filled in after generation. |
| `total_wipe_tower_cost` | float (currency) | Filament cost of the wipe tower. Filled in after generation. Currently `0` on Bambu Lab printers, here and in the file name. |
| `total_wipe_tower_filament` | float (mm) | Filament length used on the wipe tower. Filled in after generation. Currently `0` on Bambu Lab printers, here and in the file name. |

## Objects

| Placeholder | Type | Description |
| --- | --- | --- |
| `num_objects` | int | Number of distinct objects on the plate. |
| `num_instances` | int | Count of all printed instances across every object. |
| `scale[]` | string per object | Human-readable scale applied to each object (zero-based object index), for example `x:100% y:50% z:100%`. |
| `input_filename_base` | string | Name of the first printable object (or its source file name if it has none), without the extension. In `filename_format` for a saved project, the project name. |
| `input_filename` | string | `input_filename_base` followed by `.gcode`. |
| `first_object_name` | string | Name of the first printable object on the plate. |

## Plates

| Placeholder | Type | Description |
| --- | --- | --- |
| `plate_name` | string | Name of the active plate. |
| `plate_number` | string | Number of the plate, counting from 1 and padded to two digits, for example `01`. |
| `model_name` | string | Model name stored in the 3MF project, or empty. |
| `imex_mode` | string | Name of the plate's [IDEX/IQEX](printer_multimaterial_idex_iqex) parallel mode, or `primary` in Primary mode. Empty when the printer is not an IDEX/IQEX printer. |
| `imex_mode_index` | int | Zero-based index of that mode in the printer's `imex_mode_names`, which is its row in the [Modes](printer_multimaterial_idex_iqex#modes) grid. `0` is Primary. |
| `imex_mode_gcode` | string | That mode's [Mode G-code](printer_multimaterial_idex_iqex#mode-g-code), before its placeholders are expanded. |

## Dimensions

| Placeholder | Type | Description |
| --- | --- | --- |
| `first_layer_print_convex_hull` | array of `[x, y]` pairs (mm) | Polygon describing the convex hull of the first layer. |
| `first_layer_print_min` | float[2] (mm) | Bottom-left corner of the first-layer bounding box. |
| `first_layer_print_max` | float[2] (mm) | Top-right corner of the first-layer bounding box. |
| `first_layer_print_size` | float[2] (mm) | Width and depth of the first-layer bounding box. |
| `first_layer_center_no_wipe_tower` | float[2] (mm) | Center of the first layer excluding the wipe tower footprint. |
| `first_layer_height` | float (mm) | Height of the first printed layer. |
| `print_bed_min` | float[2] (mm) | Bed bounding box minimum (bottom-left corner). |
| `print_bed_max` | float[2] (mm) | Bed bounding box maximum (top-right corner). |
| `print_bed_size` | float[2] (mm) | Width and depth of the printable area. |
| `max_print_z` | int (mm) | Height of the tallest object, rounded up. |
| `max_print_height` | int (mm) | The printer's printable height. |
| `adaptive_bed_mesh_min` / `adaptive_bed_mesh_max` | float[2] (mm) | Corners of the area to probe, see [Adaptive Bed Mesh](printer_basic_information_adaptive_bed_mesh#available-g-code-variables-for-adaptive-bed-mesh-command). |
| `bed_mesh_probe_count` / `bed_mesh_algo` | int[2] / string | Probe grid size and interpolation algorithm for that area. |
| `wipe_tower_center_pos_x` / `wipe_tower_center_pos_y` | float (mm) | A point just outside the wipe tower where the nozzle can wait while it heats. |
| `wipe_tower_center_pos_valid` | bool | `true` when the print has a wipe tower and the point above is set. |

## Temperatures

| Placeholder | Type | Description |
| --- | --- | --- |
| `bed_temperature[]` | int per filament (°C) | Bed temperature of each filament for the current plate type. |
| `bed_temperature_initial_layer[]` / `first_layer_bed_temperature[]` | int per filament (°C) | Initial-layer bed temperatures for the current plate type. |
| `bed_temperature_initial_layer_single` | int (°C) | Initial-layer bed temperature of the first filament. When the bed temperature formula is set to the highest temperature, it is the highest initial-layer bed temperature of the filaments used. |
| `first_layer_temperature[]` | int per filament (°C) | Initial-layer nozzle temperatures. |
| `chamber_temperature[]` | int per filament (°C) | Chamber set-point requested for each filament. |
| `chamber_minimal_temperature[]` | int per filament (°C) | Minimum chamber temperature of each filament. |
| `overall_chamber_temperature` | int (°C) | Maximum of `chamber_temperature[]` across the filaments used in the job. |
| `min_vitrification_temperature` | int (°C) | Lowest softening temperature among the filaments used. |

## Timestamps

| Placeholder | Type | Description |
| --- | --- | --- |
| `timestamp` | string (`yyyyMMdd-hhmmss`) | Local time when G-code export started. In `filename_format`, the time the file name is built. |
| `year` / month / day | int | Gregorian date components of `timestamp`. |
| `hour` / minute / second | int | Time-of-day components of `timestamp`. |

## Environment

| Placeholder | Type | Description |
| --- | --- | --- |
| `user` | string | Username resolved from `USER`/`USERNAME` environment variables (falls back to `unknown`). |
| `version` | string | OrcaSlicer version string. |

## Preset Metadata

| Placeholder | Type | Description |
| --- | --- | --- |
| `print_preset` | string | Name of the active print preset. |
| `filament_preset[]` | string per extruder | Preset name for each filament slot. Use `[idx]` to target a specific extruder. |
| `filament_type[]` | string per extruder | Material type label reported by each filament preset (PLA, PETG, ABS, etc.). |
| `printer_preset` | string | Logical printer preset used for slicing. |

## Filename Templates

The file name is built with its own set of placeholders, separate from the one custom G-code uses. Print statistics in the file name are always the final values. If the name is needed before the G-code exists, OrcaSlicer fills them in after export.

These placeholders can be used in `filename_format`:

- Configuration keys from the active print/filament/printer presets, including `print_preset`, `filament_preset[]`, `printer_preset`, and every regular setting (line widths, temperatures, etc.).
- Object and plate metadata: `input_filename`, `input_filename_base`, `first_object_name`, `num_objects`, `num_instances`, `scale[]`, `plate_name`, `plate_number`, `model_name`, plus the timestamp, `user` and `version` placeholders.
- `filament_name` (the preset name of the first filament used, cut at `@`), `num_extruders`, `num_filaments`, `initial_tool`, `initial_extruder` and `initial_no_support_extruder`.
- Print statistics: `print_time`, `normal_print_time`, `silent_print_time`, `used_filament`, `total_cost`, `total_toolchanges`, `total_weight`, `total_wipe_tower_cost`, `total_wipe_tower_filament`, `extruded_volume_total` and `extruded_weight_total`. Here `extruded_weight_total` equals `total_weight`, and `extruded_volume` is the total volume, not a list.

Placeholders that OrcaSlicer sets while it generates G-code are **not** available inside `filename_format`, and using one makes the file name fail. That covers everything else in this page that is not a configuration setting:

- *Global Slicing State* and *Custom G-code Contexts*.
- *Slicing State* and *Dimensions*, apart from the few listed above.
- Temperature values that are not settings themselves, such as `bed_temperature_initial_layer_single` and `overall_chamber_temperature`.
- `total_layer_count`, `print_time_total_sec`, `print_time_day`, `print_time_hour`, `print_time_minute`, `print_time_sec` and `used_filament_length`.

## Custom G-code Contexts

The placeholders in this section are set only in the custom G-code listed with each table, in addition to the ones above.

### Layer-aware placeholders

| Placeholder | Type | Description |
| --- | --- | --- |
| `layer_num` | int | Current layer, counting from 0. `before_layer_change_gcode` and `layer_change_gcode` get the same number for the layer about to print. `-1` before the first layer, for example in the print-start call of `change_filament_gcode`. Provided to `before_layer_change_gcode`, `layer_change_gcode`, `time_lapse_gcode`, `wrapping_detection_gcode`, `change_filament_gcode`, `filament_start_gcode`, `filament_end_gcode`, and `machine_end_gcode`. |
| `layer_z` | float (mm) | Height of the top of the current layer. In filament start/end and machine end G-code, the nozzle's current height. Available in the same contexts as `layer_num`. |
| `max_layer_z` | float (mm) | Highest layer printed so far. Available in the same contexts as `layer_num`. |
| `filament_extruder_id` | int | In `filament_start_gcode`, the filament being loaded. In `filament_end_gcode`, the filament being unloaded, except at a tool change without the Bambu-style (Type 1) prime tower, where it is the extruder of that filament. Not set in `change_filament_gcode`. |

`layer_change_gcode` also receives the following:

| Placeholder | Type | Description |
| --- | --- | --- |
| `current_filament_id` / `current_nozzle_id` | int (filament / nozzle index) | Filament and nozzle printing when the layer starts. |
| `most_used_physical_extruder_id` | int | Physical extruder that prints most of the layer. |
| `curr_layer_mass` / `curr_accumulated_mass` | float (g) | Weight of the previous layer and of everything printed so far, for printers that limit Y acceleration by the weight on the bed. |
| `curr_y_acceleration_limit` | float (mm/s²) | Y acceleration allowed for that weight. |

### Toolchange and wipe tower placeholders

These placeholders are set in `change_filament_gcode`.

`change_filament_gcode` also runs once at the start of the print, when the first filament is selected. In that call `previous_extruder`, `current_filament_id` and `current_hotend` are `-1`, `layer_num` is `-1`, and `toolchange_count` is `1`. Test `toolchange_count > 1` to skip it.

| Placeholder | Type | Description |
| --- | --- | --- |
| `previous_extruder` / `next_extruder` | int (filament index) | Filament being unloaded and filament being loaded. |
| `current_filament_id` / `next_filament_id` | int (filament index) | Same values as `previous_extruder` / `next_extruder`. |
| `current_hotend` / `next_hotend` | int | Outgoing and incoming extruder on most printers. On Bambu Lab printers, the hotend-rack nozzle when the print moves filaments between nozzles, and `-1` otherwise. |
| `current_nozzle_id` / `next_nozzle_id` | int (nozzle index) | Outgoing and incoming nozzle. |
| `old_extruder_variant` / `new_extruder_variant` | string | Extruder variant of the outgoing and incoming extruder, for example `Direct Drive Standard`. |
| `toolchange_z` | float (mm) | Z height when the toolchange G-code starts. |
| `outer_wall_volumetric_speed` | float (mm³/s) | Volumetric speed of outer walls for the new filament, capped at its maximum volumetric speed. |
| `relative_e_axis` | bool | `true` when OrcaSlicer writes relative E moves. |
| `toolchange_count` | int | Running count of tool changes, where the print-start selection counts as `1`. The first real change reads `2`, and the last one reads `total_toolchanges + 1`. |
| `fan_speed` | int | Legacy placeholder kept for compatibility (always `0`). |
| `filament_retract_length_nc` | float (mm) | Nozzle-change retraction length of the outgoing filament, `0` if there is none. |
| `new_extruder_retracted_length` | float (mm) | How far the filament in the incoming extruder is currently retracted. |
| `old_retract_length` / `new_retract_length` | float (mm) | Retraction distance for the outgoing and incoming filaments. |
| `old_retract_length_toolchange` / `new_retract_length_toolchange` | float (mm) | Toolchange-specific retraction distances for each filament. |
| `old_filament_temp` / `new_filament_temp` | int (°C) | Requested nozzle temperatures before and after the toolchange. |
| `old_filament_e_feedrate` / `new_filament_e_feedrate` | int (mm/min) | Extrusion feedrates derived from volumetric limits for the old/new filaments. |
| `x_after_toolchange` / `y_after_toolchange` / `z_after_toolchange` | float (mm) | The nozzle position before the change, or the prime tower start point on the Type 1 prime tower. They are for information only, and changing them has no effect. To tell OrcaSlicer the nozzle moved, update `position[]`. |
| `first_flush_volume` / `second_flush_volume` | float (mm of filament) | Each half of the planned purge length. |
| `flush_length` | float (mm of filament) | Total purge length requested for the toolchange. |
| `flush_length_1` … `flush_length_4` | float (mm of filament) | Individual purge segments (unused entries are `0`). |
| `flush_volumetric_speeds[]` | float per filament (mm³/s) | Purge speed of each filament. Also available in every custom G-code. |
| `flush_temperatures[]` | int per filament (°C) | Purge temperature of each filament. Also available in every custom G-code. |
| `wipe_avoid_perimeter` | bool | `true` when wipe tower travel avoidance is active for the change. Only set by the Type 1 prime tower, and always `false` otherwise. |
| `wipe_avoid_pos_x` | float (mm) | X coordinate of the avoidance barrier used around the wipe tower. Only meaningful with the Type 1 prime tower. |
| `is_prime_tower_interface` | bool | `true` when this change prints a prime tower interface layer (Type 1 prime tower). |
| `filament_tower_interface_purge_volume` / `filament_tower_interface_print_temp` | float (mm) / int (°C) | Interface purge length and print temperature of the new filament. |
| `filament_cooling_before_tower[]` | float per filament (°C) | Temperature drop before entering the prime tower. Only set by the Type 1 prime tower, and `0` on the first layer and on interface layers. |
| `wipe_tower_center_pos_x` / `wipe_tower_center_pos_y` / `wipe_tower_center_pos_valid` | float (mm) / bool | With the Type 1 prime tower, the point next to the tower where the nozzle waits while it heats. |
| `travel_point_1_x` / `travel_point_1_y` | float (mm) | First intermediate XY travel waypoint, used by the Bambu Lab filament cutter. Fixed default values on other printers. |
| `travel_point_2_x` / `travel_point_2_y` | float (mm) | Second intermediate travel waypoint. |
| `travel_point_3_x` / `travel_point_3_y` | float (mm) | Third intermediate travel waypoint. |

### Filament start/end placeholders

| Placeholder | Type | Description |
| --- | --- | --- |
| `filament_extruder_id` | int | The filament in `filament_start_gcode`. In `filament_end_gcode`, the filament or its extruder, see [Layer-aware placeholders](#layer-aware-placeholders). |
| `current_filament_id` / `current_nozzle_id` | int (filament / nozzle index) | Filament and nozzle the script runs for. Set on most paths, including the Type 1 prime tower. |
| `retraction_distance_when_cut` | float (mm) | Cut-retraction distance for the active filament. Provided to `filament_start_gcode` (and as a global placeholder). |
| `long_retraction_when_cut` | bool | Whether the “long retraction when cut” behavior is enabled for the active filament. Provided to `filament_start_gcode` and globally. |

`filament_start_gcode` and `filament_end_gcode` also receive `layer_num`, `layer_z` and `max_layer_z`. The filament start G-code for the first filament runs before the first layer, so `layer_num` is `-1` there.

At the end of the print, `filament_end_gcode` runs once for each filament in the filament list (only for the active filament with single extruder multi-material), and then `machine_end_gcode` runs. `machine_end_gcode` gets the `filament_extruder_id`, `current_filament_id`, `current_extruder_id` and `current_nozzle_id` of the last of those calls, which is not necessarily the filament that printed last.

### Timelapse and wrapping detection

| Placeholder | Type | Description |
| --- | --- | --- |
| `most_used_physical_extruder_id` | int | Physical extruder that prints most of the layer. Supplied to `time_lapse_gcode` and `wrapping_detection_gcode`. |
| `curr_physical_extruder_id` | int | Physical extruder currently active when the macro runs. Provided to the same scripts as above. |
| `timelapse_pos_x` / `timelapse_pos_y` | int (mm) | XY coordinates selected for taking the snapshot, rounded down to whole millimeters. Available only inside `time_lapse_gcode`. |
| `has_timelapse_safe_pos` | bool | `true` when a safe snapshot position was found. Available in `time_lapse_gcode`. |
| `timelapse_inline_photo` | bool | `true` when the snapshot is taken without moving to a picked position. Available in `time_lapse_gcode`. |
| `farthest_point_timelapse_enabled` | bool | `true` when the farthest-point timelapse is active for this layer. Available in `time_lapse_gcode`. |
| `clear_to_x0` | bool | `true` when the nozzle can travel to X = 0 without crossing the print. Available in `time_lapse_gcode`. |

### Extrusion roles

| Placeholder | Type | Description |
| --- | --- | --- |
| `Perimeter` | string | Inner wall. |
| `ExternalPerimeter` | string | Outer wall. |
| `OverhangPerimeter` | string | Overhang wall. |
| `InternalInfill` | string | Sparse infill. |
| `SolidInfill` | string | Internal solid infill. |
| `TopSolidInfill` | string | Top surface. |
| `BottomSurface` | string | Bottom surface. |
| `Ironing` | string | Ironing. |
| `BridgeInfill` | string | Bridge, including internal bridges. |
| `GapFill` | string | Gap infill. |
| `Skirt` | string | Skirt. |
| `Brim` | string | Brim. |
| `SupportMaterial` | string | Support. |
| `SupportMaterialInterface` | string | Support interface. |
| `SupportTransition` | string | Support transition. |
| `WipeTower` | string | Prime tower. |
| `Mixed` | string | Multiple, or any other role. |

### Extrusion role changes

These placeholders are available in `change_extrusion_role_gcode`, `filament_change_extrusion_role_gcode` and `process_change_extrusion_role_gcode`.

| Placeholder | Type | Description |
| --- | --- | --- |
| `extrusion_role` | string | Name of the [extrusion role](#extrusion-roles) that the slicer is about to use (`Perimeter`, `ExternalPerimeter`, `SupportMaterial`, etc.). |
| `last_extrusion_role` | string | Previous [extrusion role](#extrusion-roles) before the transition. |
| `layer_num` | int | Current layer, counting from **1** in these scripts. |
| `layer_z` | float (mm) | Height of the current layer. |

### Pause / color change helpers

`machine_pause_gcode` receives no extra placeholders. An older `color_change_extruder` placeholder is no longer set, and using it fails.
