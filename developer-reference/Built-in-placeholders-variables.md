# Placeholders Variables

This page describes the built-in placeholder variables that OrcaSlicer exposes while expanding custom G-code snippets and template expressions.

- [Conventions](#conventions)
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
  - [Extrusion role changes](#extrusion-role-changes)
  - [Pause / color change helpers](#pause--color-change-helpers)

## Conventions

- Placeholder names are case sensitive and follow the same snake_case keys that appear in the UI tooltips and configuration files.
- Brackets (`[]`) mark vector-valued options. Extruder-scoped vectors default to the *currently active* extruder when no index is provided; specify a zero-based index (`bed_temperature[1]`) to query another tool. Object or plate-scoped arrays always require an explicit zero-based index.
- Unless noted otherwise distances are in millimetres, temperatures in °C, volumes in mm³, weights in grams, feedrates in mm/min, and booleans return `0`/`1`.
- Points and bounding boxes are stored as `[x, y]` pairs expressed in mm.
- `layer_num` is one-based (first layer is `1`). All other indices use zero-based numbering.
- Every print/filament/printer setting is also available under its config key (hover the label in the UI to see the key). The tables below focus on the additional runtime placeholders.

## Global Slicing State

Captures the momentary toolhead state whenever OrcaSlicer hands control to a custom G-code block.

### Read Only

| Placeholder | Type | Description |
| --- | --- | --- |
| `zhop` | float (mm) | Z-hop height present when the custom block starts. |

### Read Write

| Placeholder | Type | Description |
| --- | --- | --- |
| `position[]` | float[3] (mm) | XYZ position of the tool when control entered the custom block. Update this if you move the tool so the slicer keeps continuity. |
| `e_position[]` | float per extruder (mm) | Absolute extruder axis position, used only when the G-code uses absolute E coordinates. |
| `e_retracted[]` | float per extruder (mm) | Retraction state at block entry. Update when you manually retract or unretract so OrcaSlicer can compensate afterwards. |
| `e_restart_extra[]` | float per extruder (mm) | Planned extra priming after the next de-retraction. |

## Slicing State

Tracks which extruder, object, and priming helpers are active during the current print.

| Placeholder | Type | Description |
| --- | --- | --- |
| `current_extruder` | int | Zero-based index of the extruder currently emitting G-code. |
| `current_object_idx` | int | Zero-based index of the object being printed (used by sequential printing). |
| `has_wipe_tower` | bool | `true` when a wipe tower is present in the job. |
| `has_single_extruder_multi_material_priming` | bool | Indicates whether the single-extruder MMU priming area is in use. |
| `initial_extruder` / `initial_tool` | int | First extruder used in the print. Both placeholders expose the same value. |
| `initial_no_support_extruder` | int | First extruder that prints without supports (also used for no-support prime). |
| `is_extruder_used[]` | bool per extruder | Reports whether each extruder participates in the job. |
| `num_extruders` | int | Total number of configured extruders, regardless of usage in the current print. |
| `retraction_distance_when_cut` | float (mm) | Distance used when cutting filament (AMS / cutter retraction) for the current extruder. |
| `long_retraction_when_cut` | bool | `true` when the “long retraction when cut” behaviour is enabled for the active extruder. |
| `in_head_wrap_detect_zone` | bool | `true` if the first layer intersects the head-wrap detection area. |

## Print Statistics

Summaries of the sliced job such as time estimates, material usage, and wipe-tower costs.

| Placeholder | Type | Description |
| --- | --- | --- |
| `normal_print_time` / `print_time` | string (`hh:mm:ss`) | Estimated print duration in normal mode. Both placeholders expose the same value. |
| `silent_print_time` | string (`hh:mm:ss`) | Estimated print duration in silent mode. |
| `total_layer_count` | int | Number of sliced layers. |
| `total_toolchanges` | int | Number of planned tool changes (including wipe tower changes). |
| `used_filament` | float (mm) | Total filament length consumed by the entire job. |
| `extruded_volume[]` | float per extruder (mm³) | Volume extruded by each extruder. |
| `extruded_volume_total` | float (mm³) | Sum of `extruded_volume[]`. |
| `extruded_weight[]` | float per extruder (g) | Material weight per extruder (via filament density). |
| `extruded_weight_total` / `total_weight` | float (g) | Sum of `extruded_weight[]`. |
| `total_cost` | float (currency) | Combined material cost computed from filament cost settings. |
| `total_wipe_tower_cost` | float (currency) | Portion of `total_cost` spent on the wipe tower. |
| `total_wipe_tower_filament` | float (mm³) | Total volume extruded on the wipe tower. |

## Objects

Metadata describing the loaded models and their instances.

| Placeholder | Type | Description |
| --- | --- | --- |
| `num_objects` | int | Number of distinct objects on the plate. |
| `num_instances` | int | Count of all printed instances across every object. |
| `scale[]` | string per object | Human-readable scale applied to each object (zero-based object index). Example: `x:100% y:50% z:100%`. |
| `input_filename_base` | string | Source filename of the first imported object without the extension. |
| `input_filename` | string | Full filename (with extension) of the first imported object. |

## Plates

Metadata describing the currently selected plates.

| Placeholder | Type | Description |
| --- | --- | --- |
| `plate_name` | string | Name of the active plate. |

## Dimensions

Geometric measurements of the first layer and printable bed area, useful for positioning macros.

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

## Temperatures

Bed, nozzle, and chamber set-points taken directly from the filament profiles.

| Placeholder | Type | Description |
| --- | --- | --- |
| `bed_temperature[]` | int per extruder (°C) | Bed temperature associated with each extruder/filament. |
| `bed_temperature_initial_layer[]` / `first_layer_bed_temperature[]` | int per extruder (°C) | Initial-layer bed temperatures. |
| `bed_temperature_initial_layer_single` | int (°C) | Initial-layer bed temperature for `initial_extruder`. |
| `first_layer_temperature[]` | int per extruder (°C) | Initial-layer nozzle temperatures. |
| `chamber_temperature[]` | int per extruder (°C) | Chamber set-point requested for each filament. |
| `overall_chamber_temperature` | int (°C) | Maximum of `chamber_temperature[]` across the extruders used in the job. |

## Timestamps

Timestamp components information recorded when slicing began.

| Placeholder | Type | Description |
| --- | --- | --- |
| `timestamp` | string (`yyyyMMdd-hhmmss`) | Local timestamp captured when slicing ran. |
| `year` / month / day | int | Gregorian date components of `timestamp`. |
| `hour` / minute / second | int | Time-of-day components of `timestamp`. |

Any shell environment variable whose name starts with `SLIC3R_` is also imported as a placeholder under the same key, allowing you to pass ad-hoc values into a slice (for example `SLIC3R_BUILD_TAG`).

## Environment

Runtime environment information.

| Placeholder | Type | Description |
| --- | --- | --- |
| `user` | string | Username resolved from `USER`/`USERNAME` environment variables (falls back to `unknown`). |
| `version` | string | OrcaSlicer version string. |

## Preset Metadata

Names of the print, filament, and printer presets that provided the configuration values.

| Placeholder | Type | Description |
| --- | --- | --- |
| `print_preset` | string | Name of the active print preset. |
| `filament_preset[]` | string per extruder | Preset name for each filament slot. Use `[idx]` to target a specific extruder. |
| `filament_type[]` | string per extruder | Material type label reported by each filament preset (PLA, PETG, ABS, etc.). |
| `printer_preset` | string | Logical printer preset used for slicing. |

> [!TIP]
> Others items shares its config key with the placeholder name.  
> Hover the label to discover the key.  
> ![variable_name](https://github.com//OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/variable_name.png?raw=true)

## Filename Templates

Notes about the limited placeholder set that is available when OrcaSlicer builds the export filename.

The slicer resolves `filename_format` **before** any G-code is produced (see `Print::output_filename`).  
Only placeholders that are already present in the global parser at that time can be used in the exported file name:

- Configuration keys from the active print/filament/printer presets, including `print_preset`, `filament_preset[]`, `printer_preset`, and every regular setting (line widths, temperatures, etc.).
- Object metadata injected up front: `input_filename`, `input_filename_base`, `num_objects`, `num_instances`, `scale[]`, `plate_name`, `model_name`, plus the timestamp and user placeholders.
- Print statistics computed right after slicing such as `print_time`, `normal_print_time`, `silent_print_time`, `used_filament`, `extruded_volume`, `total_cost`, `total_toolchanges`, `total_weight`, and wipe-tower totals.

Placeholders that are populated later—during per-layer or per-tool G-code generation—are **not** available inside `filename_format`. This includes everything under *Global Slicing State*, *Slicing State*, *Layer-aware*, *Toolchange*, *Filament start/end*, *Timelapse*, *Extrusion role*, and *Pause/color change helpers*. Using them in the template causes the filename evaluation to fail because they are unset when the template is processed.

## Custom G-code Contexts

Runtime-only placeholders injected right before specific custom G-code hooks are evaluated.

In addition to the global placeholders above, OrcaSlicer injects context-specific values when it evaluates individual G-code macros.

### Layer-aware placeholders

| Placeholder | Type | Description |
| --- | --- | --- |
| `layer_num` | int (1-based) | Current layer index. Provided to `before_layer_change_gcode`, `layer_change_gcode`, `timelapse_gcode`, `wrapping_detection_gcode`, `change_filament_gcode`, `filament_start_gcode`, `filament_end_gcode`, and `machine_end_gcode`. |
| `layer_z` | float (mm) | Height of the top of the current layer (after applying any Z offset). Available in the same contexts as `layer_num`. |
| `max_layer_z` | float (mm) | Z height of the final layer. Available anywhere a layer-aware macro runs (layer change, timelapse, wrapping detection, change filament, filament start/end, machine end). |
| `filament_extruder_id` | int | Zero-based ID of the extruder whose macro is executing. Provided to filament start/end scripts, machine end G-code, change filament/path scripts, and other macros that need to know the current tool. |

### Toolchange and wipe tower placeholders

The following placeholders are populated only while `change_filament_gcode` (and the wipe-tower driven toolchange flow) is being evaluated.

| Placeholder | Type | Description |
| --- | --- | --- |
| `previous_extruder` / `next_extruder` | int | IDs of the extruder being unloaded and the one being loaded. |
| `toolchange_z` | float (mm) | Actual Z height at the moment the toolchange macro is called. |
| `outer_wall_volumetric_speed` | float (mm³/s) | Volumetric speed limit for the new extruder’s outer walls. |
| `relative_e_axis` | bool | Indicates whether the slicer is emitting relative E moves (`G91 E`). |
| `toolchange_count` | int | Number of tool changes that have occurred so far. |
| `fan_speed` | int | Legacy placeholder kept for compatibility (always `0`). |
| `old_retract_length` / `new_retract_length` | float (mm) | Retraction distance for the outgoing and incoming filaments. |
| `old_retract_length_toolchange` / `new_retract_length_toolchange` | float (mm) | Toolchange-specific retraction distances for each filament. |
| `old_filament_temp` / `new_filament_temp` | int (°C) | Requested nozzle temperatures before and after the toolchange. |
| `old_filament_e_feedrate` / `new_filament_e_feedrate` | int (mm/min) | Extrusion feedrates derived from volumetric limits for the old/new filaments. |
| `x_after_toolchange` / `y_after_toolchange` / `z_after_toolchange` | float (mm) | Position the slicer expects after the toolchange macro finishes. Update them if you move somewhere else. |
| `first_flush_volume` / `second_flush_volume` | float (mm of filament) | Each half of the planned purge length. |
| `flush_length` | float (mm of filament) | Total purge length requested for the toolchange. |
| `flush_length_1` … `flush_length_4` | float (mm of filament) | Individual purge segments (unused entries are `0`). |
| `flush_volumetric_speeds[]` | float per extruder (mm³/s) | Calibration purge speeds associated with the flush sequence. |
| `flush_temperatures[]` | int per extruder (°C) | Temperatures to use for each stage of the flush sequence. |
| `wipe_avoid_perimeter` | bool | `true` when wipe tower travel avoidance is active for the change. |
| `wipe_avoid_pos_x` | float (mm) | X coordinate of the avoidance barrier used around the wipe tower. |
| `travel_point_1_x` / `travel_point_1_y` | float (mm) | First intermediate XY travel waypoint in object coordinates. |
| `travel_point_2_x` / `travel_point_2_y` | float (mm) | Second intermediate travel waypoint. |
| `travel_point_3_x` / `travel_point_3_y` | float (mm) | Third intermediate travel waypoint. |

All `layer_*` placeholders from the previous section are also available inside `change_filament_gcode`.

### Filament start/end placeholders

| Placeholder | Type | Description |
| --- | --- | --- |
| `filament_extruder_id` | int | ID of the filament whose start or end macro is executing. Present in `filament_start_gcode`, `filament_end_gcode`, and `machine_end_gcode`. |
| `retraction_distance_when_cut` | float (mm) | Cut-retraction distance for the active filament. Provided to `filament_start_gcode` (and as a global placeholder). |
| `long_retraction_when_cut` | bool | Whether the “long retraction when cut” behaviour is enabled for the active filament. Provided to `filament_start_gcode` and globally. |

`filament_start_gcode` and `filament_end_gcode` also receive the layer-aware placeholders listed earlier (`layer_num`, `layer_z`, `max_layer_z`).

### Timelapse and wrapping detection

| Placeholder | Type | Description |
| --- | --- | --- |
| `most_used_physical_extruder_id` | int | Physical extruder that prints most of the layer. Supplied to `timelapse_gcode` and `wrapping_detection_gcode`. |
| `curr_physical_extruder_id` | int | Physical extruder currently active when the macro runs. Provided to the same scripts as above. |
| `timelapse_pos_x` / `timelapse_pos_y` | int (mm) | XY coordinates selected for taking the snapshot. Available only inside `timelapse_gcode`. |
| `has_timelapse_safe_pos` | bool | Indicates whether a safe snapshot position was found. Available in `timelapse_gcode`. |

### Extrusion role changes

| Placeholder | Type | Description |
| --- | --- | --- |
| `extrusion_role` | string | Name of the extrusion role that the slicer is about to use (Perimeter, ExternalPerimeter, Support, etc.). Available in `change_extrusion_role_gcode`. |
| `last_extrusion_role` | string | Previous extrusion role before the transition. Available in `change_extrusion_role_gcode`. |

### Pause / color change helpers

| Placeholder | Type | Description |
| --- | --- | --- |
| `color_change_extruder` | int | Extruder index associated with a color-change (`M600`) event. Populated when OrcaSlicer triggers `machine_pause_gcode` for a color change. |

Use these tables as a reference when designing custom start/end sequences, toolchange macros, or template snippets. Combine them with your preset-specific placeholders (e.g. `nozzle_temperature`, `filament_diameter`, etc.) to script advanced behaviours.
