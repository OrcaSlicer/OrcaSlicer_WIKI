# Profile App — Editor System

The Profile App provides schema-driven editor modals for three profile types: printer
variants, processes, and filaments. All three share a common architecture built around
the `useEditorDraft` hook and the `profileAppEditorSchema` engine.

## Editor Architecture

```
EditorModal component
├── Props: { target, data, machineVariants, selectedVariantId, onClose, onSave,
│            commitDraftRef, readonly?, presentation? }
├── useEditorDraft() hook ← draft lifecycle, dirty tracking, focus management
├── Schema: getProfileEditorSchema(kind) → { groups, tabs }
├── State:
│   ├── activeTab (tab navigation)
│   ├── isBaseFile / allPrinters / listAllVendor (editor-specific toggles)
│   ├── compatibleMachineIds / selectedPrinterIds (printer selection)
│   └── activeInherits (inherits chain tracking)
├── Effects:
│   ├── inherits change → rebuild draft from effective config
│   ├── base-file toggle → sync draft.instantiation
│   ├── compatible printers → sync draft.compatible_printers
│   └── unmount → auto-save if dirty
├── Layout:
│   ├── Header: title, close button
│   ├── EditorPresetBar (property search)
│   ├── TabPill row (tab navigation)
│   ├── Main pane: SectionCard → FieldShell → EditableTextField
│   └── Aside: JSON preview, base-file toggle, compatible printers
└── Exit: onSave(draft, target) → handleCommitDraftToRam → IndexedDB
```

## The Three Editors

### Variant Editor (`VariantEditorModal.tsx`)

Edits printer variant presets (`type: machine`). Notable features:

- **Dynamic extruder tab expansion:** If `nozzle_diameter` contains multiple values
  (e.g. `"0.2;0.4;0.6;0.8"` for a multi-extruder printer), the single "Extruder" tab
  is replaced with "Extruder 1" through "Extruder N". Per-extruder values are read and
  written from semicolon-separated or array-formatted fields using `getExtruderValue`
  and `setExtruderValue`, preserving the original format (array stays array, string
  stays string).
- **Layout-driven:** Uses `PRINTER_VARIANT_LAYOUT` from the schema module with
  explicit field grouping.
- **Base-file support:** Toggle between specialized (instantiated) and base-file modes.

### Process Editor (`ProcessEditorModal.tsx`)

Edits process presets (`type: process`). Notable
features:

- **6 tabs:** Quality, Strength, Speed, Support, Multimaterial, Others
- Covers hundreds of individual settings: layer heights, line widths, seams, scarf
  joints, ironing, wall generators, bridging, overhangs, infill patterns, speeds,
  accelerations, jerks, support structures, prime tower, filament assignments, flush
  options, post-processing
- **Setting Overrides tab** (Filament editor): Uses a toggle-override pattern where
  each retraction/ironing setting has a checkbox to enable/disable the override
- Uses option arrays from `processEditorOptions.ts` for dropdowns (seam position,
  wall generator, ironing type, support style, etc.)

### Filament Editor (`FilamentEditorModal.tsx`)

Edits filament presets (`type: filament`). Notable features:

- **Bed temperature sub-card:** Lists 6 bed types (Cool Plate, Textured PEI, etc.)
  each with first-layer and other-layer temperature fields
- **Compatible printer picker:** "All variants" toggle vs granular per-variant
  selection; results stored in `draft.compatible_printers` and the preview-only
  `draft._selected_printers_preview`
- **Auto-commit on unmount:** Uses `dirtyRef` to only save if modified
- **Inherits rebuild:** When the inherits dropdown changes, the draft is rebuilt
  with the new effective config while preserving user-entered fields

## Shared Components

All editors reuse these components from `profileAppSharedComponents.tsx`:

| Component | Purpose |
|---|---|
| `SectionCard` | Collapsible section wrapper with title and tone variants |
| `FieldShell` | Label + unit + description wrapper for individual fields |
| `TabPill` | Pill-style tab navigation button |
| `EditorPresetBar` | Searchable property list for quick field navigation |
| `EditableTextField` | Buffered text input (see below) |
| `BaseFileToggle` | "Is BaseFile" checkbox + inherits dropdown |
| `CompatiblePrintersSelect` | Multi-select checkbox list for printer variants |
| `EditorAsideCards` | Schema context + draft JSON side panels (filament only) |
| `SearchableSelect` | Searchable dropdown with outside-click dismissal |

## EditableTextField — Buffered Input

A critical shared component that solves the "space-eating" bug. OrcaSlicer stores
FloatOrPercent values internally as `"number,boolean"` (e.g. `"10,true"`). The
editor converts to display form (`"10%"`) and back on every keystroke. Without
buffering, the conversion would eat spaces and characters during typing.

**Solution:** `EditableTextField` maintains a local text buffer that only resyncs
from the `value` prop when the field is NOT focused. While the user is typing, the
buffer preserves exact keystrokes. On blur, the buffer commits via `toFloatOrPercentStorage`.

## useEditorDraft Hook

```typescript
useEditorDraft(initialDraft) → {
  draft,              // current draft state
  setDraft,           // direct setter
  updateField,        // (key, value) → normalize + set dirty
  registerFieldElement, // ref callback for DOM focus management
  setPendingFocusKey, // request focus on next render
  markDirty,          // force dirty flag
  dirtyRef,           // ref for unmount-time save gating
}
```

- `updateField(key, value)` — applies `toFloatOrPercentStorage` on string values,
  then marks dirty
- `registerFieldElement(key)` — returns a ref callback for DOM element registration;
  enables auto-focus after property search
- `pendingFocusKey` — auto-scrolls and focuses on next render after property selection
- `dirtyRef` — enables unmount-time save gating (only save if actually modified)

## Schema Engine

The `profileAppEditorSchema.ts` module builds editor schemas from OrcaSlicer's
`.proto` files (imported as raw strings):

### Proto File Mapping

Each profile kind maps to a set of proto source files:

- **Filament:** `filament.proto`, `cooling.proto`, `advanced.proto`, `multimaterial.proto`,
  `notes.proto`, `dependencies.proto`
- **Process:** `quality.proto`, `strength.proto`, `speed.proto`, `support.proto`,
  `multimaterial.proto`, `others.proto`
- **Printer variant:** `basic_information.proto`, `machine_g_code.proto`,
  `extruder.proto`, `machine_limits.proto`

### Field Derivation

Proto types map to editor field kinds:
- `bool` → `boolean` (checkbox)
- `int32` / `float` / `double` → `text` (number input)
- Enum types → `select` (dropdown)
- Multiline strings → `textarea`
- Default → `text`

### Inheritance Resolution

`resolveEffectiveConfig(profileName, allProfiles)` walks the inherits chain
root-first, merging configs. The function includes a cycle guard (via `_visited`
set passed through the recursion). The result is a complete config with all
inherited defaults resolved.

### Layout System

- **Printer variants** use an explicit layout (`PRINTER_VARIANT_LAYOUT`) with
  `GroupLayoutSpec[]` — fields are hand-curated into specific groups.
- **Process and filament** profiles are auto-grouped from proto annotations
  (`tab_type` / `tab_page` / `tab_optgroup`).
- **Synthetic fields** (e.g. `_syn_printable_area`) have no proto backing and are
  rendered from spec values only.

## Instantiation Semantics

```
instantiation: false  → Base File (template, not directly used for slicing)
instantiation: true   → Specialized (instantiated, compatible with specific printers)
instantiation: absent → Treated as true (specialized) — legacy default
```

Base files provide inherited defaults for specialized presets. They appear in the UI
under "Base Files" sections and are selectable as inherits parents but not as
active slicing presets.

## Compatible Printers Convention

An empty `compatible_printers` array in a process or filament preset means
**"compatible with ALL variants."** A non-empty array lists specific variant names.
The filament editor uses an `allPrinters` boolean flag to toggle between these modes.

During extraction, `compatible_printers` resolution walks the inherits chain:
if a profile has no own `compatible_printers` (key absent), it inherits from its
parent. If the key is present but empty, it's treated as "compatible with all"
(authoritative — no inheritance walk).

## FloatOrPercent Handling

OrcaSlicer stores dimensional values as `"10%"` (percentage) or `"10"` (absolute mm).
The editor uses an internal `"number,boolean"` representation for UI convenience
(`"10,true"` = `"10%"`, `"10,false"` = `"10"`).

Two helpers manage the conversion:
- `toFloatOrPercentDisplay(stored)` → `"10%"` / `"10 mm"` for display
- `toFloatOrPercentStorage(display, previous)` → `"10,true"` / `"10,false"` for storage

The storage converter only converts when the previous value is already in internal
format — preventing non-FloatOrPercent fields like `wall_loops` from being corrupted.
