# How to Test

This wiki page describes how to build and run tests on Windows, macOS and Linux, and how to add one. The tests use [Catch2](https://github.com/catchorg/Catch2) v3. Its [documentation](https://github.com/catchorg/Catch2/blob/devel/docs/Readme.md) covers the assertions and macros, and `tests/CATCH2.md` in the main repo has notes on how OrcaSlicer uses them.

Tests aren't built by default. On any platform you have to ask for them, which sets the `BUILD_TESTS` CMake option.

- [Windows](#windows)
    - [Building Tests on Windows](#building-tests-on-windows)
    - [Faster Rebuilds on Windows](#faster-rebuilds-on-windows)
    - [Running Tests on Windows](#running-tests-on-windows)
- [macOS](#macos)
    - [Building Tests on macOS](#building-tests-on-macos)
    - [Faster Rebuilds on macOS](#faster-rebuilds-on-macos)
    - [Running Tests on macOS](#running-tests-on-macos)
- [Linux](#linux)
    - [Building Tests on Linux](#building-tests-on-linux)
    - [Faster Rebuilds on Linux](#faster-rebuilds-on-linux)
    - [Running Tests on Linux](#running-tests-on-linux)
- [The Test Suites](#the-test-suites)
- [Where a Test Goes](#where-a-test-goes)
- [Test Helpers](#test-helpers)
- [Writing a Test](#writing-a-test)
    - [Naming and Tags](#naming-and-tags)
    - [Test Style](#test-style)
    - [Test Design](#test-design)
- [Adding a New Suite](#adding-a-new-suite)

## Windows

### Building Tests on Windows

Pass `--tests` to the build script:

```pwsh
build_win.bat -s --tests
```

That hands `-DBUILD_TESTS=ON` to CMake. `-l -x` builds them with clang-cl and Ninja Multi-Config instead of MSVC and Visual Studio.

The build directory is named for the configuration, compiler and architecture, so `build` for Release under MSVC and `build-clang` under clang-cl. See [Build on Windows](how_to_build_windows#the-build-script) for the full naming.

### Faster Rebuilds on Windows

After the first build you can rebuild one suite instead of everything:

```pwsh
build_win.bat -s --tests --slicer-target libslic3r_tests
```

Add `--no-configure` to skip the configure step when only sources changed. Opening the generated solution in Visual Studio and building the test project works too.

### Running Tests on Windows

`--run-tests` builds the suites and runs them:

```pwsh
build_win.bat -s --run-tests
```

The run ends by printing the `ctest` line for that build directory, so you can re-run without rebuilding. Visual Studio and Ninja Multi-Config are multi-configuration generators, so `ctest` needs `-C` to know which configuration you mean. Without it you get no tests found.

```pwsh
ctest --test-dir build/tests -C Release --output-on-failure
```

For a specific set, point at its directory:

```pwsh
ctest --test-dir build/tests/libslic3r -C Release
```

The executables land in `tests/<suite>/<config>/` inside the build directory. Running one directly is the easiest way to use Catch2's own filtering:

```pwsh
build\tests\libslic3r\Release\libslic3r_tests.exe "[Geometry]"
```

## macOS

### Building Tests on macOS

Pass `-T` to the build script, with the architecture you're building for:

```bash
./build_release_macos.sh -s -a arm64 -T
```

`-T` builds the tests and then runs them. Set `ORCA_TESTS_BUILD_ONLY=1` to build them without running. `-s` skips the dependency build, and `-c` chooses the configuration if you want something other than Release.

The build directory is `build/<arch>`, so `build/arm64` or `build/x86_64`, with the tests underneath in `build/<arch>/tests`.

### Faster Rebuilds on macOS

Rebuild one suite against the existing build directory:

```bash
cmake --build build/arm64 --config Release --target libslic3r_tests
```

Passing `-b` to the build script rebuilds without reconfiguring CMake.

### Running Tests on macOS

The default generator is Xcode, which is multi-configuration, so `ctest` needs `-C` to know which configuration you mean. Add `-x` at build time if you would rather use Ninja Multi-Config.

```bash
ctest --test-dir build/arm64/tests -C Release --output-on-failure
```

For a specific set, point at its directory:

```bash
ctest --test-dir build/arm64/tests/libslic3r -C Release
```

The executables land in `tests/<suite>/<config>/`. Running one directly is the easiest way to use Catch2's own filtering:

```bash
build/arm64/tests/libslic3r/Release/libslic3r_tests "[Geometry]"
```

## Linux

### Building Tests on Linux

Pass `-t` to the build script:

```bash
build_linux.sh -t
```

(or `-ter` or `-stb` etc).

When running `build_linux.sh` with `-t`, make sure you always include the `-e` or `-b` flag if you built the binary with them, otherwise you'll rebuild all of OrcaSlicer again before the tests are ready.

Test binaries will then appear under `build/tests` or `build-dbginfo/tests` or `build-dbg/tests`.

### Faster Rebuilds on Linux

`build_linux.sh` builds the tests with one cmake command, and you can run the same one yourself against an existing build directory:

```bash
cmake --build build --config Release --target tests/all
```

The directory and the configuration go together. `build` with `Release`, `build-dbginfo` with `RelWithDebInfo`, and `build-dbg` with `Debug`.

Point `--target` at a single suite when that's all you need:

```bash
cmake --build build --config Release --target libslic3r_tests
```

Ninja re-runs CMake itself when a `CMakeLists.txt` changes, so adding a new source file doesn't need a separate configure step.

### Running Tests on Linux

```bash
cd build
ctest --test-dir tests --output-on-failure
```

For a specific set, point at its directory:

```bash
ctest --test-dir tests/libslic3r
```

The executables land in `tests/<suite>/<config>/`. Running one directly is the easiest way to use Catch2's own filtering:

```bash
build/tests/libslic3r/Release/libslic3r_tests "[Geometry]"
```

## The Test Suites

Each suite builds its own executable and covers a different part of the codebase.

| Suite | Executable | Covers |
|---|---|---|
| `libslic3r` | `libslic3r_tests` | The core library: geometry, meshes, file formats, config and presets, Clipper, algorithms and data structures |
| `fff_print` | `fff_print_tests` | The FFF slicing pipeline, from a `Model` plus config through `Print` and `PrintObject` to emitted G-code |
| `sla_print` | `sla_print_tests` | SLA printing: support-tree and pad geometry, support-point generation, raycast |
| `libnest2d` | `libnest2d_tests` | 2D nesting and packing, using no-fit polygons |
| `slic3rutils` | `slic3rutils_tests` | The Python plugin system, its slicing-pipeline bindings, and device and network utilities |
| `filament_group` | `filament_group_tests` | Filament-to-extruder grouping, checked against golden results |

A few oddities. `sla_print` names its files `sla_<subsystem>_tests.cpp` instead of `test_<subsystem>.cpp` and brings its own entry point. In `libslic3r`, `test_hollowing` only compiles when OpenVDB is available, and `test_png_io` is commented out of `CMakeLists.txt`. And `tests/compare_analyzer/` isn't a suite at all, it's Python tooling for comparing `.3mf` output between builds or slicers.

`filament_group` compares against golden files in its `golden/` directory. If you change grouping on purpose, re-generate them and review the diff along with the rest of your change. Otherwise a golden failure means something regressed.

## Where a Test Goes

Pick the suite by the production code the test exercises, not by how the test is written.

The `libslic3r` and `fff_print` split is the one people often get wrong. If the behavior depends on print settings, or produces or consumes G-code or slicing state, it belongs in `fff_print`. If it's a property of the class that holds with no `Print` involved, it belongs in `libslic3r`. So a mesh transform, a `Model` construction check or an extrusion-geometry test goes in `libslic3r`, even though a few such tests sit in `fff_print` for historical reasons.

The same rule picks the file inside a suite. There's one file per subsystem, named `test_<subsystem>.cpp`, and it owns every test for that subsystem whether the test reads in-memory state or the generated output. A subsystem is usually one class, but it can be a feature spread over several files. If you touched a subsystem, its file is where your test goes. If there isn't one yet, add `test_<subsystem>.cpp` and list it in that suite's `CMakeLists.txt`.

## Test Helpers

Check for an existing helper before you write your own setup or G-code parsing.

`tests/test_utils.hpp` is shared by every suite. It has `load_model()` for pulling a mesh out of `tests/data/`, and `ScopedTemporaryFile` for a temporary path that cleans itself up. The `TEST_DATA_DIR` define gives you that same directory when you need a fixture `load_model()` doesn't cover.

Most suites add a local harness on top of that:

- `fff_print/test_helpers.hpp` does the most. It builds and slices a `Print` and parses the resulting G-code.
- `sla_print/sla_test_utils.hpp` builds SLA scenes and checks the support and pad geometry that come out.
- `libnest2d/libnest2d_test_utils.hpp` holds the nesting helpers. Its `printer_parts.cpp` has fixture geometry that the `libslic3r` arrangement tests borrow too.
- `slic3rutils/plugin_test_utils.hpp` backs the plugin tests, and `filament_group/fg_test_utils.hpp` builds the grouping cases.

`libslic3r` has no local harness and just uses the shared header.

## Writing a Test

A whole test looks like this:

```cpp
#include <catch2/catch_all.hpp>
#include "libslic3r/TriangleMesh.hpp"
#include "test_utils.hpp"

using namespace Slic3r;

TEST_CASE("A loaded cube has positive volume", "[TriangleMesh]") {
    TriangleMesh cube = load_model("20mm_cube.obj");
    REQUIRE(cube.volume() > 0);
}
```

Save it as `test_<subsystem>.cpp` in the suite it belongs to, list it in that suite's `CMakeLists.txt`, then build and run it as above.

### Naming and Tags

Name the test case as a plain sentence about the behavior, in the present tense, rather than prefixing it with the subsystem:

```cpp
TEST_CASE("Skirt is emitted once per layer it spans", "[SkirtBrim]")   // good
TEST_CASE("Print: Skirt generation", "[Print]")                        // avoid
```

Every test carries a subsystem tag naming what it covers, matching its file. That's the one you can count on being there, and it's what people filter on. Use PascalCase for new ones, though the older tags aren't consistent about it.

Add more tags where they earn their keep:

- A narrower tag carves a large file into slices you can run on their own, like `[Rotcalip]` within the geometry tests or `[Placer]` within nesting.
- A shared tag marks something that cuts across files, like `[Python]`, `[H2C]` or `[Regression]`.
- `[NotWorking]` marks a test disabled for a known reason, and `[.]` hides one from default runs. Say why in a comment for either.

Catch2 tags are registered as CTest labels, so `ctest -L` and `ctest -LE` filter by tag as well.

### Test Style

Prefer a flat `TEST_CASE` per behavior, with `GENERATE` for parameterized cases and shared setup pulled into helpers. The name already carries the behavior, so the BDD scaffolding is usually just noise. Keep `SCENARIO` / `GIVEN` / `WHEN` / `THEN` for a test with real shared setup that branches into a few close variations, and don't let a `SCENARIO` collect unrelated `WHEN`s.

### Test Design

A test should fail when the behavior it names breaks, and not otherwise. Most of that comes down to what you set up and what you assert.

**Set the values you depend on.** If a number in your assertion comes from a config key, set that key. Otherwise the test is also testing the default.

```cpp
// good: 20mm of cube at 2mm layers is 10, and the test says both parts
Slic3r::Test::init_and_process_print({cube(20)}, print, {
    { "layer_height",    2 },
    { "nozzle_diameter", 3 }
});
REQUIRE(print.objects().front()->layers().size() == 10);

// avoid: 10 is only right while the default layer height happens to be 2
Slic3r::Test::init_and_process_print({cube(20)}, print, {
    { "nozzle_diameter", 3 }
});
REQUIRE(print.objects().front()->layers().size() == 10);
```

**Assert the property, not an incidental number.** Byte counts, coordinates and extrusion amounts move whenever anything upstream is refactored, and none of them are what the test is named for.

```cpp
REQUIRE(role_passes(gcode, "perimeter") > 0);   // good
REQUIRE(gcode.size() == 24196);                 // avoid
```

**Match the token you care about.** A whole G-code line carries speeds, coordinates and comment wording that have nothing to do with your test.

```cpp
REQUIRE_THAT(gcode, Catch::Matchers::ContainsSubstring("; skirt"));   // good
REQUIRE(line == "G1 X10.5 Y10.5 F1800 ; skirt");                      // avoid
```

**Compare floats with a tolerance.**

```cpp
REQUIRE_THAT(layers.front()->print_z, Catch::Matchers::WithinAbs(2.0, 1e-4));   // good
REQUIRE(layers.front()->print_z == 2.0);                                        // avoid
```

**A few more.**

- Keep no shared state between tests. They have to pass under `--order rand`, which you can check by passing that flag to the suite binary.
- Depend on ordering only where ordering is the contract, the way `role_sequence` does.
- Name a regression test for the behavior it protects, not the issue or PR number, so it still means something in two years.

## Adding a New Suite

Create `tests/<suite>/` holding a `<suite>_tests.cpp` and a `CMakeLists.txt`. Every suite has the same shape, so the shortest route is copying the nearest one:

```cmake
get_filename_component(_TEST_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)

add_executable(${_TEST_NAME}_tests
  ${_TEST_NAME}_tests.cpp
  test_<subsystem>.cpp
)

target_link_libraries(${_TEST_NAME}_tests test_common libslic3r Catch2::Catch2WithMain)
set_property(TARGET ${_TEST_NAME}_tests PROPERTY FOLDER "tests")

orcaslicer_copy_test_dlls()

orcaslicer_discover_tests(${_TEST_NAME}_tests)
```

`_TEST_NAME` is taken from the directory name, which is where the `<suite>_tests` target gets its name. `orcaslicer_copy_test_dlls()` puts the runtime DLLs beside the executable on Windows and does nothing elsewhere. `orcaslicer_discover_tests()` registers every Catch2 case with CTest and turns the tags into CTest labels, which is what makes `ctest -L` work.

Link what the suite actually needs rather than copying the line above blindly. Most link `libslic3r`, `libnest2d` links `libnest2d`, and `slic3rutils` also pulls in `libslic3r_gui` and `pybind11::embed`.

Then register the directory in `tests/CMakeLists.txt`:

```cmake
add_subdirectory(<suite>)
```

If one source needs an optional dependency, guard that source rather than the whole suite, the way `test_hollowing` is:

```cmake
if (TARGET OpenVDB::openvdb)
    target_sources(${_TEST_NAME}_tests PRIVATE test_hollowing.cpp)
endif()
```
