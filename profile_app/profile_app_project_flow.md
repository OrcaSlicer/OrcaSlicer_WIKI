# Profile App — Project Open, Sync, and Data Flow

This page documents the complete lifecycle of a Profile App project: how it is created,
how data flows from R2 through IndexedDB to the UI, how edits are committed, and how
the final export reaches OrcaSlicer.

## 1. Opening a Project

### Landing Screen Flow

The `LandingScreen` component presents two options:

- **Open Project** — select from a list of previously saved project names
- **New Project** — select an existing vendor from R2 or create a custom vendor

When opening a project, the vendor name is resolved from the project folder via:

```
resolveVendorNameFromProjectFolder(R2)   ← try R2 first
  ↓ (if not found)
resolveVendorNameFromIndexedDb(IndexedDB) ← fallback for unsynced projects
```

### Data Loading Sequence

Once the vendor is resolved, `openExplorer(vendorId)` triggers the main loading
pipeline:

```
openExplorer(vendorId)
  └─ sets view="explorer", shows loading UI immediately
        │
        ▼
useEffect → loadSelectedVendorProfile()
  ├─ loadVendorRootProfileFromUserProject()
  │   └─ IndexedDB → R2 user project → R2 global → fallback
  │       Returns: { payload: VendorRootProfilePayload, source: 'indexeddb'|'r2'|'fallback' }
  │
  ├─ fetchAndStoreVendorFilesFromUserProject()
  │   └─ Loads ALL vendor files from IndexedDB (with R2/zip fallback)
  │       Each file is stored in the per-project IndexedDB database
  │
  ├─ fetchAndStoreVendorFiles(OrcaFilamentLibrary)
  │   └─ Loads global filament library (shared across all vendors)
  │
  ├─ mapVendorRootToProfileData(rootPayload)
  │   └─ Parses the four vendor root lists and builds initial state arrays
  │
  ├─ profileDataExtractor (machine, process, filament files)
  │   └─ Reads individual JSON files, resolves inherits chains,
  │       filters by instantiation, resolves compatible printer lists
  │
  └─ setData({ printerModels, variantProfiles, processes, filaments })
      └─ Populates RAM — UI renders
```

> [!IMPORTANT]
> `openExplorer` fires **immediately** so the loading UI is visible. The slow
> `syncIndexedDbFromR2` runs in the background as a fire-and-forget to prime
> IndexedDB for the next session. This prevents a frozen landing page.

### Model-Variant Routing

During data extraction, model and variant files are cross-checked against the vendor
root JSON's list entries:

- A file with `type: machine` found under `machine_model_list` gets **routed** to
  the variant profiles array
- A file with `type: machine_model` found under `machine_list` gets **routed** to
  the printer models array

This routing ensures mismatches between list entries and file types don't silently
corrupt the data model. The export pipeline's `sanitizeVendorRootsForExport` prevents
these mismatches from reaching OrcaSlicer.

### Auto-Population of Empty Models

If `machine_model_list` is empty (e.g., a brand-new custom vendor), the app generates
a fallback model named `"{vendor.name} Model"` with a 0.4mm nozzle. This ensures the
UI has at least one model to display, and the user can immediately edit or replace it.

## 2. Editing

### RAM-Only Edits

```
User opens editor for a profile
        │
        ▼
Editor modal renders with draft state (local useState + useEditorDraft hook)
        │
        ▼
User modifies fields → onChange → updateField(key, value)
        │
        ▼
User clicks Cancel  OR  switches to another profile  OR  modal unmounts
        │
        ▼
onSave(draft, target) → handleCommitDraftToRam()
  └─ setData(…) only — in-memory profile list updated
     IndexedDB write happens via scheduleWrite() in background (fire-and-forget)
```

Every editor modal has a `useEffect` cleanup that calls `onSave` on unmount, so
switching profiles auto-commits the draft to RAM. The `dirtyRef` pattern gates saves
to prevent unnecessary writes.

### Draft Lifecycle

The `useEditorDraft` hook manages the draft lifecycle:

1. **Initialize** — build initial draft from effective config (inherits chain resolved)
2. **Edit** — user modifies fields; `updateField` applies FloatOrPercent normalization
   and marks dirty
3. **Commit** — on unmount or explicit save, `onSave(draft, target)` merges draft into
   the in-memory profile and schedules an IndexedDB write
4. **Switch inherits** — when the user changes the inherits dropdown, the draft is
   rebuilt from the new effective config while preserving user-entered name, inherits,
   compatible_printers, and instantiation

### Creating New Profiles

The `AddProfileModal` handles creation of all profile types through a unified interface.
Each type auto-generates a JSON draft:

- **Printer variant:** `buildVariantJsonDraft(name, inherits)` — includes inherits,
  instantiation, printer_model, printer_variant, nozzle_diameter
- **Process:** `buildProcessJsonDraft(name, inherits, compatibleMachineIds)` — includes
  inherits, instantiation, compatible_printers
- **Filament:** `buildFilamentJsonDraft(name, inherits, compatibleMachineIds)` — includes
  inherits, instantiation, compatible_printers
- **Printer model:** `buildPrinterModelJsonDraft(name)` — includes type, model_id,
  nozzle_diameter, family, default_materials

The JSON textarea in the create modal allows editing the raw JSON before creation.
Duplicated name validation is performed across all profile types.

## 3. Syncing to R2

```
User clicks "Sync All to R2"
        │
        ▼
handleSaveProjectToR2()
  ├─ Commit any open editor draft to RAM (via commitEditorDraftRef)
  ├─ Read all profiles from data state (RAM):
  │   variantProfiles, processes, filaments, vendor root JSON
  ├─ Load machine model files from IndexedDB (with embedded image extraction)
  ├─ Build upload file list with R2 object keys
  ├─ uploadProfileAppAssetsToR2(config, files, overwrite=true)
  │   ├─ sanitizeVendorRootsForExport (cross-file manifest guard)
  │   ├─ normalizeProfileContentForExport + toOrcaJson per file
  │   ├─ batch-upload-urls (gateway POST, up to 2000 files)
  │   ├─ PUT each file to signed upload URL
  │   ├─ POST complete URL for each file
  │   └─ byte_size verification (spec matches uploaded body)
  └─ syncIndexedDbFromR2()
      → refresh IndexedDB from canonical R2 store
```

### Machine Model File Handling

Machine model files (`type: machine_model`) are stored in IndexedDB separately from
the React state arrays. During sync, they are loaded from IndexedDB by matching
`model.sourceFile` against stored file paths. Files containing embedded base64 image
data (under keys like `_cover_image_data`) have the images extracted as separate
binary upload entries and stripped from the JSON content.

## 4. Downloading as ZIP

```
User clicks "Download ZIP"
        │
        ▼
handleDownloadProject()
  ├─ Gateway GET /api/v1/profile-assets/download
  │   query: user_id, project_name
  ├─ Gateway lists all R2 objects under users/{userId}/{projectName}/
  ├─ Gateway reads each R2 object's raw bytes
  ├─ Gateway buildZip() → in-memory ZIP (no re-serialization)
  └─ Browser download (application/zip)
```

> [!NOTE]
> The ZIP contains the raw R2 bytes — the same normalized JSON that was uploaded
> during sync. No re-serialization happens on download, ensuring byte-for-byte
> fidelity with the uploaded content.

## 5. Multi-Machine Workflow

1. **Machine A** opens project → syncs IndexedDB from R2 → edits → Sync All → R2 updated
2. **Machine B** opens same project → `syncIndexedDbFromR2` compares timestamps → R2
   files are newer → downloads only changed files → IndexedDB up to date
3. Machine B now working on latest data

No merge conflicts — last write wins at the file level. The timestamp strategy ensures
only changed files are transferred, keeping sync fast even for large vendors.

