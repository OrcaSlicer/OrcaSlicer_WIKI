# Profile App — State Management

All Profile App state lives in a single React hook: `useProfileAppState`. There is no
external state library — everything is `useState`, `useRef`, `useEffect`, and
`useCallback`.

## Hook Overview

```typescript
useProfileAppState(userId: string, userEmail: string) → {
  // View state
  view, setView,
  data, setData,
  query, setQuery,

  // Selections
  selectedVendorId, setSelectedVendorId,
  selectedVariantId, setSelectedVariantId,
  selectedPrinterModelId, setSelectedPrinterModelId,
  setSelectedProcessBaseFileId,

  // Modal / editor state
  addModalKind, setAddModalKind,
  isCreatePrinterModalOpen, setIsCreatePrinterModalOpen,
  editingPrinterModelId, setEditingPrinterModelId,
  editingProfile, setEditingProfile,

  // Vendor / project state
  topLevelVendors, topLevelVendorsLoading, topLevelVendorsError,
  selectedVendorProfileLoading, selectedVendorProfileError,
  selectedVendorRootJson, selectedVendorRootJsonSource,
  savedProjectNames,
  currentProjectName, setCurrentProjectName,
  isProjectSaveInProgress, lastProjectSavedAt,
  saveNotice, setSaveNotice,
  isProjectDownloadInProgress,

  // Derived values
  selectedVendor, vendorSelectionNames,
  selectedPrinterModel, selectedVariant,
  filteredPrinterModels,
  visibleVariants, visibleBaseFilesForVariants,
  visibleProcesses, visibleProcessBaseFiles,
  visibleSpecializedFilaments, visibleFilamentBaseFiles, visibleGlobalFilaments,
  activeVariantIds,

  // Handlers
  handleLandingCreateVendor,
  handleSelectExistingGitHubVendor,
  handleSaveProjectToR2,
  handleDownloadProject,
  handleCreate,
  handleCreatePrinterWithNozzles,
  handleSavePrinterModelEdit,
  handleSelectPrinterModel,
  handleCommitDraftToRam,
  lazyFetchProjectNames,

  // Refs
  commitEditorDraftRef,

  // Misc
  userEmail,
}
```

## Core State Shape

```
view: 'landing' | 'explorer'

data: {
  vendors: Vendor[]           // available vendors
  printerModels: PrinterModel[]     // machine_model entries
  variantProfiles: VariantProfile[]  // type: machine presets
  processes: ProcessProfile[]        // type: process presets
  filaments: FilamentProfile[]       // type: filament presets
}

selectedVendorId       → resolves to selectedVendor
selectedPrinterModelId → resolves to selectedPrinterModel
selectedVariantId      → resolves to selectedVariant

editingProfile: EditorTarget | null    // currently open editor
addModalKind: ModalKind | null         // open create modal type
selectedVendorRootJson: VendorRootProfilePayload | null

currentProjectName: string
savedProjectNames: string[]
isProjectSaveInProgress: boolean
isProjectDownloadInProgress: boolean
lastProjectSavedAt: number | null
saveNotice: { kind, message } | null   // auto-dismissing notification
```

## Derived Values

These are computed on each render from the core state:

| Value | Derivation |
|---|---|
| `selectedVendor` | `data.vendors.find(id)` |
| `selectedPrinterModel` | `data.printerModels.find(id)` |
| `selectedVariant` | `data.variantProfiles.find(id)` |
| `filteredPrinterModels` | `printerModels` filtered by `query` search |
| `visibleVariants` | `variantProfiles` where `instantiation === true` and `printerModelId` matches |
| `visibleBaseFilesForVariants` | `resolveInheritedBaseFiles()` recursive chain from specialized variants |
| `visibleProcesses` | Processes filtered by variant compatibility + specialized |
| `visibleProcessBaseFiles` | Process files with `instantiation === false` |
| `visibleSpecializedFilaments` | Filaments filtered by variant + `instantiation === true` |
| `visibleFilamentBaseFiles` | Filament files with `instantiation === false` |
| `visibleGlobalFilaments` | OrcaFilamentLibrary presets (read-only, `instantiation === false`) |
| `activeVariantIds` | Collected from `compatible_printers` of visible processes/filaments |

## Key Handlers

### `handleCreate(payload: AddModalPayload)`

Creates any profile type through the unified `AddProfileModal`. The payload includes
`kind`, `name`, `inherits`, and optional JSON textarea content. The handler:

1. Parses the JSON textarea into a config object (if provided)
2. Validates for duplicate names within the profile type
3. Builds the profile object with metadata keys extracted from config
4. Appends to the in-memory state array
5. Updates the vendor root JSON lists (machine_list, process_list, filament_list,
   machine_model_list as appropriate)
6. Schedules IndexedDB writes for both the new profile file and the updated root JSON

### `handleCreatePrinterWithNozzles(payload)`

Creates a printer model with multiple nozzle variants simultaneously:

1. Parses nozzle diameters from the provided JSON or payload
2. Creates one `PrinterModel` + N `VariantProfile` entries (one per nozzle)
3. Adds the model to `machine_model_list` in the vendor root
4. Adds each variant to `machine_list` in the vendor root
5. Persists model file, variant files, and updated root JSON to IndexedDB

### `handleSavePrinterModelEdit(nextName, payload)`

Updates a printer model's name and nozzle configuration:

1. Updates the model name in the state array
2. Regenerates variant entries: removes deleted nozzles, creates new ones
3. Rebuilds both `machine_model_list` and `machine_list` entries using
   `rebuildMachineListForModel` (which ensures model entries are NOT in `machine_list`)
4. Persists all changed files to IndexedDB

### `handleCommitDraftToRam(draft, target)`

Called by editor modals on save/close:

1. Finds the target profile in the in-memory state array
2. Merges the editor draft into the profile's config, stripping metadata keys
3. For filament edits, persists `compatible_printers` as name strings (round-trip safe)
4. For variant edits, persists `printer_model` as the model name (not ID)
5. Updates the state array and schedules IndexedDB write

### `handleSaveProjectToR2()`

Initiates the full sync-to-R2 flow (documented in
[Project Flow](profile_app_project_flow)):

1. Commits any open editor draft via `commitEditorDraftRef`
2. Builds the upload file list from RAM + IndexedDB
3. Calls `uploadProfileAppAssetsToR2` with normalization applied
4. Refreshes IndexedDB from R2 via `syncIndexedDbFromR2`

## The `commitEditorDraftRef` Pattern

The profile page passes a ref (`commitEditorDraftRef`) to each editor modal. The
editor sets this ref to its own save function when mounted. When the user clicks
"Sync All to R2" while an editor is open, the sync handler calls the ref to commit
the current draft to RAM before building the upload list. This avoids losing unsaved
work without requiring the user to manually close the editor.

## Background IndexedDB Writes

All IndexedDB writes go through `scheduleWrite()` — a fire-and-forget wrapper with
3 retries and exponential backoff. The UI updates immediately (via `setData`) while
persistence happens in the background. This keeps the UI responsive even when
IndexedDB is under load.

## Save Notice

A floating notification system (`saveNotice`) provides user feedback:

```typescript
saveNotice: { kind: 'project' | 'printer-variant' | 'process' | 'filament', message: string } | null
```

Notices auto-dismiss after 2.8 seconds. They are used for success messages
("Project saved"), validation warnings ("A variant named X already exists"),
and error messages ("Gateway URL is not configured").

## View State Machine

```
'landing' ←→ 'explorer'

landing  → LandingScreen (open/create project)
explorer → full 4-column editor layout
```

Switching between views is handled by `setView()`. The `openExplorer(vendorId)`
helper sets `view = 'explorer'` and triggers the data loading pipeline.
