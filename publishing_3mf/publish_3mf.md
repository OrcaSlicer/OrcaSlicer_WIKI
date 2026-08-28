# Publish 3MF

> [!IMPORTANT]
> NEW FEATURE: **Publish 3MF**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **<stable version at merge time>**.

**Publish 3MF** lets you export a project as a 3MF file with selected print, filament and printer settings embedded. Whoever opens the published file gets your configuration alongside the geometry, so a shared model slices exactly the way you intended.

Unlike a 3MF that's generated from saving a project, this published 3MF format does not modify your printer setup when imported.

- [Overview](#overview)
- [Publishing a project](#publishing-a-project)
    - [Accessing the dialog](#accessing-the-dialog)
    - [Selecting settings](#selecting-settings)
    - [Printer tab](#printer-tab)
    - [Filament tab](#filament-tab)
    - [Mixed filament slots](#mixed-filament-slots)
    - [Process tab](#process-tab)
- [Publishable settings](#publishable-settings)
    - [Printer settings](#printer-settings)
    - [Filament settings](#filament-settings)
    - [Process settings](#process-settings)
- [Opening a published 3MF](#opening-a-published-3mf)
- [Compatibility notes](#compatibility-notes)

## Overview

A regular project save embeds a snapshot of the full project configuration and the presets in use. A published 3MF goes further in the other direction: it is deliberately minimal — you choose exactly which settings travel with the file, nothing more, nothing less. Typical uses:

- Sharing a calibrated model together with the profile it was tuned for.
- Sending a print job to another machine without dictating settings you consider optional.
- Distributing a "known good" configuration for a specific object.

## Publishing a project

### Accessing the dialog

Open the menu **File → Publish 3MF…**, or press `Ctrl`+`Shift`+`E` (available whenever the project holds at least one object). The dialog lists every publishable setting across its three tabs — **Printer**, **Filament** and **Process**. Settings that differ from the base presets of your current project are **pre-checked and shown bold**; everything else starts unchecked but can still be selected.

<!-- TODO: screenshot of the Publish 3MF dialog -->

*[Screenshot placeholder: the Publish 3MF dialog]*

### Selecting settings

Each row shows the setting name with its current value and unit. The top bar of the dialog contains:

- A **filter box** to narrow the list by setting name ("Type to filter...").
- **All** and **None** buttons to check or uncheck everything at once.
- A filter menu (right-click or the menu button) with:
    - Select All / Deselect All
    - Select visible / Deselect visible (only available while a filter is active)
    - Filter selected / Filter non-selected — show only the checked / unchecked rows; while one is active a chip replaces **All**/**None** in the bar, and clicking the chip clears it

Publishing is always allowed: if nothing is checked the file carries only the geometry plus the identity keys that are always embedded (see [Publishable settings](#publishable-settings)).

<!-- TODO: screenshot of selection controls -->

*[Screenshot placeholder: filter bar and selection controls]*

### Printer tab

One inner tab per extruder (named like the printer preset's extruders, e.g. **Extruder 1** or **Left Extruder**), each listing that extruder's **Retraction** and **Z-Hop** settings with its own values. Selection is independent per extruder: a checked row publishes exactly that extruder's value.

<!-- TODO: screenshot of the Printer tab -->

*[Screenshot placeholder: the Printer tab]*

### Filament tab

One inner tab per loaded filament slot, labeled with the preset name and its color chip. A slot publishes nothing until its **Enable** checkbox is ticked — until then the rest of the page stays hidden. An enabled slot offers:

- A **Material** group with two optional requirement rows: **Color** (the filament color the slot must carry) and **Type** (the required vendor-agnostic material family, e.g. `PLA`). These don't publish setting values — they constrain what the receiving side applies (see [Opening a published 3MF](#opening-a-published-3mf)).
- **Full Publish** — embeds the complete filament preset for that slot instead of individual keys; while it is checked the per-setting rows are disabled.
- The selectable setting groups **Retraction** and **Retraction when switching material** (see [Filament settings](#filament-settings)).

Mixed-color slots are listed on a second tab row below the physical ones — see [Mixed filament slots](#mixed-filament-slots).

<!-- TODO: screenshot of the Filament tab -->

*[Screenshot placeholder: the Filament tab]*

### Mixed filament slots

Mixed (multi-material blended) filament slots appear in their own tab strip under the Filament tab, titled by their composition — for example `1 (60%) + 2 (40%)`, or an arrow (`1 → 2`) for gradient mixes. A mixed slot has no per-setting rows and no Full Publish toggle: enabling it publishes the slot as a whole unit. The blend definition — which slots are mixed, the sublayer ratios and any gradient description (curve, range, per-part flag) — is included automatically so the mix survives on the other side. The slot's page also shows a read-only visualization of the definition (a stacked ratio bar, a triangle marker for three-component mixes, or a material-ratio-over-model-height graph for gradients).

Enabling a mixed slot automatically enables **Full Publish** on its component filament slots, so the physical materials always ship their identity. If you undo that — a component ends up neither Full Published nor carrying a **Type** requirement — pressing **OK** warns which filaments are affected; choose **Cancel** to fix the selection or **Proceed** to publish anyway. (The mix's colors are deliberately not required: the receiving side renders the blend from its own component colors.)

<!-- TODO: screenshot of a mixed filament slot page -->

*[Screenshot placeholder: a mixed filament slot with its ratio visualization]*

### Process tab

Mirrors the Process settings tab: one inner tab per settings page (Quality, Speed, Strength and so on), each keeping the same option grouping. Every process setting is offered; the ones that differ from the base preset are simply pre-checked.

<!-- TODO: screenshot of the Process tab -->

*[Screenshot placeholder: the Process tab]*

## Publishable settings

The publish dialog offers a fixed scope of settings. Printer and filament values come from a built-in allowlist, while process values can be selected freely from every print setting except a handful of structural keys that are never published.

### Printer settings

Printer settings are offered per extruder — one inner tab per extruder, mirroring the printer tab's **Retraction** and **Z-hop** sections.

- Retraction
    - Retraction Length
    - Extra length on restart
    - Retraction speed
    - Deretraction speed
    - Travel distance threshold
    - Retract on layer change
    - Wipe while retracting
    - Wipe distance
    - Retract amount before wipe
    - Retract amount after wipe
- Z-hop
    - On surfaces
    - Z-hop type
    - Z-hop height
    - Traveling angle
    - Only lift Z above
    - Only lift Z below

Toolchange retraction (**Retraction Length (Toolchange)** and **Extra length on restart (Toolchange)**) is excluded on the printer side: it belongs to the machine profile rather than a publishable behavior tweak. On the filament side it is publishable (next section).

### Filament settings

Filament values come from the filament tab's *Setting Overrides* page, grouped into two selectable categories:

- Retraction
    - Retraction Length
    - Z-hop height
    - Z-hop type
    - Only lift Z above
    - Only lift Z below
    - On surfaces
    - Retraction speed
    - Deretraction speed
    - Extra length on restart
    - Travel distance threshold
    - Retract on layer change
    - Wipe while retracting
    - Wipe distance
    - Retract amount before wipe
    - Retract amount after wipe
    - Long retraction when cut (beta)
    - Retraction distance when cut
- Retraction when switching material
    - Retraction Length (Toolchange)
    - Extra length on restart (Toolchange)

The *Ironing* overrides group is not publishable.

### Process settings

Every process setting may be selected — layer height, speeds, walls, infill and so on. The only process-side exclusions are structural keys that describe preset identity and machine hardware rather than print behavior (e.g. which preset each value belongs to, preset inheritance, preset compatibility, machine definition).

## Opening a published 3MF

When a published 3MF is opened in OrcaSlicer:

- Selected print and printer settings are applied to your current presets.
- Selected filament values are applied slot by slot, matching the author's slot order.
- Settings marked **Full Publish** become standalone filament presets embedded inside the opened project. They live only within that project — the recipient's own preset library is never modified, nor are existing presets overwritten or auto-selected.
- A slot with a checked **Type** requirement keeps your filament only on a material-type match; on a mismatch the slot is replaced with the best same-type candidate from your own library where one exists. A checked **Color** requirement is applied regardless of the type match.
- Published mixed slots are placed on the matching virtual slot; when the author's slot position holds a physical filament in your project, the mix is moved onto a free virtual slot instead.
- Anything that could not be applied — for example a setting whose value does not match your machine setup — is skipped and listed in a notification after the file loads.

## Compatibility notes

A published 3MF is written as a minimal project file without the usual embedded presets, project configuration or slicer version tags. An older OrcaSlicer that does not support publishing therefore does not show a wrong-version prompt — it simply falls back to importing the file's geometry with its own settings. The model always opens; no error is shown.
