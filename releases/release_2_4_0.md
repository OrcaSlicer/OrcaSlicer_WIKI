# V2.4.0

This is the OrcaSlicer V2.4.0 release. It focuses on bug fixes, a smoother Orca Cloud experience, and new features such as sending sliced jobs to the printer as a packaged 3MF. On the Orca Cloud side, you now stay logged in while offline, a sync can no longer overwrite a locally recreated preset, and a notification tells you when a subscribed preset has an update available. Other additions include a new Microsoft Store install channel for Windows (submission currently under review), faster slice-to-preview processing (with the largest gains on Klipper-flavor printers), a skirt-generation overhaul, and filament-list quality-of-life improvements — alongside a broad round of bug fixes (tree supports, calibration, motion-ability settings, and Linux/Flatpak) and refreshed translations, including Chinese.

**Note:** Everything from the 2.4.0 Alpha and 2.4.0 Beta is included in this build — Orca Cloud, Z Anti-Aliasing (ZAA) contouring, Machine Input Shaping, Optimized Gyroid infill, the redesigned printer selection dialog, Realistic View rendering, the bridging overhaul, expanded per-feature filament assignment, the Troubleshoot Center, native Moonraker and 3DPrinterOS hosts, and Creality K-series support. See the [2.4.0 Alpha](https://www.orcaslicer.com/wiki/releases/release_2_4_0_alpha.html) and [2.4.0 Beta](https://www.orcaslicer.com/wiki/releases/release_2_4_0_beta.html) release notes for details on those.

# 🌊 New Features & Improvements

* **Send sliced jobs to the printer as a packaged 3MF** by @SoftFever in [14238](https://github.com/OrcaSlicer/OrcaSlicer/pull/14238)
    Adds a per-printer option, "Use 3MF instead of G-code" (off by default), under Printer Settings → Basic information → Advanced. When enabled, Orca sends the sliced job as a packaged `.gcode.3mf` file instead of a plain `.gcode`, with the slice metadata correlated to the object labels embedded in the G-code. The option is export-only, so toggling it does not trigger a re-slice, and it persists with the printer preset. Fixes #11173.

    <img width="500" alt="Use 3MF instead of G-code option" src="https://github.com/user-attachments/assets/f8568c59-5acf-4180-a4c4-083729b690e4" />

* **Microsoft Store (MSIX) install channel for Windows** by @SoftFever in [14142](https://github.com/OrcaSlicer/OrcaSlicer/pull/14142)
    Adds a Microsoft Store MSIX package as a new Windows install channel, built by CI from the same install tree as the existing installer. This gives Windows 11 users a channel that works under Smart App Control — which otherwise blocks the unsigned GitHub installer — with the Store handling signing. In the packaged build, the update dialog points to the Microsoft Store instead of the GitHub release page, and file/URL associations are managed through Windows' Default Apps settings; configuration still lives in `%APPDATA%\OrcaSlicer` and is shared with classic installs. The classic NSIS installer and portable builds are unchanged.

    **Note:** the Store submission is still going through Microsoft's certification review, so the listing isn't publicly available yet — it will appear on the Microsoft Store once approved. Until then, install this release using the classic installer or portable builds as usual.

    <img width="500" alt="OrcaSlicer on the Microsoft Store" src="https://github.com/user-attachments/assets/73fd2b73-6a80-4455-93eb-10fd8188999c" />

* **Stay logged in to Orca Cloud while offline** by @Noisyfox in [14235](https://github.com/OrcaSlicer/OrcaSlicer/pull/14235)
    Orca Cloud session information is now stored locally (in the system keystore where available, otherwise encrypted with a per-machine key), so you can keep using Orca and your custom profiles while offline. Previously, having no internet connection — or even a brief network glitch at startup — would log you out automatically and make your profiles unavailable. Note that switching back to an older OrcaSlicer version after using this will log you out, since the older version can't read the new session format.

* **Filament list improvements: count badge, auto-scroll, and auto-unfold** by @yw4z in [14158](https://github.com/OrcaSlicer/OrcaSlicer/pull/14158)
    Several usability improvements for sessions with many filament profiles. A counter shows the number of filaments when the list is folded or longer than the preferred count; the list auto-scrolls to the end when you add or delete an entry so the change is visible; and the list automatically unfolds when you use the add/delete buttons, so those actions give feedback even when the area was collapsed.

    <img width="400" alt="Filament counter" src="https://github.com/user-attachments/assets/85e7312f-fcba-4e9e-9c93-09ee1316d513" />

    | Scroll to end on change: before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/fc21c6bc-c5cd-48db-9174-b8cb64088363" /> | <img width="400" src="https://github.com/user-attachments/assets/4268cccd-eb1d-4b66-b324-efabcfe274fb" /> |

    | Auto-unfold on add/remove: before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/c9712448-29df-45e9-8032-4be74b5062e2" /> | <img width="400" src="https://github.com/user-attachments/assets/2542aa7c-9f9b-44ab-851a-cc90f17c523b" /> |

* **Show the active printer name on the collapsed printer header** by @yw4z in [14148](https://github.com/OrcaSlicer/OrcaSlicer/pull/14148)
    When the printer section in the settings sidebar is folded, its title bar now shows the name of the currently active printer, so you no longer have to unfold the section to check which printer is selected. The section also automatically unfolds when a new printer is enabled from the printer-selection dialog, giving clear feedback for the change.

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/bcdb9220-b355-4a4f-a864-b27b84f3f4cf" /> | <img width="400" src="https://github.com/user-attachments/assets/e01b84ce-56dc-430c-a97f-77b9d89780eb" /> |

* **Faster slicing by caching G-code post-processing patterns** by @grant0013 in [14166](https://github.com/OrcaSlicer/OrcaSlicer/pull/14166)
    The post-slice processing pass that builds the preview and time estimates was rebuilding the same text-matching patterns for every G-code line it scanned; those patterns are now built once and reused. This speeds up the slice-to-preview step for all printers, with the biggest effect on Klipper-flavor machines (Creality K1/K2, Voron, Qidi, and similar) where the affected commands appear very frequently. In the author's reported benchmarks, a single Benchy sliced about 37% faster and a 16-Benchy plate about 65% faster (~2.9×), with byte-identical G-code output.

* **Notification when subscribed presets have updates available** by @peachismomo in [14121](https://github.com/OrcaSlicer/OrcaSlicer/pull/14121)
    Previously you only learned that a subscribed preset had an update by opening the preset bundle dialog. A plater notification now appears when Orca detects an available update for a subscribed preset, so you're alerted without having to check manually.

    <img width="500" alt="Subscribed preset update notification" src="https://github.com/user-attachments/assets/083a2d04-02f2-4a8d-825c-f0fcb791ee60" />

* **Open the Troubleshoot Center from the sidebar dev button** by @yw4z in [14178](https://github.com/OrcaSlicer/OrcaSlicer/pull/14178)
    Clicking the dev button on the sidebar now opens the Troubleshoot Center, giving quick access to diagnostics such as opening the configuration folder, packing project logs, clearing logs, and changing the log level.

* **Allow drop of sunken objects** by @vovodroid in [14243](https://github.com/OrcaSlicer/OrcaSlicer/pull/14243)
    The Drop (place-on-bed) menu item was grayed out when an object was sunk below the build plate, so it couldn't be used to bring that object back up. The Drop item now stays enabled for sunken objects, letting you raise them onto the plate.

* **Skirt overhaul: collision-aware per-object skirts and correct skirt → brim order** by @kisslorand in [14130](https://github.com/OrcaSlicer/OrcaSlicer/pull/14130)
    Reworks skirt generation. Per-object skirts are now aware of nearby features — brims, support bases, rafts, and other generated structures — and are built around each object's complete footprint at the configured skirt distance. When a skirt would intersect another object, skirt, or feature, only the affected items are grouped under a single shared skirt, expanding the group recursively until nothing overlaps; previously per-object skirts ignored surrounding features and could run through them. It also fixes the skirt/brim print order so a combined brim is now printed after the skirt instead of before it. Fixes #14101.

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/d720443d-d807-4e38-842c-899ee462efcf" /> | <img width="400" src="https://github.com/user-attachments/assets/baa8138f-2751-4f3e-baeb-f98a7c8ae601" /> |

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/ea5f5fc3-e08b-46b1-85e1-cbd3d49a745d" /> | <img width="400" src="https://github.com/user-attachments/assets/85d3fe07-1652-463d-a950-23a46575a57b" /> |

* **Smoother object shading in the 3D view** by @RF47 in [14080](https://github.com/OrcaSlicer/OrcaSlicer/pull/14080)
    Object surfaces are now rendered with smoothed shading normals, so individual mesh facets no longer show through in the highlights and curved surfaces look smoother in the 3D view. Inspired by a suggestion from @SoftFever in #13704.

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/350235b1-fab1-4578-8ae6-7c6bbe09dfcb" /> | <img width="400" src="https://github.com/user-attachments/assets/f471a766-e780-40a5-931d-db1890d6e10e" /> |

# 🛠️ Bug Fixes

* **Keep non-organic tree supports clear of object surfaces** by @kisslorand in [14128](https://github.com/OrcaSlicer/OrcaSlicer/pull/14128)
    Non-organic (classic) tree supports could be generated partially resting directly on the object's top surfaces, ignoring the intended gap. They now respect the configured Bottom Z distance as vertical clearance, so supports stay clear of those surfaces and are easier to remove without marking the part. Fixes #13997.

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/7dd39b9d-6563-44c6-b597-477d13d66960" /> | <img width="400" src="https://github.com/user-attachments/assets/dffbc059-102f-48bd-b97d-e344b2c6931f" /> |

* **Preserve the chosen preview view mode on multi-color prints** by @malventano in [13625](https://github.com/OrcaSlicer/OrcaSlicer/pull/13625)
    Fixes a regression where multi-extruder/multi-color prints forced the preview back to the Filament view on every refresh or re-slice, overwriting a manual view change (single-color prints already kept the user's choice). The smart default (Line Type for single-filament, Filament for multi-filament) is now applied only when the extruder count actually changes, so your selected view persists across re-slices and when switching between plates of the same color type, while still defaulting correctly when switching between single- and multi-color plates.

* **Apply motion ability settings correctly on multi-variant printers** by @Noisyfox in [14253](https://github.com/OrcaSlicer/OrcaSlicer/pull/14253)
    On printers such as the U1 and H2D, values changed on the motion ability settings page were written to the wrong storage slot, so the configured acceleration/jerk/velocity limits weren't saved or applied as expected. They are now stored correctly, so the configured limits are applied and emitted in the generated G-code. Fixes #13308.

* **Fix unclickable window title-bar buttons on Windows** by @Noisyfox in [14139](https://github.com/OrcaSlicer/OrcaSlicer/pull/14139)
    On Windows, the window title-bar buttons (minimize / maximize / close) could sometimes stop responding to clicks. The cursor position is now current when those buttons are hit-tested, so they reliably respond again.

    <img width="450" alt="Windows title-bar buttons" src="https://github.com/user-attachments/assets/a9a8b054-12a1-4dec-bbc7-01dd9aaaef9f" />

* **Correct the top-row tile order in YOLO Perfectionist flow calibration** by @raistlin7447 in [14132](https://github.com/OrcaSlicer/OrcaSlicer/pull/14132)
    In the YOLO Perfectionist flow-rate calibration, the top row of test tiles was laid out in the wrong left-to-right order, breaking the alternating pattern the rest of the grid follows. The tiles now read in correct ascending order, matching their printed labels. Fixes #13974.

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/2d383805-f302-481a-a6b4-8b6769429bfe" /> | <img width="400" src="https://github.com/user-attachments/assets/d32c4685-3002-4af4-a83e-9b317108bbc3" /> |

* **Fix print uploads to Creality printers with non-ASCII filenames** by @totrytakeoff in [13833](https://github.com/OrcaSlicer/OrcaSlicer/pull/13833)
    Sending a print to Creality printers (CrealityPrint host) could fail when the G-code filename contained non-ASCII characters (such as Chinese) or reserved URL characters, causing the upload to drop. Filenames are now properly encoded for the upload request, so these uploads complete successfully; the stored filename and the print command are unchanged. Fixes #11163.

* **Don't let cloud sync delete a locally recreated preset** by @peachismomo in [14116](https://github.com/OrcaSlicer/OrcaSlicer/pull/14116)
    If you deleted a preset on Orca Cloud and then created a new local preset with the same name, syncing could silently delete that new local preset. Orca now detects this conflict and offers a force-push-only option instead of pulling (which would have wiped the local copy), and unrecognized sync conflicts are handled more gracefully.

* **Fix source-build dependency installation on Arch Linux** by @dielectric-coder in [14171](https://github.com/OrcaSlicer/OrcaSlicer/pull/14171)
    Building OrcaSlicer from source on Arch Linux and Arch-based distros (such as CachyOS) failed during dependency installation because the package list referenced packages that had been renamed or removed from the official repositories. The dependency list is updated (drops the unavailable `gstreamermm`, switches to `webkit2gtk-4.1`, and performs a full system upgrade), so the Linux build script resolves dependencies and builds successfully again.

* **Fix Flatpak config migration from older installs** by @SoftFever in [3ffb958](https://github.com/OrcaSlicer/OrcaSlicer/commit/3ffb9585d2a9b97da53fdf6b305cbc5f4eb22b3b)
    The Flatpak build looked for old configuration under the wrong application ID — `io.github.orcaslicer.OrcaSlicer`, a bundle ID used only in nightly builds between 2.3.1 and 2.3.2 — so it failed to migrate settings from the widely-used pre-2.3.2 folder, `io.github.softfever.OrcaSlicer`. It now reads from the correct folder, so long-time Flatpak users keep their existing configuration when upgrading.

# 🖨️ Printer & Filament Profiles

* **Elegoo Centauri Carbon 2** layer-progress G-code fix, plus restored compatibility for renamed Elegoo Giga presets and system filaments by @wujie-elegoo in [14136](https://github.com/OrcaSlicer/OrcaSlicer/pull/14136). Fixes #14129.
* **QIDI Q2** start G-code update that fixes a bed collision at the end of the purge line by @ianalexis in [14111](https://github.com/OrcaSlicer/OrcaSlicer/pull/14111)
* **Creality K1 / K2 series** start G-code update — normalizes the K1 variants and adds the marker newer K2 firmware expects to avoid a print-time warning by @hamham999 in [14118](https://github.com/OrcaSlicer/OrcaSlicer/pull/14118)
* **Creality filament** volumetric speed correction to match current CrealityPrint values by @hamham999 in [14237](https://github.com/OrcaSlicer/OrcaSlicer/pull/14237)

# 🗪 Localization

* **German (de)** translation updates by @hliebscher in [14135](https://github.com/OrcaSlicer/OrcaSlicer/pull/14135) and [14201](https://github.com/OrcaSlicer/OrcaSlicer/pull/14201)
* **French (fr)** translation completed, with untranslated runtime strings fixed and previously hardcoded strings extracted for translation by @foXaCe in [14164](https://github.com/OrcaSlicer/OrcaSlicer/pull/14164)
* **Spanish (es)** translation update, plus reworded bridge-related tooltips by @ianalexis in [14165](https://github.com/OrcaSlicer/OrcaSlicer/pull/14165)
* **Brazilian Portuguese (pt-BR)** translation improvements by @afmenez in [14252](https://github.com/OrcaSlicer/OrcaSlicer/pull/14252)
* **Czech (cs)** translation improvements by @jakubhencl in [13666](https://github.com/OrcaSlicer/OrcaSlicer/pull/13666)
* **Chinese (zh_CN, zh_TW)** translation updates by @SoftFever in [927c5ef](https://github.com/OrcaSlicer/OrcaSlicer/commit/927c5efb8c30c15e562a538ad824d0caecbf92b1)
* **Locale catalog error fixes** across the bundled languages by @SoftFever in [81951fd](https://github.com/OrcaSlicer/OrcaSlicer/commit/81951fddb597c82fff0d356997a5e07d4fb18d3c)
* **English UI string consistency fixes** (capitalization, "G-code" hyphenation, and grammar) by @afmenez in [14047](https://github.com/OrcaSlicer/OrcaSlicer/pull/14047)

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
