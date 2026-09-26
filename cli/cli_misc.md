# CLI Misc

Options for loading settings/filaments, selecting objects, output locations, logging, and 3MF metadata. See [CLI Mode](cli_mode) for general flag syntax.

- [Loading Settings & Filaments](#loading-settings-filaments)
- [Object Selection](#object-selection)
- [Output & Logging](#output-logging)
- [Arrange Behavior](#arrange-behavior)
- [Metadata](#metadata)
- [Print Behavior](#print-behavior)

## Loading Settings & Filaments

These load the same per-tab JSON files produced by each settings tab's Save/Export action — see [Export Preset Bundle](import_export#export-preset-bundle) for how those files are created in the GUI.

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--load-settings` | `"setting1.json;setting2.json"` | Load process/machine settings from the given file(s), semicolon-separated. | |
| `--load-filaments` | `"filament1.json;filament2.json;..."` | Load filament settings from the given file(s), semicolon-separated. | |
| `--uptodate-settings` | `"setting1.json;setting2.json"` | Process/machine settings to load when used together with [`--uptodate`](cli_actions#misc-actions). | |
| `--uptodate-filaments` | `"filament1.json;filament2.json;..."` | Filament settings to load when used together with [`--uptodate`](cli_actions#misc-actions). | |
| `--downward-check` | boolean | Check whether the current machine is downward-compatible with the machines listed in `--downward-settings`. | |
| `--downward-settings` | `"machine1.json;machine2.json;..."` | Machine settings list to check against when `--downward-check` is enabled. | |
| `--load-custom-gcodes` | `custom_gcode_toolchange.json` | Load a custom G-code toolchange definition from a JSON file. Related concept: [Machine G-code](printer_machine_gcode). | |

## Object Selection

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--skip-objects` | `"3,5,10,77"` | Skip the given object indices when printing. | |
| `--clone-objects` | `"1,3,1,10"` | Clone count for each object in the load list. | Cannot be combined with [`--assemble`](cli_transform#object-handling). |
| `--load-assemble-list` | `assemble_list.json` | Load a full assemble object list (plates, objects, and their parameters) from a config file, instead of loading models directly. | Cannot be combined with positional input model files or with any [transform](cli_transform) flag. |
| `--load-filament-ids` | `"1,2,3,1"` | Filament ID to assign to each loaded object, one entry per input file. | List length must match the number of input files. |

## Output & Logging

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--datadir` | `dir` | Load and store settings at the given directory, instead of the default user config location. Useful for maintaining separate profile sets. Related concept: [Portable User Configuration](how_to_build#portable-user-configuration). | |
| `--outputdir` | `dir` | Output directory for exported files. | Created recursively if it doesn't exist; the process exits with an error if creation fails. |
| `--debug` | `level` (int, 0-5) | Debug logging level: `0` fatal, `1` error, `2` warning, `3` info, `4` debug, `5` trace. | Default: `1`. |
| `--logfile` | `file` | Redirect debug logging to a file instead of stderr. | |

## Arrange Behavior

These correspond to options in the GUI's [Auto Arrange](prepare_auto_arrange#parameters) panel.

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--allow-multicolor-oneplate` | boolean | Allow multiple materials/colors to be arranged onto the same plate. See "Allow multiple materials on same plate" in [Auto Arrange](prepare_auto_arrange#parameters). | Default: on. |
| `--allow-rotations` | boolean | Allow arrange to rotate objects to fit. See "Auto rotate for arrangement" in [Auto Arrange](prepare_auto_arrange#parameters). | Default: on. |
| `--avoid-extrusion-cali-region` | boolean | Avoid the extrusion calibration region on the plate when arranging. | Default: off. |

## Metadata

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--makerlab-name` | `name` | MakerLab name embedded when generating the 3MF. | |
| `--makerlab-version` | `version` | MakerLab version embedded when generating the 3MF. | |
| `--metadata-name` | `"name1;name2;..."` | Custom metadata field name(s) to add to the 3MF, semicolon-separated. | Paired positionally with `--metadata-value`. |
| `--metadata-value` | `"value1;value2;..."` | Custom metadata field value(s) to add to the 3MF, semicolon-separated. | Paired positionally with `--metadata-name`. |

## Print Behavior

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--enable-timelapse` | boolean | Treat this slicing run as using timelapse. See [Timelapse](others_settings_special_mode#timelapse). | Default: off. |
| `--skip-modified-gcodes` | boolean | Skip modified G-code (from printer/filament presets) embedded in a loaded 3MF. | Default: off. |
| `--allow-newer-file` | boolean | Allow slicing a 3MF that was saved by a newer OrcaSlicer version than the one running. | Default: off. |
| `--allow-mix-temp` | boolean | Allow filaments with high/low temperature requirements to be printed together. | Internal use; default: off. |
