# Proto-based Config Code Generation

OrcaSlicer uses a **protobuf schema + code generator** pipeline so that adding or changing a
setting requires editing one file instead of ~12. This page explains how the system works,
how to add new settings, and how to deal with the parts that can't be auto-generated (hooks).

---

## Overview

```
src/PrintConfigs/
├── config_metadata.proto    ← custom field extensions (label, tooltip, mode, …)
├── print.proto              ← ~477 print/process settings
├── filament.proto           ← ~119 filament settings
├── printer.proto            ← ~42 printer/machine settings
└── layout.yaml              ← UI tab / page / group / field structure
         │
         ▼  python tools/run_codegen.py
src/slic3r/GUI/generated/    ← gitignored, regenerated on every build
├── PrintConfigDef_generated.cpp   → #included by PrintConfig.cpp
├── Preset_options_generated.cpp   → #included by Preset.cpp
├── Invalidation_generated.cpp     → #included by Print.cpp
├── OptionKeys_generated.cpp       → #included by PrintConfig.cpp
└── TabLayout_generated.cpp        → #included by Tab.cpp
```

The generated files are **gitignored** and rebuilt automatically whenever a `.proto` file or
`layout.yaml` changes. You never edit them by hand.

---

## Build prerequisites

Python 3.8+ is required. The codegen pipeline installs its own Python dependencies automatically:

- `grpcio-tools` — installed by the build scripts and by `run_codegen.py` itself
- `pyyaml` — installed automatically by `run_codegen.py` on first run

You do **not** need to install them manually. Just make sure Python is on your PATH.

To regenerate manually at any time:

```bash
python tools/run_codegen.py
```

### VS Code workflow

In VS Code with the CMake Tools extension, the pipeline is fully automatic:

1. Edit `src/PrintConfigs/*.proto` or `src/PrintConfigs/layout.yaml`
2. Hit **Run** (▶) — cmake detects the change, runs `run_codegen.py`, then recompiles

The cmake `codegen_config ALL` target runs before every build and checks timestamps.

---

## Adding a new setting

1. **Choose the right proto file** based on preset type:

   | File | Preset type |
   |---|---|
   | `src/PrintConfigs/print.proto` | Print / process settings |
   | `src/PrintConfigs/filament.proto` | Filament / material settings |
   | `src/PrintConfigs/printer.proto` | Printer / machine settings |

2. **Add a field** with the appropriate annotations:

    ```protobuf
   float my_new_setting = <next_field_number> [
     (label)         = "My Setting",
     (tooltip)       = "Describe what this does.",
     (sidetext)      = "mm",
     (category)      = "Quality",
     (mode)          = MODE_ADVANCED,
     (preset)        = PRESET_PRINT,
     (has_default)   = true,
     (default_value) = "1.0",
     (invalidates)   = STEP_GCODE_EXPORT
   ];
    ```

   Field numbers must be unique within the message and **never reused**, even after removal.

   > [!TIP]
   > **`(preset)` is usually optional.** The codegen infers the preset type from the filename:
   > `print.proto` → `PRESET_PRINT`, `filament.proto` → `PRESET_FILAMENT`, `printer.proto` → `PRESET_PRINTER`.
   > Only add `(preset)` explicitly when a field in one file belongs to a different preset type.

   > [!TIP]
   > **`(has_default)` and `(default_value)` are optional.** If omitted, the field uses its
   > type's default constructor (empty vector, 0, false). This is correct for settings like
   > machine limits that get their real values from profiles, not from code.

   > [!TIP]
   > **`(mode)` controls UI visibility:** `MODE_SIMPLE` shows in all modes, `MODE_ADVANCED`
   > is hidden in Simple mode, `MODE_DEVELOP` is only visible in Developer mode (debug builds).

3. **Run the codegen:**

    ```bash
   python tools/run_codegen.py
    ```

4. **Add the field to `layout.yaml`** if you want it to appear in the settings UI
   (see [UI layout](#ui-layout-layoutyaml) below).

5. **Commit only** the `.proto` and `layout.yaml` changes. Generated files are gitignored
   and will be regenerated on each build.

### Adding an enum setting

Enum settings need more annotations than scalar settings. Here is a complete example:

```protobuf
// In print.proto (or filament/printer)
int32 my_pattern = <next_number> [
  (label)           = "My Pattern",
  (tooltip)         = "The fill pattern for my feature.",
  (co_type_hint)    = "coEnum",                                    // required: tells codegen it's an enum
  (enum_keys_map_ref) = "ConfigOptionEnum<InfillPattern>::get_enum_values()",  // C++ enum type
  (mode)            = MODE_ADVANCED,
  (preset)          = PRESET_PRINT,
  (has_default)     = true,
  (default_value)   = "ipRectilinear",                             // C++ enum value name
  (enum_value_entries) = "rectilinear",                            // serialized string (in JSON/profile)
  (enum_value_entries) = "concentric",
  (enum_label_entries) = "Rectilinear",                            // human-readable label in UI
  (enum_label_entries) = "Concentric",
  (invalidates)     = STEP_INFILL
];
```

The `enum_value_entries` and `enum_label_entries` lists must be in the same order.
The `enum_keys_map_ref` must match an existing C++ enum that has a `CONFIG_OPTION_ENUM_DEFINE_STATIC_MAPS`
macro call in `PrintConfig.cpp`. If you are adding a new enum type, you must also add that macro.

### Removing or deprecating a setting

1. **Do not delete** the field from the proto. Field numbers must never be reused (protobuf rule).
2. Change `(mode)` to `MODE_DEVELOP` to hide it from normal users.
3. If the field should disappear entirely, add a `(legacy_name)` annotation pointing to the
   replacement field, and add a migration entry in `PrintConfigDef::handle_legacy()` in
   `PrintConfig.cpp`.
4. Remove it from `layout.yaml` so it no longer appears in the UI.

### The `tab_type` / `tab_page` / `tab_optgroup` annotations

You will see these on many existing proto fields:

```protobuf
(tab_type)     = "Print",
(tab_page)     = "Quality",
(tab_optgroup) = "Layer height",
```

These are **informational metadata** — they were used by the bootstrap tool
(`tools/parse_printconfig.py`) to generate the initial `layout.yaml`. The active codegen
(`config_codegen.py`) does **not** use them to generate layout; `layout.yaml` is the
authoritative source. You do not need to add them to new fields.

---

## Invalidation steps

The `(invalidates)` annotation tells the slicer which pipeline steps need to rerun when this
setting changes. Use the most specific step that applies — invalidating too broadly slows down
interactive editing.

| Value | What reruns |
|---|---|
| `STEP_GCODE_EXPORT` | Only G-code export (fastest — for G-code strings, temperatures, speeds) |
| `STEP_SKIRT_BRIM` | Skirt and brim generation |
| `STEP_WIPE_TOWER` | Wipe tower |
| `STEP_SLICE` | Full re-slice from scratch (slowest — for geometry changes) |
| `STEP_PERIMETERS` | Perimeter generation |
| `STEP_INFILL` | Infill generation |
| `STEP_SUPPORT` | Support generation |
| `STEP_NONE` | Setting has no effect on output (metadata, display-only) |

A field can invalidate multiple steps:
```protobuf
(invalidates) = STEP_PERIMETERS,
(invalidates) = STEP_INFILL,
```

---

## Common field annotations

| Annotation | Type | Meaning |
|---|---|---|
| `(label)` | string | Short UI label |
| `(full_label)` | string | Longer label (used in search, tooltips) |
| `(tooltip)` | string | Hover tooltip text |
| `(category)` | string | Group category (e.g. `"Quality"`, `"Filament/Filament"`) |
| `(sidetext)` | string | Unit suffix shown next to the field (e.g. `"mm"`, `"%"`) |
| `(mode)` | enum | `MODE_SIMPLE`, `MODE_ADVANCED`, `MODE_DEVELOP` |
| `(preset)` | enum | `PRESET_PRINT`, `PRESET_FILAMENT`, `PRESET_PRINTER` |
| `(has_default)` | bool | Must be `true` when `(default_value)` is set |
| `(default_value)` | string | C++ constructor args (e.g. `"1.0"`, `"false"`, `"ipMonotonic"`) |
| `(invalidates)` | repeated enum | Which pipeline steps this setting invalidates (see [Invalidation steps](#invalidation-steps)) |
| `(min_value)` | double | Minimum allowed value |
| `(max_value)` | double | Maximum allowed value |
| `(is_nullable)` | bool | `true` for per-filament override fields (nullable type) |
| `(enum_keys_map_ref)` | string | e.g. `"ConfigOptionEnum<MyEnum>::get_enum_values()"` |
| `(enum_value_entries)` | repeated string | Serialized enum value strings |
| `(enum_label_entries)` | repeated string | Human-readable enum labels |
| `(gui_type)` | string | Override GUI widget type (e.g. `"i_enum_open"`, `"color"`) |

---

## Field types

| Proto type | C++ type | Use for |
|---|---|---|
| `float` | `ConfigOptionFloat` | Single numeric value |
| `repeated float` | `ConfigOptionFloats` | Per-extruder vector |
| `repeated float` + `(is_nullable)` | `ConfigOptionFloatsNullable` | Per-filament override |
| `bool` | `ConfigOptionBool` | Single boolean |
| `repeated bool` | `ConfigOptionBools` | Per-extruder vector |
| `int32` | `ConfigOptionInt` | Integer |
| `string` | `ConfigOptionString` | Text / G-code |
| `repeated string` | `ConfigOptionStrings` | Multi-line text |
| `int32` + `(co_type_hint) = "coEnum"` | `ConfigOptionEnum<T>` | Enum (single) |
| `repeated int32` + `(co_type_hint) = "coEnums"` | `ConfigOptionEnumsGeneric` | Per-extruder enum |
| `float` + `(co_type_hint) = "coPercent"` | `ConfigOptionPercent` | Percentage |
| `repeated float` + `(co_type_hint) = "coPercents"` | `ConfigOptionPercents` | Per-extruder % |

---

## Per-filament override settings

Fields whose values can override the printer's extruder settings in a filament profile use
`(is_nullable) = true`. The 16 retraction override fields (`filament_retraction_length`,
`filament_deretraction_speed`, etc.) all follow this pattern in `filament.proto`.

A nullable field generates a `ConfigOptionFloatsNullable` (or `BoolsNullable`, `PercentsNullable`)
default instead of the non-nullable base type. Nil values mean "inherit from printer".

---

## UI layout (`layout.yaml`)

`src/PrintConfigs/layout.yaml` controls which settings appear in which tab / page / group in
the settings UI. Changing this file and running codegen regenerates `TabLayout_generated.cpp`.

### Basic structure

<!-- markdownlint-disable MD007 -->
```yaml
tabs:
  - name: TabPrint         # matches the C++ class name
    pages:
      - name: "Quality"
        icon: "custom-gcode_quality"   # page icon key
        groups:
          - name: "Layer height"
            icon: "param_layer_height"  # optgroup anchor key
            fields:
              - layer_height            # simple field (path looked up automatically)
              - initial_layer_print_height
```
<!-- markdownlint-enable MD007 -->

### Field formats

<!-- markdownlint-disable MD007 -->
```yaml
fields:
  - field_key                          # no doc path
  - field_key: "doc/path#anchor"       # with doc path (dict, single key)
  - [field_a, field_b]                 # multi-option line (two fields on one row)
  - _separator_                        # visual separator
```
<!-- markdownlint-enable MD007 -->

> [!NOTE]
> Multi-option lines `[f1, f2]` use the **first field's label and tooltip** as the line label.
> If you need a custom label (e.g. `"Fan speed-up time"` instead of the field's own label),
> the group must use `hook: true` and the custom `Line` is built in `TabLayoutExtra.cpp`.

### Special group types

#### `hook: true` — custom widget or special callback

The group structure is generated (page + optgroup created), but the content is
**delegated to a hook method** on the tab class. Use this when a group needs a
custom widget (e.g. the bed shape picker), a special `m_on_change` callback, or
a multi-option `Line`.

```yaml
- name: "Printable space"
  icon: "param_printable_space"
  hook: true        # → tab.layout_hook_printable_space(optgroup.get())
```

The hook method is declared in `Tab.hpp` and implemented in `TabLayoutExtra.cpp`:

```cpp
// Tab.hpp
void layout_hook_printable_space(ConfigOptionsGroup* optgroup);

// TabLayoutExtra.cpp
void TabPrinter::layout_hook_printable_space(ConfigOptionsGroup* optgroup)
{
    create_line_with_widget(optgroup, "printable_area", "...", [this](wxWindow* parent) {
        return create_bed_shape_widget(parent);
    });
    optgroup->append_single_option_line("bed_exclude_area", "...");
    // ... more simple fields
}
```

#### `gcode: true` — G-code field with edit button

Generates the standard G-code group pattern: `validate_custom_gcode_cb` callback,
`edit_custom_gcode` button, and `is_code = true` / `height = gcode_field_height` field properties.

```yaml
- name: "Machine start G-code"
  icon: "param_gcode"
  gcode: true
  fields:
    - machine_start_gcode: printer_machine_gcode#machine-start-g-code
```

---

## Adding a new UI page

To add a completely new page to an existing tab, add it to `layout.yaml` under the correct tab:

<!-- markdownlint-disable MD007 -->
```yaml
tabs:
  - name: TabPrint
    pages:
      - name: "My New Page"
        icon: "custom-gcode_my_icon"    # page icon key
        groups:
          - name: "My Group"
            icon: "param_my_group"
            fields:
              - my_field_one
              - my_field_two
```
<!-- markdownlint-enable MD007 -->

The codegen generates `TabPrint_build_my_new_page_layout(TabPrint& tab)` and a wrapper
`TabPrint_build_layout` that calls it in order. The page will appear automatically in the UI.

> [!IMPORTANT]
> New pages appear **at the end** of the tab by default. The order in `layout.yaml` controls
> the order in the tab. Reorder pages in the yaml to change their position in the UI.

---

## Adding a new UI group

### Simple group (all `append_single_option_line`)

Add it directly to `layout.yaml`:

```yaml
- name: "My New Group"
  icon: "param_my_group"
  fields:
    - my_field_one: "doc/path#anchor"
    - my_field_two: "doc/path#anchor"
```

Then run `python tools/run_codegen.py`. No C++ changes needed.

### Group with a custom widget (hook)

1. Add the group to `layout.yaml` with `hook: true`:

    ```yaml
   - name: "My Custom Group"
     icon: "param_my_group"
     hook: true
    ```

2. Declare the hook method in `Tab.hpp` on the appropriate tab class:

    ```cpp
   void layout_hook_my_custom_group(ConfigOptionsGroup* optgroup);
    ```

3. Implement it in `src/slic3r/GUI/TabLayoutExtra.cpp`:

    ```cpp
   void TabPrinter::layout_hook_my_custom_group(ConfigOptionsGroup* optgroup)
   {
       create_line_with_widget(optgroup, "my_key", "doc/path", [this](wxWindow* parent) {
           // return custom widget
       });
       optgroup->append_single_option_line("another_key", "doc/path");
   }
    ```

4. Run `python tools/run_codegen.py` — the generated function calls your hook automatically.

---

## Where generated files are included

| Generated file | Included in | What it provides |
|---|---|---|
| `PrintConfigDef_generated.cpp` | `PrintConfig.cpp` (inside `init_fff_params()`) | Registers all settings with their types, labels, defaults |
| `Preset_options_generated.cpp` | `Preset.cpp` (file scope) | `s_Preset_print_options`, `s_Preset_filament_options`, `s_Preset_printer_options` arrays |
| `Invalidation_generated.cpp` | `Print.cpp` (inside `invalidate_state_by_config_options()`) | `opt_key → {steps}` map |
| `OptionKeys_generated.cpp` | `PrintConfig.cpp` (file scope) | `s_extruder_option_keys`, `s_filament_option_keys` vectors |
| `TabLayout_generated.cpp` | `Tab.cpp` (after `validate_custom_gcode_cb` forward declaration) | `inline void TabXxx_build_yyy_layout(TabXxx&)` functions |

---

## Tab build() wiring

Each `Tab::build()` function delegates to the generated layout functions. Understanding this is
important when debugging UI layout or adding new pages.

### TabPrint

```
TabPrint::build()
  └── TabPrint_build_layout(*this)          ← generated from layout.yaml
       ├── TabPrint_build_quality_layout()
       ├── TabPrint_build_strength_layout()
       ├── TabPrint_build_speed_layout()
       ├── TabPrint_build_support_layout()
       ├── TabPrint_build_multimaterial_layout()
       └── TabPrint_build_others_layout()
```

`TabPrint::build()` is **fully generated** — no hand-written page structure.

### TabFilament

```
TabFilament::build()
  ├── TabFilament_build_main_layout(*this)  ← generated (Filament / Cooling / Multimaterial pages)
  └── build_extra_layout()                  ← TabLayoutExtra.cpp
       ├── Continues Multimaterial page (toolchange + ramming_parameters widget)
       ├── add_filament_overrides_page()    ← checkbox-driven nullable retraction overrides
       ├── Dependencies page               ← compatible_printers / compatible_prints widgets
       └── Notes page
```

`add_filament_overrides_page()` and the Dependencies page use `create_line_with_widget` which
cannot be expressed in the proto schema — they stay hand-written in `TabLayoutExtra.cpp`.

### TabPrinter

```
TabPrinter::build_fff()
  ├── TabPrinter_build_basic_info_layout(*this)   ← generated, calls hooks
  │    ├── tab.layout_hook_printable_space()       ← TabLayoutExtra.cpp (bed shape widget)
  │    ├── tab.layout_hook_advanced()              ← TabLayoutExtra.cpp (thumbnail m_on_change)
  │    ├── tab.layout_hook_cooling_fan()           ← TabLayoutExtra.cpp (multi-option line)
  │    ├── Extruder Clearance                      ← fully generated from layout.yaml
  │    ├── Adaptive bed mesh                       ← fully generated from layout.yaml
  │    └── Accessory                               ← fully generated from layout.yaml
  ├── TabPrinter_build_gcode_layout(*this)         ← generated (Machine G-code + Notes)
  └── build_unregular_pages(true)                  ← hand-written (dynamic per-extruder pages)
```

The kinematics page (Motion ability) is **not yet yaml-driven** — it is built by the hand-written
`build_kinematics_page()` called from `build_unregular_pages()`.

---

## `virtual_preset_keys`

Some keys appear in `s_Preset_*_options` arrays but have **no `ConfigOptionDef`** — they are
handled specially (connectivity settings, identity fields, cross-preset keys). These are declared
in the proto message body using the `virtual_preset_keys` message option:

```protobuf
message PrinterSettings {
  option (virtual_preset_keys) = "printer_technology";
  option (virtual_preset_keys) = "printable_area";
  // ...
  float extruder_clearance_radius = 1 [...];
}
```

The codegen merges them (deduplicated, sorted) into the generated `s_Preset_printer_options` array
alongside the field-derived keys.

Keys defined in `init_common_params()` (like `layer_height`, `elefant_foot_compensation`) that
belong to print presets are also added as `virtual_preset_keys` in `print.proto` since they are
registered in `PrintConfigDef` but not in the proto fields.

---

## Important

### MSBuild doesn't track `#include`d generated files

When you change a `.proto` file or `layout.yaml`, cmake's `codegen_config` target detects it and
reruns the generator. But MSBuild doesn't automatically know that `PrintConfig.cpp` needs
recompiling because its `#include`d file changed.

**Workaround**: After running codegen manually, touch the affected source file:

```pwsh
# PowerShell
(Get-Item src/libslic3r/PrintConfig.cpp).LastWriteTime = Get-Date
(Get-Item src/slic3r/GUI/Tab.cpp).LastWriteTime = Get-Date
```

This is handled automatically when building through VS Code (the cmake `codegen_config ALL` target
triggers before compilation) or through the build scripts.

### Nullable type mismatch crash

If a `coEnums` field has `(is_nullable) = true`, the codegen emits `ConfigOptionEnumsGenericNullable`
as the default value type. If you forget `(is_nullable)` on a field that is declared as
`ConfigOptionEnumsGenericNullable` in a `StaticPrintConfig` struct, the app crashes at startup
with `ACCESS_VIOLATION` during DLL initialization — `StaticCache::finalize()` calls
`opt->set(def->default_value.get())` and the `dynamic_cast` to the nullable type returns null.

**Always match `(is_nullable)` in the proto to the C++ struct member type.**

### `print_config_def` is a global static

`const PrintConfigDef print_config_def;` is a global static in `PrintConfig.cpp`. Its constructor
calls `init_fff_params()` (the generated code) at DLL load time. Any exception or crash in the
generated code causes Windows error 1114 (`DLL_INIT_FAILED`) — the app exits silently before any
window appears.

### `config_metadata_pb2.py` must match `config_metadata.proto`

`tools/config_metadata_pb2.py` is a Python binding auto-generated from `config_metadata.proto`.
If you modify `config_metadata.proto` (e.g. to add a new field annotation), you must regenerate
this file:

```bash
python -m grpc_tools.protoc --proto_path=src/PrintConfigs --python_out=tools/ config_metadata.proto
```

If `config_metadata_pb2.py` is out of sync with `config_metadata.proto`, the codegen will fail
with a cryptic `AttributeError` about a missing extension field.

### `auto page` redeclaration (MSVC)

MSVC rejects redeclaring `auto page = ...` multiple times in the same function scope. The codegen
handles this by using `page = ...` (no `auto`) for the 2nd+ page in each function. If you add
pages manually, follow the same pattern.

---

## Running the codegen manually

```bash
# Full pipeline (compile .proto → generate .cpp → skip validation)
python tools/run_codegen.py

# Full pipeline with validation (checks generated output against original)
python tools/run_codegen.py --validate-only

# Tab layout only (if only layout.yaml changed — faster)
# Not available yet; run the full pipeline instead
python tools/run_codegen.py
```

---

## Files 

| File | Purpose |
|---|---|
| `src/PrintConfigs/config_metadata.proto` | Defines all custom proto extensions (`label`, `tooltip`, etc.) |
| `src/PrintConfigs/print.proto` | All print/process settings |
| `src/PrintConfigs/filament.proto` | All filament/material settings |
| `src/PrintConfigs/printer.proto` | All printer/machine settings |
| `src/PrintConfigs/layout.yaml` | UI tab/page/group layout (drives `TabLayout_generated.cpp`) |
| `tools/config_codegen.py` | The code generator (proto → C++, yaml → C++) |
| `tools/run_codegen.py` | Pipeline script (compile .proto → run generator) |
| `src/slic3r/GUI/TabLayoutExtra.cpp` | Hook implementations for groups that need custom widgets |
| `src/slic3r/GUI/Tab.hpp` | Hook method declarations on tab classes |
