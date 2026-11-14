# V2.5.1

This is the OrcaSlicer V2.5.1 release, a maintenance update on top of 2.5.0. Thank you to everyone who reported problems with 2.5.0!

It fixes problems connecting and uploading to printers, crashes, slicing bugs and security issues. Toolchangers can now copy per-nozzle settings to every tool, and **Reload from disk** gets a keyboard shortcut.

If you chose an HTTPS CA file for a LAN printer before 2.5.1, see **Security** below: you may need to choose it again.

<!-- downloads:start -->

## Downloads

| Platform | File |
| --- | --- |
| Windows installer (x64) | [OrcaSlicer_Windows_Installer_V2.5.1_x64.exe](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer_Windows_Installer_V2.5.1_x64.exe) |
| Windows installer (ARM64) | [OrcaSlicer_Windows_Installer_V2.5.1_arm64.exe](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer_Windows_Installer_V2.5.1_arm64.exe) |
| Windows portable (x64) | [OrcaSlicer_Windows_V2.5.1_x64_portable.zip](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer_Windows_V2.5.1_x64_portable.zip) |
| Windows portable (ARM64) | [OrcaSlicer_Windows_V2.5.1_arm64_portable.zip](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer_Windows_V2.5.1_arm64_portable.zip) |
| macOS (Apple Silicon and Intel) | [OrcaSlicer_Mac_universal_V2.5.1.dmg](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer_Mac_universal_V2.5.1.dmg) |
| Linux AppImage (x86_64) | [OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.5.1.AppImage](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.5.1.AppImage) |
| Linux AppImage (aarch64) | [OrcaSlicer_Linux_AppImage_Ubuntu2404_aarch64_V2.5.1.AppImage](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer_Linux_AppImage_Ubuntu2404_aarch64_V2.5.1.AppImage) |
| Linux Flatpak (x86_64) | [OrcaSlicer-Linux-flatpak_V2.5.1_x86_64.flatpak](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer-Linux-flatpak_V2.5.1_x86_64.flatpak) |
| Linux Flatpak (aarch64) | [OrcaSlicer-Linux-flatpak_V2.5.1_aarch64.flatpak](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/OrcaSlicer-Linux-flatpak_V2.5.1_aarch64.flatpak) |
| Windows debug symbols (for developers) | [Debug_PDB_V2.5.1_for_developers_only.7z](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.1/Debug_PDB_V2.5.1_for_developers_only.7z) |

<!-- downloads:end -->

# 🌊 New Features & Improvements

* **Copy per-nozzle settings to every tool of a toolchanger** by @ianalexis and @raistlin7447 in [17461](https://github.com/OrcaSlicer/OrcaSlicer/pull/17461)
    On printers with more than two extruders, such as the Snapmaker U1, the button that copies per-nozzle settings to another extruder was always disabled, so you had to set up each tool by hand. Copying now works for any number of tools, from the process settings, the printer's **Extruder** and **Motion ability** pages, and the material settings. In the process and printer settings, values only go to nozzles of the same volume type, so Standard and High Flow values stay apart. Tools you add by raising the extruder count get their own copy of tool 1's process values, ready to edit. Fixes #16916.

    The unsaved changes dialog, which the copy goes through, also gets a checkbox for each changed value, so you choose which changes to save, transfer or copy.

    <img width="500" alt="Copy dialog on a Snapmaker U1 copying tool 1's Standard nozzle settings to tools 2 to 4" src="https://github.com/user-attachments/assets/26fc5b9f-e83a-4680-9d02-5863a63cea96" />

    <img width="500" alt="Unsaved changes dialog with a checkbox for each changed value" src="https://github.com/user-attachments/assets/f595d5f7-4587-49d7-9a22-00f86046c1ea" />

* **Keyboard shortcut for Reload from disk** by @thelegendtubaguy in [17373](https://github.com/OrcaSlicer/OrcaSlicer/pull/17373) — **Reload from disk** is bound to Ctrl+Shift+R (Cmd+Shift+R on macOS) in the 3D view and the object list, and you can change the key in the **Keyboard Shortcuts** dialog. The **Clone** and **Reload from disk** items in the right-click menu show the new key right away, without a restart. Fixes #8703. [Wiki](https://www.orcaslicer.com/wiki/keyboard_shortcuts#customizing-shortcuts)

* **The printer connection guide shows the current interface** by @yw4z in [17421](https://github.com/OrcaSlicer/OrcaSlicer/pull/17421) — the animation in the Device tab that shows how to connect a printer was re-recorded with the current interface.

# 🛠️ Bug Fixes

## Security

* **AMF files can't freeze OrcaSlicer** by @lamweilun in [17290](https://github.com/OrcaSlicer/OrcaSlicer/pull/17290)
    On Windows and macOS, a crafted AMF file with nested XML entities could use up memory and freeze OrcaSlicer, because the XML parser it ships with had its guard against this turned off. The guard is on again, in an updated parser. A file that relies on this kind of expansion no longer imports. Fixes #17287.

* **Plugin packages install over a trusted connection** by @HanifKoh in [17292](https://github.com/OrcaSlicer/OrcaSlicer/pull/17292) — OrcaSlicer installs the Python packages a plugin needs from PyPI with a bundled tool called uv. That tool still trusted a root certificate whose intermediate keys had leaked, so someone between your computer and PyPI who held one of those keys could swap the packages a plugin installs. The bundled uv is updated and no longer trusts that certificate.

* **Bambu Lab LAN printers use the HTTPS CA file you choose** by @Alphakilo in [17062](https://github.com/OrcaSlicer/OrcaSlicer/pull/17062) — the **HTTPS CA File** in the **Connect the printer using IP and access code** dialog had no effect on Bambu Lab printers, so connections that needed it, such as to a self-hosted proxy, failed. OrcaSlicer now saves the CA file with each printer and trusts it when connecting, and the field is no longer greyed out for Bambu Lab printers on Windows and macOS. The file must contain only CA certificates. A CA file chosen before 2.5.1 isn't carried over, so choose it again in the dialog. Fixes #17061.

## Crashes

* **No crash when editing an object's speed** by @HanifKoh in [17529](https://github.com/OrcaSlicer/OrcaSlicer/pull/17529)
    Since 2.5.0, changing any speed in an object's or part's process settings could close OrcaSlicer with an "out of memory" error. It happened when the process had no extruder variant for the selected printer, for example on a Bowden printer with a process made for direct drive. The settings page now uses the extruder's first variant in that case, as slicing already does. Fixes #17521.

* **No crash when clicking in the Measure tool** by @raistlin7447 and @yw4z in [17383](https://github.com/OrcaSlicer/OrcaSlicer/pull/17383)
    The **Measure** and **Assemble** tools could crash when you clicked while the cursor was over something they couldn't select, such as an edge highlight off the model, a feature the Assemble tool filters out, or a selection that was just removed. On the Linux Flatpak, it crashed every time. A click like that now acts like a click on empty space. A selected circle's ring also keeps the right thickness as you zoom. Fixes #17367.

## Slicing & Print Quality

* **Copies of an object print where they show on the plate** by @Eldenroot in [17183](https://github.com/OrcaSlicer/OrcaSlicer/pull/17183) — when an object that isn't symmetric had a copy whose first instance was rotated by an angle that isn't a multiple of 90°, that copy could reuse the original's sliced layers. It then printed shifted from where it showed on the plate, with no warning. Such objects are now sliced separately.

* **Copies of an object keep their own height ranges** by @Art-Porto in [17279](https://github.com/OrcaSlicer/OrcaSlicer/pull/17279) — when an object and a pasted copy of it had different height range modifiers, both were sliced the same way. The copy's range was ignored, or the first object's range, such as a filament change, was used on both. Objects whose height ranges differ are now sliced separately.

* **Spiral vase works with height range modifiers** by @kisslorand in [17143](https://github.com/OrcaSlicer/OrcaSlicer/pull/17143) and [17154](https://github.com/OrcaSlicer/OrcaSlicer/pull/17154)
    A height range that changed a setting such as wall speed, line width or flow ratio made **Spiral vase** report that the object contains more than one material. An object with a height range modifier was also sliced with several walls instead of one. Spiral vase now checks the filaments assigned to the object, and slices a single wall in every height range. Fixes #8257 and #17022.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Spiral vase object with a height range sliced with several walls" src="https://github.com/user-attachments/assets/c5f6acf7-d8e2-46e9-a6ce-be198b89ae92" /> | <img width="400" alt="The same object sliced with a single wall" src="https://github.com/user-attachments/assets/570f7a96-2bcc-45c9-8ff6-5e367eaa1a26" /> |

* **Height ranges line up with Z shrinkage compensation** by @fa1k3 and @SoftFever in [16491](https://github.com/OrcaSlicer/OrcaSlicer/pull/16491) — with **Shrinkage (Z)** set to anything other than 100%, height range modifiers applied their settings at the wrong heights, and a range that reached the top of the object could leave its top layers at the default layer height. Height ranges now follow the compensated height.

* **Cleaner multiline infill paths** by @ianalexis in [17341](https://github.com/OrcaSlicer/OrcaSlicer/pull/17341) — with **Fill Multiline** above 1, Adaptive Cubic, Support Cubic, Honeycomb, Quarter Cubic and Lightning infill could print paths that started in the middle of a line, ran along the walls and ended where they started. Those pieces are joined back together. Single-line infill doesn't change.

* **Slicing pipeline plugins run when the preset picks them** by @DIEHARDave in [16884](https://github.com/OrcaSlicer/OrcaSlicer/pull/16884) — a plugin chosen in **Slicing Pipeline Plugin** in the process preset could be skipped at slice time with no warning, so the G-code was exported without the plugin's changes. This could happen when the preset's plugin list was built before the plugin finished loading. OrcaSlicer now finds the plugin by name in that case. A plugin that isn't loaded is still skipped.

## Prime Tower & Multi-Material

* **The nozzle stays lifted until it's back over the print** by @gazi-faysal-jubayer in [16933](https://github.com/OrcaSlicer/OrcaSlicer/pull/16933)
    Since 2.3.2, after a tool change at the prime tower, the nozzle came down from its lift while it traveled back across the print, which left streaks of color. A lifted nozzle now travels at the lifted height and lowers only at its destination, as it did in 2.3.1. This applies to every lifted travel that ends lower, including detours around walls. Fixes #14968.

* **The last filament is unloaded again on single extruder multi-material printers** by @fer-marino and @HanifKoh in [15917](https://github.com/OrcaSlicer/OrcaSlicer/pull/15917) and [17496](https://github.com/OrcaSlicer/OrcaSlicer/pull/17496)
    Since 2.5.0, on a single extruder multi-material printer, the last filament wasn't rammed and unloaded at the end of the print when the prime tower ended below the top of the print, as it does when a filament is only used on the lower layers. The final unload is written again, at the top layer of the print, so the nozzle doesn't move down into the part. Printers with several tools, including those with multitool ramming such as the Snapmaker U1, are unchanged, so they don't ram in mid-air above the tower. Fixes #15788.

* **Prime tower checks apply only when a tower is printed** by @Art-Porto in [16999](https://github.com/OrcaSlicer/OrcaSlicer/pull/16999)
    A plate whose parts all used one filament, with only the **Support/raft interface** on another, was refused before slicing with "The prime tower is only supported if all objects have the same variable layer height", even when no part needed support and no tower would be printed. Such plates are now checked after slicing, and only if a tower is printed. With **No sparse layers (beta)** on, any object taller than the **Height to lid** clearance (Printer settings > Basic information > Extruder Clearance) was refused wherever it stood. An object away from the tower is checked against the real tower height instead. Fixes #16936.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Plate refused before slicing with the prime tower variable layer height error" src="https://github.com/user-attachments/assets/2a545f25-7406-45f3-bdf8-aefb014c7d4d" /> | <img width="400" alt="The same plate sliced with no prime tower" src="https://github.com/user-attachments/assets/b6c3905c-f2fd-4cbf-ab20-27e1bc18db6b" /> |

* **Precise Z height no longer makes the prime tower too big** by @HanifKoh in [17204](https://github.com/OrcaSlicer/OrcaSlicer/pull/17204) — with **Precise Z height** on, a filament change and objects of different heights, slicing could fail with "Prime tower is partially outside the printable area" even though Prepare showed a small tower. The very thin layers where one object ends a few microns above another now print their tower work on the tower layer below. Fixes #17083.

* **Gap infill uses the inner wall filament with Classic walls** by @ianalexis in [17229](https://github.com/OrcaSlicer/OrcaSlicer/pull/17229) — with the Classic **Wall generator**, choosing an outer wall filament in **Filament for Features** also moved the gap infill between walls to that filament. It now prints with the inner wall filament, matching Arachne, which prints inner walls in that space. With a single wall loop, gap infill stays on the outer wall filament.

## Command Line

* **The CLI keeps the flushing volumes of multi-nozzle projects** by @HanifKoh in [17440](https://github.com/OrcaSlicer/OrcaSlicer/pull/17440) — on a printer with more than one nozzle, such as the H2D, a project exported from the command line listed one nozzle volume type for all of its nozzles. When the CLI opened that export again, it recalculated the flushing volumes from the filament colors, so values you had set were lost. The CLI writes one volume type per nozzle instead. A project without volume types takes the printer's default types, as in the GUI, so a printer whose default is High Flow, such as the Prusa CORE One INDX 4T HF and 8T HF, now exports as High Flow.

* **No CLI crash when extruder areas don't overlap** by @HanifKoh in [17439](https://github.com/OrcaSlicer/OrcaSlicer/pull/17439) — a printer profile can give each extruder its own printable area. When those areas only touched or didn't overlap at all, slicing from the command line crashed before placing any object. Objects are now placed on the whole bed in that case, and a prime tower is refused with a message that the extruders share no common area. No bundled printer profile is affected.

* **No CLI crash on a mismatched filament order** by @HanifKoh in [17243](https://github.com/OrcaSlicer/OrcaSlicer/pull/17243) — a plate's custom filament order for other layers is stored as a count and a list of values. When the count didn't match the values, as with `--other-layers-print-sequence-nums 1`, the CLI read past the end of the list and could crash. Such a pair is now treated as no custom order, with a warning in the log.

* **No CLI crash on filament presets without a diameter** by @anselor in [16911](https://github.com/OrcaSlicer/OrcaSlicer/pull/16911) — since 2.5.0, a CLI run that loaded filament presets without a color crashed when a preset didn't set a diameter, or stopped with a config error when a later filament didn't set the support flag. Missing values now follow the first filament or the option's default.

## Preview

* **The preview shows temperature changes on RepRapFirmware** by @ianalexis in [17464](https://github.com/OrcaSlicer/OrcaSlicer/pull/17464)
    On printers whose **G-code flavor** is RepRapFirmware, the G-code preview never showed a nozzle temperature change, so a temperature tower looked like it printed at one temperature, and each change was drawn as a retraction. The exported G-code was already right. The preview and its print time estimate now handle these changes correctly. Fixes #14534 and #17436.

    <img width="600" alt="Temperature tower in the G-code preview on a RepRapFirmware printer, each block colored by its nozzle temperature" src="https://github.com/user-attachments/assets/920c21af-b2f3-475f-abe0-72040081d8ab" />

* **The nozzle marker tilts on belt printers** by @yw4z in [17427](https://github.com/OrcaSlicer/OrcaSlicer/pull/17427) — in Preview, the nozzle marker stayed upright while the layers were drawn tilted. It now tilts to match the print direction at any belt angle.

* **The tool position readout shows the position on its own plate** by @Noisyfox in [17172](https://github.com/OrcaSlicer/OrcaSlicer/pull/17172) — on plates after the first, the tool position readout in Preview included the plate's offset in the scene. It now shows the position on the current plate.

## Design Tab

* **Clicking a constraint's badge selects it** by @SoftFever in [17459](https://github.com/OrcaSlicer/OrcaSlicer/pull/17459)
    In a Design tab sketch, a click on a constraint's badge deleted the constraint right away. A dimension label drawn over the badge could also hide it, so a click on the label could delete a constraint you couldn't see. A badge click now selects the constraint and its row in the **Constraints** list, and the Delete key removes it. A label drawn over a badge takes the click. Sketches with thousands of constraints also no longer stall while the list is rebuilt. [Wiki](https://www.orcaslicer.com/wiki/design_sketching#constraints-and-dimensions)

    Before:

    <video controls width="800" src="https://github.com/user-attachments/assets/87eb0f02-3a07-450f-baf4-0a85bf3bfff2"></video>

    After:

    <video controls width="800" src="https://github.com/user-attachments/assets/cb3c0092-3eb8-4bbb-84ae-040139304cad"></video>

* **A sketch's Constraints card shows the first time you edit it** by @SoftFever in [17458](https://github.com/OrcaSlicer/OrcaSlicer/pull/17458) — opening an existing sketch for editing didn't show its **Constraints** card until the second time, and the card and the banner over the canvas named it as if it were a new sketch. Both now show on the first open and name the sketch you're editing.

## Interface Fixes

* **The mixed filament dialog is easier to use** by @thelegendtubaguy in [16866](https://github.com/OrcaSlicer/OrcaSlicer/pull/16866)
    Dragging the ratio handle outside the triangle no longer makes it jump to the opposite side: it stops at the nearest edge. Adding a third material or turning on **Gradient Effect** could also grow the dialog past the bottom of the screen, hiding **Cancel** and **OK** under the taskbar. The dialog now stays on screen. The 10% minimum for each filament is drawn as a dashed line, and the two-material ratio bar spans the full width of the dialog.

    <video controls width="800" src="https://github.com/user-attachments/assets/55c33ed5-5d70-46c2-9dcc-e67ceb9c38ad"></video>

    <img width="400" alt="Mixed filament triangle with the 10% minimum for each filament drawn as a dashed line" src="https://github.com/user-attachments/assets/4a08baeb-0631-4cd0-8a0e-008e573fe9c8" />

* **Fill bed with instances puts the copies on their plate** by @SoftFever in [17480](https://github.com/OrcaSlicer/OrcaSlicer/pull/17480) — copies made by **Fill bed with instances** showed in the Objects panel but weren't registered with their plate until you moved them, and with **Show Labels** on, only the original had a label. The copies now join their plate when the fill finishes, as copies made with **Set number of instances** do.

* **Plate thumbnails update in Focus mode** by @RF47 in [17320](https://github.com/OrcaSlicer/OrcaSlicer/pull/17320) — after you added a plate, a primitive or a pasted object, the plate toolbar could keep showing an old thumbnail.

* **Focus mode hides objects with large modifiers** by @HanifKoh in [17474](https://github.com/OrcaSlicer/OrcaSlicer/pull/17474) — with Focus mode on, an object whose modifier reached over another plate stayed drawn on that plate. Focus mode now places an object by its parts only, so modifiers no longer pull it onto other plates. Fixes #17434.

* **Realistic View stays on while painting** by @ianalexis in [17317](https://github.com/OrcaSlicer/OrcaSlicer/pull/17317) — opening seam, support or fuzzy skin painting turned the **Realistic View** preference off, and it could stay off, for example after you switched to another tool. Painting no longer changes it.

* **Lightning settings hide when there is no sparse infill** by @RF47 in [17277](https://github.com/OrcaSlicer/OrcaSlicer/pull/17277) — with the Lightning pattern and **Sparse infill density** at 0%, **Lightning overhang angle**, **Prune angle** and **Straightening angle** still showed, though they do nothing. They're now hidden.

* **The view pans and rotates from the center of mass details box** by @thelegendtubaguy in [17137](https://github.com/OrcaSlicer/OrcaSlicer/pull/17137) — the box sits over the model, and a drag that started on it did nothing, so you couldn't pan or rotate the view from there. A right drag that started on the box and ended off it also opened the context menu. A drag on the box now moves the view like a drag over empty space, and a right click off the box closes it, like a left click.

* **The printable tooltip shows only where it applies** by @kisslorand in [17076](https://github.com/OrcaSlicer/OrcaSlicer/pull/17076) — the object list showed the printable tooltip on parts and layer ranges, which have no printable checkbox. It now shows only on objects and instances.

* **Scale to build volume is greyed out when it can't be used** by @Eldenroot and @yw4z in [16353](https://github.com/OrcaSlicer/OrcaSlicer/pull/16353) — the right-click menu item was always enabled. It's now greyed out for parts, cut objects, an empty selection, and beds that aren't rectangular or round, the same as the Speed Dial command.

* **The Clone dialog's Fill button says what it does** by @Eldenroot in [17152](https://github.com/OrcaSlicer/OrcaSlicer/pull/17152) — its tooltip said it fills the bed with copies, a method that no longer exists. It now says it fills the bed with instances.

## Windows & macOS

* **No stray horizontal scrollbar in the object list on Windows** by @yw4z in [17169](https://github.com/OrcaSlicer/OrcaSlicer/pull/17169) — when the vertical scrollbar appeared or went away, the Name column kept its old width, so a horizontal scrollbar showed up. The column now fits the list again.

* **Closed settings dialogs stay hidden on Windows** by @HanifKoh in [17161](https://github.com/OrcaSlicer/OrcaSlicer/pull/17161) — after **Material settings** or **Printer settings** had been opened once, the closed dialog still showed over the main window in the taskbar preview. Fixes #17124.

* **Double clicks on checkboxes and switches work on Windows** by @thelegendtubaguy in [17194](https://github.com/OrcaSlicer/OrcaSlicer/pull/17194) — a quick double click on a checkbox, switch or radio button toggled it three times, so it looked like a click was lost, and a radio button could look selected while its value was cleared. A double click now toggles twice.

* **"DEV" fits in the mode switch on Retina Macs** by @lamweilun in [17197](https://github.com/OrcaSlicer/OrcaSlicer/pull/17197) — in Developer mode, the settings mode switch drew "DEV" at double size on Retina displays, so the text was cut off. Fixes #17180.

## Printer Connectivity & Cloud

* **Bambu Lab LAN printers saved before 2.5.0 are back** by @thelegendtubaguy in [17468](https://github.com/OrcaSlicer/OrcaSlicer/pull/17468)
    Bambu Lab printers added over LAN in 2.4 or earlier disappeared from the **Device** tab after upgrading to 2.5.0. They come back on their own, without being added again. Fixes #17351 and #17460.

* **Upload and Print starts the print on more Creality printers** by @raistlin7447 in [17365](https://github.com/OrcaSlicer/OrcaSlicer/pull/17365)
    With the CrealityPrint host type, **Upload and Print** sent the file to the Ender-3 V3, Ender-3 V3 Plus, Ender-3 V3 KE, CR-10 SE, Ender-5 Max and K2 SE, but the print never started, and no error showed. OrcaSlicer asked these printers to start the file from a folder they don't use. It now uses the folder each of them keeps its files in. Fixes #8735, #17078, #17363 and #17364.

* **Moonraker printers keep their port** by @grant0013 in [17257](https://github.com/OrcaSlicer/OrcaSlicer/pull/17257)
    A Moonraker, Qidi, Snapmaker or CrealityPrint printer whose print host includes a port, such as `192.168.1.50:7125`, connected the first time and then failed with "OrcaSlicer can't connect" in every later session, because the saved address lost its port. The port is now kept, and printers already saved without it reconnect without being added again.

* **Filament sync keeps each slot's material** by @anselor in [17089](https://github.com/OrcaSlicer/OrcaSlicer/pull/17089) — when a Creality, Moonraker, Qidi or Snapmaker printer reported a material that had no visible filament preset, sync could pick a preset for a different material, such as PLA, and show the slot as that material. It now uses OrcaSlicer's generic preset for the reported material, and also recognizes PLA+, PLA PRO, ABS+ and PETG+ as their base material.

* **Flow Dynamics Calibration shows again for the A1 and A1 mini** by @brummbrum in [16055](https://github.com/OrcaSlicer/OrcaSlicer/pull/16055) — on A1 and A1 mini printers with older firmware, the **Flow Dynamics Calibration** option was missing when sending a print. OrcaSlicer read the printer's support for it from a status flag that this firmware leaves off, even though the printer reports the support elsewhere. It now keeps the support the printer reports. Fixes #16033.

* **Configuration updates for vendors you don't use stop coming back** by @peachismomo in [17449](https://github.com/OrcaSlicer/OrcaSlicer/pull/17449) — OrcaSlicer could keep asking to install a configuration update for a printer vendor you have no printers from, such as Qidi. Installing it didn't help, because the profiles of unused vendors are removed again at startup. Background update checks now skip vendors you don't use. Updates for OrcaSlicer's own bundles and for vendors you just added still show. Fixes #17400.

# 🖨️ Printer & Filament Profiles

## Profile Updates & Fixes

* **Bed and hotend models load for more printers** by @yw4z in [17348](https://github.com/OrcaSlicer/OrcaSlicer/pull/17348) — several printer profiles pointed at bed or hotend model files, or bed textures, whose names didn't match, some only on Linux, where file names are case-sensitive. They now load for the Chuanying X1, Vzbot 235 AWD and 330 AWD, Flashforge AD5X, Adventurer 4 Series, Adventurer 5M, Adventurer 5M Pro and Adventurer A5, Z-Bolt S1000 and S1000 Dual, Elegoo Neptune 4 and Centauri 2, MagicMaker, and Qidi Q2 and Q2C. Felix, Goofoo, Vivedino and Prusa CORE One L bed models are smaller, several printers have new cover pictures, and the profile folder is about 10 MB smaller.

# 🗪 Localization

* All 22 languages translate every new string in 2.5.1, by @HanifKoh in [4eda9b5](https://github.com/OrcaSlicer/OrcaSlicer/commit/4eda9b55c9b32328a851711ffa27199a35f1f081)

---

# ❤️ Support OrcaSlicer

> **OrcaSlicer is — and will remain — free and open source.**
>
> Every release represents countless hours of behind-the-scenes work: building features, fixing bugs, validating profiles, and testing across real machines.
>
> If OrcaSlicer helps you bring ideas to life, please consider supporting the project. Donations are used to support the open-source contributors who help build and maintain OrcaSlicer, and to cover project costs such as servers, development tools, test machines, filament, printer parts, and other infrastructure.
>
> Your support helps us keep improving OrcaSlicer for everyone — while keeping the project free, open, and community-driven.
>
> **Thank you for being part of the OrcaSlicer journey.** 🙏

<p align="center">
  <a href="https://ko-fi.com/G2G5IP3CP"><img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Support on Ko-fi"></a>
</p>
<p align="center">
  <a href="https://paypal.me/softfever3d"><img src="https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white" alt="Donate via PayPal"></a>
</p>
