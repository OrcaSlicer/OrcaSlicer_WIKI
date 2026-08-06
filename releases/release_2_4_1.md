# V2.4.1

This is the OrcaSlicer V2.4.1 release — a maintenance update on top of 2.4.0 with a broad round of profile and preset fixes at its core: it restores filaments that had gone missing or were miscategorized in the Orca Filament Library and the filament selection dialog, de-duplicates profile setting IDs, corrects ambiguous AMS filament matches, and improves how renamed and inherited presets are resolved. Other changes include a native Windows ARM64 build, a new minimal chamber temperature field, and a reworked skirt and brim generator (fixing a 2.4.0 regression that re-printed the skirt during per-object/sequential printing), alongside fixes for fuzzy skin, AMS sync ordering, CrealityPrint hosts, and Linux Wayland rendering. It also adds Snapmaker U1 nozzle profiles, Elegoo Centauri 2 support, and a refreshed translation catalog.

# 🌊 New Features & Improvements

* **Native Windows ARM64 build (Snapdragon X Elite)** by @abehrman in [14059](https://github.com/OrcaSlicer/OrcaSlicer/pull/14059), brought up to date and merged by @SoftFever in [14381](https://github.com/OrcaSlicer/OrcaSlicer/pull/14381)
    Adds a green, native Windows-on-ARM build (not x64 under emulation) for Snapdragon X Elite and other Windows ARM64 devices, folded into the standard Windows build matrix. It ships full feature parity — STEP/STP import, SVG→3D, and text emboss all build and work on ARM64 — with the x64/x86 build paths unchanged. This is a build/CI addition; wiring ARM64 into the official signed-release pipeline (code signing, installer) is a follow-up. The original work and authorship are @abehrman's (#14059); #14381 simply brings that branch up to date with `main`. With the new ARM64 builds, the Windows x64 installer and portable downloads now carry an `_x64` suffix in their filenames to distinguish them from the ARM64 ones.

* **Minimal chamber temperature field** by @igiannakas in [14340](https://github.com/OrcaSlicer/OrcaSlicer/pull/14340)
    Adds a per-filament "Minimal" chamber temperature alongside the existing value (now labelled "Target") in the filament settings, exposed to print-start macros as the `chamber_minimal_temperature` variable. This lets a start macro begin printing once the chamber reaches a threshold — for example, start at 50 °C while the chamber keeps heating toward a 60 °C target. The value is validated against the target (it warns and clamps if set higher) and is not emitted via M141/M191; it defaults to zero for existing profiles.

    <img width="700" alt="Minimal and Target chamber temperature fields" src="https://github.com/user-attachments/assets/77ac6670-ab21-4f58-bd9b-6b18406b2acb" />

* **Skirt and brim generation rework** by @kisslorand in [14333](https://github.com/OrcaSlicer/OrcaSlicer/pull/14333)
    Reworks skirt and brim generation into a single, shared flow and **fixes a regression introduced by the 2.4.0 skirt overhaul** affecting per-object and sequential (*By Object*) printing: with a skirt enabled, the skirt could be re-printed before each object — running the nozzle back over it, or even knocking already-printed parts off the plate — and the object print order was not respected. Skirts are now tracked per group and per print height so each one prints exactly once. In *By Layer* mode with per-object skirts, the order is now skirt → brim → object for each object (previously all skirts printed first), and brims print together with the object or group they belong to while *Combine brims* still merges touching brims. Draft shields are generated through the same logic, fixing cases where a draft shield failed to generate at *Skirt height = 0* or overlapped the brim. Unsafe *By Object* configurations that would need a shared multi-layer skirt or draft shield are now rejected with a clear slicing error. Fixes #14319 and #14366.

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/87e02fa7-d449-4981-90f9-4ddb1cb9d9fc" /> | <img width="400" src="https://github.com/user-attachments/assets/9ea5ab4d-7d91-4102-8644-11561dd9d195" /> |

    | Draft shield at Skirt height = 0 — Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/b5f074ba-5758-4509-8a06-21ec2cd4cae7" /> | <img width="400" src="https://github.com/user-attachments/assets/748f5471-a300-4d81-a41d-2e9ad9ea15e4" /> |

* **Warning dialog about the profile-sync change** by @SoftFever in [14377](https://github.com/OrcaSlicer/OrcaSlicer/pull/14377)
    Adds a one-time warning dialog explaining the profile-sync behavior change introduced in 2.4.0, so users understand how their profiles are synced before it affects them.

    <img width="600" alt="Profile sync change warning dialog" src="https://github.com/user-attachments/assets/cffc477f-d947-4745-ac1f-d45259d142af" />

* **Specify the plate index for 3MF uploads** by @SoftFever in [14404](https://github.com/OrcaSlicer/OrcaSlicer/pull/14404)
    When sending a job as a packaged `.gcode.3mf`, the upload now names which plate to print. Because the G-code inside a `.gcode.3mf` is index-coded and a bundle can carry several plates, the OctoPrint and Moonraker hosts now forward a `plateindex` field so the correct plate prints; servers that don't use it simply ignore the field, leaving the plain G-code path unchanged.

# 🛠️ Bug Fixes

## Profiles & presets

* **Fix filament inheritance issues in Custom Printer Creation** by @yw4z and @SoftFever in [12060](https://github.com/OrcaSlicer/OrcaSlicer/pull/12060)
    Creating a printer for several vendors (Chuanying, Lulzbot, MagicMaker, Snapmaker, Sovol, TwoTrees, Z-Bolt, and some Bambu Lab presets) could fail because filaments that inherit from the Orca Filament Library weren't found while loading those vendors' profiles. The library is now searched correctly, so these profiles load and the printers can be created; filaments can also be imported from the Orca Filament Library to cut down on duplicates. Fixes #11704.

    | Before | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/fb33e80f-c95d-49db-a162-b880b92a0d85" /> | <img width="400" src="https://github.com/user-attachments/assets/c71980da-276f-4565-ba33-8a6d80c54cae" /> |

* **Restore filaments missing from the Filament Selection dialog** by @ExPikaPaka in [14398](https://github.com/OrcaSlicer/OrcaSlicer/pull/14398)
    System filament presets could silently disappear from the setup guide's filament picker: a cache bug corrupted filament-type resolution, so some filaments were filed under the wrong material category (for example, Generic PLA resolved as ABS) and vanished from the expected type filter. Type resolution is now correct, so the affected filaments appear under the right category again. Related to #7292, #14365, and #14248.

    | Before (missing) | After |
    |--------|-------|
    | <img width="400" src="https://github.com/user-attachments/assets/db8d2124-9490-4ded-ae58-5ff809deab56" /> | <img width="400" src="https://github.com/user-attachments/assets/10bf048a-0af3-4f80-a852-502361d6c118" /> |

* **De-duplicate profile setting IDs** by @SoftFever in [14432](https://github.com/OrcaSlicer/OrcaSlicer/pull/14432)
    Every profile needs a setting ID that is unique across all profiles — it's what a user preset's parent reference points at — but many vendors had copied Bambu's generic IDs (one ID was shared by over 1,500 files). Each profile's ID is now derived deterministically from its vendor, type, and name, so IDs are unique and stable across runs, with a CI check guarding against collisions. The stricter check also surfaced and cleaned up several long-standing duplicate profiles (Prusa, WEMAKE3D, the Orca Filament Library, and Bambu Lab/AliZ). Bambu's existing IDs are kept as-is for compatibility with Bambu-synced presets.

* **Fix ambiguous AMS filament matches on Bambu Lab profiles** by @SoftFever in [14459](https://github.com/OrcaSlicer/OrcaSlicer/pull/14459)
    A filament is matched from the AMS by its material ID together with printer compatibility, so two presets that share a material ID and are both compatible with the same printer make the match ambiguous — the slicer could silently pick the wrong one. This fixes the 11 Bambu Lab profiles where that happened (over-claimed nozzle compatibility, a copy-pasted printer name, and a wrong inheritance) and adds a profile-validator check to catch any regressions.

* **More robust preset resolution on load** by @peachismomo in [14429](https://github.com/OrcaSlicer/OrcaSlicer/pull/14429) and [14430](https://github.com/OrcaSlicer/OrcaSlicer/pull/14430)
    Improves how presets are resolved when loading: presets whose vendor/system name has since changed are now resolved through their `renamed_from` mapping, and a preset's stored parent reference is corrected when it's empty or no longer matches the current profile. Together these reduce cases where a renamed or updated system preset fails to link to its parent.

* **Fix syncing a shared preset bundle that contains a parentless preset** by @ExPikaPaka in [14287](https://github.com/OrcaSlicer/OrcaSlicer/pull/14287)
    Downloading or updating a shared (subscribed) preset bundle could fail when the bundle included a preset with no parent, because the parent-availability check assumed every preset inherited from another preset. Presets without a parent are now handled correctly, so shared bundles download and update without error.

* **Remove duplicate Flashforge filaments from the system list** by @indyjonesnl in [14316](https://github.com/OrcaSlicer/OrcaSlicer/pull/14316)
    Several Flashforge filaments (such as "Flashforge PLA Silk" and "ASA Basic" — 15 in total) appeared twice in the system filament list due to overlapping `compatible_printers` entries in the profiles. The affected presets are repointed to the correct printers and the redundant entries removed, so each filament now shows once with no loss of coverage. The Flashforge profile version was also bumped so the corrected profiles re-sync to existing installs. Closes #10998.

## Slicing & printing

* **Fix fuzzy skin artifacting regression** by @SoftFever in [14382](https://github.com/OrcaSlicer/OrcaSlicer/pull/14382)
    Fixes a regression (introduced by #14031) where fuzzy skin could cause wall collapse/artifacting on some profiles. A regression test built from the reporter's profile (0.20 mm Standard @BBL X1C, 0.4 mm nozzle, 2 walls) was added to guard against it. Fixes #14376.

* **Fix crash with per-object skirt on an empty plate** by @SoftFever in [14403](https://github.com/OrcaSlicer/OrcaSlicer/pull/14403)
    Fixes a crash that occurred when *By Object* skirt was enabled and a model was then added to a focused plate (e.g. add a second plate, switch back to the first, set skirt loops and switch skirt type to *By Object*, then add a model).

* **Fix AMS overwrite sync showing filaments in the wrong order** by @SoftFever in [14408](https://github.com/OrcaSlicer/OrcaSlicer/pull/14408)
    When syncing the filament list from the AMS with the *Overwriting* option, the preview listed the AMS filaments in reversed order even though the mapping actually applied was correct. The preview now iterates filaments in a stable, material-index order, so it matches what gets applied. Fixes #14335.

* **Wait for nozzle temperature before the purge line** by @indyjonesnl in [14120](https://github.com/OrcaSlicer/OrcaSlicer/pull/14120)
    Several Artillery (Sidewinder X3/X4 Plus/Pro) and Flashforge (AD5X, Adventurer 5M / 5M Pro) profiles set the first-layer nozzle temperature without waiting, so the purge line could run before the nozzle was hot enough. These profiles now wait for the target temperature (`M109`) before purging, producing a clean prime line.

## Connectivity & hosts

* **CrealityPrint: avoid a false "End of file" error on K1-family printers** by @sandman21vs in [14344](https://github.com/OrcaSlicer/OrcaSlicer/pull/14344)
    Sending a print to a Creality K1-family printer over the `crealityprint` host popped up `End of file [asio.misc:2]` even though the print actually started, because the firmware closes the control WebSocket as soon as it accepts the command. The post-send read and close are now best-effort, so a benign disconnect after a successful send no longer reports as a failure.

* **CrealityPrint: don't hardcode port :4408 for the Device tab** by @totrytakeoff in [14326](https://github.com/OrcaSlicer/OrcaSlicer/pull/14326)
    The Device tab WebView no longer forces port `:4408` for CrealityPrint printers, which broke setups that route the web UI through a reverse proxy or a different port. It now uses the generic fallback (your configured `print_host_webui`, otherwise the plain `print_host` with no port appended). Related to #7747 and #10740.

* **Keep pinned networking plugins across app updates** by @SoftFever in [19db9aa](https://github.com/OrcaSlicer/OrcaSlicer/commit/19db9aa9c3f6720bceaff2d4c9c377362c440f4f)
    OrcaSlicer lets you pin a specific networking plugin version, but updating the app would remove the existing plugin. Pinned plugins are now preserved across app version updates.

## Platform & UI

* **Fix the Flow Rate Calibration wiki link** by @MarkusKgit in [14378](https://github.com/OrcaSlicer/OrcaSlicer/pull/14378)
    The "Wiki Guide" link in the Flow Rate Calibration dialog pointed to a URL that redirected to the wiki home page; it now opens the correct Flow Ratio calibration guide.

* **Linux: fix blank/garbled web views on Wayland** by @SoftFever in [f9693c4](https://github.com/OrcaSlicer/OrcaSlicer/commit/f9693c4c967b93f2c483ae0dd32e0545221913ff)
    WebKit2GTK accelerated compositing is unreliable on Wayland, producing blank or garbled web views (such as the Home and Device tabs) with both NVIDIA and AMD drivers. Compositing is now disabled whenever a Wayland session is detected (covering native Wayland and XWayland), and the Flatpak build uses `fallback-x11`; pure X11 sessions keep hardware acceleration.

* **Linux: allow AppImage execution for non-owner users** by @pallaswept in [14339](https://github.com/OrcaSlicer/OrcaSlicer/pull/14339)
    The 2.4.0 AppImage set execute permissions only for the owner and group, which prevented it from running as another user — for example inside a firejail sandbox or when the AppImage is extracted (as the AUR package does). Execute permission is now granted for others as well.

# 🖨️ Printer & Filament Profiles

* **Snapmaker U1** — adds 0.2 mm and 0.8 mm nozzle profiles and completes the 0.6 mm process lineup, and fixes the bed dimensions (270 × 270 mm) so all nozzle variants show the correct build area by @ni4223 in [14305](https://github.com/OrcaSlicer/OrcaSlicer/pull/14305) and [14391](https://github.com/OrcaSlicer/OrcaSlicer/pull/14391)

    <img width="500" alt="Snapmaker U1 correct bed dimensions" src="https://github.com/user-attachments/assets/0917bd1e-894b-4f3b-bc12-52978695b312" />

* **Elegoo Centauri 2** — adds machine, filament, and process profiles, synced from ElegooSlicer by @wujie-elegoo in [14402](https://github.com/OrcaSlicer/OrcaSlicer/pull/14402)

    <img width="500" alt="Elegoo Centauri 2" src="https://github.com/user-attachments/assets/08bc1de2-5ff3-42be-89de-0aa186fb008d" />

* **QIDI X-Max 4** — now uses the `qidi` printer agent by default, so it connects without having to set it manually by @thelegendtubaguy in [14334](https://github.com/OrcaSlicer/OrcaSlicer/pull/14334)

# 🗪 Localization

* **Translation catalog refresh** across the bundled languages — Catalan, Czech, German, Spanish, French, Hungarian, Italian, Japanese, Korean, Lithuanian, Dutch, Polish, Brazilian Portuguese, Russian, Swedish, Thai, Turkish, Ukrainian, Vietnamese, and Chinese (Simplified & Traditional) by @SoftFever in [e3eca45](https://github.com/OrcaSlicer/OrcaSlicer/commit/e3eca45f3dc440f1b37162716bc439ec76270fb5)

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
