# V2.5.0

**OrcaSlicer 2.5.0 is here, the biggest update in OrcaSlicer's history**, built from nearly 1,300 pull requests by more than 180 contributors. You can now add features with **Python plugins**, print on **belt printers**, mix new colors from the filaments you have loaded with **color mixing**, give surfaces real 3D texture with **Texture Displacement**, design parametric parts in the experimental **Design tab**, and print two to four parts at once on **IDEX and IQEX printers**. **Toolhead collision volumes** keep Arrange, brims and travel moves clear of bed clips, tool docks and other obstacles. Smarter travel planning cuts unneeded moves with nothing to turn on, and OrcaSlicer starts, slices and exports noticeably faster. It also supports the **Bambu Lab H2C and A2L**, with mixed nozzle sizes on the H2D and X2D, and brings the new **Speed Dial**, Precise Seam modifiers, new infill options and hundreds of fixes.

**Note:** This release includes everything from the 2.5.0 [alpha](https://www.orcaslicer.com/wiki/releases/release_2_5_0_alpha), [beta](https://www.orcaslicer.com/wiki/releases/release_2_5_0_beta) and [release candidate](https://www.orcaslicer.com/wiki/releases/release_2_5_0_rc), whose release notes walk through everything new if you're coming from 2.4. The notes below cover only what changed since the release candidate.

🧩 **Give plugins a try!** The community has already created and shared lots of plugins on the [Orca Cloud plugin hub](https://cloud.orcaslicer.com/app/plugins/plugin-hub), so take a look: you may find just the tool you've been missing. Plugins can add one-click tools, fine-tune how layers and G-code come out, or bring whole new panels into OrcaSlicer. Open **Plugins** from the main menu, subscribe to the ones you like with your Orca Cloud account, and OrcaSlicer installs them and offers updates as their authors improve them. Plugin permissions let you control whether a plugin can go online, start other programs or reach outside OrcaSlicer's data folder, and the new **Permissions** tab shows what each plugin is allowed to do. They aren't a sandbox, so install plugins you trust. Have an idea of your own? The [plugin development guide](https://www.orcaslicer.com/wiki/plugin_development) will get you started, and once you publish your plugin on the hub, everyone can enjoy it.

Thank you to everyone who tested the release candidate! This release fixes the blockers you reported. Bridges print at bridge speed again with **Slow down for curled perimeters** on, scarf joint seams no longer show as bands with Arachne and arc fitting, and Klipper printers no longer stop over the wipe tower at every tool change. Mesh Boolean, filament sync and projects with fewer filaments than the printer has tools no longer crash, and Esc in the settings search no longer freezes OrcaSlicer on Linux. Orca Cloud presets download on a computer that has never synced, and the custom camera source is back in the Device tab. Windows builds are now also signed with OrcaSlicer's own code signing certificate.

**Two changes to check if you're upgrading from 2.4:**

- **Bambu Lab process presets default to Grid infill.** The 2.5.0 profile sync with BambuStudio ([15851](https://github.com/OrcaSlicer/OrcaSlicer/pull/15851)) changed the default **Sparse infill pattern** of Bambu Lab process presets from Cross Hatch to Grid. Presets that don't set their own pattern now use Grid, and so do your presets based on them. To keep Cross Hatch, set it in your process preset.
- **Features left on Default use the object's filament.** In **Filament for Features**, a feature left on **Default** now always prints with the object's own filament ([17058](https://github.com/OrcaSlicer/OrcaSlicer/pull/17058)). Before, choosing a filament for infill or a top or bottom surface could quietly switch other features left on Default to it as well. If a project relied on that, set those features to the filament you want.

<!-- downloads:start -->

## Downloads

| Platform | File |
| --- | --- |
| Windows installer (x64) | [OrcaSlicer_Windows_Installer_V2.5.0_x64.exe](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer_Windows_Installer_V2.5.0_x64.exe) |
| Windows installer (ARM64) | [OrcaSlicer_Windows_Installer_V2.5.0_arm64.exe](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer_Windows_Installer_V2.5.0_arm64.exe) |
| Windows portable (x64) | [OrcaSlicer_Windows_V2.5.0_x64_portable.zip](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer_Windows_V2.5.0_x64_portable.zip) |
| Windows portable (ARM64) | [OrcaSlicer_Windows_V2.5.0_arm64_portable.zip](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer_Windows_V2.5.0_arm64_portable.zip) |
| macOS (Apple Silicon and Intel) | [OrcaSlicer_Mac_universal_V2.5.0.dmg](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer_Mac_universal_V2.5.0.dmg) |
| Linux AppImage (x86_64) | [OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.5.0.AppImage](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.5.0.AppImage) |
| Linux AppImage (aarch64) | [OrcaSlicer_Linux_AppImage_Ubuntu2404_aarch64_V2.5.0.AppImage](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer_Linux_AppImage_Ubuntu2404_aarch64_V2.5.0.AppImage) |
| Linux Flatpak (x86_64) | [OrcaSlicer-Linux-flatpak_V2.5.0_x86_64.flatpak](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer-Linux-flatpak_V2.5.0_x86_64.flatpak) |
| Linux Flatpak (aarch64) | [OrcaSlicer-Linux-flatpak_V2.5.0_aarch64.flatpak](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/OrcaSlicer-Linux-flatpak_V2.5.0_aarch64.flatpak) |
| Windows debug symbols (for developers) | [Debug_PDB_V2.5.0_for_developers_only.7z](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.0/Debug_PDB_V2.5.0_for_developers_only.7z) |

<!-- downloads:end -->

# 🌊 New Features & Improvements

* **Manage plugin permissions in the Plugins window** by @peachismomo in [17285](https://github.com/OrcaSlicer/OrcaSlicer/pull/17285)
    A new **Permissions** tab in the Plugins window shows what each plugin is allowed to do, grouped into File system, Network access, Execution and Audit events. You can add and remove grants there instead of editing files, and changes apply right away, even while the plugin is loaded. For a plugin you trust, the **Full access** switch skips permission checks after a warning, although a plugin still can't reach OrcaSlicer's configuration, certificates or secrets directly. Permission prompts point you to the tab, and an approval to create or delete a file applies only to that one operation. Permissions guard against mistakes, not against a malicious plugin: they don't fully isolate a plugin from your files or network, so only install plugins you trust.

    <img width="500" alt="Permissions tab of the Plugins window with the Full access switch and the File system, Network access, Execution and Audit events sections" src="https://github.com/user-attachments/assets/4dac0928-a9b2-4d78-86ee-fbaea94cd834" />

* **Speed Dial runs an action with one click** by @lamweilun in [17291](https://github.com/OrcaSlicer/OrcaSlicer/pull/17291) and [17301](https://github.com/OrcaSlicer/OrcaSlicer/pull/17301) — clicking a row or a favorite runs it instead of selecting it. To read an action's description and wiki link, rest the pointer on it and they show in the footer. Pinned actions no longer have a close button; right-click one to unpin it.

# 🛠️ Bug Fixes

## Slicing & Print Quality

* **Bridges print at bridge speed with Slow down for curled perimeters** by @RF47 in [17144](https://github.com/OrcaSlicer/OrcaSlicer/pull/17144) — with **Slow down for curled perimeters** on, bridges printed at the slowest overhang speed instead of the **Bridge** speed since the 2.5.0 alpha. They use the bridge speed again, as in 2.4. Fixes #17123.

* **Scarf joint seams line up with Arachne and arc fitting** by @HanifKoh in [17030](https://github.com/OrcaSlicer/OrcaSlicer/pull/17030)
    With the Arachne wall generator and arc fitting on, the end of the scarf ramp moved a little from layer to layer, so the seam stepped sideways and showed as bands. The ramp now keeps its exact length on straight walls, and the seam stays in line. Fixes #16969.

    <img width="450" alt="Scarf seam in the preview stepping sideways between layers before, and straight after" src="https://github.com/user-attachments/assets/46a7317b-8d3f-4569-86b3-5d342edf4c8c" />

* **Gap fill prints after the lines around it, and internal solid Spiral Inset has no gaps** by @ianalexis in [17223](https://github.com/OrcaSlicer/OrcaSlicer/pull/17223)
    In fills that keep their order, such as Monotonic, Monotonic line, Concentric and Spiral Inset, gap fill could print before the lines around the gap since the 2.5.0 beta. It now prints after them. **Spiral Inset** internal solid infill also left strips up to two lines wide in the middle of each island, which became gap fill or, with **Apply gap fill** set to Top and bottom surfaces or Nowhere, stayed as holes. Arachne fills them again, and its extra lines print at the center end of each spiral, so the nozzle no longer travels back to the center for them, on top and bottom surfaces too. On the test model, layers with internal solid infill need a quarter as much gap fill. The Spiral Inset icon now shows a square spiral.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Spiral Inset internal solid infill with wide gap fill strips in the middle of each island" src="https://github.com/user-attachments/assets/81ab9ef9-264e-4afc-af8b-01907379e295" /> | <img width="400" alt="The same layer with the spirals filling the islands and only small gap fill" src="https://github.com/user-attachments/assets/21bf36bc-20a8-4774-99cf-f8638ebe76df" /> |

* **Cleaner Gyroid and TPMS infill paths** by @ianalexis in [17334](https://github.com/OrcaSlicer/OrcaSlicer/pull/17334) — sparse infill with **Adaptive density**, TPMS-FK, Optimized Gyroid, and Gyroid or TPMS-D with **Fill Multiline** above 1 no longer print paths that start in the middle of a line, run along the walls and end where they started. On the author's test project this saved 2 to 6 minutes on prints of 2 to 4 hours. Plain Gyroid is unchanged.

* **Wipe inward follows the retraction settings** by @valerii-bokhan in [17160](https://github.com/OrcaSlicer/OrcaSlicer/pull/17160) — **Wipe inward** now retracts the same way as the regular wipe, keeping your split between retracting before and during the wipe, and is skipped when a travel needs no retraction. It's now available with the **Outer/Inner** wall order too. With Outer/Inner and **Inner/Outer/Inner**, where the inner wall next to the seam isn't printed yet, it moves inward by at most half the outer wall's width. At seams on corners, it picks its direction from where the nozzle actually is.

* **As object list keeps copies in list order** by @lamweilun in [17232](https://github.com/OrcaSlicer/OrcaSlicer/pull/17232) — with the print sequence set to **By layer** and **Intra-layer order** set to **As object list**, copies of one object could print out of list order, for example when every second copy was rotated. They now follow the list, and the 3D view's Sequence # labels match. Fixes #17221.

## Belt Printers

* **Brim and part at the same height above the belt** by @HarrierPigeon in [16757](https://github.com/OrcaSlicer/OrcaSlicer/pull/16757)
    The brim was laid lower above the belt than the part's outer wall, by 0.12 mm at 45° with 0.32 mm layers, so no Y offset or endstop setting worked for both. Brim lines now sit at the height of the outer wall that rests on the belt. Where the part's walls touch the belt, they also print with the first-layer speed, flow and fan settings, as the brim already did. If you leveled your belt against the brim, level it once more. Fixes #16705.

* **Z shrinkage compensation applied once** by @fa1k3 in [16490](https://github.com/OrcaSlicer/OrcaSlicer/pull/16490) — with **Shrinkage (Z)** above 100% on a belt printer, the compensation was applied twice to the part's height, so the top of the part wasn't sliced. The build height check also uses the compensated height, so a part that fits once compensated is no longer refused.

## Prime Tower & Multi-Material

* **Klipper printers no longer stop over the wipe tower** by @ghzserg in [17246](https://github.com/OrcaSlicer/OrcaSlicer/pull/17246) — since the 2.5.0 alpha, extra `M400` commands stopped Klipper printers over the wipe tower up to five times per tool change, and the nozzle oozed onto it. The printer now waits only where it must, such as before a temperature change or the tool change itself. On a print with 247 tool changes, the extra stops cost about 30 minutes.

## Presets & Projects

* **Projects with fewer filaments than the printer has tools** by @raistlin7447 and @HanifKoh in [17330](https://github.com/OrcaSlicer/OrcaSlicer/pull/17330) and [17262](https://github.com/OrcaSlicer/OrcaSlicer/pull/17262)
    On a tool changer such as the Snapmaker U1, opening a project with fewer filaments than the printer has tools could make slicing fail with "Flush volumes matrix do not match to the correct size!", crash **Synchronize now**, or leave the extra slots in the sidebar without a filament list for the rest of the session. Every slot now gets its settings and filament list, and the new slots take filament 1's color, as in 2.4. Fixes #16432, #17288 and #17258.

* **Presets keep Arc fitting after an upgrade** by @HanifKoh in [17047](https://github.com/OrcaSlicer/OrcaSlicer/pull/17047) — **Arc fitting** changed from on/off to a list of choices in the 2.5.0 beta. If you upgraded from the 2.5.0 alpha, process presets from Creality, Prusa and 11 other vendors could show and slice with Arc fitting off. They now keep the setting from their profile.

* **Profile updates between releases are back on** by @SoftFever in [17289](https://github.com/OrcaSlicer/OrcaSlicer/pull/17289) — OrcaSlicer again downloads the printer and filament profile updates published between releases, as 2.4 did. The 2.5.0 alpha, beta and release candidate only did so with a hidden setting turned on. With **Stealth mode** on, OrcaSlicer no longer checks for them.

## Plugins

* **Plugin dependencies with a version range install** by @SoftFever in [17196](https://github.com/OrcaSlicer/OrcaSlicer/pull/17196) — a `.py` plugin that lists a dependency with a version range, such as `"numpy>=1.20,<2"`, on one line now installs its packages. Before, OrcaSlicer split the list at every comma, so the install failed.

* **Plugins work with folders that have non-Latin names** by @GNUGiminot in [16925](https://github.com/OrcaSlicer/OrcaSlicer/pull/16925) — on Windows with a UI language such as Russian, a plugin that touched a folder with a non-Latin name, such as a Cyrillic one, hung, and OrcaSlicer could crash soon after.

## Interface Fixes

* **Speed Dial stays centered on the main window** by @lamweilun in [17242](https://github.com/OrcaSlicer/OrcaSlicer/pull/17242) — after you move or resize the main window, or drag it to another display, Speed Dial opens centered on it instead of where the window used to be.

* **Speed Dial stays open on Linux** by @lamweilun in [17245](https://github.com/OrcaSlicer/OrcaSlicer/pull/17245) — opening Speed Dial soon after startup no longer closes it again a moment later.

* **3D navigator drags with an object behind it** by @lamweilun in [17284](https://github.com/OrcaSlicer/OrcaSlicer/pull/17284) — dragging the navigator cube now rotates the view even when an object sits behind it. Before, the drag was ignored and the view snapped to the face you pressed when you let go. Fixes #17282.

## Crashes & Hangs

* **Esc in the settings search no longer freezes OrcaSlicer on Linux** by @HanifKoh in [17118](https://github.com/OrcaSlicer/OrcaSlicer/pull/17118) — pressing Esc while searching in the printer or filament settings closed the settings dialog but left the search popup open. On Wayland the whole window froze, and on X11 the popup swallowed the next click. Esc now closes the search first, here and in the object list search. Fixes #17067.

* **No Mesh Boolean crash on some meshes** by @Noisyfox in [17080](https://github.com/OrcaSlicer/OrcaSlicer/pull/17080) — **Mesh boolean** no longer crashes on meshes with stray vertices that aren't part of any triangle, which some imported projects have.

* **No crash syncing filaments after deleting a plate** by @akaitsukiakari in [17042](https://github.com/OrcaSlicer/OrcaSlicer/pull/17042) — syncing filaments from a printer no longer crashes when the plate used for the previous sync was deleted, or a project with fewer plates was opened since.

* **No freeze before the Creality send dialog** by @raistlin7447 in [17177](https://github.com/OrcaSlicer/OrcaSlicer/pull/17177)
    On a Creality printer without a CFS, such as a K1C, clicking **Print** froze OrcaSlicer for 10 seconds while it waited for slot data the printer never sends. The dialog now opens right away and reads the printer in the background: **Upload** works at once, and **Upload and Print** turns on when the read ends. When there's no filament mapping, the dialog says why. Fixes #17128.

    <img width="450" alt="Send G-code dialog for a K1C saying the printer reports no CFS connected, so the print will use the external spool" src="https://github.com/user-attachments/assets/ad7612a1-d5cf-4a55-a2b5-e3d8c32cf773" />

## Printer Connectivity & Cloud

* **Custom camera source is back** by @HanifKoh in [17326](https://github.com/OrcaSlicer/OrcaSlicer/pull/17326) — the **Custom camera source** setting in the Device tab's camera settings, missing since the 2.5.0 alpha, is back for Bambu Lab printers, so the Device tab can show your own camera again. A source you set up in 2.4 comes back without entering it again, and a button in the **Camera** panel's title bar switches between it and the printer's own camera. Fixes #17308.

* **Orca Cloud presets download on a new computer** by @HanifKoh in [17263](https://github.com/OrcaSlicer/OrcaSlicer/pull/17263) — on a computer that had never synced with Orca Cloud, your presets could fail to download, however many times you restarted OrcaSlicer. They now download on the first sync. Fixes #17256.

* **AMS settings show a connected AMS Lite** by @lamweilun in [17159](https://github.com/OrcaSlicer/OrcaSlicer/pull/17159) — on an A-series printer with an AMS Lite, the AMS settings dialog showed "AMS/AMS 2 Pro/AMS HT" as the connected type, and choosing AMS Lite in the list asked the printer for the regular AMS firmware. Fixes #17125.

* **Qidi printers keep the native Device and Calibration tabs** by @peachismomo in [17162](https://github.com/OrcaSlicer/OrcaSlicer/pull/17162) — with **Use printer agents instead of print hosts** on, Qidi printers get the same tabs as other Moonraker printers again: **Device**, **Calibration**, and the printer's web page as **Device (Web)**. In the release candidate, the web page replaced the Device tab and the Calibration tab was hidden. Qidi Box slot mapping at print start is unchanged.

* **Moonraker printers connect after switching agents** by @thelegendtubaguy in [17141](https://github.com/OrcaSlicer/OrcaSlicer/pull/17141) — with **Use printer agents instead of print hosts** on, a printer preset switched to the Moonraker agent now connects, and filament sync works, even when OrcaSlicer had saved that printer under the default agent. Fixes #17004.

# 🧰 Platform & Build

* **Windows builds signed by OrcaSlicer** by @SoftFever in [17305](https://github.com/OrcaSlicer/OrcaSlicer/pull/17305) — Windows release and nightly builds, including the installer and the app's program files, are now signed and timestamped with OrcaSlicer's own code signing certificate, issued to ORCASLICER PTE. LTD., so Smart App Control and SmartScreen see a known publisher.

# 🖨️ Printer & Filament Profiles

## New Filament Profiles

* **PrintaLot PETG** — 24 presets covering 56 Bambu Lab printer and nozzle combinations in the Orca Filament Library, by @sirjassam in [17029](https://github.com/OrcaSlicer/OrcaSlicer/pull/17029)

* **Recycling Fabrik and EverLoop** — rPLA, rPETG and rABS from Recycling Fabrik, and EverLoop rPLA Premium, rPLA Premium Matte and rPETG Premium, all made from 100% recycled plastic, for every printer in the Orca Filament Library, by @rudeldi in [17188](https://github.com/OrcaSlicer/OrcaSlicer/pull/17188)

## Profile Updates & Fixes

* **Sovol SV08 MAX** — 0.2 and 1.0 mm nozzle variants with their own process presets, by @thalisantunes in [17108](https://github.com/OrcaSlicer/OrcaSlicer/pull/17108)

* **Sovol SV08** — the 0.4 and 0.8 mm nozzle printers now default to their own process presets, by @thalisantunes in [17106](https://github.com/OrcaSlicer/OrcaSlicer/pull/17106)

* **Prusa XL** — a misspelled setting name left the presets' deretraction speeds at 30 mm/s; they now use 25 mm/s, or 15 mm/s with the 0.8 mm nozzle, by @nuclearmistake in [17259](https://github.com/OrcaSlicer/OrcaSlicer/pull/17259)

* **Flashforge** — 23 printers now default to a process preset they can use, the Creator 5 0.32 mm process moves from the 0.6 to the 0.8 mm nozzle, and the Creator 5 Pro chamber heats when chamber temperature control is on, by @thelegendtubaguy in [17323](https://github.com/OrcaSlicer/OrcaSlicer/pull/17323) (Fixes #17306 and #14353)

# 🗪 Localization

* All 22 languages now cover every new string in 2.5.0, by @SoftFever and @raistlin7447 in [17332](https://github.com/OrcaSlicer/OrcaSlicer/pull/17332), [17333](https://github.com/OrcaSlicer/OrcaSlicer/pull/17333) and [17336](https://github.com/OrcaSlicer/OrcaSlicer/pull/17336). Simplified and Traditional Chinese are complete, strings that came back in 2.5.0, such as the custom camera source, get their earlier human translations back, and most other new strings are machine translations.
* Russian translation update by @Felix14-v2 in [17225](https://github.com/OrcaSlicer/OrcaSlicer/pull/17225)
* On the plugin Permissions tab, **Processes** (programs a plugin may start) no longer shows the French, Russian, Vietnamese and Chinese word for print process presets, by @raistlin7447 in [17339](https://github.com/OrcaSlicer/OrcaSlicer/pull/17339)
* UTF-8, SVG and STEP are always in uppercase, and RepRapFirmware is spelled the same way everywhere, by @afmenez in [17092](https://github.com/OrcaSlicer/OrcaSlicer/pull/17092) and [17174](https://github.com/OrcaSlicer/OrcaSlicer/pull/17174)

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
