# Publish 3MF

> [!IMPORTANT]
> NEW FEATURE: **Publish 3MF**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **<stable version at merge time>**.

**Publish 3MF** lets you export a project as a 3MF file with selected print, filament and printer settings embedded. Whoever opens the published file gets your configuration alongside the geometry, so a shared model slices exactly the way you intended.

- [Overview](#overview)
- [Publishing a project](#publishing-a-project)
    - [Accessing the dialog](#accessing-the-dialog)
    - [Selecting settings](#selecting-settings)
    - [Printer tab](#printer-tab)
    - [Process tab](#process-tab)
    - [Filament tab](#filament-tab)
    - [Mixed filament slots](#mixed-filament-slots)
- [Opening a published 3MF](#opening-a-published-3mf)
- [Compatibility notes](#compatibility-notes)

## Overview

A regular 3MF export saves geometry plus a snapshot of the currently selected presets. A published 3MF goes further: you choose exactly which settings travel with the file — nothing more, nothing less. Typical uses:

- Sharing a calibrated model together with the profile it was tuned for.
- Sending a print job to another machine without dictating settings you consider optional.
- Distributing a "known good" configuration for a specific object.

## Publishing a project

### Accessing the dialog

Open the menu **File → Publish 3MF…**, or press `Ctrl`+`Shift`+`E`. The publish dialog lists every setting that differs from the base presets of your current project.

<!-- TODO: screenshot of the Publish 3MF dialog -->

*[Screenshot placeholder: the Publish 3MF dialog]*

### Selecting settings

The top bar of the dialog contains:

- A **filter box** to narrow the list by setting name ("Type to filter...").
- **All** and **None** buttons to check or uncheck everything at once.
- A filter menu (right-click or the menu button) with:
    - Select All / Deselect All
    - Select visible / Deselect visible (applies only while a text filter is active)
    - Filter selected / Filter non-selected

<!-- TODO: screenshot of selection controls -->

*[Screenshot placeholder: filter bar and selection controls]*

### Printer tab

Lists printer settings such as retraction and Z-hop options from the printer preset. Check the individual rows you want embedded in the published file.

<!-- TODO: screenshot of the Printer tab -->

*[Screenshot placeholder: the Printer tab]*

### Process tab

Lists process (print settings) entries that differ from the system preset — layer height, speeds, walls, infill and so on. Check the rows you want to publish.

<!-- TODO: screenshot of the Process tab -->

*[Screenshot placeholder: the Process tab]*

### Filament tab

The filament section shows one entry per loaded filament slot with its material type and color. Each category can be toggled with an **Enable** checkbox.

For each slot you can additionally choose:

- **Full Publish** — embeds the complete filament preset for that slot instead of only selected keys.
- A required **material type** — the receiving side will only apply matching filaments.

<!-- TODO: screenshot of the Filament tab -->

*[Screenshot placeholder: the Filament tab]*

### Mixed filament slots

Projects using mixed (multi-material blended) filament slots publish those slots as a whole when their category is enabled. The blend definition — which slots are mixed, the mixing ratios and any gradient information — is included automatically so the mix survives on the other side.

## Opening a published 3MF

When a published 3MF is opened in OrcaSlicer:

- Selected print and printer settings are applied to the recipient's current presets.
- Selected filament values are applied slot by slot, matching the author's slot order.
- Settings marked **Full Publish** become standalone filament presets embedded inside the opened project. They live only within that project — the recipient's own preset library is never modified, nor are existing presets overwritten or auto-selected.
- Required material types are checked before applying; a mismatched slot is replaced by a same-type filament from the recipient's library where possible.

## Compatibility notes

Older versions of OrcaSlicer that do not support publishing simply ignore the embedded settings and open the file's geometry only. The model always opens; no error is shown.
