# Release V2.4.0 Alpha

This is the OrcaSlicer V2.4.0 Alpha release. The headline feature is **Orca Cloud** — a new centralized platform for profile sync, preset bundle sharing, and community discovery at cloud.orcaslicer.com. This release also introduces **Z Anti-Aliasing (ZAA) contouring** for smoother top surfaces, an Expert user mode, native Wayland support for Linux, Machine Input Shaping, Optimized Gyroid infill, Prusa-style combined brims, a redesigned printer selection dialog, and a large number of bug fixes and profile updates.

**Note:** Please check #13828 for known issues.

# ☁️ Orca Cloud

Orca Cloud is now live at [cloud.orcaslicer.com](https://cloud.orcaslicer.com) — a centralized platform that brings your 3D printing workflow online.

It keeps your printer, filament, and process profiles synchronized across every machine you use, lets you share finely tuned preset bundles with the community, and helps you discover configurations created by fellow makers around the world.

Think of it as the connective tissue between your slicer, your profiles, and the broader OrcaSlicer ecosystem — no more manually copying config files between computers or hunting through forums for the right profile.

**Note:** Orca Cloud is optional. Local profiles and existing OrcaSlicer workflows continue to work as before. You can keep using OrcaSlicer without logging in to Orca Cloud.

**Open ecosystem:** Orca Cloud is part of our long-term vision for an open 3D printing ecosystem. We want OrcaSlicer to connect users, contributors, printer manufacturers, filament makers, and hardware/software partners through shared profiles, better compatibility data, and smoother workflows. We welcome users, makers, manufacturers, and partners to join, integrate, and collaborate with us to build an ecosystem that benefits the whole community and the wider 3D printing industry.

This is just the beginning. We have many more features planned for Orca Cloud and the broader OrcaSlicer ecosystem.

Orca Cloud is designed with privacy in mind. Data is currently hosted in the USA. In the future, we plan to add more region-specific servers and allow users to choose their preferred data center location for improved performance, data residency, and privacy needs.

* **Orca Cloud — Profile Sync, Version History, Preset Bundles, and Community Sharing** [PR 13414](https://github.com/OrcaSlicer/OrcaSlicer/pull/13414)

    **Profile Sync:** Log in to OrcaSlicer with your Orca Cloud account, and your printer, filament, and process profiles sync automatically across machines. You can also view and manage all synced profiles from the Orca Cloud web interface.

    <img width="1481" height="969" alt="Orca Cloud profile sync interface" src="https://github.com/user-attachments/assets/c7be02c0-d2c4-45d0-b971-fbe7fbf0bbb7" />

    **Profile Version History:** Your cloud-backed profiles support version history on Orca Cloud. Mark milestones, track what changed, and revert to a previous version whenever you need — useful for recovering from a tuning session that did not work out, or rolling back to a known-good configuration before an important print.

    <img width="1547" height="828" alt="Orca Cloud profile version history" src="https://github.com/user-attachments/assets/51df0928-abc4-45d4-867e-d942412dab54" />

    **Preset Bundles:** Create shareable preset bundles with descriptions, images, version info, and compatible printer metadata. Publish them publicly for the community to discover, or keep them private and share only with specific collaborators.

    <img width="1344" height="830" alt="Orca Cloud preset bundle editor" src="https://github.com/user-attachments/assets/53c0ae4f-87f7-4b26-bbef-1a9b4b0d27cb" />

    **Community Explore:** Browse public bundles shared by the community on the Orca Cloud website. Subscribe to bundles you like and they will sync to your slicer automatically, with update notifications when the author publishes a new version.

    <img width="1479" height="1103" alt="Orca Cloud community explore page" src="https://github.com/user-attachments/assets/8e62b86a-ba97-46e7-b895-f43015c6463f" />

    **Full introduction video:**

    <video controls width="800" src="https://github.com/user-attachments/assets/c7031969-d8e1-4f0d-8344-79ce18ea1378"></video>

    **Orca Cloud Wiki:** [cloud.orcaslicer.com/wiki/](https://cloud.orcaslicer.com/wiki/)

* **Orca Cloud improvements and fixes** by @peachismomo, @ExPikaPaka, @SoftFever, @andrewsoonqn, and @erpalma in [PR 13755](https://github.com/OrcaSlicer/OrcaSlicer/pull/13755), [PR 13745](https://github.com/OrcaSlicer/OrcaSlicer/pull/13745), [PR 13757](https://github.com/OrcaSlicer/OrcaSlicer/pull/13757), [PR 13778](https://github.com/OrcaSlicer/OrcaSlicer/pull/13778), [PR 13673](https://github.com/OrcaSlicer/OrcaSlicer/pull/13673), [PR 13738](https://github.com/OrcaSlicer/OrcaSlicer/pull/13738), [PR 13793](https://github.com/OrcaSlicer/OrcaSlicer/pull/13793), [PR 13645](https://github.com/OrcaSlicer/OrcaSlicer/pull/13645), [PR 13756](https://github.com/OrcaSlicer/OrcaSlicer/pull/13756), [PR 13779](https://github.com/OrcaSlicer/OrcaSlicer/pull/13779), [PR 13776](https://github.com/OrcaSlicer/OrcaSlicer/pull/13776), [PR 13781](https://github.com/OrcaSlicer/OrcaSlicer/pull/13781), [PR 13796](https://github.com/OrcaSlicer/OrcaSlicer/pull/13796), and [PR 13797](https://github.com/OrcaSlicer/OrcaSlicer/pull/13797)
    Multiple follow-up improvements to the Orca Cloud experience: clearer visual distinction between Orca Cloud and Bambu Cloud login UIs, a force sync button for manually pushing profiles to the cloud (with a fix for the false "modified" highlight during sync), synced preset values now reflect in the UI immediately without needing to switch tabs, a consistent account display name between login and refresh, restored printer camera live view for cloud-connected printers (including H2D), clearer cloud error messages, HTTP error responses now show user-visible message boxes instead of failing silently, cloud sync during startup now runs in the background to eliminate UI freezes, and fixes for detached custom presets not appearing after download, spurious 401 login errors on slow networks, 409 sync conflicts on startup, and a crash from cloud preset sync racing the GUI at startup.

* **Add more logs to track Orca Cloud logout issues** by @peachismomo in [PR 13713](https://github.com/OrcaSlicer/OrcaSlicer/pull/13713)
    Added diagnostic logging around cloud logout events to help identify unexpected logouts.

# 🌊 New Features & Improvements

* **Z Anti-Aliasing (ZAA) contouring** by @adob in [PR 12736](https://github.com/OrcaSlicer/OrcaSlicer/pull/12736) with fixes and improvements by @valerii-bokhan, @RF47, and @ianalexis in [PR 13452](https://github.com/OrcaSlicer/OrcaSlicer/pull/13452), [PR 13508](https://github.com/OrcaSlicer/OrcaSlicer/pull/13508), [PR 13510](https://github.com/OrcaSlicer/OrcaSlicer/pull/13510), [PR 13450](https://github.com/OrcaSlicer/OrcaSlicer/pull/13450), [PR 13766](https://github.com/OrcaSlicer/OrcaSlicer/pull/13766), and [PR 13446](https://github.com/OrcaSlicer/OrcaSlicer/pull/13446)
    Z Anti-Aliasing (ZAA) reduces visible stair-stepping on curved and sloped top surfaces by raycasting each extrusion point against the original 3D mesh and micro-adjusting the Z height to follow the actual surface geometry. Instead of keeping every move at a single flat Z for the whole layer, OrcaSlicer emits varying Z values inside the affected layer — noticeably smoothing domes, chamfers, and shallow slopes without changing the nominal layer height of the rest of the print. Five new settings are available under Print Settings > Quality (`zaa_enabled`, `zaa_min_z`, `zaa_minimize_perimeter_height`, `zaa_dont_alternate_fill_direction`, `zaa_region_disable`). This is an Expert mode feature currently targeting top-facing curved or sloped surfaces. [Wiki](https://www.orcaslicer.com/wiki/quality_settings_z_contouring)

    <img width="800" alt="ZAA contouring" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/z-contouring/z-contouring.jpg?raw=true" />

* **Fuzzy skin ripple mode** by @GeordieTomo in [PR 13471](https://github.com/OrcaSlicer/OrcaSlicer/pull/13471) with improvements by @ianalexis in [PR 13506](https://github.com/OrcaSlicer/OrcaSlicer/pull/13506) and [PR 12479](https://github.com/OrcaSlicer/OrcaSlicer/pull/12479)
    Adds a new Ripple generator mode to fuzzy skin that produces uniform patterned textures instead of noise-based perturbation. Three new parameters are available when Ripple mode is selected: ripples per layer, ripple offset, and layers between ripple offset. Also includes fixes for fuzzy skin artifacts when combined with painted fuzzy skin regions and sacrificial bridge layers. Fixes #13325. [Wiki](https://www.orcaslicer.com/wiki/others_settings_fuzzy_skin)

    <img width="600" alt="Fuzzy skin ripple mode settings" src="https://github.com/user-attachments/assets/a143baf3-ea5b-4a3e-abbb-99163e533bf7" />

    | Classic noise | Ripple mode |
    |---------------|-------------|
    | <img width="400" alt="Classic fuzzy skin" src="https://github.com/user-attachments/assets/c9d2e206-cecd-4d6b-86de-6e1c516b02ae" /> | <img width="400" alt="Ripple fuzzy skin" src="https://github.com/user-attachments/assets/396dc249-b861-44af-929b-915281eafab4" /> |

* **Optimized Gyroid infill** by @peyton-marcotte in [PR 13379](https://github.com/OrcaSlicer/OrcaSlicer/pull/13379)
    Adds an experimental "Optimize gyroid wave" option that automatically tunes the gyroid wavelength and amplitude per region based on density, line spacing, and layer height. The optimization uses Euler-Bernoulli buckling physics: by tightening the wave along the Z (layer-stacking) axis, each vertical strand gains higher resistance to buckling under compression — the dominant failure mode for FFF parts under load. Standard gyroid output is byte-identical when the option is unchecked. Developed as part of the CRAMP project at Brown University with NASA Space Grant funding, in collaboration with ELEGOO and Polymaker. Winning architectures from this research beat commodity baselines by up to 60% in compressive strength-to-mass.

    <img width="600" alt="Optimized Gyroid infill comparison" src="https://github.com/user-attachments/assets/2da9cb70-8774-491e-8c6d-e350521c7ec1" />

* **Combine brims (Prusa-style brims)** by @RF47 in [PR 12343](https://github.com/OrcaSlicer/OrcaSlicer/pull/12343)
    Refactors brim generation to follow PrusaSlicer methodology: the unified brim creates a continuous ring around all objects on the build plate for stronger bed adhesion. If multiple materials are used on the first layer, normal brim is recommended to avoid staining parts with different colors. For by-object sequence prints, normal brim generation is maintained. Fixes #10635. [Wiki](https://www.orcaslicer.com/wiki/others_settings_brim)

    | Normal brim | Combined brim |
    |-------------|---------------|
    | <img width="400" alt="Normal brim" src="https://github.com/user-attachments/assets/5fd6448d-6f95-4f57-a414-cb1bb5290d95" /> | <img width="400" alt="Combined brim" src="https://github.com/user-attachments/assets/b63fc077-7534-4192-adaa-b0f2cfba3beb" /> |

* **Multiple dovetail cuts** by @Xipit in [PR 12318](https://github.com/OrcaSlicer/OrcaSlicer/pull/12318)
    The dovetail cutting tool now supports cutting with multiple dovetails in a single cut operation (previously limited to one). You can specify the count and gap between dovetails — ideal for splitting large models into pieces that fit on the build plate and can be reassembled accurately.

    <img width="600" src="https://github.com/user-attachments/assets/cb5edea2-c63c-4f70-b119-623bb495970b" />

* **Non-Crossing Tri-hexagon infill pattern** by @RF47 in [PR 13433](https://github.com/OrcaSlicer/OrcaSlicer/pull/13433) and [PR 13422](https://github.com/OrcaSlicer/OrcaSlicer/pull/13422)
    Adds a non-crossing tri-hexagon pattern to trapezoidal fill that prevents intersection lines, producing a stronger and more isotropic infill. Each layer is rotated by 120 degrees for uniform strength along X and Y axes. The pattern grid has been centered and symmetrically aligned for even infill distribution.

    <img width="600" alt="Tri-hexagon centering before/after" src="https://github.com/user-attachments/assets/4a8eb1c6-5d81-44d3-8c82-38f993e1612a" />

* **Machine Input Shaping** by @ianalexis in [PR 11202](https://github.com/OrcaSlicer/OrcaSlicer/pull/11202) with wiki and calibration updates in [PR 13569](https://github.com/OrcaSlicer/OrcaSlicer/pull/13569) and [PR 13571](https://github.com/OrcaSlicer/OrcaSlicer/pull/13571)
    Adds Resonance Compensation override to the Printer Settings, allowing you to set X/Y axis frequency and damping values directly in OrcaSlicer. Supports Adaptive Klipper, RRF, and Marlin 2 input shaper types. Particularly useful for Marlin printers where the IS menu is disabled, or when you want to manage input shaping from the slicer side. Emits the appropriate G-code for each firmware type. [Wiki](https://www.orcaslicer.com/wiki/printer_motion_ability)

    <img width="800" alt="Machine Input Shaping" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/inputshaping_printer.png?raw=true" />

* **Kinematics (Jerk & Acceleration) visualization** by @ianalexis in [PR 13169](https://github.com/OrcaSlicer/OrcaSlicer/pull/13169)
    Adds Jerk/Junction Deviation and Acceleration preview modes to the G-code viewer. JD values are calculated dynamically based on the current acceleration, making it easy to correlate motion parameters with specific print features and identify potential quality issues.

    <img width="600" alt="Kinematics visualization" src="https://github.com/user-attachments/assets/001adb0f-9426-4d72-9537-a20f6e5081c9" />

* **Elephant foot compensation for solid layers** by @pi-squared-studio in [PR 11526](https://github.com/OrcaSlicer/OrcaSlicer/pull/11526) with fixes by @ianalexis in [PR 13476](https://github.com/OrcaSlicer/OrcaSlicer/pull/13476) and [PR 13523](https://github.com/OrcaSlicer/OrcaSlicer/pull/13523)
    Extends elephant foot compensation to solid layers above the bottommost layer by manipulating infill density. Instead of only compensating the first layer, density increases linearly up to 100% across the specified number of compensation layers, absorbing excess plastic more gradually for better dimensional accuracy.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="EFC before" src="https://github.com/user-attachments/assets/b590b1b0-1a29-4502-8c7f-9716a2ad5ec8" /> | <img width="400" alt="EFC after" src="https://github.com/user-attachments/assets/6f0200b5-e7d9-4809-8409-e393a8b1dfa9" /> |

    [Wiki](https://www.orcaslicer.com/wiki/quality_settings_precision)

* **Max Resolution and Deviation settings exposed for Arachne** by @valerii-bokhan in [PR 11925](https://github.com/OrcaSlicer/OrcaSlicer/pull/11925)
    Exposes the Arachne wall generator's internal resolution and deviation constants as user-configurable settings. Maximum Resolution (0.005–0.5, default 0.5) and Maximum Deviation (0.005–0.05, default 0.025) give experienced users finer control over wall quality and slicing performance. Lower values produce cleaner walls with fewer artifacts at the cost of longer slicing times — particularly useful for high-detail prints where Arachne's default settings introduce visible artefacts compared to the Classic wall generator. Fixes #10235.

    | Classic | Arachne (default) | Arachne (min resolution/deviation) |
    |---------|-------------------|-------------------------------------|
    | <img width="250" alt="Classic" src="https://github.com/user-attachments/assets/8d07ba42-eab5-487b-bb0b-fc6a78b114b8" /> | <img width="250" alt="Arachne default" src="https://github.com/user-attachments/assets/01d4c6c5-5587-496c-a4f2-f58510d69ba7" /> | <img width="250" alt="Arachne improved" src="https://github.com/user-attachments/assets/c396e1f4-e77c-49c8-9692-af399059a1cb" /> |

* **First layer travel acceleration and jerk configurable** by @rcopra in [PR 11674](https://github.com/OrcaSlicer/OrcaSlicer/pull/11674) with toggle improvements by @kisslorand in [PR 13320](https://github.com/OrcaSlicer/OrcaSlicer/pull/13320) and wiki by @ianalexis in [PR 13324](https://github.com/OrcaSlicer/OrcaSlicer/pull/13324)
    Adds separate configurable travel acceleration and jerk values for the first layer. Fast travel accelerations on the first layer help reduce oozing and stringing, while slower print accelerations maintain good bed adhesion. The toggle behavior now correctly groups all first layer motion settings.

    <img width="400" alt="First layer travel acceleration settings" src="https://github.com/user-attachments/assets/f7875fa4-b4d9-45d3-ba0e-a4316f9ad94d" />
    <img width="400" alt="First layer travel jerk settings" src="https://github.com/user-attachments/assets/ee51a2b3-3054-42f8-bd6b-10f0a7f79e48" />

    <video controls width="800" src="https://github.com/user-attachments/assets/408d424c-e9a7-4cf8-bf2f-f43912d9ef8b"></video>

* **Brim flow ratio setting** by @valerii-bokhan in [PR 11876](https://github.com/OrcaSlicer/OrcaSlicer/pull/11876)
    Adds a dedicated flow ratio setting for brims that operates independently of the first layer flow ratio. Previously, brim flow was tied to the first layer flow ratio, meaning any adjustment for the brim also affected the entire first layer. Now you can fine-tune brim extrusion separately — increase flow for stronger bed adhesion on the brim while keeping the first layer flow at its optimal value. Fixes #11853.

    <img width="500" alt="Brim flow ratio setting" src="https://github.com/user-attachments/assets/2e315883-8749-4c7c-94cb-4faea75232fd" />

* **Inverse print direction for holes** by @RF47 in [PR 12669](https://github.com/OrcaSlicer/OrcaSlicer/pull/12669)
    Reverses the printing direction of internal hole walls for improved surface consistency on internal perimeters. The "Auto" wall direction option has been simplified to direct on/off toggles for each direction, also separating internal and overhang wall reversing for finer control. Based on an idea from @discip. Fixes #11630.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Hole direction before" src="https://github.com/user-attachments/assets/1e13b615-33da-4a8a-aaab-dfbb2c12522d" /> | <img width="300" alt="Hole direction after" src="https://github.com/user-attachments/assets/cacbbfff-bde1-46b7-ab58-2af27d3c7c10" /> |

* **Cooling: per-printer min fan PWM floor** by @igiannakas in [PR 13715](https://github.com/OrcaSlicer/OrcaSlicer/pull/13715)
    Adds a per-printer "Minimum non-zero part cooling fan speed" setting — any non-zero fan command is clamped up to this percentage at G-code emission time. Also fixes a silent override that forced `close_fan_the_first_x_layers` from 0 to 1 when `full_fan_speed_layer` was set. Fixes #11029.

    <img width="500" alt="Min fan PWM floor setting and fan ramp behavior" src="https://github.com/user-attachments/assets/13bd4bbc-f5d7-4a98-af46-39601fb20ab4" />
    <img width="500" alt="Fan ramp fix comparison" src="https://github.com/user-attachments/assets/f8a050c9-7545-4a4c-9366-5cf0d7f77298" />

    <img width="600" alt="Minimum non-zero part cooling fan speed setting in Printer Settings" src="https://github.com/user-attachments/assets/13bd4bbc-f5d7-4a98-af46-39601fb20ab4" />

    <img width="600" alt="Cooling fan PWM floor behavior with ramp from layer 1" src="https://github.com/user-attachments/assets/f8a050c9-7545-4a4c-9366-5cf0d7f77298" />

* **Hybrid tree support: fix first-layer behavior and expose density** by @kisslorand in [PR 13454](https://github.com/OrcaSlicer/OrcaSlicer/pull/13454)
    Hybrid tree supports now correctly use support material flow instead of brim flow on the first layer, fixing over-extrusion and potential bed collisions. The first-layer density and expansion settings are properly exposed in the UI. First-layer spacing on the support base is now derived from the actual first-layer support flow, and tree-only regions use existing brim expansion settings independently. Fixes #13430.

    <img width="400" alt="First layer density setting now visible in UI" src="https://github.com/user-attachments/assets/d53b49c1-4aac-43e8-adfe-40d45d2bfcfb" />

    | Before (incorrect line width) | After (correct line width) |
    |-------------------------------|----------------------------|
    | <img width="400" alt="Tree support base before fix" src="https://github.com/user-attachments/assets/d7ade618-4b5a-497b-b40c-c6545f282698" /> | <img width="400" alt="Tree support base after fix" src="https://github.com/user-attachments/assets/e3496c35-8a8d-412b-abb7-766e3d48f2a1" /> |

    <img width="600" alt="Hybrid tree support density setting now properly exposed in UI" src="https://github.com/user-attachments/assets/d53b49c1-4aac-43e8-adfe-40d45d2bfcfb" />

    | Circular base (meaningless density before fix) | Rectilinear base (meaningful density after fix) |
    |-------------------------------------------------|-------------------------------------------------|
    | <img width="400" alt="Circular base pattern with no density effect before fix" src="https://github.com/user-attachments/assets/d7ade618-4b5a-497b-b40c-c6545f282698" /> | <img width="400" alt="Rectilinear base pattern with proper density control after fix" src="https://github.com/user-attachments/assets/e3496c35-8a8d-412b-abb7-766e3d48f2a1" /> |

* **Reduce Spiral Z generation segment density** by @igiannakas in [PR 12564](https://github.com/OrcaSlicer/OrcaSlicer/pull/12564)
    Reduced precision of spiral Z-hop moves to lower the G-code command rate, preventing "Timer Too Close" errors on high-speed Klipper machines running on Raspberry Pi 5. Extreme precision is less critical for non-printing moves.

* **Remove "Auto" wall direction option** by @vovodroid in [PR 6193](https://github.com/OrcaSlicer/OrcaSlicer/pull/6193)
    Simplified wall direction settings by removing the ambiguous "Auto" mode in favor of direct on/off toggles for each direction. The rewrite also separates internal and overhang wall reversing, and adds an option to print overhangs after internal walls for improved adhesion while keeping the external wall first in outer-inner and inner-outer-inner modes. Spiral vase mode can now be printed in any direction.

* **Fix gaps between walls and sparse infill** by @echipachenko in [PR 12770](https://github.com/OrcaSlicer/OrcaSlicer/pull/12770)
    When "Detect Narrow Infill" was enabled, sparse infill (Grid pattern) showed visible gaps between infill lines and walls. Root cause: the inner area was shrunk by `scaled_spacing * 0.5` but infill was only expanded by `scaled_spacing * 0.1`, creating a net 0.4x gap. Expansion now matches the shrinkage at `scaled_spacing * 0.5`. Fixes #12304.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Infill gaps before" src="https://github.com/user-attachments/assets/6bad4da1-d74d-4321-b853-48c9fba9ba5b" /> | <img width="400" alt="Infill gaps after" src="https://github.com/user-attachments/assets/c65c2d87-732f-4c03-975f-fe3d2b9e7404" /> |

* **Correct gap fill width bounds in outer-only and mixed-wall cases** by @kisslorand in [PR 12057](https://github.com/OrcaSlicer/OrcaSlicer/pull/12057)
    Previously, internal wall geometry was used unconditionally when computing gap fill bounds, which could misrepresent safe overlap when external and internal walls differ in thickness or spacing. The minimum gap fill width is now derived from the smaller of internal and external wall widths, preventing overestimation of allowable overlap. This is a geometry reference correction — existing gap fill behavior is unchanged except where wall geometry references were incorrect. Fixes #12030.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Gap fill before" src="https://github.com/user-attachments/assets/91b514ce-8e52-4cef-b6fe-a983933fb0fc" /> | <img width="400" alt="Gap fill after" src="https://github.com/user-attachments/assets/8f4aed32-3b64-4d89-a855-6868402f0881" /> |

* **Extend short-travel smoothing to external overhang walls** by @kisslorand in [PR 11975](https://github.com/OrcaSlicer/OrcaSlicer/pull/11975)
    Short micro-travels immediately before a perimeter can cause a sudden acceleration impulse, leading to vibration and ringing on visible surfaces. Acceleration and jerk for short travels before standard external walls were already reduced, but external overhang walls were excluded and still used full travel acceleration/jerk. This fix extends the same short-travel smoothing to external overhang walls, using the configured overhang-wall (bridge) acceleration and consistent jerk handling for these transitions. External walls, internal walls, infill, supports, and regular travel remain unchanged.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Overhang smoothing before" src="https://github.com/user-attachments/assets/738a5a63-80d0-43a9-bb21-868a6e2622c7" /> | <img width="400" alt="Overhang smoothing after" src="https://github.com/user-attachments/assets/99bfe421-0bf0-4e53-8b36-ecd31e031c2e" /> |

* **Ignore Jerk values warning when using Junction Deviation** by @ianalexis in [PR 13575](https://github.com/OrcaSlicer/OrcaSlicer/pull/13575)
    Suppressed misleading jerk value warnings when Junction Deviation is the active motion mode.

* **Granular exhaust fan speed control** by @misterff1 in [PR 13228](https://github.com/OrcaSlicer/OrcaSlicer/pull/13228)
    Adds independent checkboxes to control exhaust fan speed during printing and after print completion, replacing the previous all-or-nothing behavior. Both default to enabled for backward compatibility. Addresses #13116.

    <img width="600" alt="Granular exhaust fan speed checkboxes UI" src="https://github.com/user-attachments/assets/e71e7de3-2def-4046-b5dc-55bf3b516ce5" />

* **Extrusion role change G-code in Process and Filament** by @ianalexis in [PR 11784](https://github.com/OrcaSlicer/OrcaSlicer/pull/11784)
    New G-code insertion points for handling extrusion role changes, available at both the process and filament preset levels. This separates role-change G-code from the machine level, so you can define behavior at role transitions (e.g., perimeter to infill, support material changes) and save it with your process or filament presets without depending on the machine configuration. G-code execution order is: Machine → Filament → Process. A power-user feature inspired by @RF47, useful for per-role fan speed adjustments, temperature changes, or custom toolhead actions.

    <img width="600" alt="Extrusion role change G-code settings" src="https://github.com/user-attachments/assets/7504c94d-a77d-4a89-a62b-9a424404940c" />

* **Per-vendor profile version updates** by @softfever and @peachismomo in [PR 13394](https://github.com/OrcaSlicer/OrcaSlicer/pull/13394)
    OrcaSlicer now checks for updated printer, filament, and process profiles on a per-vendor basis via `check-version.orcaslicer.com/profiles`. When a vendor publishes newer profiles for your machine, a notification appears prompting you to upgrade to the latest tuned configurations with a single click — no more wondering if your profiles have fallen behind. This lays the groundwork for coming OrcaSlicer profile OTA support.

    <img width="600" alt="Per-vendor profile update notification" src="https://github.com/user-attachments/assets/cd69f5a5-6e23-456f-92e2-25774c358644" />

    <img width="600" alt="Profile update details" src="https://github.com/user-attachments/assets/3316b8d3-ad39-4543-9eae-b72efc4ab64b" />

* **Expert user mode** by @SoftFever in [PR 13348](https://github.com/OrcaSlicer/OrcaSlicer/pull/13348)
    Adds a new Expert user mode between Advanced and Developer modes. The mode switch button now uses a three-way toggle (Simple / Advanced / Expert). Expert mode exposes experimental and advanced options that require a deeper understanding of the 3D printing process, without overwhelming users who don't need them. Settings like ZAA contouring and Machine Input Shaping are assigned to this mode.

    <img width="400" alt="Expert mode three-way toggle button" src="https://github.com/user-attachments/assets/ec7e198c-2ce0-46e4-a7aa-580ec3585986" />

    [Wiki](https://www.orcaslicer.com/wiki/option_mode)

* **3MF Export/Import with Orca version tags** by @ianalexis in [PR 12509](https://github.com/OrcaSlicer/OrcaSlicer/pull/12509)
    3MF files now include OrcaSlicer-specific version tags alongside Bambu Studio tags, enabling accurate version-aware import behavior. When opening a 3MF file, OrcaSlicer checks the embedded version information and warns you if the file was created with a newer version that may use features or settings not available in your current one. Files from versions ≤ 2.3.2 are treated as legacy and imported with appropriate compatibility handling. Fixes a bug where Orca versions like 2.3.2 were incorrectly interpreted as 2.3.0.2.

    | Feature | Screenshot |
    |---------|-----------|
    | Version tag system | <img width="350" alt="Orca version tag system" src="https://github.com/user-attachments/assets/f43bb4b8-cbe0-429d-971a-5fcbd82a417f" /> |
    | Future BBS version warning | <img width="600" alt="Future BBS version warning dialog" src="https://github.com/user-attachments/assets/96f2f58c-2a7d-4958-b839-9b3dcc69ca4b" /> |
    | Future Orca version warning | <img width="600" alt="Future Orca version warning dialog" src="https://github.com/user-attachments/assets/d1f4d7da-8dd8-482d-8441-772cea0717df" /> |
    | BBS version warning | <img width="600" alt="BBS version warning dialog" src="https://github.com/user-attachments/assets/fd0e37d8-523b-48b9-8428-d60103cbbc89" /> |

* **CGAL Fix Model for Linux and Mac** by @ianalexis in [PR 12155](https://github.com/OrcaSlicer/OrcaSlicer/pull/12155)
    The "Fix Model" function now works on Linux and macOS using CGAL instead of Windows-only APIs. Multi-part STL files are fixed part-by-part; non-3D elements (points, lines, planes) are automatically removed. Considerably faster than the previous Windows-only implementation. Fixes #5013, #4923, #8740, #9156.

    | Before (broken model) | After (repaired) |
    |-----------------------|-------------------|
    | <img width="400" alt="Broken model before CGAL fix" src="https://github.com/user-attachments/assets/c95b9914-b131-4d33-a4c5-329f023e78b2" /> | <img width="400" alt="Model repaired by CGAL" src="https://github.com/user-attachments/assets/015773df-7331-4e5f-9b04-6be9cdf79318" /> |

* **CLI: add layer_height, sparse_infill_density, and wall_loops to results** by @Eldenroot in [PR 13001](https://github.com/OrcaSlicer/OrcaSlicer/pull/13001)
    The CLI `--export` output now includes layer height, sparse infill density, and wall loop count values, making it easier for automation scripts and print farm management tools to extract key print parameters without parsing the full configuration.

* **Native Wayland support for Linux** by @SoftFever in [PR 13197](https://github.com/OrcaSlicer/OrcaSlicer/pull/13197) with additional fixes by @thomashenauer, @SoftFever, and @yw4z in [PR 13707](https://github.com/OrcaSlicer/OrcaSlicer/pull/13707), [PR 13721](https://github.com/OrcaSlicer/OrcaSlicer/pull/13721), [PR 13723](https://github.com/OrcaSlicer/OrcaSlicer/pull/13723), [PR 13563](https://github.com/OrcaSlicer/OrcaSlicer/pull/13563), and [PR 13747](https://github.com/OrcaSlicer/OrcaSlicer/pull/13747)
    OrcaSlicer now runs natively on Wayland — no XWayland required. Includes fixes for multi-monitor setups, submenu popup parenting, data-view and dropdown submenu popups, faint toolbar icons under Wayland, and a crash when opening the Preview tab on startup.

* **Flatpak 2.4 update** by @SoftFever in [PR 13799](https://github.com/OrcaSlicer/OrcaSlicer/pull/13799)
    Updated the Flatpak manifest and build configuration for the 2.4 release.

* **Enhance network share experience for flatpak** by @SoftFever in [PR 13809](https://github.com/OrcaSlicer/OrcaSlicer/pull/13809)
    Improved network share and filesystem access when running OrcaSlicer as a Flatpak, addressing sandbox-related limitations.

## Multi-Material

* **Keep painting after mesh changes** by @Noisyfox in [PR 13472](https://github.com/OrcaSlicer/OrcaSlicer/pull/13472)
    A new experimental option under Preferences > Developer > "Keep painted feature after mesh change" preserves your painted regions across planar cuts, dovetail cuts, splitting to parts/objects, mesh boolean operations, reloading from disk, fix model, and simplify/smooth operations. No more losing your support enforcers or seam paintings after making a cut.

    <img width="400" alt="Keep painting after cut option" src="https://github.com/user-attachments/assets/8b195486-538e-4eda-9e77-bfdf1a794306" />

* **Option to always travel to wipe tower before Tx on multi-toolhead setups** by @igiannakas in [PR 13703](https://github.com/OrcaSlicer/OrcaSlicer/pull/13703)
    Adds an option for type 2 wipe towers on multi-toolhead printers backed by an MMU to always travel to the wipe tower before executing tool change commands, reducing oozing during multi-material prints.

* **Filament compatibility temperature-aware** by @ianalexis in [PR 13522](https://github.com/OrcaSlicer/OrcaSlicer/pull/13522)
    The temperature-based filament compatibility check is now more intelligent: instead of using hardcoded temperature range tables per material type, it checks actual material temperatures against each other's recommended ranges. A message explains how to disable this check if needed. Fixes #10543.

* **Warn for abnormal temperature differences** by @kisslorand in [PR 12345](https://github.com/OrcaSlicer/OrcaSlicer/pull/12345)
    If the temperature difference between first layer and other layers exceeds 15°C for the bed or 30°C for the nozzle, a warning popup now alerts you when saving or closing the preset. You can temporarily suppress the warning for the current session. Fixes #12310.

    <img width="600" alt="Temperature warning dialog" src="https://github.com/user-attachments/assets/58d7ca03-a850-4cee-9871-7a3b8e275626" />

## Improved Printer Support

* **Repetier G-code flavor** by @yogihybo in [PR 13126](https://github.com/OrcaSlicer/OrcaSlicer/pull/13126)
    Adds Repetier as a selectable G-code flavor with appropriate defaults: machine limits emission and remaining time (M73) are turned off, and jerk handling is refactored for Repetier compatibility. Includes a generic Repetier printer profile.
    <img width="400" alt="Repetier G-code flavor in dropdown" src="https://github.com/user-attachments/assets/d2007504-14e7-4ea9-8f56-2561f4257bf7" />
    <img width="400" alt="Repetier G-code output preview" src="https://github.com/user-attachments/assets/fe85d059-d4d8-49c5-8673-ea928d3d2782" />

* **Improved SnapmakerPrinterAgent filament sync** by @gaaat98 in [PR 13265](https://github.com/OrcaSlicer/OrcaSlicer/pull/13265)
    Snapmaker filament syncing now matches against vendor-specific and custom filament presets using filament type, vendor name, and color distance for more accurate matching. Generic matching is kept as a fallback. Inspired by #13202.

* **Add fallback for Qidi series ID matching** by @thelegendtubaguy in [PR 13065](https://github.com/OrcaSlicer/OrcaSlicer/pull/13065)
    Some Qidi printers (Max 4, Q2) don't report their model identifier via Moonraker's `/server/info` endpoint, preventing filament matching. A fallback now uses the configured machine type when the printer doesn't identify itself.

* **Support file uploads and device details for Elegoo Centauri Carbon 2** by @anjis-elegoo in [PR 13212](https://github.com/OrcaSlicer/OrcaSlicer/pull/13212)
    Adds LAN file upload support and the device details page for the Elegoo Centauri Carbon 2. You can now send files to the printer over LAN and manage prints from the device details page. Note: upload-and-print is not supported — printing must be initiated from the device details page. If access code protection is enabled on the printer, enter the code in the API Key/Password field.

    <img width="600" alt="Elegoo Centauri Carbon 2 device page" src="https://github.com/user-attachments/assets/778b3c70-7cbe-4f7f-ae92-8c00ecaeae9b" />

* **Allow printing without nozzle info from firmware** by @lynaghk in [PR 12814](https://github.com/OrcaSlicer/OrcaSlicer/pull/12814)
    Printers that don't report nozzle size and hardness (such as older Bambu firmware) no longer block printing. The UI now shows "unknown" instead of incorrectly assuming 0.4mm, and the size/hardness checks are bypassed when this information isn't available. Fixes #8280, #12279, #12674.

    | Before (printing blocked with error) | After (prints with "unknown" nozzle) |
    |---------------------------------------|---------------------------------------|
    | <img width="400" alt="Error popup blocking print before fix" src="https://github.com/user-attachments/assets/9d0e9081-c53e-446f-abdf-3ed16dba3911" /> | <img width="400" alt="Printing allowed with unknown nozzle after fix" src="https://github.com/user-attachments/assets/98d760fd-84c2-4c4b-8b8f-d4f0a0fc048e" /> |

    | Before: blocked with nozzle mismatch error | After: shows "unknown" and allows printing |
    |---------------------------------------------|---------------------------------------------|
    | <img width="400" alt="Nozzle mismatch error blocking print before fix" src="https://github.com/user-attachments/assets/98d760fd-84c2-4c4b-8b8f-d4f0a0fc048e" /> | <img width="400" alt="Nozzle shown as unknown, printing allowed after fix" src="https://github.com/user-attachments/assets/6cb529c0-334c-4876-91c1-c22f41232eda" /> |

* **Linux: use GTK sink for Wayland Bambu liveview** by @thomashenauer in [PR 13432](https://github.com/OrcaSlicer/OrcaSlicer/pull/13432)
    On native Wayland sessions, Bambu printer liveview could show a black screen or crash because the default GStreamer video overlay path relied on X11 window handles. This fix detects native Wayland and uses an explicit GTK widget sink via `wxNativeWindow` for reliable embedded playback. Also fixes a race condition where Orca validated the video size before wx/GStreamer had finished loading the stream. Fixes #13300, #9280.

    | Before (black screen) | After (working liveview) |
    |-----------------------|---------------------------|
    | <img width="400" alt="Bambu liveview black screen before fix" src="https://github.com/user-attachments/assets/6937679e-b38d-4608-a565-17d85a550996" /> | <img width="400" alt="Bambu liveview working after fix" src="https://github.com/user-attachments/assets/4c3417f6-c2de-4cdc-95b0-1afa37487118" /> |

## Performance & Optimizations

* **Increase profile loading timeout** by @SoftFever in [PR 13661](https://github.com/OrcaSlicer/OrcaSlicer/pull/13661)
    Raised the profile-loading timeout to three minutes so slower computers can finish loading large profile sets. Fixes #12728, #12789, #13565.
* **Speed up startup and show splash progress** by @JustNotesa in [PR 13667](https://github.com/OrcaSlicer/OrcaSlicer/pull/13667)
    Reduces startup time and shows live loading progress in the splash screen.
* **Add persistent cookie storage for PrinterWebView on WebKitGTK** by @Ocraftyone in [PR 13135](https://github.com/OrcaSlicer/OrcaSlicer/pull/13135)
    Printer web views on Linux now persist cookies between sessions, improving the experience with print hosts that require authentication (such as SimplyPrint).


# 📐 Calibration Improvements

* **Improved flow rate calibration menu** by @tome9111991 in [PR 11956](https://github.com/OrcaSlicer/OrcaSlicer/pull/11956)
    The Flow Rate Calibration dialog now lets you choose your preferred top surface pattern instead of being forced to use Archimedean Chords. A dedicated selector gives you full control over the calibration's surface finish.

    <img width="400" alt="Flow rate pattern selector" src="https://github.com/user-attachments/assets/c2febe03-3403-48e9-98e3-19c8579a5228" />

* **Temperature tower nozzle-based adjustment** by @ianalexis in [PR 12269](https://github.com/OrcaSlicer/OrcaSlicer/pull/12269)
    Temperature tower calibration now scales the tower based on nozzle size and readjusts test temperatures for the resized height. Layer height is automatically adjusted for optimal calibration results. Fixes #6978, #12281.

    <img width="600" alt="Temperature tower calibration based on nozzle size" src="https://github.com/user-attachments/assets/d89d0e77-c1b2-4b44-8e97-fab88c3a43f6" />

* **Preserve model placement in calibration tests** by @ianalexis in [PR 13252](https://github.com/OrcaSlicer/OrcaSlicer/pull/13252)
    Calibration tests no longer re-center loaded project (.3mf/.amf) models, preserving their original placement. Fixes #12645.

# 🎨 UI & UX

* **Printer selection dialog redesign** by @yw4z in [PR 12248](https://github.com/OrcaSlicer/OrcaSlicer/pull/12248)
    A major redesign of the printer selection dialog with two new layout options: Compact view (50% less scroll height) and List view (70% less). Sticky titlebars keep vendor names always visible while scrolling, any key press automatically focuses the search bar, indeterminate checkboxes track partial selections, and a new sidebar enables faster vendor jumping. Each printer card now shows nozzle information, and a "Create" button makes adding new printers straightforward. Vendors are now sorted alphabetically.

    Cover view:
    <img width="500" src=https://github.com/user-attachments/assets/66d6715a-b98b-49ba-950b-35a23983a930/>

    Compact view:
    <img width="500" src=https://github.com/user-attachments/assets/28a1ffe9-be4d-4aa2-b3c9-eaf8fbd98987/>

    List view:
    <img width="500" src=https://github.com/user-attachments/assets/e8f5a314-bd80-4286-80a6-7b5aa497ce92/>

* **Line Type preview: display distances and amount values** by @ianalexis in [PR 13681](https://github.com/OrcaSlicer/OrcaSlicer/pull/13681)
    The Line Type view in the Preview tab now shows travel distances, extrusion amounts, and estimated times per line type. Extrusion weights automatically scale from grams to kilograms/tons when needed. Seam travel distance is calculated as `seam_gap + seam_slope_min_length`. Based on work by @sscargal in #11187.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Line type before" src="https://github.com/user-attachments/assets/0b34ee47-4ef0-426a-832d-58a0527b2f4b" /> | <img width="400" alt="Line type after" src="https://github.com/user-attachments/assets/5ea94595-d18a-4fd3-88e9-b425e0c6b4eb" /> |

* **Tool Position window: improved vertex info** by @yw4z in [PR 12614](https://github.com/OrcaSlicer/OrcaSlicer/pull/12614)
    The Tool Position info window now reports travel, seam, wipe, retraction, and unretraction feature types in addition to the existing type data. Fixed "????" values that appeared on Windows by properly initializing the read buffer.

    <img width="600" alt="Tool position improved info" src="https://github.com/user-attachments/assets/3a7b57cc-2446-4019-baf2-4bada9888478" />

* **Display tool change count after slicing** by @unixunion in [PR 12474](https://github.com/OrcaSlicer/OrcaSlicer/pull/12474)
    The slicing results now show the total number of filament tool changes, giving a quick estimate of purge waste and print complexity for multi-material prints. Implements #12464.
    <img width="400" alt="Tool change count in slicing results" src="https://github.com/user-attachments/assets/015b73d8-9938-4887-81c8-3f7cfe67c390" />

* **Release Notes dialog improvements** by @yw4z in [PR 12265](https://github.com/OrcaSlicer/OrcaSlicer/pull/12265)
    The release notes dialog now has a cleaner layout with more space for content, properly sized web content without horizontal scrolling, a "Check on GitHub" button to view the release online, and improved hyperlink colors. Also fixes large images causing horizontal overflow.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Release notes before" src="https://github.com/user-attachments/assets/9621f4e8-bba3-4e5c-84f1-81e23e3cb144" /> | <img width="400" alt="Release notes after" src="https://github.com/user-attachments/assets/f0ec27fd-8144-4887-8283-031ad2707fe7" /> |

* **MultiChooseDialog & Profile Dependencies improvements** by @yw4z in [PR 9971](https://github.com/OrcaSlicer/OrcaSlicer/pull/9971)
    The multi-select dialog now has proper window captions and labels, fixed "All" checkbox state handling, filtering support with select/deselect for visible items, and a right-click context menu. Optimized drawing for better performance.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Profile dependencies before" src="https://github.com/user-attachments/assets/f9a9b3f9-e3e6-4033-b857-54953911d555" /> | <img width="400" alt="Profile dependencies after" src="https://github.com/user-attachments/assets/453aeaca-2fd3-424a-9ea4-dd38e5f5a07a" /> |

* **Restructured Painting Tool UI** by @Xipit in [PR 12852](https://github.com/OrcaSlicer/OrcaSlicer/pull/12852) with follow-ups by @Xipit and @yw4z in [PR 13340](https://github.com/OrcaSlicer/OrcaSlicer/pull/13340), [PR 13421](https://github.com/OrcaSlicer/OrcaSlicer/pull/13421), and [PR 13365](https://github.com/OrcaSlicer/OrcaSlicer/pull/13365)
    Reorganizes the painting tool interface for better usability: "On Overhangs only" is now placed under the overhang highlight slider (making the relationship clear), Vertical/Horizontal checkboxes appear under the Brush size slider and only when they affect the selected tool, and the Section View slider is available for the Gap Fill tool. The "Pen size" control is renamed to "Brush size" for consistency. Also fixes MMuSegmentation window width changes and standardizes brush size and smart fill angle controls.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Support painting before" src="https://github.com/user-attachments/assets/487c071b-a005-4393-882b-f2959b559b68" /> | <img width="300" alt="Support painting after" src="https://github.com/user-attachments/assets/bd4d684b-82ae-4a2d-a035-1948fab4117f" /> |
    | <img width="300" alt="Seam painting before" src="https://github.com/user-attachments/assets/3cdb345f-addc-4380-a5d9-423d84373047" /> | <img width="300" alt="Seam painting after" src="https://github.com/user-attachments/assets/d5eb8294-d917-4ce3-824d-9694aac370e1" /> |

* **Restructure Text/Emboss Tool UI** by @Xipit in [PR 12864](https://github.com/OrcaSlicer/OrcaSlicer/pull/12864)
    Reorganized the Text/Emboss tool for a better workflow: the Style setting is now above Font (since it dictates the remaining options), Revert buttons follow their settings instead of preceding them, Operations are on a single line, and inconsistent spacing between elements has been fixed.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Text tool before" src="https://github.com/user-attachments/assets/6c2a5ad3-0a3a-4dcd-a7ed-1c9e73c2ae23" /> | <img width="300" alt="Text tool after" src="https://github.com/user-attachments/assets/dffceac7-d44d-4719-93b5-a51123c541d7" /> |

* **Unify Tool UI Footer** by @Xipit in [PR 12850](https://github.com/OrcaSlicer/OrcaSlicer/pull/12850)
    Standardized the footer across all gizmo tools with consistent "Done"/"Cancel" buttons, Reset button behavior (only enabled when changes have been made), and unified warning positions. The Text tool gains a Reset button. The Gap Fill tool's Apply buttons have been moved underneath the Gap Area slider. The detailed footer structure is: Content → Action Buttons → Tooltip / Reset / Confirm / Cancel → Warnings.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Support gizmo before" src="https://github.com/user-attachments/assets/a567e344-8cc3-4d4a-9a90-83ee3171e93a" /> | <img width="300" alt="Support gizmo after" src="https://github.com/user-attachments/assets/646a403d-dc19-4ac2-9672-5e7aa6f9bd89" /> |
    | <img width="300" alt="Seam gizmo before" src="https://github.com/user-attachments/assets/eb2919f5-813d-4c6e-a1d0-ea341c15ae1c" /> | <img width="300" alt="Seam gizmo after" src="https://github.com/user-attachments/assets/50d2d9bd-57fb-452a-8c83-c69ddcd73278" /> |

* **Refactor Tooltip Button** by @Xipit in [PR 12848](https://github.com/OrcaSlicer/OrcaSlicer/pull/12848)
    Consolidated 9 slightly different tooltip button implementations into a single shared utility in GLGizmoUtils. Added tooltips to the Text gizmo and shortcut descriptions to the Cut gizmo. Shortcut labels now consistently use "Left mouse button" and platform-appropriate modifier key visuals throughout the UI.

    | Assembly gizmo tooltips (before) | Assembly gizmo tooltips (after) |
    |----------------------------------|--------------------------------|
    | <img width="300" alt="Assembly gizmo before" src="https://github.com/user-attachments/assets/9c242ee2-e3e1-415c-83c7-e3fd48c0d732" /> | <img width="300" alt="Assembly gizmo after" src="https://github.com/user-attachments/assets/902e9d9a-b855-4ef0-b1f0-4433c71680eb" /> |

    | Emboss gizmo tooltips (before) | Emboss gizmo tooltips (after) |
    |----------------------------------|--------------------------------|
    |<img width="300" alt="Text gizmo with new tooltip button" src="https://github.com/user-attachments/assets/00c5b23e-7ce3-4788-8bb7-2c8d5643a249" />|<img width="300" alt="Text gizmo with new tooltip button added" src="https://github.com/user-attachments/assets/00c5b23e-7ce3-4788-8bb7-2c8d5643a249" />|

    | Assembly Gizmo tooltip before | Assembly Gizmo tooltip after |
    |-------------------------------|------------------------------|
    | <img width="300" alt="Assembly gizmo tooltip before refactor" src="https://github.com/user-attachments/assets/9c242ee2-e3e1-415c-83c7-e3fd48c0d732" /> | <img width="300" alt="Assembly gizmo tooltip after refactor" src="https://github.com/user-attachments/assets/902e9d9a-b855-4ef0-b1f0-4433c71680eb" /> |

* **Graphics Preferences: Anti-aliasing + FPS** by @ianalexis in [PR 13538](https://github.com/OrcaSlicer/OrcaSlicer/pull/13538)
    A new Graphics settings tab exposes MSAA multiplier (default 4x, was previously hardcoded) and adds FXAA (Fast Approximate Anti-Aliasing) as a post-process option. Lower MSAA improves performance on integrated GPUs; higher values improve quality on powerful GPUs or low-DPI monitors. Also adds an FPS counter and FPS limiter for diagnostic purposes.

    <img width="600" alt="Graphics preferences" src="https://github.com/user-attachments/assets/c50418e4-a576-45c4-9c18-d2cf92daa6b7" />

    | FXAA Disabled | FXAA Enabled |
    |---------------|--------------|
    | <img width="400" alt="FXAA disabled" src="https://github.com/user-attachments/assets/70523ca8-b704-4e33-bc99-d62f5e08ee15" /> | <img width="400" alt="FXAA enabled" src="https://github.com/user-attachments/assets/6a715b75-f7f7-4d7e-9e03-05b6957f2c4e" /> |

## QoL Improvements

* **Mouse button assignment (None/Pan/Rotate)** by @r3dbaba in [PR 10736](https://github.com/OrcaSlicer/OrcaSlicer/pull/10736)
    Left, Middle, and Right mouse buttons can now be independently assigned to None, Pan, or Rotate functions. This is particularly useful for left-handed users, those coming from other CAD tools with different mouse conventions, or anyone who wants a customized 3D viewport navigation experience. Addresses #4440 and #7272.

    <img width="350" alt="Mouse button assignment settings" src="https://github.com/user-attachments/assets/e3f45f0e-2e79-4425-a9c9-a0c7b4bc9a99" />

* **"Change type" UX as submenu with checkmarks** by @Eldenroot in [PR 12205](https://github.com/OrcaSlicer/OrcaSlicer/pull/12205)
    The "Change type" dialog is now an inline submenu with checkmarks, matching the "Change Filament" UX.

<img width="500" height="162" alt="Screenshot-20260524130942" src="https://github.com/user-attachments/assets/4ac22b5c-0cac-49b3-b965-08a80aaf05af" />

* **Auto-select external spool if it's the only installed filament** by @Noisyfox in [PR 13356](https://github.com/OrcaSlicer/OrcaSlicer/pull/13356)
    When a printer has only an external spool installed (no AMS/multi-material unit), the external spool is automatically selected, eliminating an extra click. Also adds a warning when the model's filament type doesn't match the type set in the device. Fixes #13103.
    <img width="500" alt="Filament type mismatch warning" src="https://github.com/user-attachments/assets/52b0d1fe-e8f6-47a3-b1ea-9fd6f39b2e9e" />
    <img width="500" alt="Auto-selected external spool UI" src="https://github.com/user-attachments/assets/00ffcd98-3b34-48d0-b91b-5634a787d8fe" />

* **Show filament edit button or action menu dynamically** by @yw4z in [PR 12651](https://github.com/OrcaSlicer/OrcaSlicer/pull/12651)
    The filament area now shows a simpler edit button instead of a full action menu for toolchanger/IDEX printers (where filament usage is fixed) and single-filament configurations. The Delete button has been moved to the end of the menu to prevent accidental clicks. Fixes #12649.

    <img width="600" src=https://github.com/user-attachments/assets/4b9e7672-91e8-44bc-b3e8-caccaaf346de/>

* **Disable "snap to build plate" option** by @Xipit in [PR 11801](https://github.com/OrcaSlicer/OrcaSlicer/pull/11801)
    Adds a per-object "Auto Drop" toggle (default enabled, shortcut `D`) surfaced in the context menu. When disabled, small arrows appear under the object's bounding box to indicate it won't snap to the bed. The setting is preserved across splitting and assembly operations, and survives in 3MF files. An "Auto Drop" checkbox is also available in the import dialog. Useful for preserving relative positioning when loading multi-part models. Addresses #8194.

    <img width="400" alt="Auto drop context menu" src="https://github.com/user-attachments/assets/0c4bb6ab-ad32-4e9c-b2e2-6210da7fa298" />

* **Toggle printability with keyboard shortcut** by @datapaganism in [PR 13279](https://github.com/OrcaSlicer/OrcaSlicer/pull/13279)
    Press `V` to toggle the printability of selected objects on the build plate — a fast alternative to right-clicking each part. The shortcut is shown in the right-click context menu and documented in Keyboard Shortcuts preferences. Addresses #9120.

    <img width="500" alt="Keyboard shortcut for toggle printable" src="https://github.com/user-attachments/assets/d31a089a-f415-464b-8c63-b3de9e482fdb" />

* **Linux: left-side window buttons option** by @yw4z in [PR 12831](https://github.com/OrcaSlicer/OrcaSlicer/pull/12831)
    Adds an option to place minimize/maximize/close buttons on the left side of the titlebar for Linux users who prefer a macOS-style layout. Tested on Debian GNOME, Mint Cinnamon, and Fedora KDE.

    <img width="600" alt="Left side window buttons" src="https://github.com/user-attachments/assets/3f8f3c26-3d31-48f5-badf-a9da83b6d168" />

* **Require fewer clicks to change filament in object list** by @Xipit in [PR 12603](https://github.com/OrcaSlicer/OrcaSlicer/pull/12603)
    Changing filament for an object now takes 3 clicks instead of 5+: single click on the filament indicator, second click opens the dropdown, third click selects. This mirrors the existing name-change behavior.

    Before:

    <video controls width="800" src="https://github.com/user-attachments/assets/b7efab68-e8fc-4177-a88e-3be2a2ea5366"></video>

    After:

    <video controls width="800" src="https://github.com/user-attachments/assets/c261c7f0-75e9-4291-b68b-dc7d8a6c0d1e"></video>

* **Show sparse infill rotation warning only once** by @RF47 in [PR 13461](https://github.com/OrcaSlicer/OrcaSlicer/pull/13461)
    The sparse infill rotation template warning now appears only once instead of repeatedly. Fixes #10963.

* **Improve generic 3MF import** by @ianalexis in [PR 13403](https://github.com/OrcaSlicer/OrcaSlicer/pull/13403)
    Generic and CAD-authored 3MF files are now imported silently as geometry instead of prompting an unnecessary dialog. Fixes #12434.

## Text / Description Improvements

* **Fix "cancle" typo** by @theshantanujoshi in [PR 13769](https://github.com/OrcaSlicer/OrcaSlicer/pull/13769)
    Corrected a misspelled "cancle" to "cancel" in the UI.
* **Add tooltips to Transfer buttons** by @ianalexis in [PR 13535](https://github.com/OrcaSlicer/OrcaSlicer/pull/13535)
    Transfer setting buttons now show descriptive tooltips.
* **Fix reverse on even hint** by @igiannakas in [PR 13739](https://github.com/OrcaSlicer/OrcaSlicer/pull/13739)
    Fixed an issue with wall direction reversal on even-numbered layers. Fixes #13425.
* **Clarify Create nozzle for existing printer** by @yw4z in [PR 11773](https://github.com/OrcaSlicer/OrcaSlicer/pull/11773)
    Users were often confused when they couldn't proceed past the nozzle selection step while trying to add a common nozzle size (like 0.4mm) that already existed as a preset. Instead of a dead end, the dialog now offers to switch to the existing preset so users can view, edit, and customize it directly — turning a blocking point into a guided workflow.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Create nozzle before" src="https://github.com/user-attachments/assets/2ff806ef-fef4-42ec-893a-969dbe44188e" /> | <img width="300" alt="Create nozzle after" src="https://github.com/user-attachments/assets/9ced4d01-ba14-4f42-b467-b0d6762cc187" /> |

## Fixes & Consistency Improvements

* **UI fixes and improvements** by @yw4z in [PR 12513](https://github.com/OrcaSlicer/OrcaSlicer/pull/12513)
    A wide-ranging UI polish pass touching 15 areas: fixed Bambu device selector search box borders on dark mode, aligned titlebar menus with their associated buttons, improved combobox dropdown widths to match content, fixed version text size on macOS, corrected message dialog sizing (they were too wide), fixed canvas menu overlapping with the sliced plates toolbar, improved STEP import dialog styling with rounded rectangle tips section, fixed drop file dialog filename clipping by showing names on a separate line, improved hyperlink colors in canvas notifications, fixed Bambu bind dialog button alignment, enhanced the color picker margins, aligned project page welcome screen buttons, and corrected URL casing on web-related translations.

    **Drop file dialog**
    | Drop file dialog Before | After |
    |--------|-------|
    | <img width="400" alt="Drop file before" src="https://github.com/user-attachments/assets/96bab3c6-2aec-4b34-9e77-8f0a13b7746d" /> | <img width="400" alt="Drop file after" src="https://github.com/user-attachments/assets/cf289318-02b8-4b45-8ba0-8d7ff5222152" /> |

    **Preferences > Combobox dropdowns with content width**
    | Before | After |
    |--------|-------|
    | <img width="167" height="164" alt="Screenshot-20260228222453" src="https://github.com/user-attachments/assets/3eea160c-a42f-4b4e-98b5-bedc661bfcd9" /> | <img width="195" height="163" alt="Screenshot-20260228222500" src="https://github.com/user-attachments/assets/1b8e5f0a-0a74-464c-8902-2ddc999efd25" /> |

    **Step mesh dialog**
    | Before | After |
    |--------|-------|
    | <img width="427" height="375" alt="Screenshot-20260228224110" src="https://github.com/user-attachments/assets/1dea3d61-6575-4a5f-a36e-4a217088fdad" /> | <img width="512" height="371" alt="Screenshot-20260302054632" src="https://github.com/user-attachments/assets/5625a176-f0f9-4053-81c4-c86ca992052f" /> |

    **Properly sized message dialogs**
    | Before | After |
    |--------|-------|
    | <img width="424" height="180" alt="Screenshot-20260228223005" src="https://github.com/user-attachments/assets/6c9488d7-f4dd-4d1d-9d88-86f00b908c73" /> | <img width="756" height="193" alt="Screenshot-20260228223153" src="https://github.com/user-attachments/assets/d5d8fda1-2729-48f4-953b-715d23d42c91" /> |

* **Improve mode button visuals** by @yw4z in [PR 13795](https://github.com/OrcaSlicer/OrcaSlicer/pull/13795)
    Fixed the mode toggle button's colors (dark mode, pressed state), visual state after enable/disable from preferences, track drawing shape, and focus border. Developer mode now shows "DEV" text.

    Before
    <img width="400" alt="Mode button before" src="https://github.com/user-attachments/assets/a773a95f-ad0e-4bc0-a55b-51b4d43e7963" />
    After
    <img width="400" alt="Mode button after" src="https://github.com/user-attachments/assets/3780ae54-1c56-4d16-a206-6944b128c1ac" />

* **Don't steal focus from text inputs on mouse hover** by @RF47 in [PR 12834](https://github.com/OrcaSlicer/OrcaSlicer/pull/12834)
    Hovering the mouse over the 3D viewport no longer steals keyboard focus from active text input fields. Fixes #12823.
* **Fix FilamentGroupPopup not dismissing on macOS** by @SoftFever in [PR 13574](https://github.com/OrcaSlicer/OrcaSlicer/pull/13574)
    Fixed a macOS freeze caused by the filament group popup dialog failing to dismiss.
* **Fix printer name disappearing when editing a nozzle variant** by @Noisyfox in [PR 13653](https://github.com/OrcaSlicer/OrcaSlicer/pull/13653)
    Editing a non-first nozzle variant of a multi-nozzle printer profile could cause the printer name to disappear.
* **Fix UI freeze after hiding sync popup on Linux** by @erpalma in [PR 13657](https://github.com/OrcaSlicer/OrcaSlicer/pull/13657)
    Hiding the filament sync popup on Linux/GTK could leave the UI unresponsive because `BaseTransparentDPIFrame::on_hide()` always called `mainframe->Show()`. Now only calls Show() when the main frame is not already visible. Fixes #11288, #11701, #12553.
* **Fix right edge of G-code viewer legend not interactive** by @kisslorand in [PR 11899](https://github.com/OrcaSlicer/OrcaSlicer/pull/11899)
    The rightmost edge of legend rows in the G-code viewer was not responding to clicks.
* **Fix sidebar filament count for multi-extruder printers** by @SoftFever in [PR 13706](https://github.com/OrcaSlicer/OrcaSlicer/pull/13706)
    Multi-extruder printers could show fewer filament slots in the sidebar than the printer actually has nozzles. This happened when switching between dual-extruder profiles (the sidebar would drop to a single filament) or when loading a partial saved filament list. The sidebar now always shows at least one filament slot per nozzle, and saved filament colors are preserved rather than truncated.
    <img width="350" alt="Sidebar filament count fix" src="https://github.com/user-attachments/assets/4aaada18-694b-4d7c-8103-34176878a99e" />
* **Fix vertical alignment issues** by @yw4z in [PR 13133](https://github.com/OrcaSlicer/OrcaSlicer/pull/13133)
    Fixed vertical misalignment of the printer name display and clone progress indicator in the sidebar, which were noticeably off-center.
* **Fix TextInput & ComboBox glitches after scrolling on scaled displays** by @yw4z in [PR 13805](https://github.com/OrcaSlicer/OrcaSlicer/pull/13805)
    Borders around text inputs and comboboxes were not filling the available space after scrolling on scaled displays. Tested on Windows 11.

* **Fix dirty-state marker for edited system printer presets** by @kisslorand in [PR 11900](https://github.com/OrcaSlicer/OrcaSlicer/pull/11900)
    System printer presets now correctly show the "*" (modified) indicator when edited, matching the behavior of all other preset types. Fixes #11705.
    | Before | After |
    |--------|-------|
    | <img width="400" alt="Dirty marker before" src="https://github.com/user-attachments/assets/cd8070bd-30ce-4a4f-b6b4-c5d34944173a" /> | <img width="400" alt="Dirty marker after" src="https://github.com/user-attachments/assets/611d157f-6d27-4d0a-b58d-8f3cf92312da" /> |

* **Fix ObjectTableDialog close on Escape** by @Jo-Con-El in [PR 12979](https://github.com/OrcaSlicer/OrcaSlicer/pull/12979)
    The Object Table dialog now correctly closes when pressing Escape.

* **Auto hide/show ironing angle settings** by @ansonl in [PR 11451](https://github.com/OrcaSlicer/OrcaSlicer/pull/11451)
    Ironing angle settings are automatically hidden when a concentric ironing pattern is selected, since they don't apply.

* **Remove black borders on controls on Linux and fix assertion errors** by @yw4z in [PR 13718](https://github.com/OrcaSlicer/OrcaSlicer/pull/13718), [PR 13362](https://github.com/OrcaSlicer/OrcaSlicer/pull/13362), and [PR 13363](https://github.com/OrcaSlicer/OrcaSlicer/pull/13363)
    Fixed GTK assertion errors on window resize, removed black borders on checkbox and switch buttons, and fixed unnecessary scrollbars appearing with only one filament.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Checkbox borders before" src="https://github.com/user-attachments/assets/b39ca843-3b6d-49d5-ad0b-278de4f73c1e" /> | <img width="300" alt="Checkbox borders after" src="https://github.com/user-attachments/assets/17069eb6-2e8d-4faa-8100-6b401fdf7bef" /> |

* **Fix macOS object-list filament editor crash/glitch** by @thelegendtubaguy in [PR 13700](https://github.com/OrcaSlicer/OrcaSlicer/pull/13700)
    The filament column in the object list could enter Cocoa native text editing exposing `wxCustomRendererObject` or crash on invalid `DataViewBitmapText` values on macOS. Multiple defensive fixes applied, and on macOS filament-column editing now routes through the custom bitmap-choice renderer. Fixes #13682.

* **Fix Windows double window and title bar issues** by @ianalexis, @Noisyfox, and @yw4z in [PR 13074](https://github.com/OrcaSlicer/OrcaSlicer/pull/13074), [PR 13020](https://github.com/OrcaSlicer/OrcaSlicer/pull/13020), and [PR 13117](https://github.com/OrcaSlicer/OrcaSlicer/pull/13117)
    Fixed a double title bar issue on Windows 10 by removing the window caption style, enlarged the resize grabber zone for easier window resizing, and fixed overscaled controls (color picker, sidebar icons, titlebar buttons) that appeared after the wxWidgets upgrade due to missing scaling values on wxBitmaps. Fixes #13046, #13130, #13073.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Double window before" src="https://github.com/user-attachments/assets/f6d607af-0cb6-488b-977d-b53db0622dcd" /> | <img width="300" alt="Double window after" src="https://github.com/user-attachments/assets/ccf2ecee-14c8-404d-a387-92781aea7bb7" /> |
    | <img width="300" alt="Overscaled controls before" src="https://github.com/user-attachments/assets/f558866e-2d52-4ed0-b7c5-67872ad95b40" /> | <img width="300" alt="Overscaled controls after" src="https://github.com/user-attachments/assets/89f462de-880d-4b43-84c5-71fd3cc6a768" /> |

* **Fix "Jump to" links for non-print preset settings** by @kisslorand in [PR 13381](https://github.com/OrcaSlicer/OrcaSlicer/pull/13381)
    Validation notification "Jump to" links always targeted Print preset settings, even for issues in other preset types. Now correctly resolves the target preset type. Fixes #13350.

* **Fix stale keyboard refresh and auto-resize flicker in Preview** by @kisslorand in [PR 12707](https://github.com/OrcaSlicer/OrcaSlicer/pull/12707)
    Keyboard navigation in the Preview tab now immediately refreshes the speed profile popup, and the popup no longer flickers with an incorrect height before correcting itself.

* **Fix Flow Ratio dialog shrinking after minimize** by @packerlschupfer in [PR 13545](https://github.com/OrcaSlicer/OrcaSlicer/pull/13545)
    On Linux/wxGTK, minimizing the main window collapsed the Flow Ratio calibration dialog to ~222x249px with the OK button unreachable. The dialog was missing `SetSizeHints()` which all other calibration dialogs already use.

* **Fix filament combobox not working after adding extruder** by @Noisyfox in [PR 13194](https://github.com/OrcaSlicer/OrcaSlicer/pull/13194)
    For multi-tool printers, the filament selection combobox would stop working after adding a new extruder, leaving the filament slot unconfigurable.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Combobox broken before" src="https://github.com/user-attachments/assets/fe69b5cf-c914-485c-ba6a-08a6180ce0c2" /> | <img width="400" alt="Combobox fixed after" src="https://github.com/user-attachments/assets/e860b4fc-a571-46da-8bcf-fedb5d2c9932" /> |

* **Fix font rendering pixelated when ClearType disabled** by @yw4z in [PR 12201](https://github.com/OrcaSlicer/OrcaSlicer/pull/12201)
    Added grid-fitting metadata to the UI font using FontForge so text renders correctly on Windows when ClearType is turned off (common on high-resolution or non-RGB displays). Fixes #11732.

    | Before (ClearType off) | After |
    |------------------------|-------|
    | <img width="400" alt="Font before" src="https://github.com/user-attachments/assets/d1ed7d4a-6cbf-4cb0-bfbf-29a48f46f3b3" /> | <img width="400" alt="Font after" src="https://github.com/user-attachments/assets/5781b567-c2f1-488d-833b-369c77253bad" /> |

* **Fix flushing volume dialog OK/Cancel buttons clipped** by @Blumlaut in [PR 13762](https://github.com/OrcaSlicer/OrcaSlicer/pull/13762)
    The flushing volume dialog's OK/Cancel buttons could fall below the visible area when the window was clamped to screen size (many filaments, small displays, or high DPI). Converted to flexbox layout with a scrollable table area, and added an accurate fixed overhead calculation in C++. Fixes #13511.

    | Before (buttons clipped below visible area) | After (scrollable table, buttons always visible) |
    |----------------------------------------------|---------------------------------------------------|
    | <img width="394" alt="Flushing volume dialog with OK/Cancel buttons clipped" src="https://github.com/user-attachments/assets/bffa204b-2db1-4ccd-b06b-7892ba9a735c" /> | <img width="600" alt="Flushing volume dialog with scrollable table and visible buttons after fix" src="https://github.com/user-attachments/assets/15f00779-74c9-4895-9f89-82e013665de0" /> |

* **Allow the flush volumes dialog to be resized** by @erpalma in [PR 13663](https://github.com/OrcaSlicer/OrcaSlicer/pull/13663)
    The flushing volumes dialog can now be resized, making it easier to manage long filament lists for multi-material printers.

* **Linux: match titlebar font** by @yw4z in [PR 12828](https://github.com/OrcaSlicer/OrcaSlicer/pull/12828)
    The custom titlebar font now matches the system UI font on Linux by applying `SetFont()` to the ArtProvider and window title, bringing the titlebar text visually closer to native windows. Previously the ArtProvider used the default system font which caused a noticeable mismatch between the titlebar and the rest of the window.

    <img width="600" alt="Titlebar font comparison Linux vs Windows" src="https://github.com/user-attachments/assets/5ed20ba5-a11f-48d0-98f0-4f6013dca884" />

* **Improved Splash screen rendering** by @yw4z in [PR 12586](https://github.com/OrcaSlicer/OrcaSlicer/pull/12586)
    Simplified the splash screen drawing code, fixed blank splash screen on Linux (#13441), and fixed a niche crash (#12576). Fonts now use the correct size on scaled monitors by using wxPaintDC which already accounts for DPI scaling.

* **Hide non-applicable settings for tree supports** by @kisslorand in [PR 12367](https://github.com/OrcaSlicer/OrcaSlicer/pull/12367)
    Settings that don't apply to tree-based supports (such as Independent Support Layer Height for Organic trees and Threshold Overlap for all tree styles) are now hidden from the UI when a tree support style is selected, reducing confusion and incorrect bug reports.

* **Improve readability of "Only one wall" settings** by @yw4z in [PR 13121](https://github.com/OrcaSlicer/OrcaSlicer/pull/13121)
    The one-wall threshold option is now hidden when its parent setting is disabled, reducing clutter and making the "Only one wall on top/bottom/internal surfaces" parameters easier to read.

    | Before | After |
    |--------|-------|
    | <img width="385" alt="Only one wall settings before readability improvement" src="https://github.com/user-attachments/assets/7ce73739-af9c-45a5-a53b-57057e0d5f76" /> | <img width="378" alt="Only one wall settings after hiding threshold when disabled" src="https://github.com/user-attachments/assets/531cbbb6-45c9-44b7-ac62-2e0741319020" /> |

* **Fix seams glitch on Linux** by @RF47 in [PR 13233](https://github.com/OrcaSlicer/OrcaSlicer/pull/13233)
    Fixed missing faces in seam geometry on Linux that appeared as visual glitches in the preview.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Seams glitch before" src="https://github.com/user-attachments/assets/8d44eaec-4324-4f98-8467-3b38a84620db" /> | <img width="400" alt="Seams glitch after" src="https://github.com/user-attachments/assets/7c14e8ff-ea4d-4e2a-97d1-3193d01bf2a7" /> |

# 🛠️ Bug Fixes

* **Fix crash when selecting or moving wipe tower** by @icedrone in [PR 13243](https://github.com/OrcaSlicer/OrcaSlicer/pull/13243)
    Fixed a regression from the auto-drop feature where selecting or moving the wipe tower caused a crash due to a garbage pointer dereference. The wipe tower has a synthetic object index outside the normal range, which was not guarded against in `Selection::get_auto_drop()`.

* **Fix support interface semantics, gap handling, and tree support interfaces** by @kisslorand in [PR 11812](https://github.com/OrcaSlicer/OrcaSlicer/pull/11812)
    A comprehensive 4-part fix for support structures: replaced the global soluble interface flag with explicit per-side zero-gap detection, fixed interface spacing/density coupling, corrected bottom interface generation for both organic and non-organic tree supports, fixed deterministic interlacing, and resolved issues with independent layer height interface count semantics. Fixes #8887, #10763.

* **Fix extrusion of support layers at wrong Z height** by @kisslorand in [PR 13327](https://github.com/OrcaSlicer/OrcaSlicer/pull/13327) and [PR 13460](https://github.com/OrcaSlicer/OrcaSlicer/pull/13460)
    In rare cases, two support layers were created back-to-back without moving to the correct Z height between them, causing missing support layers. Height tracking info was being cleared too early, and the ZAA port in #12736 reverted the original fix. Both issues are now resolved.

* **Fix support preview artifacts (missing layers)** by @kisslorand in [PR 13310](https://github.com/OrcaSlicer/OrcaSlicer/pull/13310)
    Floating-point imprecision in gap subdivision (`ceil(0.20000001/0.2)` = 2 instead of 1) could produce duplicate splits, causing missing support layers in the preview. Added epsilon tolerance to prevent this. Fixes #12846.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Support artifacts before" src="https://github.com/user-attachments/assets/8c5464fb-adfe-4494-a703-1ebe20008b26" /> | <img width="400" alt="Support artifacts after" src="https://github.com/user-attachments/assets/6f4a1c99-0149-4f41-bc0c-3637e6746ab0" /> |

* **Fix collision with the bed using tree supports** by @RF47 in [PR 13524](https://github.com/OrcaSlicer/OrcaSlicer/pull/13524)
    Added a safeguard ensuring the first layer height is never less than the brim height, preventing a rare bed collision with tree supports. Fixes #13500.

* **Fix tree support "on build plate only" missing interface layers** by @Argolein in [PR 13192](https://github.com/OrcaSlicer/OrcaSlicer/pull/13192)
    Tree supports with "on build plate only" enabled were not generating support interface layers, resulting in poor surface quality on supported overhangs.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="No interface before" src="https://github.com/user-attachments/assets/09a27d3e-3c90-4cb0-b397-163067a61604" /> | <img width="400" alt="Interface layers after" src="https://github.com/user-attachments/assets/37e20946-91d6-46d3-9012-22ee024ace89" /> |

* **Fix role-based fan speeds lost on layer change** by @kisslorand in [PR 13390](https://github.com/OrcaSlicer/OrcaSlicer/pull/13390)
    Feature-specific fan speed overrides could be silently lost when crossing layer boundaries because Orca skipped emitting a fresh G-code marker, thinking it was already active. Now correctly layer-aware — each new layer emits a fresh marker when a feature continues across the boundary. Fixes #8143.

* **Fix fan stuck at wrong speed after role-based override ends** by @kisslorand in [PR 13336](https://github.com/OrcaSlicer/OrcaSlicer/pull/13336)
    When fan speed-up time was enabled with role-based fan overrides, the fan could stay stuck at the higher override speed because Orca lost track of the actual fan speed output. Now correctly returns to the expected speed after overrides complete.

* **Fix first layer speed and slow down handling with rafts** by @yogihybo in [PR 13224](https://github.com/OrcaSlicer/OrcaSlicer/pull/13224) and [PR 13415](https://github.com/OrcaSlicer/OrcaSlicer/pull/13415)
    Initial layer speed and slow-down logic now correctly account for raft layers. The first raft base layer gets the correct infill speed, overhang slowdown is excluded for the first layer above the raft, and slow-down layer interpolation is split into separate branches for rafts vs. no rafts. Fixed an operator precedence bug (`!m_config.raft_layers > 0` → `m_config.raft_layers == 0`).

    | Before (with raft) | After (with raft) |
    |---------------------|-------------------|
    | <img width="400" alt="Raft slowdown before" src="https://github.com/user-attachments/assets/2405945e-ecae-44c0-8583-9af295eb9d2b" /> | <img width="400" alt="Raft slowdown after" src="https://github.com/user-attachments/assets/3a129da4-a6a2-409b-be92-2f5f7a68ef10" /> |

* **Fix overhang reverse threshold being ignored** by @kisslorand in [PR 13061](https://github.com/OrcaSlicer/OrcaSlicer/pull/13061)
    Wall direction was reversing on alternating layers even with disabled fuzzy skin, because disabled fuzzy skin was still treated as active internally, triggering an alternative wall generation path that skipped the overhang threshold check. Also fixes arc fitting and contour simplification. Fixes #13055.

* **Fix crash from inconsistent draft shield layer height** by @RF47 in [PR 12937](https://github.com/OrcaSlicer/OrcaSlicer/pull/12937)
    Multi-object prints with per-object draft shields and independent support layer heights could produce erratic draft shield layers or crash with large object counts. Support layer height is now properly isolated and does not interfere with draft shield generation. Fixes #10950, #10788.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Draft shield before" src="https://github.com/user-attachments/assets/41e7e551-32d4-4f3a-a01f-85d1a881c5b1" /> | <img width="400" alt="Draft shield after" src="https://github.com/user-attachments/assets/38171b66-dc6d-4efc-acc0-1fce92cf3c8d" /> |

* **Fix fuzzy skin regression with classic wall generator** by @RF47 in [PR 12920](https://github.com/OrcaSlicer/OrcaSlicer/pull/12920)
    Fixed a regression where the classic wall generator produced artifacts with fuzzy skin enabled. Still fixes the original fuzzy skin artifact from the prior commit without the regression. Fixes #12911.

    <img width="600" alt="Fuzzy skin regression fix" src="https://github.com/user-attachments/assets/e8735ab9-d77b-4aee-a977-40d4da29e114" />

* **Fix save custom machine profiles with different extruder count** by @RF47 in [PR 13035](https://github.com/OrcaSlicer/OrcaSlicer/pull/13035)
    Custom machine profiles with a different extruder count than their parent now save correctly. The root cause: this function was cherry-picked from Bambu Studio, which doesn't allow changing the number of extruders. Fixes #12949, #12994.

* **Fix trapezoidal fill layer rotation with infill combination** by @RF47 in [PR 13276](https://github.com/OrcaSlicer/OrcaSlicer/pull/13276)
    Rotation was calculated from layer ID rather than the actual layer position, causing incorrect rotation when infill combination was active. Fixes #13275.

* **Fix flush_multiplier type mismatch** by @SoftFever in [PR 13062](https://github.com/OrcaSlicer/OrcaSlicer/pull/13062)
    Fixed a type mismatch where `flush_multiplier` was using a single float instead of a vector of floats, causing incorrect flush volume behavior.

* **Fix air filtration and chamber heater UI controls** by @kisslorand in [PR 12525](https://github.com/OrcaSlicer/OrcaSlicer/pull/12525), [PR 13384](https://github.com/OrcaSlicer/OrcaSlicer/pull/13384), and [PR 13440](https://github.com/OrcaSlicer/OrcaSlicer/pull/13440), and by @brandonfhall in [PR 13393](https://github.com/OrcaSlicer/OrcaSlicer/pull/13393)
    Fixed air filtration and exhaust fan settings being incorrectly hidden on printers that support them (Bambu H2D, P1S, X1, X1C, Elegoo Centauri). Chamber temperature control is now always visible for Klipper users who need it for macros and heat soaking, while M141/M191 emission is still gated by the "activate temperature control" flag. The support chamber temperature control flag is also now exposed in filament profiles without requiring developer mode (#12924).

* **Fix first layer toolhead preheating with 2+ extruders and ooze prevention** by @igiannakas in [PR 13741](https://github.com/OrcaSlicer/OrcaSlicer/pull/13741)
    With ooze prevention enabled and preheat_time > 0, the first layer's early M104 used "Other layers" temperature instead of first-layer temperature because `m_layer_id` had already advanced by post-process time. Now tracks a local `current_layer_id` that increments on layer changes. Fixes #13351.

* **Fix vase mode zero flow bug** by @RF47 in [PR 13517](https://github.com/OrcaSlicer/OrcaSlicer/pull/13517)
    Extremely short extrusions in vase mode could cause flow to drop to zero, particularly problematic with large nozzles. These are now filtered out with a minimum extrusion length that depends on slice resolution.

* **Fix collision warnings for overlapping instances** by @tome9111991 in [PR 12122](https://github.com/OrcaSlicer/OrcaSlicer/pull/12122)
    Duplicate instances of the same object were not flagged with collision warnings because collision detection relied on cached convex hulls at the ModelObject/ModelVolume level. Also improved wipe tower conflict detection. Fixes #12077.

    <img width="400" alt="Collision warning" src="https://github.com/user-attachments/assets/3d1119bf-823c-4425-b615-e16f2f2ea2dd" />

* **Fix outer wall for bridges** by @kisslorand in [PR 13411](https://github.com/OrcaSlicer/OrcaSlicer/pull/13411)
    Enabling "Bridge counterbore holes" by "Partially bridged" caused ordinary bridges to lose their overhang-wall generation. The partial-bridge rewrite was being applied to all unsupported bridge islands, not just counterbore-like surfaces. Now restricted to hole-bearing bridge islands only. Fixes #13344.

    | Before | After |
    |--------|-------|
    | <img width="400" alt="Bridge walls before" src="https://github.com/user-attachments/assets/36f8664f-fa97-41ce-be9c-4a892bea8131" /> | <img width="400" alt="Bridge walls after" src="https://github.com/user-attachments/assets/1bfce032-61b3-46dc-a0c5-319dbdfcf229" /> |

* **Fix auto-arrangement boundary for skirt loops** by @Eldenroot in [PR 12999](https://github.com/OrcaSlicer/OrcaSlicer/pull/12999)
    Cherry-picked from Bambu Studio. Auto-arrange now correctly accounts for skirt loops when calculating object placement boundaries.

* **Fix sacrificial bridge layer edge case with only 2 perimeters** by @RF47 in [PR 13018](https://github.com/OrcaSlicer/OrcaSlicer/pull/13018)
    With only 2 perimeters, walls could disappear from sacrificial bridge layers because the filter consumed the entire ExPolygon. The geometry handling now preserves walls at low perimeter counts. Fixes #12953.

    | Before | After |
    |--------|-------|
    | <img width="300" alt="Sacrificial before 1" src="https://github.com/user-attachments/assets/cd927360-2b15-4a79-8d55-991f415b0b49" /> | <img width="300" alt="Sacrificial after 1" src="https://github.com/user-attachments/assets/6e584eba-612e-4421-ad63-245fdae176c6" /> |

* **Fix LAN printing crashes and hangs on Bambu H2D** by @hyiger in [PR 13296](https://github.com/OrcaSlicer/OrcaSlicer/pull/13296)
    Fixed two LAN printing issues with newer Bambu networking plugins: a crash from missing file transfer symbols, and indefinite hangs at 30% upload progress caused by the eMMC print path on H2D. LAN mode now correctly falls back to the standard FTP transfer path. Also fixes H2D LAN print job routing by @erpalma in [PR 13662](https://github.com/OrcaSlicer/OrcaSlicer/pull/13662).

* **Fix non-ASCII path corruption on Windows** by @SoftFever in [PR 13036](https://github.com/OrcaSlicer/OrcaSlicer/pull/13036)
    Fixed file path corruption when paths contain non-ASCII characters on Windows using a `from_path()` helper.

* **Fix "Access Violation" crash** by @RF47 in [PR 12856](https://github.com/OrcaSlicer/OrcaSlicer/pull/12856)
    Added range checks to prevent access violations when parsed extruder or filament IDs are out of bounds in M1020 and T command processing. Fixes #12704.

* **Fix crash with painted line on corrupted models** by @RF47 in [PR 12806](https://github.com/OrcaSlicer/OrcaSlicer/pull/12806)
    Fixed an infinite loop condition when rasterizing a painted line across corrupted mesh geometry. Fixes #12648, #13083.

* **Fix crash when returning from assembly view on Linux** by @RF47 in [PR 13091](https://github.com/OrcaSlicer/OrcaSlicer/pull/13091)
    Refactored the "Return" toolbar button handling to use deferred actions and null checks, fixing a crash when exiting assembly view. Fixes #12768.

* **Fix crash when changing SVG/TEXT type to Support Blocker/Enforcer** by @yw4z in [PR 13120](https://github.com/OrcaSlicer/OrcaSlicer/pull/13120) and @DImagine in [PR 13281](https://github.com/OrcaSlicer/OrcaSlicer/pull/13281)
    Disabled Support Blocker/Enforcer menu items are now properly grayed out when the selection contains SVG or TEXT volumes (which don't support these modifiers). A follow-up further hardens the original fix and removes a dead code path. Fixes #5070.

* **Fix crash with SVG "use surface"** by @RF47 in [PR 13262](https://github.com/OrcaSlicer/OrcaSlicer/pull/13262)
    Added preflight mesh validation (validity, emptiness, self-intersection check) before CGAL corefinement operations when applying "use surface" to SVG modifiers. Fixes #13167.

* **Fix crash on launch from temporary object reference** by @Noisyfox in [PR 13341](https://github.com/OrcaSlicer/OrcaSlicer/pull/13341)
    Fixed a crash on application startup caused by a dangling reference to a temporary object introduced in the tooltip button refactor (#12848).

* **Fix stealth mode handling** by @RF47 in [PR 13285](https://github.com/OrcaSlicer/OrcaSlicer/pull/13285)
    Stealth mode now correctly avoids network connections and cloud sync operations when enabled. Fixes #13049.

* **Fix per-feature filament assignments ignored at slice time** by @ianalexis in [PR 13607](https://github.com/OrcaSlicer/OrcaSlicer/pull/13607)
    Filament assignments made for specific features (e.g., per-role filament) were not honored during slicing. Fixes #10470.
* **Fix one wall on top/bottom surfaces for assembly objects** by @igiannakas in [PR 13714](https://github.com/OrcaSlicer/OrcaSlicer/pull/13714)
    The "one wall on top/bottom surfaces" setting was applied incorrectly to assembly objects, and is now handled correctly.
* **Fix partial sacrificial bridge anchors** by @ianalexis in [PR 13052](https://github.com/OrcaSlicer/OrcaSlicer/pull/13052)
    Improves anchor generation for partial sacrificial bridges, producing more reliable bridging over overhangs.
* **Fix false out-of-bounds validation for large paths** by @ianalexis in [PR 13179](https://github.com/OrcaSlicer/OrcaSlicer/pull/13179)
    When a feature's bounding box extended beyond the build volume, Orca could raise a false "out of bed" error. It now falls back to per-move validation. Fixes #11965.
* **Skip small-area compensation validation when disabled** by @ianalexis in [PR 12528](https://github.com/OrcaSlicer/OrcaSlicer/pull/12528)
    Model validation no longer raises false errors related to small-area flow compensation when that feature is turned off.
* **Fix .gcode.3mf files not displaying** by @Noisyfox in [PR 13360](https://github.com/OrcaSlicer/OrcaSlicer/pull/13360)
    Fixed an issue where opening a .gcode.3mf file would not display its contents. Fixes #13159.
* **Harden CLI export without OpenGL** by @mwnickerson in [PR 13532](https://github.com/OrcaSlicer/OrcaSlicer/pull/13532)
    CLI export now continues in headless environments where OpenGL thumbnail generation is unavailable, instead of failing.
* **Fix crash when embossing text** by @Noisyfox in [PR 13772](https://github.com/OrcaSlicer/OrcaSlicer/pull/13772)
    Bumped the worker thread stack size to 16MB to prevent a crash when embossing text into models via CGAL on macOS and Linux. Fixes #13313.
* **Fix assembly view crash and empty canvas on Flatpak** by @yw4z in [PR 13413](https://github.com/OrcaSlicer/OrcaSlicer/pull/13413)
    Fixed a crash when entering assembly mode and an empty 3D canvas when running the Flatpak build.
* **Ignore SIGPIPE at startup to prevent crashes on dropped printer connections** by @zsiddique in [PR 13788](https://github.com/OrcaSlicer/OrcaSlicer/pull/13788)
    Prevents crashes caused by SIGPIPE signals when printer network connections are unexpectedly dropped.
* **Fix possible null dereference in DeviceManager during timer refresh** by @SoftFever in [PR 13802](https://github.com/OrcaSlicer/OrcaSlicer/pull/13802)
    Fixed a potential crash when `DeviceManager::check_pushing()` is called while the selected machine reference is missing or stale during a timer refresh.
* **Fix flatpak crash on start** by @SoftFever in [PR 13808](https://github.com/OrcaSlicer/OrcaSlicer/pull/13808)
    Fixed a crash that occurred when launching the Flatpak build of OrcaSlicer.
* **Fix single-instance IPC by preserving "OrcaSlicer" suffix in title** by @AMoo-Miki in [PR 13017](https://github.com/OrcaSlicer/OrcaSlicer/pull/13017)
    Fixed the single-instance file handoff mechanism on Windows that was broken by a title bar change.
* **Fix stealth mode cloud service logout** by @SoftFever in [PR 13531](https://github.com/OrcaSlicer/OrcaSlicer/pull/13531)
    When stealth mode is enabled, cloud services are now logged out and the sideboard is hidden for privacy.
* **Fix wxWidgets 3.3.2 upgrade issues** by @SoftFever in [PR 13740](https://github.com/OrcaSlicer/OrcaSlicer/pull/13740), @bwees in [PR 13737](https://github.com/OrcaSlicer/OrcaSlicer/pull/13737), @thomashenauer in [PR 13707](https://github.com/OrcaSlicer/OrcaSlicer/pull/13707), and @SoftFever in [PR 13747](https://github.com/OrcaSlicer/OrcaSlicer/pull/13747)
    Various fixes following the wxWidgets 3.3.2 upgrade: ObjectTable crash on cell deselect, macOS deep link handling, submenu popup parenting on Wayland, and a Preview tab crash on Linux/Wayland at startup.
* **Fix filament syncing with nozzle diameter guards** by @lynaghk in [PR 13330](https://github.com/OrcaSlicer/OrcaSlicer/pull/13330)
    Fixed a regression where filament syncing was incorrectly blocked by nozzle diameter compatibility checks, affecting printers that don't report nozzle information. The fix encapsulates the checking logic in a dedicated helper function for more robust compatibility validation. Fixes #13236 and #13176.
* **Fix Bambu Cloud login via embedded WebView** by @andrewsoonqn in [PR 13768](https://github.com/OrcaSlicer/OrcaSlicer/pull/13768)
    Fixed an issue where Bambu Cloud login via the embedded WebView would fail after submitting the verification code. Newer Bambu network plugin flows return a `user_ticket_login` command with a short-lived ticket, which the embedded WebView dialog did not handle — the login result was ignored and the UI appeared to keep loading. The fix adds the missing ticket exchange flow so embedded WebView login works consistently with the external browser path.
* **Fix Bambu login regression** by @SoftFever in [PR 13407](https://github.com/OrcaSlicer/OrcaSlicer/pull/13407)
    Fixed a regression introduced in the 3MF version tag update (#12509) that prevented logging into Bambu Cloud. Added a ticket-based OAuth flow.
* **Fix "could not load bitmap printer_preview_" crash on Linux** by @yw4z in [PR 12425](https://github.com/OrcaSlicer/OrcaSlicer/pull/12425)
    The code used a non-existent printer cover bitmap for non-BBL printers, causing a crash on Linux. Now uses covers from the vendor folder.
* **Fix PrinterWebView deferred URL clearing** by @RobertKuszmar in [PR 11508](https://github.com/OrcaSlicer/OrcaSlicer/pull/11508)
    PrinterWebView now only clears the deferred URL on successful load, retrying when returning to the device tab after the printer was off.
* **Fix Windows test linking** by @Wachhund in [PR 12939](https://github.com/OrcaSlicer/OrcaSlicer/pull/12939)
    wxWidgets Unicode defines caused Catch2 to provide wmain() instead of main(), breaking all test executables on MSVC.
* **Fix registration of filament_dynamic_map and filament_switcher config options** by @malventano in [PR 13623](https://github.com/OrcaSlicer/OrcaSlicer/pull/13623)
    Two config options added for X2D support were never registered in PrintConfig.cpp, causing crashes when loading .3mf files containing these keys.
* **Fix input_filename_base using object name instead of project name** by @raistlin7447 in [PR 13753](https://github.com/OrcaSlicer/OrcaSlicer/pull/13753)
    Export G-code always used the first object's name instead of the saved project name because three export functions were passing empty strings to `output_filepath_for_project()`. Now correctly uses the saved project path. Fixes #1945.
* **Fix crash on startup from low max volumetric speed** by @yw4z in [PR 13716](https://github.com/OrcaSlicer/OrcaSlicer/pull/13716)
    Some profiles inherited a max volumetric speed of 0, causing a crash. A default value of 12 is now set for all common profiles.
* **Fix model/step MIME type support on Unix** by @Eldenroot in [PR 13000](https://github.com/OrcaSlicer/OrcaSlicer/pull/13000)
    Cherry-picked from Bambu Studio. Added model/step to the list of supported MIME types on Unix, enabling proper file association for STEP files on Linux and macOS.
* **Fix crash when color was not specified** by @Eldenroot in [PR 13002](https://github.com/OrcaSlicer/OrcaSlicer/pull/13002)
    Added a fallback when a color value was not specified, preventing a crash.
* **Fix generic locale fallback on all platforms** by @icedrone in [PR 12948](https://github.com/OrcaSlicer/OrcaSlicer/pull/12948)
    When the system locale was set to an unavailable regional variant (e.g., en_IL), OrcaSlicer could crash on startup. The fallback logic (try base language, then chain through best available translations) was previously Linux-only; now works on all platforms.
* **Fix CLI segfault with P1S profiles** by @sparkleHazard in [PR 13193](https://github.com/OrcaSlicer/OrcaSlicer/pull/13193)
    CLI slicing with BBL printer profiles crashed due to nullptr dereference when extruder/filament options were absent from the resolved config. Added null guards.
* **Fix Linux segfault when loading Fluidd/Mainsail printer hosts** by @SoftFever in [PR 13724](https://github.com/OrcaSlicer/OrcaSlicer/pull/13724)
    WebKitGTK segfaults on `<object>` elements in older Fluidd (<1.37.0) and Mainsail (<2.16.1). A document-start user script injected inside PrinterWebView replaces vue-resize's `<object>` elements with `<div>` shims. Linux only. Credit to @VittC for diagnosing the root cause. Fixes #7210.
* **Fix macOS crash on close** by @Noisyfox in [PR 13215](https://github.com/OrcaSlicer/OrcaSlicer/pull/13215)
    Fixed a crash that occurred when closing OrcaSlicer on macOS.
* **Fix Windows file handoff when single-instance mode enabled** by @kisslorand in [PR 12944](https://github.com/OrcaSlicer/OrcaSlicer/pull/12944)
    Opening files from Explorer while Orca runs in single-instance mode was silently dropping files because the forwarding logic looked up the running instance by its title text, which had changed. Now uses stable window properties and instance hashes instead. Fixes #12925.
* **Fix arc fitting time progress with firmware retraction** by @vovodroid in [PR 12888](https://github.com/OrcaSlicer/OrcaSlicer/pull/12888)
    Fixed an issue where arc fitting broke the remaining time progress indicator when firmware retraction was enabled. Fixes #12796.
* **Fix Bambu camera stream freeze on Linux** by @tofublock in [PR 13359](https://github.com/OrcaSlicer/OrcaSlicer/pull/13359)
    The X1C live camera view froze after a few seconds on Linux due to unreliable decode timestamps from the Bambu tunnel library causing GStreamer to wait indefinitely for future timestamps. Fixed by synthesizing monotonic timestamps using EWMA-based period adaptation. Linux only.
* **Fix filament/printer selection stuck on loading** by @yw4z in [PR 13492](https://github.com/OrcaSlicer/OrcaSlicer/pull/13492)
    Fixed the filament and printer selection dialog getting stuck in an indefinite loading state.
* **Fix second extruder settings not handled for H2D/X2D** by @Noisyfox in [PR 13648](https://github.com/OrcaSlicer/OrcaSlicer/pull/13648)
    A signed/unsigned comparison bug caused extruder_id=-1 ("all extruders") to be treated as 0xFFFFFFFF and reset to 0, so only the first extruder received the correct settings variant. Fixes #13559.
* **Fix MANUAL_TOOL_CHANGE regression for BBL printers** by @SoftFever in [PR 13516](https://github.com/OrcaSlicer/OrcaSlicer/pull/13516)
    BBL-specific M1020 S handling in `toolchange()` bypassed `toolchange_prefix()`, so `manual_filament_change` had no effect and M1020 was always emitted regardless of the setting. The BBL logic is now properly moved into `toolchange_prefix()`. Fixes #11795.
* **Fix unicode preset name crash** by @SoftFever and @Noisyfox in [PR 13458](https://github.com/OrcaSlicer/OrcaSlicer/pull/13458) and [PR 13503](https://github.com/OrcaSlicer/OrcaSlicer/pull/13503)
    Fixed a crash when preset names contained characters outside the ASCII range (e.g., accented characters, CJK characters, or other Unicode text).

# 📜 Profiles

## Profile Processing Improvements

* **Fix generic filaments not showing on list** by @Sabriel-Koh in [PR 13037](https://github.com/OrcaSlicer/OrcaSlicer/pull/13037)
    Multiple fixes for the printer/filament selection dialog: blank selections on first open, default filaments not being pre-selected during initial setup, @System filament naming missing the postfix, and single-item sub-dropdowns not rendering. Also refactored code to properly save profile data before updating the selection. Fixes #12297, #12922.
* **Fix stray "Default Filament" preset selection** by @SoftFever in [PR 13570](https://github.com/OrcaSlicer/OrcaSlicer/pull/13570)
    A stray "Default Filament" entry could be written to OrcaSlicer.conf and cause a misleading filament selection on load. It is now ignored.
* **Fix preset variant truncation on load** by @cgarwood82 in [PR 13316](https://github.com/OrcaSlicer/OrcaSlicer/pull/13316)
    When a child printer preset has more extruders than its parent, `set_with_restore` silently truncated per-extruder settings during project load. Added a guard to skip the parent-shaped merge when the child has more extruders. Fixes #12085.

## New Printer Profiles
* **X2D Support** by @glowstab in [PR 13388](https://github.com/OrcaSlicer/OrcaSlicer/pull/13388)
    Adds full printer definition, machine/process/filament presets, and dual-nozzle handling for the Bambu Lab X2D. Includes support for custom filament mapping, auto-mapping, wipe tower cooling, LAN mode printing, and left/right filament distinction. Validated with 20+ hours of dual-nozzle printing and all CTest tests passing. Fixes #13294.
* **Bambu Lab P2S** printer and process profile updates matching latest official tweaks by @misterff1 in [PR 13118](https://github.com/OrcaSlicer/OrcaSlicer/pull/13118) and [PR 13355](https://github.com/OrcaSlicer/OrcaSlicer/pull/13355)
* **Flashforge Artemis** printer profile by @midnight-creator in [PR 11902](https://github.com/OrcaSlicer/OrcaSlicer/pull/11902)
* **Flashforge Creator 5 and Creator 5 Pro** printer profiles by @FlashforgeOfficial in [PR 13259](https://github.com/OrcaSlicer/OrcaSlicer/pull/13259)
* **Anycubic Kobra 3 Max** printer profile by @robertbaker in [PR 11586](https://github.com/OrcaSlicer/OrcaSlicer/pull/11586)
* **Anycubic Kobra X** printer profile by @CSLRDoesntGameDev in [PR 13529](https://github.com/OrcaSlicer/OrcaSlicer/pull/13529) and [PR 13677](https://github.com/OrcaSlicer/OrcaSlicer/pull/13677)
* **re:3D** printer profiles by @re3Dev in [PR 12935](https://github.com/OrcaSlicer/OrcaSlicer/pull/12935)
* **LH Stinger** printer profiles by @lhndo in [PR 13410](https://github.com/OrcaSlicer/OrcaSlicer/pull/13410)
* **Cubicon xCeler-Mini** printer and material profiles by @Hyvision in [PR 13172](https://github.com/OrcaSlicer/OrcaSlicer/pull/13172)

## New Filament Profiles

* **Bambu Lab Beta Filaments** (PLA, PETG, ABS, TPU) profiles by @ericwong-person in [PR 13318](https://github.com/OrcaSlicer/OrcaSlicer/pull/13318)
* **GreenGate3D PETG** filament profile by @stringlapse in [PR 13448](https://github.com/OrcaSlicer/OrcaSlicer/pull/13448)
* **FILL3D PLA Basic, PETG, PP, PPCF, PA** filament profiles by @julianramirezarango-source in [PR 12973](https://github.com/OrcaSlicer/OrcaSlicer/pull/12973)

## Profile Updates & Fixes
* **Profile folder optimizations** — SVG textures fır best quality, 50% size reduction (68MB → 34MB), bed model optimizations and updates HQ covers for Anet, Anker, Anycubic, Artillery, BIQU, Creality, Elegoo, Flashforge, FLSUN, Prusa, Qidi, Re3D, Rh3D, Snapmaker, Sovol, and more by @yw4z in [PR 13149](https://github.com/OrcaSlicer/OrcaSlicer/pull/13149)
* **Bambu Lab X2D** printer definition, machine/process/filament presets, and dual-nozzle support by @glowstab in [PR 13388](https://github.com/OrcaSlicer/OrcaSlicer/pull/13388)
* **Bump printers version to propagate X2D to existing users** by @RJAudas in [PR 13806](https://github.com/OrcaSlicer/OrcaSlicer/pull/13806)
* **Snapmaker U1** — 5 bug fixes and new 0.6mm/mixed-nozzle profiles by @kbaker827 in [PR 12824](https://github.com/OrcaSlicer/OrcaSlicer/pull/12824)
* **Anycubic Kobra Neo** 0.4mm nozzle profiles by @AndyHazz in [PR 12913](https://github.com/OrcaSlicer/OrcaSlicer/pull/12913)
* **Qidi X-Max 4** nozzle profile updates by @HYzd766 in [PR 13526](https://github.com/OrcaSlicer/OrcaSlicer/pull/13526)
* **Qidi X-Max 4** hotbed temperature adjustments by @HYzd766 in [PR 13717](https://github.com/OrcaSlicer/OrcaSlicer/pull/13717)
* **Qidi** disable Reduce infill retraction by @HYzd766 in [PR 13267](https://github.com/OrcaSlicer/OrcaSlicer/pull/13267)
* **Creality K2** STL and texture updates by @folofse in [PR 13098](https://github.com/OrcaSlicer/OrcaSlicer/pull/13098)
* **Creality K2 Plus/K2** adaptive bed mesh bounding box by @imammedo in [PR 13290](https://github.com/OrcaSlicer/OrcaSlicer/pull/13290)
* **Creality generic ASA** first layer temp adjusted from 60°C to 100°C by @pghwinter in [PR 13558](https://github.com/OrcaSlicer/OrcaSlicer/pull/13558)
* **Elegoo Centauri Carbon 2** filament_type fix by @Wegerich in [PR 13012](https://github.com/OrcaSlicer/OrcaSlicer/pull/13012)
* **Elegoo** profile cleanup by @SoftFever in [PR 13148](https://github.com/OrcaSlicer/OrcaSlicer/pull/13148)
* **Elegoo Centauri Carbon 2** file upload and device details support by @anjis-elegoo in [PR 13212](https://github.com/OrcaSlicer/OrcaSlicer/pull/13212)
* **Improved Z-Bolt Profiles** — filament renaming, G-code thumbnails, 0.6mm processes, and macros by @Transistor427 in [PR 13240](https://github.com/OrcaSlicer/OrcaSlicer/pull/13240)
* **Fix custom ZBolt profile filament selection** showing only @system by @peachismomo in [PR 13468](https://github.com/OrcaSlicer/OrcaSlicer/pull/13468)
* **Fix Ender-3 V3 KE** nozzle switching by @dennisklappe in [PR 13438](https://github.com/OrcaSlicer/OrcaSlicer/pull/13438)
* **Junction Deviation profiles & calibration limits** — JD values updated across Marlin printer profiles, with calibration capped at 0.3 and a warning above 0.25 by @ianalexis in [PR 13241](https://github.com/OrcaSlicer/OrcaSlicer/pull/13241) and [PR 13253](https://github.com/OrcaSlicer/OrcaSlicer/pull/13253)
* **Printer cover images** added and improved (RatRig, Centauri Carbon, Kingroon, and more) by @ianalexis in [PR 13660](https://github.com/OrcaSlicer/OrcaSlicer/pull/13660)
* **Fix K2 family chamber temperature control defaults** by @brandonfhall in [PR 13399](https://github.com/OrcaSlicer/OrcaSlicer/pull/13399)
    Chamber temperature control was hidden on Creality K2, K2 Plus, and K2 Pro because it required Developer mode. Now enabled by default.
* **Fix Ender-3 V3 KE nozzle switching** by @dennisklappe in [PR 13438](https://github.com/OrcaSlicer/OrcaSlicer/pull/13438)
    Missing printer_variant keys in nozzle profiles caused the slicer to always revert to 0.2mm.

# 🗪 Localization

* Brazilian Portuguese translations by @afmenez in [PR 12891](https://github.com/OrcaSlicer/OrcaSlicer/pull/12891)
* Spanish translation update by @Jo-Con-El in [PR 12981](https://github.com/OrcaSlicer/OrcaSlicer/pull/12981), @ianalexis in [PR 13652](https://github.com/OrcaSlicer/OrcaSlicer/pull/13652), and @peterm-m in [PR 13196](https://github.com/OrcaSlicer/OrcaSlicer/pull/13196)
* German translation updates by @hliebscher in [PR 13785](https://github.com/OrcaSlicer/OrcaSlicer/pull/13785), STEP typo fix by @hliebscher in [PR 13100](https://github.com/OrcaSlicer/OrcaSlicer/pull/13100)
* Czech translation with full menu by @jakubhencl in [PR 13465](https://github.com/OrcaSlicer/OrcaSlicer/pull/13465)
* Turkish translations update by @GlauTechCo in [PR 13155](https://github.com/OrcaSlicer/OrcaSlicer/pull/13155)
* Italian translation updates by @Kappa971 in [PR 13585](https://github.com/OrcaSlicer/OrcaSlicer/pull/13585), [PR 13674](https://github.com/OrcaSlicer/OrcaSlicer/pull/13674), and [PR 13720](https://github.com/OrcaSlicer/OrcaSlicer/pull/13720)
* Hungarian language update by @kisslorand in [PR 13321](https://github.com/OrcaSlicer/OrcaSlicer/pull/13321)
* Simplified Chinese locale fixes by @Neko-vecter in [PR 13225](https://github.com/OrcaSlicer/OrcaSlicer/pull/13225) and [PR 13235](https://github.com/OrcaSlicer/OrcaSlicer/pull/13235)
* Globally fix "milimeters" typo by @valerii-bokhan in [PR 13295](https://github.com/OrcaSlicer/OrcaSlicer/pull/13295)
* Globally fix "milisecond" typo by @afmenez in [PR 13329](https://github.com/OrcaSlicer/OrcaSlicer/pull/13329)
* Remove wrong c-format/boost-format markers from non-format strings by @afmenez in [PR 13251](https://github.com/OrcaSlicer/OrcaSlicer/pull/13251)
* Improve language on some GUI strings by @afmenez in [PR 13553](https://github.com/OrcaSlicer/OrcaSlicer/pull/13553)
* General translation and string-list refresh by @ianalexis in [PR 13622](https://github.com/OrcaSlicer/OrcaSlicer/pull/13622)
* **Fix Simplified Chinese locale issues** by @Neko-vecter in [PR 13225](https://github.com/OrcaSlicer/OrcaSlicer/pull/13225)
    Fixed incorrect translations for several UI elements in Simplified Chinese: corrected the "On" key label, changed the filament term from `细丝` to `耗材`, and fixed the view cube labels.

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
