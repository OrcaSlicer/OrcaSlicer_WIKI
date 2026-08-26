# Build on Windows

Building OrcaSlicer for 64-bit Windows. MSVC is the default toolchain, and clang-cl (LLVM) is supported as an alternative.

- [Tools Required](#tools-required)
- [Hardware Requirements](#hardware-requirements)
- [Get the Source](#get-the-source)
- [Build the Dependencies](#build-the-dependencies)
- [Building with MSVC](#building-with-msvc)
- [Building with clang-cl](#building-with-clang-cl)
    - [Additional Tools](#additional-tools)
    - [The Preset File](#the-preset-file)
    - [Visual Studio](#visual-studio)
    - [VS Code](#vs-code)
    - [Command Line](#command-line)
- [Troubleshooting](#troubleshooting)
    - [Dependencies](#dependencies)
    - [Windows SDK](#windows-sdk)
    - [clang-cl](#clang-cl)

## Tools Required

- [Visual Studio](https://visualstudio.microsoft.com/vs/) 2026, 2022 or 2019, with the *Desktop development with C++* workload

    ```pwsh
    winget install --id=Microsoft.VisualStudio.Community -e --override "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --passive --wait"
    ```

- [CMake](https://cmake.org/)

    ```pwsh
    winget install --id=Kitware.CMake -e
    ```

- [Strawberry Perl](https://strawberryperl.com/)

    ```pwsh
    winget install --id=StrawberryPerl.StrawberryPerl -e
    ```

- [Git](https://git-scm.com/)

    ```pwsh
    winget install --id=Git.Git -e
    ```

> [!IMPORTANT]
> A plain `winget install` of Visual Studio installs the IDE without any C++ compiler, and the build fails later with CMake unable to find a Visual Studio instance. The `--override` flags above add the required *Desktop development with C++* workload.
>
> If Visual Studio is already installed without it, add the workload from **Visual Studio Installer** -> **Modify** -> check *Desktop development with C++* -> **Modify**.

> [!IMPORTANT]
> Strawberry Perl bundles its own CMake. If it comes first on `PATH`, `cmake --version` reports that copy rather than the one you installed. Run `where cmake` to list the active copies, then reorder **System Environment Variables** > **Path** so the real one wins:
>
> ```text
> C:\Program Files\CMake\bin
> C:\Strawberry\c\bin
> ```
>
> OrcaSlicer needs CMake 3.13 or newer, and 3.21 or newer for the clang-cl presets below. CMake 4.x is fine.

![windows_variables_path](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/windows_variables_path.png?raw=true)

![windows_variables_order](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/windows_variables_order.png?raw=true)

> [!TIP]
> [GitHub Desktop](https://desktop.github.com/) is optional and gives you a GUI for repository and branch management:
>
> ```pwsh
> winget install --id=GitHub.GitHubDesktop -e
> ```

## Hardware Requirements

- Minimum 16 GB RAM
- Minimum 23 GB free disk space
- 64-bit CPU
- 64-bit Windows 10 or later

## Get the Source

Clone the repository, either from GitHub Desktop or on the command line:

```pwsh
git clone https://github.com/OrcaSlicer/OrcaSlicer
```

Everything below runs from the **x64 Native Tools Command Prompt for VS**, in the clone:

```pwsh
cd path\to\OrcaSlicer
```

## Build the Dependencies

`build_release_vs.bat` builds the dependencies with MSVC. clang-cl links against those same ones, because it targets the MSVC ABI. Build them once:

```pwsh
build_release_vs.bat deps
```

They install into `deps\build\OrcaSlicer_dep\usr\local`.

Debug builds link the debug C runtime (`/MDd`), which cannot be mixed with the release one, so they need a separate set:

```pwsh
build_release_vs.bat deps debug
```

Those install into `deps\build-dbg\` and are required for a Debug build under either toolchain.

## Building with MSVC

`build_release_vs.bat` generates a Visual Studio solution and builds it with MSVC. This is the toolchain CI uses.

1. Build OrcaSlicer:

    ```pwsh
    build_release_vs.bat slicer
    ```

    ![vs_cmd](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/vs_cmd.png?raw=true)

2. Open the generated solution:

    ```pwsh
    build\OrcaSlicer.slnx
    ```

3. Set the build configuration to `Release` and run the **Local Windows Debugger**.

    ![compile_vs_local_debugger](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/develop/compile_vs_local_debugger.png?raw=true)

4. The executable is written to:

    ```pwsh
    build\src\Release\orca-slicer.exe
    ```

For a Debug build, build the debug dependencies first, then:

```pwsh
build_release_vs.bat slicer debug
```

That writes `build-dbg\OrcaSlicer.slnx` and `build-dbg\src\Debug\orca-slicer.exe`, and finds `deps\build-dbg` on its own because the build directory is named to match.

`build_release_vs.bat slicer tests` builds the test suites as well. See [How to Test](how_to_test) for running them.

> [!NOTE]
> The first build of any branch is slow. After that, changes to `.cpp` files compile quickly and changes to `.hpp` files take longer depending on how widely the header is included. Switching branches back and forth also forces a long rebuild even when nothing else changed.

## Building with clang-cl

OrcaSlicer also builds with the **clang-cl (LLVM)** toolchain and the **Ninja** generator. It compiles the project considerably faster than MSVC on the same machine, which is the main reason to use it. Official builds and CI use MSVC, so a change still has to compile there.

> [!IMPORTANT]
> clang-cl support was added in [OrcaSlicer PR #14375](https://github.com/OrcaSlicer/OrcaSlicer/pull/14375) (merged 2026-08-19). A checkout that predates it will not compile with clang-cl. Rebase onto `main` first.

### Additional Tools

On top of the *Desktop development with C++* workload:

- The **C++ Clang Compiler for Windows** individual component (`Microsoft.VisualStudio.Component.VC.Llvm.Clang`). Add it from **Visual Studio Installer** -> **Modify** -> **Individual components**, searching for *Clang*. It installs `clang-cl.exe` and `lld-link.exe` under `VC\Tools\Llvm\x64\bin`.
- **Ninja**. Visual Studio ships its own copy; VS Code and the command line both need this one.

    ```pwsh
    winget install --id=Ninja-build.Ninja -e
    ```

> [!NOTE]
> The separate **MSBuild support for LLVM (clang-cl) toolset** component (`Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset`) is only needed to drive clang-cl through the Visual Studio generator with `-T ClangCL`. The Ninja setup below does not use it.

### The Preset File

Visual Studio, VS Code and the command line all read the same CMake preset file. Create `CMakeUserPresets.json` in the repository root:

```json
{
  "version": 3,
  "configurePresets": [
    {
      "name": "x64-clang",
      "displayName": "x64 Clang",
      "description": "clang-cl and Ninja Multi-Config, built against deps/build",
      "generator": "Ninja Multi-Config",
      "binaryDir": "${sourceDir}/out/build/${presetName}",
      "architecture": { "value": "x64", "strategy": "external" },
      "toolset": { "value": "host=x64", "strategy": "external" },
      "environment": {
        "CC": "clang-cl",
        "CXX": "clang-cl",
        "NINJA_STATUS": "[%s/%t %p :: %e] "
      },
      "cacheVariables": {
        "CMAKE_CONFIGURATION_TYPES": "Release;RelWithDebInfo;MinSizeRel",
        "CMAKE_PREFIX_PATH": "${sourceDir}/deps/build/OrcaSlicer_dep/usr/local",
        "BUILD_TESTS": { "type": "BOOL", "value": "ON" }
      },
      "vendor": {
        "microsoft.com/VisualStudioSettings/CMake/1.0": {
          "hostOS": [ "Windows" ],
          "intelliSenseMode": "windows-clang-x64"
        }
      }
    },
    {
      "name": "x64-clang-debug",
      "displayName": "x64 Clang Debug",
      "description": "clang-cl and Ninja, built against deps/build-dbg",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/out/build/${presetName}",
      "architecture": { "value": "x64", "strategy": "external" },
      "toolset": { "value": "host=x64", "strategy": "external" },
      "environment": {
        "CC": "clang-cl",
        "CXX": "clang-cl",
        "NINJA_STATUS": "[%s/%t %p :: %e] "
      },
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "CMAKE_PREFIX_PATH": "${sourceDir}/deps/build-dbg/OrcaSlicer_dep/usr/local",
        "BUILD_TESTS": { "type": "BOOL", "value": "ON" }
      },
      "vendor": {
        "microsoft.com/VisualStudioSettings/CMake/1.0": {
          "hostOS": [ "Windows" ],
          "intelliSenseMode": "windows-clang-x64"
        }
      }
    }
  ],
  "buildPresets": [
    { "name": "x64-clang-release",        "configurePreset": "x64-clang", "configuration": "Release" },
    { "name": "x64-clang-relwithdebinfo", "configurePreset": "x64-clang", "configuration": "RelWithDebInfo" },
    { "name": "x64-clang-minsizerel",     "configurePreset": "x64-clang", "configuration": "MinSizeRel" },
    { "name": "x64-clang-debug-build",    "configurePreset": "x64-clang-debug" }
  ],
  "testPresets": [
    {
      "name": "x64-clang-test-release",
      "configurePreset": "x64-clang",
      "configuration": "Release",
      "output": { "outputOnFailure": true }
    },
    {
      "name": "x64-clang-test-relwithdebinfo",
      "configurePreset": "x64-clang",
      "configuration": "RelWithDebInfo",
      "output": { "outputOnFailure": true }
    },
    {
      "name": "x64-clang-test-debug",
      "configurePreset": "x64-clang-debug",
      "output": { "outputOnFailure": true }
    }
  ]
}
```

`x64-clang` uses Ninja Multi-Config, so one build directory holds Release, RelWithDebInfo and MinSizeRel. Switching between them needs no reconfigure. `x64-clang-debug` is separate because it builds against the Debug dependencies.

Only RelWithDebInfo is compiled with `/Zi`, so switch to it when you need to debug. Release and MinSizeRel produce no symbols to step through.

> [!IMPORTANT]
> Do not omit `CMAKE_PREFIX_PATH`. Without it, CMake derives the dependency location from the **name** of the build directory, so `out/build/x64-clang` sends it looking in `deps\x64-clang\` and configuration fails at `find_package(Boost 1.83.0 REQUIRED)` with *Could not find a package configuration file provided by "Boost"*. Only a build directory named exactly `build` resolves on its own, and that name is already taken by the MSVC build.

> [!TIP]
> `BUILD_TESTS` is `ON` so the test suites build alongside the application, and the test presets can run them. Set it to `OFF` for slightly faster builds if you do not need them. See [How to Test](how_to_test).

> [!TIP]
> On Ninja 1.12 or newer, changing `NINJA_STATUS` to `"[%f/%t %p :: %w / %W] "` adds elapsed time and an ETA to each line:
>
> ```text
> [119/760  15% :: 00:07 / 07:23] Building CXX object src\libslic3r\CMakeFiles\libslic3r.dir\RelWithDebInfo\Fill\FillBase.cpp.obj
> ```

### Visual Studio

1. Open the repository as a CMake project: **File > Open > Folder**. Do not open `build\OrcaSlicer.slnx`, which is the MSVC solution.
2. Pick a build preset in the **Configuration** dropdown, `x64-clang-release` for instance. Visual Studio labels that dropdown *Configuration*, but its entries are build presets, and each one names a configure preset and a configuration together, so it is the only thing to set.
3. Set the startup item to the `orca-slicer.exe` entry whose path matches that preset, `src\Release\orca-slicer.exe` for `x64-clang-release`. Visual Studio defaults to a different executable and remembers your choice from then on. Do not pick either `(Install)` entry.
4. Build with **Build > Build All**. The executable is written under `out\build\<configure preset>\`, so `x64-clang-release` gives:

    ```pwsh
    out\build\x64-clang\src\Release\orca-slicer.exe
    ```

5. Run the tests with **Test > Run CTests for OrcaSlicer** once they are built.

> [!NOTE]
> `x64-clang-debug-build` uses a single-configuration generator, so it has no per-configuration subdirectory. Its startup item is `src\orca-slicer.exe` and the executable lands in `out\build\x64-clang-debug\src\orca-slicer.exe`.

> [!NOTE]
> Visual Studio may show a *Build failed* prompt on the first build even though the build succeeded and the application runs. Choosing to continue starts it normally, and later builds do not prompt. Check the **Output** pane instead of the dialog. A real failure names a file, and a failed configure step produces the same dialog.

### VS Code

Requires the **CMake Tools** extension (`ms-vscode.cmake-tools`). It switches to preset mode on its own once `CMakeUserPresets.json` exists, so there is nothing to configure.

Open the **CMake** panel from the Activity Bar and set the entries under **Project Status**:

- **Configure** to `x64 Clang`
- **Build** to the configuration you want, `x64-clang-release` for instance
- **Test** to `x64-clang-test-release`
- **Launch** and **Debug** to `OrcaSlicer_app_gui`, both of which default to `all`. Pick the entry under `src\Release\`, not `OrcaSlicer_app_gui (Install)`

The build preset carries the configuration, so switching between Release, RelWithDebInfo and MinSizeRel means switching build preset. The same entries are on the Command Palette under **CMake: Select Configure Preset** and **CMake: Select Build Preset**.

The **Launch** and **Debug** entries in that panel run the selected target directly. To debug with `F5` instead, add a launch configuration to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "OrcaSlicer",
      "type": "cppvsdbg",
      "request": "launch",
      "program": "${command:cmake.launchTargetPath}",
      "args": [],
      "cwd": "${command:cmake.launchTargetDirectory}",
      "stopAtEntry": false,
      "console": "internalConsole"
    }
  ]
}
```

`cppvsdbg` is the Windows debugger and reads the PDBs clang-cl produces. The `${command:cmake...}` values follow the active launch target and build preset, so nothing is hard-coded. `cwd` starts the application next to the `resources` junction it needs.

> [!IMPORTANT]
> Without that configuration, **Run > Start Debugging** offers to generate one and suggests **C++ (GDB/LLDB)**, which targets MinGW and LLDB. The template it writes debugs a single source file and fails with *Variable ${fileDirname} can not be resolved*.

### Command Line

The **x64 Native Tools Command Prompt for VS** puts `clang-cl`, `lld-link` and the Windows SDK on `PATH`. From the repository root:

```pwsh
cmake --preset x64-clang
cmake --build --preset x64-clang-release
ctest --preset x64-clang-test-release
```

The executable is written to:

```pwsh
out\build\x64-clang\src\Release\orca-slicer.exe
```

## Troubleshooting

### Dependencies

> [!TIP]
> Some changes are not picked up by a rebuild because they live in the prebuilt dependencies, not in the OrcaSlicer sources. Rebuild the affected dependency target instead of everything under `deps/`.
>
> For example, after modifying `wxInspector`, run this from the repository root:
>
> ```pwsh
> cmake --build deps\build --target dep_wxInspector --config Release
> ```
>
> The path is relative, so from anywhere else CMake fails with `... deps\build is not a directory`. Visual Studio's built-in terminal (**View > Terminal**) starts in the solution folder `build\`, so use `..\deps\build` there. Then rebuild so the updated dependency is linked in.

> [!TIP]
> If a dependency build fails with `patch does not apply`, delete `deps\build` (and `deps\build-dbg`) and build them again. `git apply` cannot re-apply a patch to sources that already carry it.

> [!TIP]
> If the build fails outright, delete the `build/` and `deps/build/` directories to clear cached build data and start again.

> [!TIP]
> If the build fails while configuring ZLIB, uninstall ZLIB from your Vcpkg library.

### Windows SDK

> [!TIP]
> If the *Fix model* option is missing from an object's context menu, the build did not pick up the Windows SDK. To fix it:
>
> 1. Locate the `winrt` folder in your Windows SDK installation, for example:
>
>    ```pwsh
>    C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\winrt
>    ```
>
>    The exact path varies with your Windows SDK version.
>
> 2. Open the **libslic3r_gui** project properties and go to **Configuration Properties > C/C++ > Preprocessor > Preprocessor Definitions**. Add `HAS_WIN10SDK`.
>
> 3. Open the **OrcaSlicer_app_gui** project properties and go to **Configuration Properties > C/C++ > General > Additional Include Directories**. Add the path to the `winrt` folder from step 1.
>
> 4. Build the solution.

### clang-cl

[PR #14375](https://github.com/OrcaSlicer/OrcaSlicer/pull/14375) changed how two dependencies are built. Dependencies built before it fail under clang-cl:

- **TBB** was compiled with `/GL`, and `lld-link` rejects LTCG objects. This surfaces late, at the `Linking CXX shared library src\OrcaSlicer.dll` step, as one error per object with no file or line:

    ```text
    lld-link: error: tbb.dir\Release\queuing_rw_mutex.obj: is not a native COFF file. Recompile without /GL?
    ```

- **wxWidgets** installs its libraries under `vc_x64_lib`, but its own CMake config file looks for a `clang_x64_lib` directory when the compiler is clang-cl. This fails at configure time, with an `include could not find requested file` error naming `clang_x64_lib/wxWidgetsTargets.cmake`.

Rebuilding the dependencies fixes both:

```pwsh
build_release_vs.bat deps
```

To rebuild only TBB, delete `deps\build\dep_TBB-prefix` first and run the same command.
