# V2.5.2

This is the OrcaSlicer V2.5.2 release, a maintenance update on top of 2.5.1. Thank you to everyone who reported problems with 2.5.1!

It fixes crashes while slicing, STEP files that imported with faces missing, the Linux AppImage freezing on Wayland, and parts close to the size of the bed that wouldn't arrange. On Bambu Lab printers and others with the Type 1 prime tower, you can now set the **Prime volume** of each filament, for example to make the tower smaller. Building OrcaSlicer from source works again too.

**If you print on a Prusa CORE One or a Snapmaker U1**, see **Printer & Filament Profiles** below: CORE One presets slow down for the steepest overhangs, and the U1 checks rod clearance more strictly when printing by object.

<!-- downloads:start -->

## Downloads

| Platform | File |
| --- | --- |
| Windows installer (x64) | [OrcaSlicer_Windows_Installer_V2.5.2_x64.exe](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer_Windows_Installer_V2.5.2_x64.exe) |
| Windows installer (ARM64) | [OrcaSlicer_Windows_Installer_V2.5.2_arm64.exe](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer_Windows_Installer_V2.5.2_arm64.exe) |
| Windows portable (x64) | [OrcaSlicer_Windows_V2.5.2_x64_portable.zip](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer_Windows_V2.5.2_x64_portable.zip) |
| Windows portable (ARM64) | [OrcaSlicer_Windows_V2.5.2_arm64_portable.zip](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer_Windows_V2.5.2_arm64_portable.zip) |
| macOS (Apple Silicon and Intel) | [OrcaSlicer_Mac_universal_V2.5.2.dmg](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer_Mac_universal_V2.5.2.dmg) |
| Linux AppImage (x86_64) | [OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.5.2.AppImage](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.5.2.AppImage) |
| Linux AppImage (aarch64) | [OrcaSlicer_Linux_AppImage_Ubuntu2404_aarch64_V2.5.2.AppImage](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer_Linux_AppImage_Ubuntu2404_aarch64_V2.5.2.AppImage) |
| Linux Flatpak (x86_64) | [OrcaSlicer-Linux-flatpak_V2.5.2_x86_64.flatpak](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer-Linux-flatpak_V2.5.2_x86_64.flatpak) |
| Linux Flatpak (aarch64) | [OrcaSlicer-Linux-flatpak_V2.5.2_aarch64.flatpak](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/OrcaSlicer-Linux-flatpak_V2.5.2_aarch64.flatpak) |
| Windows debug symbols (for developers) | [Debug_PDB_V2.5.2_for_developers_only.7z](https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.5.2/Debug_PDB_V2.5.2_for_developers_only.7z) |

<!-- downloads:end -->

# 🌊 New Features & Improvements

* **Set each filament's prime volume for the Type 1 prime tower** by @Art-Porto in [17424](https://github.com/OrcaSlicer/OrcaSlicer/pull/17424)
    On the Type 1 prime tower, which every Bambu Lab printer uses, the process **Prime volume** had no effect, because the tower purges each filament's own prime volume, and no settings page showed that value. The filament's **Multimaterial** page has a new **Prime volume** group for it. **Filament change** sets how much the tower purges for a filament change. **Hotend change** does the same for a hotend change and appears on printers whose extruder holds more than one nozzle, such as the H2C. The group shows only on printers that use the Type 1 tower, and there the process **Prime volume** is greyed out, with the reason shown when you hover over its label. Projects slice as before until you change a value, and the Type 2 tower is unchanged. Fixes #16350.

    A lower prime volume makes a smaller tower: on an H2D with two filaments, setting **Filament change** to 10 mm³ instead of the profile's 30 cut the tower from 3.26 m of filament to 1.95 m.

    <img width="500" alt="Prime volume group on the filament's Multimaterial page for an H2C, with Filament change and Hotend change" src="https://github.com/user-attachments/assets/a16b08c9-1496-4e20-9ee3-dff0d16931a4" />

# 🛠️ Bug Fixes

## Crashes

* **No crash slicing some projects that 2.4 sliced** by @HanifKoh in [17599](https://github.com/OrcaSlicer/OrcaSlicer/pull/17599) and [17600](https://github.com/OrcaSlicer/OrcaSlicer/pull/17600)
    Since 2.5.0, some projects crashed OrcaSlicer while slicing. A long, nearly straight strip of internal solid infill could get a point placed metres away, and the shape that made crashed the slicer. Those strips slice correctly again. As a safety net, a region the slicer can't build toolpaths for is skipped instead of crashing the whole slice: it gets no walls or infill, and an error goes to the log. Fixes #17577.

* **No crash on an empty first layer with a prime tower** by @RF47 in [17565](https://github.com/OrcaSlicer/OrcaSlicer/pull/17565) — with the prime tower on and a single filament, an object with nothing on its first layer, such as a cube standing on an edge, crashed OrcaSlicer and the command line. Slicing stops with the "One object has an empty first layer and can't be printed" error instead, as it does without the tower. Fixes #17554.

* **No crash when the 3D view can't start OpenGL** by @HanifKoh in [17441](https://github.com/OrcaSlicer/OrcaSlicer/pull/17441)
    When OpenGL couldn't be activated for the 3D view, for example on a PC whose monitor was plugged into the motherboard with its integrated graphics turned off, OrcaSlicer showed an empty grey view and then crashed on the first notification or slice. It no longer crashes. On Windows, a message says the 3D view can't be shown, names the graphics adapter behind that display when it can find it, and lists what to check, such as plugging the monitor into another graphics card. The 3D view still needs a working OpenGL driver to draw anything.

* **No crash on a project that assigns a filament to a missing nozzle** by @HanifKoh in [17476](https://github.com/OrcaSlicer/OrcaSlicer/pull/17476) — on printers with more than one nozzle, a project that assigned a filament to a nozzle the printer doesn't have, as a hand-edited or old project can, crashed the slice, and a bad tool number for a nozzle could crash or hang the G-code export. Such a filament prints with the first nozzle, and the bad tool number is skipped. The same assignment from the command line (`--filament-map`) also slices rather than crashing.

## Slicing & Print Quality

* **Only one wall on top surfaces keeps the top infill off inner walls** by @lamweilun and @ianalexis in [17597](https://github.com/OrcaSlicer/OrcaSlicer/pull/17597)
    With **Only one wall on top surfaces** and **Top surface expansion** both on, an inner wall that ran straight across a top surface, such as the long side of a wide ledge with parts rising at its ends, was kept, and the expanded top infill printed over it. Such walls are now found along their whole length, with both wall generators. Arachne cuts them back where they cross the top. Classic drops each such wall loop whole, so more loops go than before, and the band they leave gets internal solid infill when **Ensure vertical shell thickness** is All, or sparse infill otherwise. Fixes #17300. [Wiki](https://www.orcaslicer.com/wiki/quality_settings_wall_and_surfaces#only-one-wall)

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Top surface infill printed over the inner walls on the layer where the base ends" src="https://github.com/user-attachments/assets/64318a49-c265-427b-97a1-b5772d404aaf" /> | <img width="400" alt="The same layer with no inner walls under the top surface infill" src="https://github.com/user-attachments/assets/41a3ff4b-6231-41a5-90b9-e6e1040c1c5c" /> |

* **Fewer tiny moves in smoothed infill at fine resolutions** by @ianalexis in [17630](https://github.com/OrcaSlicer/OrcaSlicer/pull/17630)
    With **Sparse infill smooth factor** on and a very fine G-code **Resolution**, each rounded corner was split into so many tiny moves that a Klipper printer had to plan over a thousand of them per second, and a Qidi Q2 stopped several times along infill paths that the preview showed without pauses. Corners follow the resolution down to 0.005 mm and no finer. On a test project at a resolution of 0, the sparse infill went from 656,000 moves to 286,000, the G-code shrank from 28 MB to 18 MB, and the infill printed about 7% faster in a simulation of Klipper's planner. At 0.005 mm or coarser, the G-code doesn't change; among system profiles, only the four with a resolution of 0 are affected. [Wiki](https://www.orcaslicer.com/wiki/strength_settings_infill#sparse-infill-smooth-factor)

* **Tree Hybrid support keeps its expanded first layer on the bed** by @HanifKoh and @hammams in [17700](https://github.com/OrcaSlicer/OrcaSlicer/pull/17700) — with **Tree Hybrid** support, no raft and a **First layer expansion** above 0, an overhang near the edge of the plate got first-layer support past the edge, and the plate was refused for G-code outside the printable area. The expanded first layer is trimmed to the bed and its excluded areas. Fixes #17695. [Wiki](https://www.orcaslicer.com/wiki/support_settings_support#initial-layer-expansion)

* **A plate's Skirt start point is saved with the project** by @yw4z in [17457](https://github.com/OrcaSlicer/OrcaSlicer/pull/17457) — a **Skirt start point** set in a plate's settings was lost when the project was saved and opened again.

* **The max flowrate test starts at its starting flow** by @ianalexis in [17699](https://github.com/OrcaSlicer/OrcaSlicer/pull/17699) — the first loop of the test's spiral ramped up from zero flow, so the base of the test printed almost no plastic and reached the starting flow only at the end of that loop. The whole first loop prints at the starting flow. [Wiki](https://www.orcaslicer.com/wiki/volumetric_speed_calib)

* **The G-code's first layer time comment reports the first layer** by @lamweilun in [17328](https://github.com/OrcaSlicer/OrcaSlicer/pull/17328) — the `; estimated first layer printing time (normal mode)` comment gave the time of the start G-code instead, close to zero when it only calls a `PRINT_START` macro. It holds the first layer's time, the same value saved in 3MF files. Fixes #17325.

## Import, Arrange & Tools

* **STEP files import with all their faces** by @RF47 in [17720](https://github.com/OrcaSlicer/OrcaSlicer/pull/17720)
    Since 2.5.0, some STEP files imported with faces missing. In the Fusion file from the report, four bands of a tilted chimney came in as flat discs. Those faces mesh completely again. On ARM64 computers, such as Apple Silicon Macs, the repair that runs on an imported mesh with holes could also merge unrelated edges and stretch triangles, in STEP and SVG imports alike. It no longer does. Fixes #17636.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="STEP model whose four cone bands imported as flat discs" src="https://github.com/user-attachments/assets/0bad88cf-ee6e-41b4-aae5-e8d40b0e7cd2" /> | <img width="300" alt="The same STEP model imported with all its faces" src="https://github.com/user-attachments/assets/ae72bfdf-45a7-46db-893a-cc1c8f6c342b" /> |

* **Parts almost as wide as the bed arrange again** by @raistlin7447 and @yw4z in [17416](https://github.com/OrcaSlicer/OrcaSlicer/pull/17416)
    Arrange couldn't place some parts that nearly fill the bed in one direction, though 2.4 could, such as 250 mm parts on the 256 mm bed of an A1. The arrange spacing no longer pushes such parts off the bed, and the room kept for brims and skirts is measured on each part as it is turned for packing, including by **Align to Y axis**. A first layer line width given as a percentage is no longer read as millimetres when leaving room for the skirt, which affected 32 bundled profiles. With an arrange spacing set, parts can also come right up to the bed margin instead of staying half the spacing inside it. Fixes #17376.

    <img width="700" alt="The reporter's parts arranged by 2.5.0 on the left and by 2.5.2 on the right" src="https://github.com/user-attachments/assets/2b9b4749-587a-4a9d-8a7e-3e5ee0d366f5" />

* **The Measure and Assemble tools work on stretched objects** by @kisslorand in [17549](https://github.com/OrcaSlicer/OrcaSlicer/pull/17549) and [17552](https://github.com/OrcaSlicer/OrcaSlicer/pull/17552)
    On an object scaled by different amounts along each axis, the **Measure** tool still took a round edge stretched into an ellipse for a circle, so it showed a wrong diameter and a highlight that didn't follow the edge. Angles between faces were off too: a pyramid stretched along X measured 91.7° instead of 96.2°. Features are now found on the stretched shape, so angles come out right and an ellipse is no longer offered as a circle. In the **Assemble** tool, **Parallel** could also deform a part of such an object, turning a cylinder's round end oval. Fixes #17526.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Measure tool highlighting a circle that doesn't follow the stretched top edge of a cylinder" src="https://github.com/user-attachments/assets/092510f2-7ef5-4a18-87b9-9503b9102e67" /> | <img width="400" alt="The same stretched edge, no longer detected as a circle" src="https://github.com/user-attachments/assets/0d814771-5001-4b7a-92f0-a8c37006a6b8" /> |
    | <img width="400" alt="Angle between two faces of a stretched pyramid measured as 91.724 degrees" src="https://github.com/user-attachments/assets/1a5c3aa5-2bb2-4cb0-9ca1-bc56a2bf609a" /> | <img width="400" alt="The same angle measured as 96.227 degrees" src="https://github.com/user-attachments/assets/cd143a6f-7946-4caf-9dde-8a1351a982a2" /> |

* **Right clicks on empty space leave the Cut tool alone** by @Noisyfox and @yw4z in [17200](https://github.com/OrcaSlicer/OrcaSlicer/pull/17200) — with the planar **Cut** tool open, a right click on empty space could change the cut preview, uncheck and grey out **Cut to parts**, and leave **Reset** unavailable. Such clicks leave everything as it was, and **Reset** stays available whenever you're assigning parts to a side of the cut.

* **The Texture Displacement tool shows only the selected object** by @yw4z in [17656](https://github.com/OrcaSlicer/OrcaSlicer/pull/17656) — the tool kept the other objects and instances on the plate in view, along with the negative parts and modifiers of the selected object. It now shows only the model parts of the object you're working on.

* **Clicks between toolbar icons stay on the toolbar** by @yw4z in [15548](https://github.com/OrcaSlicer/OrcaSlicer/pull/15548) — a click in a gap between the icons of the 3D view's top toolbar, or on one of its dividers, went through to the 3D view, which deselected the object or closed the open tool. Those clicks, right clicks included, no longer reach the 3D view, in the Assemble view too.

## Interface Fixes

* **No trailing zeros in number fields in Czech and Russian** by @HanifKoh in [17704](https://github.com/OrcaSlicer/OrcaSlicer/pull/17704) — with OrcaSlicer in Czech or Russian, numeric fields in the settings could show four decimals, such as `0.2000` instead of `0.2`. Fixes #17672.

* **The Sync Nozzle status dialog fits its table in dark mode** by @peachismomo in [17607](https://github.com/OrcaSlicer/OrcaSlicer/pull/17607) — on a printer with a nozzle rack, such as the H2C, the **Sync Nozzle status** dialog could open with a large empty band under its nozzle table, white in dark mode, and flash white before the table appeared. The dialog sizes the table once it has its full width, and opens dark in dark mode.

## Plugins

* **Cloud plugins update on Windows** by @peachismomo in [17462](https://github.com/OrcaSlicer/OrcaSlicer/pull/17462) — updating a cloud plugin that was in use could stop with an error that its folder wasn't empty, before the new version was downloaded. Those updates go through.

* **Plugin pages switch properly from the overflow tab** by @HanifKoh in [17626](https://github.com/OrcaSlicer/OrcaSlicer/pull/17626) — with more plugin pages than **Visible plugin pages** allows, picking another page from the last tab's dropdown left the previous page drawn over it. Fixes #17624.

* **Texture packs with long file paths show up on Windows** by @HanifKoh in [17730](https://github.com/OrcaSlicer/OrcaSlicer/pull/17730) — textures from a Plugin Hub texture pack whose full path reached 260 characters were missing from the texture picker, with nothing in the log, and how many went missing depended on the length of the Windows user name. They're now listed and load, and so do textures in folders whose names have non-ASCII characters. Fixes #17713.

## Linux, macOS & Windows

* **No more Wayland freezes in the AppImage** by @raistlin7447 in [17399](https://github.com/OrcaSlicer/OrcaSlicer/pull/17399)
    Since 2.5.0, the Linux AppImage could freeze or garble its window on Wayland when you opened **Preview**, **Device** or **Project**, with the 3D view staying drawn over the other pages. Reporters hit it on Intel and AMD graphics with their system's WebKitGTK. On Wayland, builds outside the Flatpak now have WebKitGTK draw through shared memory instead of the GPU buffers that broke, and the **Device** tab keeps its smooth scrolling. The Flatpak, whose own WebKitGTK works, keeps the GPU buffers. To keep them in other builds, start OrcaSlicer with `WEBKIT_DMABUF_RENDERER_FORCE_SHM=0`. Fixes #17381.

* **The 3D view stays drawn under VirtualGL** by @HarrierPigeon in [17508](https://github.com/OrcaSlicer/OrcaSlicer/pull/17508) — when OrcaSlicer runs through VirtualGL's EGL back end (`vglrun -d egl`), as in remote or headless sessions, 2.5.0 and 2.5.1 turned the 3D view black whenever it reused its last frame, such as on every plain mouse move in Preview. With FXAA on, every frame was black. The view draws normally again, with anti-aliasing kept.

* **"Open in OrcaSlicer" links work on macOS when OrcaSlicer is closed** by @bwees in [16769](https://github.com/OrcaSlicer/OrcaSlicer/pull/16769) — when OrcaSlicer wasn't already running, a link from Printables or Thingiverse started it on the Home screen without loading the model. The model now loads either way. Fixes #14602.

* **The "Check the reason" panel lays out correctly on macOS** by @raistlin7447 in [17366](https://github.com/OrcaSlicer/OrcaSlicer/pull/17366) — in the print, send, calibration and printer binding dialogs, the error panel that **Check the reason** opens drew all of its rows on top of each other. Fixes #17065.

## Printer Connectivity

* **The Device tab loads the printer's page only when you open it** by @Art-Porto in [17580](https://github.com/OrcaSlicer/OrcaSlicer/pull/17580) — since 2.5.0, for printers whose **Device** tab shows the printer's web interface, OrcaSlicer loaded that page about 20 seconds after starting, even if you never opened the tab, and kept it running until you quit. A camera on that page streamed the whole time: on a Creality K2, each open OrcaSlicer cost the printer about 14% of a CPU core. The page loads when you first open the tab.

* **Filament sync reads the CFS Lite on a Creality SPARKX i7 again** by @HanifKoh in [17702](https://github.com/OrcaSlicer/OrcaSlicer/pull/17702) — since 2.5.1, filament sync found no slots on a SPARKX i7 with a CFS Lite, because the printer first reports that no CFS is connected and sends the slots right after. OrcaSlicer now waits briefly for them. Fixes #17675.

# 🧰 Platform & Build

* **Building from source works again** by @raistlin7447, @RF47, @Noisyfox and @HanifKoh in [17742](https://github.com/OrcaSlicer/OrcaSlicer/pull/17742), [17743](https://github.com/OrcaSlicer/OrcaSlicer/pull/17743), [17725](https://github.com/OrcaSlicer/OrcaSlicer/pull/17725), [17596](https://github.com/OrcaSlicer/OrcaSlicer/pull/17596) and [17601](https://github.com/OrcaSlicer/OrcaSlicer/pull/17601)
    Since the wxWidgets fork that OrcaSlicer builds against moved on November 20, every build from source stopped at the wxWidgets download, including the Flatpak and distribution packages built from the 2.5.1 source tarball. Builds fetch the pinned wxWidgets version again. The dependencies also build with CMake 4.5, which the GNOME 50 SDK ships, with MSVC on Windows systems set to a non-UTF-8 code page such as Simplified Chinese (936), and with MSVC 14.52 on Windows on Arm. Fixes #17740.

# 🖨️ Printer & Filament Profiles

## Profile Updates & Fixes

* **Prusa CORE One presets slow down for the right overhangs** by @HanifKoh in [17605](https://github.com/OrcaSlicer/OrcaSlicer/pull/17605)
    Many CORE One and CORE One L process presets had PrusaSlicer's overhang speeds in the wrong slots, so a steeper overhang could print faster than a gentler one. "0.20mm STRUCTURAL @CORE One 0.4", for example, printed 25% overhangs at 30 mm/s and 50% overhangs at 45 mm/s. On ten presets, mostly for 0.6 mm nozzles, the steepest overhangs printed at a speed meant for mild ones, about 91 mm/s on "0.20mm SPEED @CORE One 0.6". The speeds move to the right slots with their values unchanged, and the CORE One MMU3 presets take the corrected speeds from the presets they're based on. Fixes #17604.

* **Snapmaker U1 rod clearance from Snapmaker's own measurements** by @KuzuriAo and @ianalexis in [17276](https://github.com/OrcaSlicer/OrcaSlicer/pull/17276) and [17099](https://github.com/OrcaSlicer/OrcaSlicer/pull/17099)
    The U1's **Height to rod** drops from 27.5 to 26 mm, Snapmaker's CAD value of 27.05 mm with a 1 mm safety margin, and **Distance to rod** is 41.2 mm instead of the default 40. When printing by object, a plate is now refused if an object between 26 and 27.5 mm tall shares a Y band with an object printed after it, since the rod can touch it or come within a millimetre. The **Snapmaker U1 (0.4+0.6 nozzle)** profile, which set no clearances of its own, gets the U1's values instead of a 36 mm rod height and a 65 mm radius. A typo in the comments of the U1 start G-code is fixed too. Fixes #17091.

* **AnkerMake M5 printers show the right print time** by @MinDBreaK in [17548](https://github.com/OrcaSlicer/OrcaSlicer/pull/17548) — the print time written for the printer held only the seconds part of the total, so the printer showed the wrong time. The fix was tested on the M5, and the M5C, which shares its start G-code, gets it too.

# 🗪 Localization

* All 22 languages translate every new string in 2.5.2, by @HanifKoh in [7324a6f](https://github.com/OrcaSlicer/OrcaSlicer/commit/7324a6f08100ac0316a45d9a0049cb6b31c26982)

* Korean uses the same word for "extruder" in the left and right extruder labels as everywhere else, by @rlarjsdn-kgw in [17612](https://github.com/OrcaSlicer/OrcaSlicer/pull/17612)

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
