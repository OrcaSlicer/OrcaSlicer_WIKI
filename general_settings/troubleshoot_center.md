# Troubleshoot Center

The **Troubleshoot Center** gathers everything needed to diagnose a problem — and everything a maintainer will ask you for when you open a bug report — into a single dialog: system information, application logs, the configuration folder and an overview of the loaded profiles.

No user-specific information is collected or shared. Everything the dialog produces is written to a location you choose, and nothing leaves your computer unless you attach it to a report yourself.

- [Opening the Troubleshoot Center](#opening-the-troubleshoot-center)
- [System information](#system-information)
- [Information](#information)
- [Profiles](#profiles)
- [More](#more)
- [Reporting an issue](#reporting-an-issue)

## Opening the Troubleshoot Center

There are two ways to open it:

- **Help menu** → **Troubleshoot Center**.
- **Mode selector**, when [Developer mode](option_mode) is active. In Developer mode the selector is locked (there is nothing to switch between), so clicking it opens the Troubleshoot Center instead. Its tooltip reads *Developer mode — Launch troubleshoot center...*.

> [!NOTE]
> Only the mode selector on the sidebar opens the dialog.  
> The mode selector shown in the Printer and Filament settings dialogs does not.

## System information

The panel at the left of the dialog lists the data most often needed to reproduce a problem:

- Operating system and version
- **Package type** — how OrcaSlicer was installed: *Local Build*, *Installed* or *Portable* on Windows, *AppImage* or *Flatpak* on Linux, *Homebrew* on macOS
- CPU
- Installed RAM
- GPU
- Monitors, with their native resolution and scaling

Above the panel, the application version is shown together with the build hash, which links to the exact commit the build was made from.

Two buttons control the panel:

- **Copy** — copies the whole block to the clipboard, already formatted for pasting into a GitHub report.
- **Hide** / **Show** — collapses the panel down to the operating system name only. Use this before taking a screenshot of the dialog if you would rather not show your full specifications.

## Information

- **Pack...** — collects the current project file and the logs of the current session into a single ZIP named `OrcaSlicer_PackedDebugInfo_<YYYYMMDD_HHMM>.zip`. This is the file to attach to a bug report.
    - If the project has unsaved changes you are asked to save it first. Choosing **No** closes the dialog so you can review the project.
    - If no project has been saved in the current session, only the logs are packed.
- **Report issue** — opens the GitHub bug report form with the operating system, OrcaSlicer version and OS version fields already filled in.

> [!TIP]
> Additional visual examples — images or a short screen recording — make a report much easier to act on. Attach them along with the packed ZIP.

## Profiles

- **Clean system profiles cache** → **Clean** — deletes the cached `system` folder inside the configuration folder so the system profiles are rebuilt from scratch on the next launch. Useful when profiles look corrupted or out of date after an update.

    > [!WARNING]
    > This requires a restart. OrcaSlicer closes and relaunches itself once the folder has been removed, so make sure no other OrcaSlicer instance is running and that your project is saved. If any file in the folder is locked by another application the operation is aborted and nothing is deleted.

- **Loaded profiles overview** → **Export...** — writes a detailed overview of the loaded profiles, including compatibility metadata, to a `ProfilesOverview.json` file of your choosing.
- The table below shows, for **Printers**, **Filaments** and **Processes**, the count of profiles currently in use, followed by the number of system profiles and user profiles (`in use / system + user`).

See [User Profiles](user_profiles) for what these profiles are and where they are stored.

## More

- **Configurations folder** → **Browse...** — opens the OrcaSlicer data directory in your file manager. This is where profiles, the application configuration and the logs live:
    - Windows: `%APPDATA%\OrcaSlicer`
    - macOS: `~/Library/Application Support/OrcaSlicer`
    - Linux: `~/.config/OrcaSlicer`
- **Log level** — sets the verbosity of the log file: `fatal`, `error`, `warning`, `info`, `debug` or `trace`. The change applies immediately and is remembered across restarts.

    > [!TIP]
    > When asked to reproduce a bug with more detail, set the level to `debug` or `trace`, restart OrcaSlicer, reproduce the problem, then pack the logs. Lower the level again afterwards — verbose logging produces large files.

- **Stored logs** → **Pack...** — exports every stored log file as `OrcaSlicer_Logs_<YYYYMMDD_HHMM>.zip`.
- **Stored logs** → **Clear** — deletes the stored log files, keeping only the current session's log. The label next to the button shows how many log files are stored and how much space they use.

## Reporting an issue

A good report usually contains:

1. The output of **Copy** from the [System information](#system-information) panel.
2. The ZIP produced by **Pack...** in the [Information](#information) section — the project plus the session logs.
3. Steps to reproduce the problem, and a screenshot or screen recording if the issue is visual.

Then use **Report issue** to open a pre-filled bug report and attach the files.
