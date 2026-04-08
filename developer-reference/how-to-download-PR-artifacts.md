# How to Download Pull Requests Artifacts for Testing

When a Pull Request (PR) is created or updated in the [OrcaSlicer repository](https://github.com/OrcaSlicer/OrcaSlicer/pulls), GitHub Actions automatically builds the project and generates artifacts that can be downloaded for testing purposes.

> [!IMPORTANT]
> It's recommended to [Backup your Presets](import_export#export-preset-bundle) before testing PR artifacts.

1. Log in to your GitHub account.
2. Open the Pull Request you want to test.
3. Navigate to the "Checks" tab located at the top of the PR page.  
   ![pr-artifacts-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/pr-artifacts/pr-artifacts-1.png?raw=true)
4. In the "Checks" tab, look for the "Build all" section.  
   ![pr-artifacts-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/pr-artifacts/pr-artifacts-2.png?raw=true)
5. **Scroll down** to find the "Artifacts" section.  
   ![pr-artifacts-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/pr-artifacts/pr-artifacts-3.png?raw=true)
6. Click on the artifact name or its download button to download the ZIP file containing the build artifacts.
    - Windows:
        - `OrcaSlicer_Windows_[PR_NUMBER]_portable` : Portable Version, **RECOMMENDED** for testing.
        - `OrcaSlicer_Windows_[PR_NUMBER]` : Installer Will overwrite existing installations.
    - macOS:
        - `OrcaSlicer_Mac_universal_[PR_NUMBER]` : Universal macOS DMG file.
    - Linux:
        - `OrcaSlicer-Linux-flatpak_[PR_NUMBER]_x86_64.flatpak` : Flatpak for x86_64.
        - `OrcaSlicer-Linux-flatpak_[PR_NUMBER]_aarch64.flatpak` : Flatpak for ARM64.
        - `OrcaSlicer_Linux_ubuntu_2404_[PR_NUMBER]` : Ubuntu 24.04 DEB package.
7. Once downloaded, extract the ZIP file to access the build artifacts.

> [!TIP]
> Share this guide to others!
>
> Short Link:
>
> ```css
> https://www.orcaslicer.com/wiki/How-to-download-PR-artifacts
> ```
>
> Markdown Link:
>
> ```md
> [How to Download Pull Requests Artifacts for Testing](https://www.orcaslicer.com/wiki/How-to-download-PR-artifacts)
> ```
