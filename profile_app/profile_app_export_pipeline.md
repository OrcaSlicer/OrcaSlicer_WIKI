# Profile App — Export Pipeline

This page documents every rule applied by the export normalization pipeline in the
OrcaCloud Profile App. These rules exist because OrcaSlicer's C++ preset loader
([`PresetBundle`](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/PresetBundle.cpp),
[`ConfigBase`](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/Config.cpp),
and the setup wizard
[`WebGuideDialog`](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/slic3r/GUI/WebGuideDialog.cpp))
has strict JSON format requirements. A single malformed file can cause the **entire vendor**
to be dropped from OrcaSlicer's printer list.

All rules are applied at the R2 sync boundary in
[`exportNormalization.ts`](https://github.com/OrcaSlicer/OrcaCloud/blob/main/apps/cloud-frontend/src/features/profileApp/pages/exportNormalization.ts).
In-app state and IndexedDB content are left untouched — normalization is pure and
export-only. The gateway ZIP download serves R2 bytes verbatim, so normalized uploads
flow into every zip.

## Per-File Rules

These are applied by `normalizeProfileContentForExport()` to every JSON file before
serialization.

### 1. Empty `inherits` Key Omitted

**OrcaSlicer behavior:** `PresetBundle::load_vendor_configs_from_json` reads the
`inherits` key and tries to resolve it as a parent preset name. If the value is an
empty string `""`, the lookup for a preset named `""` fails, and the function throws
`ConfigurationError`. The error propagates and the **entire vendor** is dropped.

**Stock convention:** Root preset files (`fdm_process_common`, `fdm_filament_common`,
`fdm_machine_common`) have **no** `inherits` key at all — it is simply absent.

**Rule:** If `inherits` is present and its trimmed value is empty, the key is removed
from the output entirely. Non-empty values are preserved.

**Code reference:** `PresetBundle.cpp` line ~4066-4098:
```cpp
auto it1 = key_values.find("inherits");
if (it1 != key_values.end()) {
    inherits = it1->second;
    // Lookup inherits in config_maps — fails on ""
    if (default_config == nullptr) {
        BOOST_LOG_TRIVIAL(error) << "can not find inherits " << inherits;
        return reason;  // → ConfigurationError thrown by caller
    }
}
```

### 2. Scalar Vector Fields → Arrays

**OrcaSlicer behavior:** The setup wizard (`WebGuideDialog.cpp`) accesses certain fields
with `[0]` index notation:
```cpp
OneMachine["nozzle"] = pm["nozzle_diameter"][0];    // line ~1360
sVendor = jLocal["filament_vendor"][0];              // line ~1008
sType = jLocal["filament_type"][0];                  // line ~1016
```

If these fields are plain strings instead of arrays, nlohmann JSON throws
`type_error.305` ("cannot use operator[] with a numeric argument with string"),
aborting the entire vendor family in the wizard.

**Rule:** The following fields are converted from scalar strings to arrays by splitting
on `;`:

| Profile type | Fields array-ified |
|---|---|
| `type: machine` | `nozzle_diameter` |
| `type: filament` | `filament_type`, `filament_vendor` |

> [!IMPORTANT]
> `type: machine_model` files keep the semicolon string form (`"0.2;0.4;0.6"`) —
> that is the correct format for model definition files. Only variant preset files
> need arrays.

**Example:**
```json
// Before (scalar — wizard crashes)
{ "nozzle_diameter": "0.4" }
// After (array — wizard accepts)
{ "nozzle_diameter": ["0.4"] }
```

### 3. Missing `filament_id` on Instantiable Filaments

**OrcaSlicer behavior:** `PresetBundle` requires every instantiable system filament
preset to carry a non-empty `filament_id`. If missing, the function returns an error
and throws `ConfigurationError` — dropping the entire vendor.

**Code reference:** `PresetBundle.cpp` line ~4211-4217:
```cpp
if (filament_id.empty() && "Template" != vendor_name) {
    BOOST_LOG_TRIVIAL(error) << "can not find filament_id for " << preset_name;
    reason = "Can not find filament_id for " + preset_name;
    return reason;  // → ConfigurationError thrown
}
```

> [!NOTE]
> Base filaments (`instantiation: "false"`) do **not** need a `filament_id`. The
> check is only for instantiable (`"true"`) presets.

**Rule:** For `type: filament` files where `instantiation` is `"true"` and no
`filament_id` is present, a deterministic ID is generated using FNV-1a 32-bit hash
of the preset name, encoded as base36, prefixed with `OCF` (e.g. `OCF1YC1IOI`).

The hash is stable across re-syncs — the same preset name always produces the same ID.
Existing `filament_id` values (from stock presets) are preserved untouched.

### 4. Raw JSON Booleans/Numbers → Strings

**OrcaSlicer behavior:** `ConfigBase::load_from_json` only accepts string and
string-array values. Any other JSON type (boolean, number, null) logs
`"invalid json type"` and the setting is **silently dropped** — the value reverts
to the C++ default.

**Code reference:** `Config.cpp` line ~998-1004:
```cpp
if (it.value().is_string()) { /* process string */ }
else if (it.value().is_array()) { /* process array of strings */ }
else {
    BOOST_LOG_TRIVIAL(error) << "invalid json type for " << it.key();
    // value silently ignored
}
```

**Rule:** Raw booleans are converted to `"1"` (true) / `"0"` (false). Raw numbers are
converted to their string representation. This applies to scalar values and array
elements alike.

> [!NOTE]
> Metadata keys (`instantiation`, `from`, `type`, `name`, `inherits`) keep their
> own conventions — `instantiation` uses `"true"`/`"false"` strings which are
> handled separately by the `toOrcaBool` helper.

### 5. C++ Enum Identifiers → OrcaSlicer Serialized Keys

**OrcaSlicer behavior:** The profile editor may produce internal enum identifiers like
`WallSequence::InnerOuter` instead of OrcaSlicer's serialized form `"inner wall/outer
wall"`. These are silently substituted by the config loader when unknown.

**Rule:** 27 enum values across 8 enum types are reverse-mapped to their OrcaSlicer
serialized keys:

| Enum type | Internal | Serialized |
|---|---|---|
| `WallSequence` | `InnerOuter` | `inner wall/outer wall` |
| `WallSequence` | `OuterInner` | `outer wall/inner wall` |
| `WallSequence` | `InnerOuterInner` | `inner-outer-inner wall` |
| `WallDirection` | `CounterClockwise` | `ccw` |
| `WallDirection` | `Clockwise` | `cw` |
| `WallDirection` | `Auto` | `auto` |
| `SeamScarfType` | `None` | `none` |
| `SeamScarfType` | `External` | `external` |
| `SeamScarfType` | `All` | `all` |
| `PerimeterGeneratorType` | `Classic` | `classic` |
| `PerimeterGeneratorType` | `Arachne` | `arachne` |
| `PrintOrder` | `Default` | `default` |
| `PrintOrder` | `AsObjectList` | `as_obj_list` |
| `FuzzySkinMode` | `Displacement` | `displacement` |
| `FuzzySkinMode` | `Extrusion` | `extrusion` |
| `FuzzySkinMode` | `Combined` | `combined` |
| `NoiseType` | `Classic` | `classic` |
| `NoiseType` | `Perlin` | `perlin` |
| `NoiseType` | `Billow` | `billow` |
| `NoiseType` | `RidgedMulti` | `ridgedmulti` |
| `NoiseType` | `Voronoi` | `voronoi` |
| `SlicingMode` | `Regular` | `regular` |
| `SlicingMode` | `EvenOdd` | `even_odd` |
| `SlicingMode` | `CloseHoles` | `close_holes` |

Unknown `Enum::Value` strings pass through untouched — OrcaSlicer substitutes its
default value in that case.

### 6. FloatOrPercent Internal Format → OrcaSlicer Form

**OrcaSlicer behavior:** Values like `seam_gap` or `inner_wall_line_width` can be
expressed as either absolute (e.g. `"0.45"` mm) or percentage (e.g. `"15%"`). The
profile app editor uses an internal representation `"number,boolean"` (e.g.
`"10,true"` = 10%, `"20,false"` = 20mm) for UI convenience.

**Rule:** Values matching the regex `/^-?(?:\d+\.?\d*|\.\d+)\s*,\s*(true|false)$/`
are converted:
- `"10,true"` → `"10%"`
- `"20, false"` → `"20"`
- `"0., false"` → `"0."`

Values that don't match this pattern are left unchanged.

### 7. Corrupted Model-Table Keys

**OrcaSlicer behavior:** Two specific config options store line-based lookup tables:
- `small_area_infill_flow_compensation_model` — a **string array** of `"x,y"` pairs
- `adaptive_pressure_advance_model` — a single **multiline string** of `x,y,z` tuples

When these are corrupted into quoted-fragment strings like `"\"0,0\", \"\\n0.2,0.4444\""`,
OrcaSlicer throws `"Invalid value provided"` and drops the vendor.

**Rule:** Quoted fragments are extracted, unescaped, split on newlines, and rebuilt
into the correct form — a string array for `small_area_…` and a clean multiline string
for `adaptive_pressure_advance_model`.

### 8. Multi-Extruder `printer_variant` Collapse

**OrcaSlicer behavior:** `PresetBundle` validates each machine preset's
`printer_variant` against the model file's `nozzle_diameter` list. A multi-extruder
variant like `"0.4,0.4"` doesn't match any single nozzle diameter and causes:
```
"defines invalid printer variant '0.4,0.4', it will be ignored"
```
This error throws `ConfigurationError` — **aborting the entire machine section**
for that vendor. The model card appears in the wizard (from `machine_model_list`,
parsed separately), but no machine presets from that point onward are loaded.

**Rule:** For `type: machine` files, if `printer_variant` contains a comma, split on
comma and keep only the first diameter.

## Cross-File Rule

Applied by `sanitizeVendorRootsForExport()` to the entire upload set before
serialization.

### 9. Machine-Model Entries Stripped from `machine_list`

**OrcaSlicer behavior:** Every entry in the vendor root's `machine_list` is parsed as
a **machine preset**. If a `machine_model` file is registered there, it has no
`instantiation` key, no `printer_model`, and no `printer_variant` — causing
`"Missing instantiation attribute"` and `"defines no printer model"`. The entry
logs an error and **throws `ConfigurationError`**, dropping the entire vendor.

**Rule:** Each `machine_list` entry's target file is cross-checked against the other
files in the upload set. Entries targeting `type: machine_model` files are stripped
from the list. Entries targeting files not in the upload set are preserved (can't
verify).

## Formatting

All files are serialized via `toOrcaJson()` which produces `JSON.stringify` with tab
indentation (`\t`) and CRLF line endings (`\r\n`), matching OrcaSlicer's expected
format exactly.

## Testing

The export pipeline is covered by 30 unit tests in `exportNormalization.test.ts` and
an end-to-end acceptance test in `exportPipelineAcceptance.test.ts` that feeds a
bundle containing every documented defect through the pipeline and validates it against
the OrcaSlicer loader rules.
