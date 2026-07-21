# Profile App — Vendor Root JSON

Every vendor in OrcaSlicer is defined by a root JSON file (e.g. `Afinia.json`,
`Anker.json`) that serves as the **authoritative registry** for all profiles in that
vendor. The Profile App reads this file to discover models, variants, processes, and
filaments; it writes back to it when profiles are created, renamed, or deleted.

## Structure

```json
{
  "name": "Afinia",
  "version": "02.04.00.01",
  "description": "Afinia configurations",
  "machine_model_list": [
    { "name": "Afinia H+1(HS)", "sub_path": "machine/Afinia H+1(HS).json" }
  ],
  "machine_list": [
    { "name": "fdm_machine_common", "sub_path": "machine/fdm_machine_common.json" },
    { "name": "Afinia H+1(HS) 0.4 nozzle", "sub_path": "machine/Afinia H+1(HS) 0.4 nozzle.json" }
  ],
  "process_list": [
    { "name": "fdm_process_common", "sub_path": "process/fdm_process_common.json" },
    { "name": "0.20mm Standard @Afinia H+1(HS)", "sub_path": "process/0.20mm Standard @Afinia H+1(HS).json" }
  ],
  "filament_list": [
    { "name": "fdm_filament_common", "sub_path": "filament/fdm_filament_common.json" },
    { "name": "Afinia PLA", "sub_path": "filament/Afinia PLA.json" }
  ]
}
```

## The Four Lists

### `machine_model_list`

Contains one entry per **printer model**. Each entry points to a `type: machine_model`
JSON file that defines:

- `name` — the model's display name (must be unique across ALL vendors)
- `model_id` — a slug-like identifier
- `nozzle_diameter` — semicolon-separated list of available sizes (e.g. `"0.2;0.4;0.6"`)
- `family` — the vendor name this model belongs to
- `machine_tech` — always `"FFF"` for filament printers
- `default_materials` — semicolon-separated list of filament preset names to pre-select in the wizard
- `bed_model`, `bed_texture`, `hotend_model` — optional model asset filenames

> [!IMPORTANT]
> The `nozzle_diameter` field uses the **semicolon string form** (`"0.2;0.4;0.6"`),
> not a JSON array. This is the format OrcaSlicer expects in `machine_model` files.
> Machine variant files use the **array form** (`["0.4"]`).

### `machine_list`

Contains one entry per **machine preset** and **base machine file**. These entries are
parsed by OrcaSlicer as `type: machine` presets:

- **Variant presets** — one per nozzle size, e.g. `Afinia H+1(HS) 0.4 nozzle`. These are
  instantiable (`instantiation: "true"`) and define `printer_model`, `printer_variant`,
  `printable_area`, `printable_height`, `default_print_profile`, etc.
- **Base files** — templates shared across all models, e.g. `fdm_machine_common`,
  `fdm_afinia_common`. These have `instantiation: "false"` and provide inherited defaults.

> [!WARNING]
> **Never register a `machine_model` file in `machine_list`.** OrcaSlicer parses every
> `machine_list` entry as a machine preset. A model file there fails instantiation
> validation and throws `ConfigurationError`, dropping the **entire vendor**.
> The Profile App's export pipeline strips these entries automatically via
> `sanitizeVendorRootsForExport`.

### `process_list`

Contains one entry per **process preset** and **base process file**. Process presets
define slicing parameters (layer height, line widths, speeds, etc.). By convention:

- Common base files are listed first (`fdm_process_common`, vendor-specific commons)
- Specialized presets follow, typically with the pattern
  `{layer_height}mm {description} @{vendor/model}`
- Each process preset declares `compatible_printers` — an array of machine preset names

### `filament_list`

Contains one entry per **filament preset** and **base filament file**. Filament presets
define material properties (temperature, flow, cooling, etc.). By convention:

- Common base files are listed first (`fdm_filament_common`, `fdm_filament_abs`, etc.)
- Specialized presets follow, offering material-specific settings
- Each filament preset has a `filament_id` — a short code used for AMS mapping
  (e.g. `GFA00` for Afinia ABS, `OCF` + hash for app-created filaments)

## Critical Rules Enforced by the Export Pipeline

These rules were discovered by debugging against OrcaSlicer 2.4.x source code and are
enforced in the export normalization layer. See
[Export Pipeline](profile_app_export_pipeline) for the full specification.

| # | Rule | Consequence if violated |
|---|---|---|
| 1 | Empty `inherits` key must be omitted | Whole vendor dropped |
| 2 | `nozzle_diameter` must be array in variant files | Wizard crash, vendor family dropped |
| 3 | Every instantiable filament needs `filament_id` | Whole vendor dropped |
| 4 | Config values must be strings or string arrays | Settings silently discarded |
| 5 | `machine_list` must not contain `machine_model` entries | Whole vendor dropped |
| 6 | `printer_variant` must not contain commas (multi-extruder collapse) | Machine section aborted, model unreachable |

## Preset Name Uniqueness

Preset names must be unique **across all vendors**, not just within one. OrcaSlicer
loads vendors alphabetically and merges them into a global preset pool. If two vendors
have presets with the same name, the first vendor's preset wins and the second is
silently discarded with a `"Found duplicated preset"` error.

> [!TIP]
> Use vendor-specific names for app-created presets — e.g. `Anker X1 0.4 nozzle`
> instead of `New Printer 0.4 nozzle`. The stock convention is to include the vendor
> or model name in every preset name.

## Relation to Files on Disk

Each `sub_path` in a list entry is relative to the vendor directory. The full path for
the Profile App export is `resources/profiles/{vendor}/{sub_path}`. When placed in
OrcaSlicer's `resources/profiles/`, the structure is:

```
resources/profiles/
├── Afinia.json                  ← vendor root JSON
├── Afinia/
│   ├── machine/
│   │   ├── Afinia H+1(HS).json          ← machine_model
│   │   ├── Afinia H+1(HS) 0.4 nozzle.json  ← machine preset
│   │   └── fdm_machine_common.json       ← base file
│   ├── process/
│   │   ├── fdm_process_common.json
│   │   └── 0.20mm Standard @Afinia H+1(HS).json
│   └── filament/
│       ├── fdm_filament_common.json
│       └── Afinia PLA.json
```

## OrcaSlicer Loading Behavior

OrcaSlicer does **not** read `resources/profiles/` directly at runtime. On launch:

1. `PresetUpdater` compares the vendor JSON `version` in `resources/profiles/` against
   `%APPDATA%/OrcaSlicer/system/{vendor}.json`.
2. If the resources version is **newer**, files are copied from `resources/profiles/`
   into the AppData `system/` cache.
3. `PresetBundle` loads presets from the AppData `system/` cache.

> [!WARNING]
> If you fix a profile file in `resources/profiles/` without bumping the `version`
> field, OrcaSlicer will **not** re-sync the fix into its cache. Either bump the
> version or delete the vendor's folder under `%APPDATA%/OrcaSlicer/system/` before
> launching.

The setup wizard also reads `resources/profiles/{vendor}.json` directly when
populating the "Select Printer" dialog, checking for `_cover.png` images and
building model cards.
