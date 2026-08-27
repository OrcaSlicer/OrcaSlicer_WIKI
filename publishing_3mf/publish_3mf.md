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
- [Publishable settings](#publishable-settings)
    - [Printer settings](#printer-settings)
    - [Filament settings](#filament-settings)
    - [Process settings](#process-settings)
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

Toolchange retraction (**Retraction Length (Toolchange)** and **Extra length on restart (Toolchange)**) is excluded: it belongs to the machine profile rather than a publishable behavior tweak.

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

Material identity keys — colour, material type, vendor and diameter — are always embedded regardless of your selection so a published file remains valid on the receiving side. See [Mixed filament slots](#mixed-filament-slots) for how blended slots travel with the file.

### Process settings

Every process setting that differs from the base preset may be selected — layer height, speeds, walls, infill and so on. The only process-side exclusions are structural keys that describe preset identity and machine hardware rather than print behavior:

| Excluded keys | What they govern |
| --- | --- |
| `printer_settings_id`, `filament_settings_id`, `print_settings_id`, `sla_print_settings_id`, `sla_material_settings_id`, `physical_printer_settings_id` | Which preset each value belongs to; publishing them would rewrite the recipient's preset inheritance |
| `inherits`, `inherits_group` | Preset inheritance chain |
| `compatible_printers`, `compatible_prints`, `compatible_printers_condition`, `compatible_prints_condition`, `default_filament_profile`, `default_print_profile`, `default_sla_print_profile`, `default_sla_material_profile` | Preset compatibility and default-profile selection |
| `printer_technology`, `printer_model`, `printer_variant`, `bed_shape`, `extruder_count`, `filament_ids` | Machine definition and hardware layout |
| `different_settings_to_system` | Dirty-state marker used by the UI |

## Opening a published 3MF

When a published 3MF is opened in OrcaSlicer:

- Selected print and printer settings are applied to the recipient's current presets.
- Selected filament values are applied slot by slot, matching the author's slot order.
- Settings marked **Full Publish** become standalone filament presets embedded inside the opened project. They live only within that project — the recipient's own preset library is never modified, nor are existing presets overwritten or auto-selected.
- Required material types are checked before applying; a mismatched slot is replaced by a same-type filament from the recipient's library where possible.

## Compatibility notes

Older versions of OrcaSlicer that do not support publishing simply ignore the embedded settings and open the file's geometry only. The model always opens; no error is shown.
