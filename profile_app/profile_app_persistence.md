# Profile App — Persistence Layers

The Profile App uses four persistence layers to store and synchronize profile data.
Each layer serves a specific purpose in the data flow.

## Layer Overview

```
R2 (source of truth)  ←→  IndexedDB (cache)  →  RAM (editing)  →  R2 (sync)
```

| Layer | Technology | Location | Role |
|---|---|---|---|
| **R2** | Cloudflare R2 | `users/{userId}/{projectName}/` | Canonical store. Every JSON file has an `uploaded` timestamp set by R2 on PUT. |
| **IndexedDB** | Browser native | `orca-profile-app-db_{userId}_{projectName}` | Local cache. Stores every profile file keyed by scoped path. Records have `updatedAt` (ms) and JSON `content`. |
| **RAM** | React `useState` | `data` in `useProfileAppState` | Working copy. All edits happen here. Committed to R2 only on "Sync All". |
| **localStorage** | Browser native | Multiple keys | Project names list, vendor list cache (5-min TTL), global filaments once-copy flag. |

## IndexedDB

### Database Structure

Each project gets its own database: `orca-profile-app-db_{userId}_{projectName}`.

This is a per-project isolation design — keys within each database are simple since
scope is encoded in the database name.

### Object Stores

**`vendorFiles` store:**
- Keyed by `fileStorageKey` (normalized `sourceFilePath`)
- Indexed by `byVendorKey` (vendor name)
- Records contain: `filePath`, `vendorKey`, `content` (JSON), `rawText` (original
  JSON formatting for unedited files), `updatedAt` (ms timestamp)

**`vendorRootJson` store:**
- Keyed by scoped vendor key
- Records contain: `content` (the full vendor root JSON), `updatedAt`

### Write Strategy

All IndexedDB writes use a retry wrapper (`indexedDbService.ts`) with 3 attempts and
exponential backoff (400ms / 800ms / 1600ms). Writes are fire-and-forget via
`scheduleWrite()` — the UI updates immediately while persistence happens in the
background.

During the initial loading phase only, writes are awaited with `writeWithRetry()` to
ensure data is ready before the UI renders.

### Timestamp Storage

The key `_profileAppLastModified` is injected into JSON content during
`syncIndexedDbFromR2`. It is stamped from the R2 `uploaded` value and stored as a
convenience copy. It is **not** read during timestamp comparison — only R2 `uploaded`
metadata and IndexedDB `updatedAt` participate.

## R2 (Cloudflare Remote Storage)

### Key Convention

- **Global profiles:** `profiles/{VendorName}.json`, `profiles/{VendorName}/machine/...`
- **User projects:** `users/{userId}/{projectName}/{VendorName}/...`

Global profiles are read-only vendor data seeded from the OrcaSlicer ecosystem. User
projects contain the user's edits and custom profiles.

### Operations

| Operation | Gateway Endpoint | Notes |
|---|---|---|
| List files | `GET /list` | Paginated, returns `{key, uploaded}` per object |
| Read file | `GET /object` | Returns raw bytes; used by sync for JSON + binary |
| Upload files | `POST /batch-upload-urls` | Up to 2000 files per batch |
| Signed PUT | `PUT /:encodedKey/content` | Per-file upload to pre-signed URL |
| Complete | `POST /:encodedKey/complete` | Confirms multipart upload |
| Download ZIP | `GET /download` | Streams all project files as ZIP |
| Copy vendor | `POST /copy-vendor-to-user` | Clones global vendor to user project |

### Signed URL Security

Upload URLs are HMAC-SHA256 signed with a configurable TTL (`UPLOAD_URL_TTL_SECONDS`,
default 3600s). The signature payload includes the object key, user ID, and
expiration time. All gateway routes require Supabase authentication.

## localStorage

Used for lightweight, non-critical caching:

| Key | Content | TTL |
|---|---|---|
| `orca-cloud-top-level-vendors:{userId}` | Cached vendor list with `fetchedAt` | 5 minutes |
| `orca-profile-project-names:{userId}` | Project names array | None (persistent) |
| `orca-profile-project-name:{userId}` | Last selected project name | None (persistent) |
| `orca-r2-global-filaments-once:{scopeKey}` | Flag: global filaments already copied | Permanent |

The vendor list cache avoids repeated R2 list calls during a session. The global
filaments flag tracks whether the OrcaFilamentLibrary files have been copied to
the user project (only needs to happen once per project).

## Sync Flow

### Sync All to R2

```
handleSaveProjectToR2()
  ├─ Build file list from RAM (variants, processes, filaments, root)
  ├─ Load machine model files from IndexedDB (with embedded image extraction)
  ├─ sanitizeVendorRootsForExport (cross-file manifest guard)
  ├─ normalizeProfileContentForExport (per-file rules)
  ├─ toOrcaJson (tab + CRLF serialization)
  ├─ uploadProfileAppAssetsToR2 → batch-upload-urls → PUT per file → complete
  └─ syncIndexedDbFromR2 → refresh IndexedDB from canonical R2 store
```

### Timestamp-Aware Sync (`syncIndexedDbFromR2`)

```
1. listAllProfileAssetObjects() → one API call, all files + R2 uploaded timestamps
2. For each R2 object:
     r2Time = entry.uploaded * 1000    (R2 seconds → ms)
     idbTime = indexedDbMap.get(r2KeyToIdbPath(entry.key))
     if idbTime is missing OR r2Time > idbTime:
       download file from R2 → stamp _profileAppLastModified → store in IndexedDB
3. Return { synced: N, skipped: M }
```

Only files with newer R2 timestamps are downloaded — unchanged files are skipped.
This enables efficient multi-machine workflows: Machine A syncs edits to R2, Machine B
opens the project and downloads only the changed files.

### Initial Project Load

When a project is first opened, files are loaded through a three-tier fallback:

1. **IndexedDB** — fastest; if files exist with valid timestamps, use them
2. **R2 user project** — if files exist in the user's R2 folder, download and cache
3. **R2 global profiles** — fallback: download the vendor `.zip` from global R2,
   extract JSON files, upload any images to the user's project

> [!NOTE]
> The `.zip` download approach dramatically reduces the number of R2 API calls
> compared to listing individual files. A single ZIP request replaces hundreds of
> individual file downloads during initial project setup.

## Data Integrity Guards

### Byte-Size Verification

During batch upload, the `byte_size` sent in the batch-upload-urls request matches
the actual uploaded body. Both are computed from the same normalized JSON string,
ensuring no drift between the metadata spec and the actual payload.

### Cross-File Manifest Validation

Before upload, `sanitizeVendorRootsForExport` checks every `machine_list` entry
against its target file's `type` field in the upload set. Entries targeting
`machine_model` files are stripped.

### Round-Trip Format Preservation

The `rawText` field on IndexedDB records preserves original JSON formatting for
files that haven't been edited — ensuring re-uploads of unmodified files match
their original form exactly.

## Edge Cases

- **Empty R2 (new project):** `syncIndexedDbFromR2` returns `{synced:0, skipped:0}`.
  ZIP extraction from global `profiles/{vendorName}.zip` populates IndexedDB.
- **IndexedDB unavailable:** `syncIndexedDbFromR2` short-circuits, returns zeros.
- **Individual file download fails:** Skipped silently, retried on next sync.
- **Non-JSON files:** Filtered out during sync (only `.json` processed).
- **R2 key → IndexedDB path mismatch:** `r2KeyToIdbPath` normalizes before lookup.
- **Cross-vendor preset name collision:** First vendor alphabetically wins;
  duplicates in later vendors are discarded.
- **Stale AppData cache:** OrcaSlicer only re-syncs from `resources/profiles` when
  the vendor JSON `version` increases. Bump the version or delete the cached
  vendor folder when testing regenerated profiles.
