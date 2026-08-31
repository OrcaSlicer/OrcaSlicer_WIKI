# CLI Actions

Action options tell OrcaSlicer what to *do* with the model(s) it loaded — export, slice, or inspect them. See [CLI Mode](cli_mode) for general flag syntax.

- [Export](#export)
- [Slicing](#slicing)
- [Model Info](#model-info)
- [Misc Actions](#misc-actions)

## Export

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--export-3mf` | `filename.3mf` | Export the project as a 3MF file. | Default filename: `output.3mf`. |
| `--export-slicedata` | `slicing_data_directory` | Export slicing data (the sliced result cache) to a folder. | Cannot be combined with `--load-slicedata`. |
| `--load-slicedata` | `slicing_data_directory` | Load previously-cached slicing data from a directory instead of re-slicing. | Cannot be combined with `--export-slicedata` or [`--repetitions`](cli_transform#object-handling). |
| `--export-stl` | boolean | Export the model(s) as a single STL. | |
| `--export-stls` | `stl_path` | Export the model(s) as multiple STLs, one per object, to a directory. | |
| `--min-save` | boolean | Export the 3MF with minimum size (strips extra data not needed for printing). | |
| `--export-settings` | `settings.json` | Export the current effective process/printer/filament settings to a JSON file. | Default filename: `output.json`. |

## Slicing

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--slice` | `option` (int) | Slice the plate(s): `0` = all plates, `i` = plate `i`, any other value is invalid. | |
| `--mtcpp` | `count` | Maximum triangle count per plate allowed for slicing. | Default: `1000000`. |
| `--mstpp` | `time` (seconds) | Maximum slicing time allowed per plate. | Default: `300`. |
| `--no-check` | boolean | Skip validity checks such as G-code path conflict detection. | |
| `--normative-check` | boolean | Run the normative (specification) checks. | Default: on. |

## Model Info

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--info` | boolean | Print the loaded model's information (object/instance counts, dimensions, etc.) to stdout. | Runs on the unrepaired model. |

## Misc Actions

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--help` / `-h` | boolean | Print CLI usage help. | |
| `--uptodate` | boolean | Update the config values embedded in a loaded 3MF to the current OrcaSlicer version's defaults/schema. | |
| `--load-defaultfila` | boolean | For any object without an explicitly loaded filament, use the first filament as its default. | |
| `--pipe` | `pipename` | Send slicing progress updates to a named pipe, for integration with external tooling. | |
