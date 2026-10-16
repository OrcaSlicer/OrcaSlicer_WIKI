# Compiler Caching

A compiler cache keeps the object file each compile produced, stored against a hash of the source, the headers it pulled in and the command line. When those inputs come round again the object is copied back instead of compiled. Rebuilding after a branch switch, a reconfigure, or into a new build directory then costs a fraction of the usual time.

OrcaSlicer supports [ccache](https://ccache.dev/) and [sccache](https://github.com/mozilla/sccache) on Windows, Linux and macOS.

- [What It Costs](#what-it-costs)
- [Windows](#windows)
- [Linux](#linux)
- [macOS](#macos)
- [Cache Size](#cache-size)
- [Sharing One Cache Between Build Directories](#sharing-one-cache-between-build-directories)
- [Checking It Works](#checking-it-works)

## What It Costs

Caching is not free, and whether it pays depends on how you work.

A cache only helps when it is asked for something it already holds, so the first build of anything fills it and gains nothing. On Windows neither tool caches a compile that uses a precompiled header, so enabling a cache there means building without one. That makes every compile parse the full header set itself, which roughly doubles a build from scratch. On Linux and macOS the build scripts set ccache up to cache those compiles, so the precompiled header stays on.

What you get back is the rebuild. A configuration already in the cache links rather than compiles, so the same work drops from tens of minutes to around a minute, most of which is linking.

That trade suits some habits more than others:

- **Worth it** if you switch branches often, keep more than one build directory, reconfigure regularly, or rebuild the same commit in a different configuration.
- **Not worth much** if you build one directory, edit a handful of files and rebuild incrementally. Ninja already skips everything you did not touch, and the precompiled header makes the files you did touch compile faster.

## Windows

ccache already ships inside [Strawberry Perl](https://strawberryperl.com/), which the build needs anyway, so `where ccache` usually finds one. If not:

```pwsh
winget install --id=Ccache.Ccache -e
```

Then pass `--cache` to [the build script](how_to_build_windows#the-build-script):

```pwsh
build_win.bat -s -l -x --cache ccache
```

The value is `ccache`, `sccache` or `off`. It needs `-l -x`, because CMake only runs a compiler launcher under the Ninja and Makefile generators, and ccache refuses a `cl.exe` compile that carries `/Zi`.

`--cache` also turns the precompiled header off, since neither tool caches a compile that uses one.

The build script names the tool it resolved before it starts:

```text
Precompiled header: off
Compiler cache: C:/Strawberry/c/bin/ccache.exe
```

### Visual Studio and VS Code

Neither reads the build script, so the same settings need added to [the preset file](how_to_build_windows#the-preset-file). Four entries in `cacheVariables`:

```json
"CMAKE_C_COMPILER_LAUNCHER": "ccache",
"CMAKE_CXX_COMPILER_LAUNCHER": "ccache",
"SLIC3R_PCH": { "type": "BOOL", "value": "OFF" },
"SLIC3R_RELATIVE_DEBUG_PATHS": { "type": "BOOL", "value": "ON" }
```

ccache has to be on `PATH` for the IDE process. Because those presets already build into the same directories `build_win.bat` uses, the IDE and the script then reuse each other's work instead of reconfiguring over it.

## Linux

Install ccache from the package manager, for example `apt install ccache` or `pacman -S ccache`.

[`build_linux.sh`](how_to_build_linux) enables caching by itself once a tool is on `PATH`, preferring sccache over ccache. Name the one you want with `CMAKE_CCACHE`:

```bash
CMAKE_CCACHE=ccache ./build_linux.sh -s
```

For ccache the script also sets the options that let it cache compiles using the precompiled header, so the header stays on. A change to a header the precompiled header covers then misses every compile that uses it. `-p` turns the precompiled header off, so such a change misses only the files that include that header, at the cost of slower misses.

## macOS

Install ccache with `brew install ccache`.

[`build_release_macos.sh`](how_to_build_macos) enables caching by itself once a tool is on `PATH`, preferring sccache over ccache. A launcher already set in `CMAKE_CXX_COMPILER_LAUNCHER` or `CMAKE_C_COMPILER_LAUNCHER` takes precedence over that, and `CMAKE_CCACHE` over both. Name the tool you want with `CMAKE_CCACHE`, or set it to `none` to build without one:

```bash
CMAKE_CCACHE=ccache ./build_release_macos.sh -s
```

Each run applies its own choice to the build directory. A run without `CMAKE_CCACHE` picks again, replacing a tool an earlier run named, and a run that finds no tool turns caching off.

Builds that skip the script's configure step keep the tool the last configure recorded. These are `-b`, `cmake --build` and builds from the Xcode app. After uninstalling the tool, run the script once without `-b`. Until you do, those builds fail because the tool is missing.

Caching works with both the default Xcode generator, through Xcode's Compiler Launcher setting, and Ninja (`-x`). As on Linux, the script sets ccache up to cache compiles that use the precompiled header, so the header stays on.

### Building from the Xcode app

A project the script generated still compiles through ccache when you build it from the Xcode app, but without the script's environment, so ccache has only its configuration file to go on. `ccache -sv` names that file as `Config file`. Add:

```text
sloppiness = pch_defines,time_macros,include_file_mtime,include_file_ctime,clang_index_store
depend_mode = true
```

Xcode indexes while it builds Debug and RelWithDebInfo, the configurations compiled without optimisation, and passes `-index-store-path` on each of those compiles. Without `clang_index_store` ccache refuses all of them. With it, a cache hit does not update Xcode's index for that file.

## Cache Size

Once the cache is full, both tools evict whatever was used least recently, so too small a limit discards builds you still want. ccache defaults to 5 GB and one full build of OrcaSlicer occupies 1 to 2 GB of it, so raise the limit by roughly how many builds you want kept:

```pwsh
ccache -M 20G
```

A build here means one configuration of one checkout. Debug and Release count separately, as does the same commit in a second worktree.

- **5 GB**, the default, keeps two or three. Enough while you stay in one configuration.
- **20 GB** covers several configurations and branches, which suits most work.
- **50 GB** or more if you keep multiple worktrees, or move between Debug and Release regularly.

## Sharing One Cache Between Build Directories

This part is ccache only; sccache has no equivalent setting.

By default an object records the directory it was compiled in, so a second build directory shares nothing with the first even at the same commit. Two ccache settings and one build option change that.

`ccache --show-config` prints which file it reads. Add:

```text
base_dir = /path/that/contains/your/checkouts
hash_dir = false
```

`base_dir` has to be an ancestor of the sources, the build directories **and** the dependency prefix. If it covers only some of them, ccache rewrites part of each compile line and the rest still differs.

The build option is `SLIC3R_RELATIVE_DEBUG_PATHS`, which records `.` as the compilation directory rather than an absolute path. `--cache` sets it, and the preset entries above set it explicitly. Debugging is unaffected, because the linker writes the absolute source paths into the PDB.

> [!NOTE]
> Turning this on changes every compile line, so the first build afterwards rebuilds everything and fills the cache again.

## Checking It Works

```pwsh
ccache -s
```

`Cacheable calls` is how many compiles ccache saw and `Hits` how many it served without compiling. A first build is mostly misses. Build the same commit into a fresh directory and those files should come back as hits, nearly all of them direct.

`Uncacheable calls` in the hundreds means something is stopping ccache from storing most of what it sees. `ccache -sv` names the reason for each one. A precompiled header still being used is the common cause, and `/Zi` on a `cl.exe` compile is the other.
