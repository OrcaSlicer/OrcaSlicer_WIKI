# Publish 3MF

> [!IMPORTANT]
> NEW FEATURE: **Publish 3MF**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than 2.5.0.

**Publish 3MF** lets you export a project as a 3MF file with selected print, filament, and printer settings embedded. Whoever opens the published file gets your configuration alongside the geometry, so a shared model slices exactly the way you intended.

Unlike a regular project save, a published 3MF does **not** modify the recipient's printer setup when imported — it simply applies the settings you chose to include.

- [Why use Publish 3MF?](#why-use-publish-3mf)
- [Publishing a project](#publishing-a-project)
    - [Opening the dialog](#opening-the-dialog)
    - [Choosing which settings to include](#choosing-which-settings-to-include)
    - [Printer tab](#printer-tab)
    - [Filament tab](#filament-tab)
    - [Mixed filament slots](#mixed-filament-slots)
    - [Process tab](#process-tab)
- [Opening a published 3MF](#opening-a-published-3mf)
- [Compatibility notes](#compatibility-notes)

## Why use Publish 3MF?

A regular **Save Project** embeds a snapshot of your entire configuration and all presets. **Publish 3MF** works the opposite way: it is deliberately minimal — you pick exactly which settings travel with the file, nothing more, nothing less.

Typical uses:

- Sharing a calibrated model together with the profile it was tuned for.
- Sending a print job to someone without dictating settings you consider optional.
- Distributing a "known good" configuration for a specific object.

## Publishing a project

### Opening the dialog

Open the menu **File → Publish 3MF…**, or press `Ctrl`+`Shift`+`E` (available whenever the project holds at least one object).

The dialog lists every publishable setting across three tabs — **Printer**, **Filament**, and **Process**. Settings that differ from the base presets of your current project are **pre-checked and shown in bold**; everything else starts unchecked but can still be selected.

<!-- TODO: screenshot of the Publish 3MF dialog -->

*[Screenshot placeholder: the Publish 3MF dialog]*

### Choosing which settings to include

Each row shows the setting name with its current value and unit. The top bar of the dialog provides several ways to control what gets published:

- A **filter box** to narrow the list by setting name ("Type to filter...").
- **All** and **None** buttons to check or uncheck everything at once.
- A filter menu (right-click or the menu button) with:
    - **Select All** / **Deselect All**
    - **Select visible** / **Deselect visible** — only available while a filter is active
    - **Filter selected** / **Filter non-selected** — show only the checked or unchecked rows; while one is active a chip replaces **All**/**None** in the bar, and clicking the chip clears it

Publishing is always allowed: if nothing is checked the file carries only the geometry.

<!-- TODO: screenshot of selection controls -->

*[Screenshot placeholder: filter bar and selection controls]*

### Printer tab

One tab per extruder (named like your printer's extruders, e.g. **Extruder 1** or **Left Extruder**), each listing that extruder's **Retraction** and **Z-Hop** settings with its own values. Selection is independent per extruder: a checked row publishes exactly that extruder's value.

<!-- TODO: screenshot of the Printer tab -->

*[Screenshot placeholder: the Printer tab]*

### Filament tab

One tab per loaded filament slot, labeled with the preset name and its color chip. A slot publishes nothing until its **Enable** checkbox is ticked — until then the rest of the page stays hidden.

An enabled slot offers:

- A **Material** group with two optional requirement rows: **Color** (shows a color swatch and the filament color the slot must carry) and **Type** (the required material family, e.g. `PLA`). These don't publish setting values — they constrain what the receiving side applies (see [Opening a published 3MF](#opening-a-published-3mf)).
- **Full Publish** — embeds the complete filament preset for that slot instead of individual settings; while it is checked the per-setting rows are disabled.
- The selectable setting groups **Retraction** and **Retraction when switching material** (see below).

Mixed-color slots are listed on a second tab row below the physical ones — see [Mixed filament slots](#mixed-filament-slots).

<!-- TODO: screenshot of the Filament tab -->

*[Screenshot placeholder: the Filament tab]*

### Mixed filament slots

Mixed (multi-material blended) filament slots appear in their own tab strip under the Filament tab, titled by their composition — for example `1 (60%) + 2 (40%)`, or an arrow (`1 → 2`) for gradient mixes.

A mixed slot has no per-setting rows and no Full Publish toggle: enabling it publishes the slot as a whole unit. The blend definition — which slots are mixed, the sublayer ratios and any gradient description — is included automatically so the mix survives on the other side. The slot's page also shows a read-only visualization of the definition (a stacked ratio bar, a triangle marker for three-component mixes, or a material-ratio-over-model-height graph for gradients).

Enabling a mixed slot automatically enables **Full Publish** on its component filament slots, so the physical materials always ship their identity. If you undo that — a component ends up neither Full Published nor carrying a **Type** requirement — pressing **OK** shows a warning dialog listing each affected mix and its missing component, with a hint on how to fix it. Choose **Cancel** to return to the dialog or **Publish anyway** to proceed. (The mix's colors are deliberately not required: the receiving side renders the blend from its own component colors.)

On import, mixed filament definitions are validated: a definition with fewer than two components, or referencing missing or mixed slots, is rejected and reported as skipped. The slot becomes an empty mixed-filament placeholder that the GUI flags until you assign filaments to it.

<!-- TODO: screenshot of a mixed filament slot page -->

*[Screenshot placeholder: a mixed filament slot with its ratio visualization]*

### Process tab

Mirrors the Process settings tab: one inner tab per settings page (Quality, Speed, Strength and so on), each keeping the same option grouping. Every process setting is offered; the ones that differ from the base preset are simply pre-checked.

<!-- TODO: screenshot of the Process tab -->

*[Screenshot placeholder: the Process tab]*

## Opening a published 3MF

When a published 3MF is opened in OrcaSlicer, the file loads as a **new project** — the title shows "Untitled" and **Save** (`Ctrl`+`S`) prompts for a destination rather than overwriting the published file. The file is added to the recent projects list.

Your current presets are preserved; the published settings are overlaid on top of them:

- **Print settings** are applied to your active print preset.
- **Printer settings** are applied to your active printer preset, limited to retraction and z-hop only. Single-extruder printers receive only the first extruder's values.
- **Filament values** are applied slot by slot, matching the author's slot order. Slots beyond your printer's capacity are either dropped (single-nozzle printers) or placed as empty mixed-filament placeholders that you assign your own filaments to.
- Settings marked **Full Publish** become standalone, project-embedded filament presets. They are detached from any library preset and live only within that project — your own preset library is never modified.
- A slot with a checked **Type** requirement keeps your filament only on a material-type match; on a mismatch the slot is replaced with the best available candidate from your library. A checked **Color** requirement is applied regardless of the type match.
- **Mixed filament definitions** are written into the project's configuration. A mix whose slot position holds a physical filament in your project is relocated to a free virtual slot, and the model's extruder references are remapped to match.
- Anything that could not be applied — for example a setting whose value does not match your machine setup, or a filament slot beyond the printer's capacity — is skipped and listed in a notification after the file loads.

Two notifications may appear:

- **"Some published settings could not be applied:"** — lists each skipped setting.
- **"Some filament slots were changed:"** — lists slot relocations and replacements.

## Compatibility notes

A published 3MF is written as a minimal project file without embedded presets, project configuration, or slicer version tags. An older OrcaSlicer that does not support publishing therefore does not show a wrong-version prompt — it simply falls back to importing the file's geometry with its own settings. The model always opens; no error is shown.
