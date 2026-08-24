# Build Overview

OrcaSlicer builds from source on Windows, macOS, and Linux. Each platform has its own tools and build script:

- [Build on Windows](how_to_build_windows)
- [Build on macOS](how_to_build_macos)
- [Build on Linux](how_to_build_linux)

## Build Stages

Every platform builds in the same two stages, and each build script can run either on its own:

1. **Dependencies.** Third-party libraries such as Boost, wxWidgets, TBB and OpenCV are compiled once under `deps/` and installed into a prefix there.
2. **OrcaSlicer.** The application is compiled and linked against that prefix.

The dependency stage is skipped on later builds unless you delete its build directory, so the first build takes far longer than later ones. It is also why a dependency change has to be rebuilt on its own; each platform page explains how.

## Running the Tests

See [How to Test](how_to_test).

## Portable User Configuration

Place a folder named `data_dir` next to the OrcaSlicer executable and OrcaSlicer uses it as its configuration directory. That gives you a portable installation on a USB stick, or several profile sets kept isolated.

Nothing needs recompiling, and each copy set up this way keeps its own user data.

### Example Folder Structure

```text
OrcaSlicer.exe
data_dir/
```
