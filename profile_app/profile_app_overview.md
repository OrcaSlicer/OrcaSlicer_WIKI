# Profile App — Overview

The **Profile App** is a feature within Orca Cloud that provides a browser-based editor for
OrcaSlicer vendor profile data. It lets you create, edit, and manage printer models,
machine variants, print processes, and filament profiles — all organized by vendor — and
sync them to Cloudflare R2 for backup and sharing. The exported profiles are
OrcaSlicer-compatible JSON files that drop directly into `resources/profiles/`.

## Key Capabilities

- **Browse vendors** from the OrcaSlicer ecosystem or create custom vendors from scratch
- **Edit profiles** through schema-driven JSON forms with property search
- **Manage printer models** with nozzle diameter selection, default materials, and model assets
- **Sync projects** bidirectionally between browser IndexedDB and Cloudflare R2
- **Download complete vendor bundles** as ZIP files for OrcaSlicer
- **Export normalization** guarantees every file OrcaSlicer loads is structurally valid

## Architecture at a Glance

```
ProfileApp (React + TypeScript)
├── useProfileAppState        ← All state, effects, handlers (extracted hook)
├── UI Layer
│   ├── ProfileAppPage        ← View coordinator (440 lines)
│   ├── LandingScreen         ← Open / create project flow
│   ├── VariantSection        ← Sidebar: printer variants
│   ├── ProcessSection        ← Sidebar: processes
│   ├── FilamentSection       ← Sidebar: filaments
│   └── Editor Modals         ← Filament / Process / Variant editors
├── Persistence Layer
│   ├── IndexedDB             ← Primary local storage (per-project databases)
│   ├── R2 (Cloudflare)       ← Remote canonical store
│   ├── localStorage          ← Project names, vendor list cache
│   └── Gateway (Hono/CF)     ← Signed upload URLs, ZIP download, R2 proxy
└── Export Pipeline
    ├── normalizeProfileContentForExport  ← Per-file rules
    └── sanitizeVendorRootsForExport      ← Cross-file manifest guard
```

## Data Flow Summary

```
R2 (source of truth)  ←→  IndexedDB (cache)  →  RAM (editing)  →  R2 (sync)
```

1. **Open Project** — Load vendor root JSON and all profile files from IndexedDB (with R2
   fallback), populate React state.
2. **Edit** — Editor modals modify in-memory state only; background writes to IndexedDB.
3. **Sync to R2** — Build upload list from RAM + IndexedDB, normalize via export pipeline,
   upload in batches via signed URLs.
4. **Download ZIP** — Gateway reads all R2 objects under the project prefix, builds ZIP
   in memory, streams to browser.

## Directory Structure

```
apps/cloud-frontend/src/features/profileApp/pages/
├── ProfileAppPage.tsx              # View coordinator — composes the UI
├── useProfileAppState.ts           # Core state hook (~2,200 lines)
├── LandingScreen.tsx               # Landing page
│
├── VariantSection.tsx              # Printer variants sidebar
├── ProcessSection.tsx              # Processes sidebar
├── FilamentSection.tsx             # Filaments sidebar
│
├── VariantEditorModal.tsx          # Printer variant editor
├── ProcessEditorModal.tsx          # Process editor (~3,500 lines)
├── FilamentEditorModal.tsx         # Filament editor
│
├── PrinterModelForm.tsx            # Printer model create/edit
├── profileAppCreateModals.tsx      # Unified create modal
│
├── useEditorDraft.ts               # Draft lifecycle hook
├── profileAppEditorSchema.ts       # Schema engine (proto-driven)
├── EditableTextField.tsx           # Buffered text input
│
├── r2Gateway.ts                    # R2 API client
├── profileAppR2Sync.ts             # Sync orchestrator
├── profileAppIndexedDb.ts          # IndexedDB CRUD
├── vendorFileLoader.ts             # R2 → IndexedDB hydration
├── zipUtils.ts                     # ZIP download/extract
│
├── exportNormalization.ts          # Export-boundary serializer
├── profileDataExtractor.ts         # Root JSON → profile data mapper
├── vendorListUtils.ts              # List merge/dedup helpers
├── contentPredicates.ts            # Pure predicate functions
│
├── types.ts                        # All feature types
├── constants.ts                    # Feature constants
└── profileAppShared.ts             # JSON serializer + helpers
```

**Source:** 35 files, ~13,000 lines of TypeScript/TSX.
**Tests:** 10 test files, 54 profileApp-specific tests.

## Key Design Decisions

### No external state library
All state lives in React `useState` / `useRef` within a single `useProfileAppState` hook.
This keeps the data flow transparent — every mutation is traceable through the hook's
handler functions.

### Per-project IndexedDB databases
Each project gets its own IndexedDB database (`orca-profile-app-db_{scopeKey}`). Keys
within are simple (scoped to the DB name, not the key). This was a breaking change from
the original single-database architecture and enables clean project isolation.

### Export-boundary normalization
The app stores and edits values in its own internal formats. A single normalization choke
point at upload converts everything to OrcaSlicer-compatible JSON. In-app state is
untouched — normalization is pure and export-only. See [Export Pipeline](profile_app_export_pipeline) for all rules.

### Three-tier data source
IndexedDB (fastest) → R2 user project → R2 global profiles. Fallback chains are used
throughout data loading, ensuring files are available even when the network is down.

### Timestamp-aware sync
R2 object `uploaded` timestamps are compared against IndexedDB `updatedAt` to download
only changed files. See [Persistence](profile_app_persistence) for details.

## Vendor Root JSON

Every vendor has a root JSON file (e.g. `Afinia.json`) that serves as the authoritative
registry. See [Vendor Root JSON](profile_app_vendor_root_json) for the full specification
and critical rules.
