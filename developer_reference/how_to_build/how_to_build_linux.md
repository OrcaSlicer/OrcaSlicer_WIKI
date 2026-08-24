# Build on Linux

Linux distributions are available in two formats: [using Docker](#using-docker) (recommended) or [building directly](#linux-build) on your system.

- [Using Docker](#using-docker)
    - [Docker Dependencies](#docker-dependencies)
    - [Docker Instructions](#docker-instructions)
- [Troubleshooting](#troubleshooting)
- [Linux Build](#linux-build)
    - [Dependencies](#dependencies)
        - [Common dependencies across distributions](#common-dependencies-across-distributions)
        - [Additional dependencies for specific distributions](#additional-dependencies-for-specific-distributions)
    - [Linux Instructions](#linux-instructions)

## Using Docker

How to build and run OrcaSlicer using Docker.

### Docker Dependencies

- Docker
- Git

### Docker Instructions

```pwsh
git clone https://github.com/OrcaSlicer/OrcaSlicer && cd OrcaSlicer && ./scripts/DockerBuild.sh && ./scripts/DockerRun.sh
```

## Troubleshooting

The `scripts/DockerRun.sh` script includes several commented-out options that can help resolve common issues. Here's a breakdown of what they do:

- `xhost +local:docker`: If you encounter an "Authorization required, but no authorization protocol specified" error, run this command in your terminal before executing `scripts/DockerRun.sh`. This grants Docker containers permission to interact with your X display server.
- `-h $HOSTNAME`: Forces the container's hostname to match your workstation's hostname. This can be useful in certain network configurations.
- `-v /tmp/.X11-unix:/tmp/.X11-unix`: Helps resolve problems with the X display by mounting the X11 Unix socket into the container.
- `--net=host`: Uses the host's network stack, which is beneficial for printer Wi-Fi connectivity and D-Bus communication.
- `--ipc host`: Addresses potential permission issues with X installations that prevent communication with shared memory sockets.
- `-u $USER`: Runs the container as your workstation's username, helping to maintain consistent file permissions.
- `-v $HOME:/home/$USER`: Mounts your home directory into the container, allowing you to easily load and save files.
- `-e DISPLAY=$DISPLAY`: Passes your X display number to the container, enabling the graphical interface.
- `--privileged=true`: Grants the container elevated privileges, which may be necessary for libGL and D-Bus functionalities.
- `-ti`: Attaches a TTY to the container, enabling command-line interaction with OrcaSlicer.
- `--rm`: Automatically removes the container once it exits, keeping your system clean.
- `orcaslicer $*`: Passes any additional parameters from the `scripts/DockerRun.sh` script directly to the OrcaSlicer executable within the container.

By uncommenting and using these options as needed, you can often resolve issues related to display authorization, networking, and file permissions.

## Linux Build

How to build OrcaSlicer on Linux.

### Dependencies

The build system supports multiple Linux distributions including Ubuntu/Debian and Arch Linux. All required dependencies will be installed automatically by the provided shell script where possible, however you may need to manually install some dependencies.

> [!NOTE]
> Fedora and other distributions are not currently supported, but you can try building manually by installing the required dependencies listed below.

#### Common dependencies across distributions

- autoconf / automake
- cmake
- curl / libcurl4-openssl-dev
- dbus-devel / libdbus-1-dev
- eglexternalplatform-dev / eglexternalplatform-devel
- extra-cmake-modules
- file
- gettext
- git
- glew-devel / libglew-dev
- gstreamer-devel / libgstreamerd-3-dev
- gtk3-devel / libgtk-3-dev
- libmspack-dev / libmspack-devel
- libsecret-devel / libsecret-1-dev
- libspnav-dev / libspnav-devel
- libssl-dev / openssl-devel
- libtool
- libudev-dev
- mesa-libGLU-devel
- ninja-build
- texinfo
- webkit2gtk-devel / libwebkit2gtk-4.0-dev or libwebkit2gtk-4.1-dev
- wget

#### Additional dependencies for specific distributions

- **Ubuntu 22.x/23.x**: libfuse-dev, m4
- **Arch Linux**: mesa, wayland-protocols

### Linux Instructions

1. **Install system dependencies:**

   ```pwsh
   ./build_linux.sh -u
   ```

2. **Build dependencies:**

   ```pwsh
   ./build_linux.sh -d
   ```

3. **Build OrcaSlicer with tests:**

   ```pwsh
   ./build_linux.sh -st
   ```

4. **Build AppImage (optional):**

   ```pwsh
   ./build_linux.sh -i
   ```

5. **All-in-one build (recommended):**

   ```pwsh
   ./build_linux.sh -dsti
   ```

**Additional build options:**

- `-b`: Build in debug mode (mostly broken at runtime for a long time; avoid unless you want to be fixing failed assertions)
- `-c`: Force a clean build
- `-C`: Enable ANSI-colored compile output (GNU/Clang only)
- `-e`: Build RelWithDebInfo (release + symbols)
- `-j N`: Limit builds to N cores (useful for low-memory systems)
- `-1`: Limit builds to one core
- `-l`: Use Clang instead of GCC
- `-p`: Disable precompiled headers (boost ccache hit rate)
- `-r`: Skip RAM and disk checks (for low-memory systems)

> [!NOTE]
> The build script automatically detects your Linux distribution and uses the appropriate package manager (apt, pacman) to install dependencies.

> [!TIP]
> For first-time builds, use `./build_linux.sh -u` to install dependencies, then `./build_linux.sh -dsti` to build everything.

> [!TIP]
> Some changes are not picked up by a normal rebuild because they live in the prebuilt dependencies (`deps/`), not in the OrcaSlicer sources. In that case rebuild the affected dependency target instead of the whole `deps/` tree.
>
> For example, after modifying `wxInspector`:
>
> ```bash
> cd ~/OrcaSlicer   # the repository root, where build_linux.sh lives
> cmake --build deps/build --target dep_wxInspector
> ./build_linux.sh -s
> ```
>
> The path is relative, so running it from anywhere else fails with `.../deps/build is not a directory`.
>
> No `--config` flag is needed here: the dependencies are configured with a single-config generator, so the build type is fixed when they are configured. Use `deps/build-dbg` for debug builds (`-b`) and `deps/build-dbginfo` for RelWithDebInfo builds (`-e`).

> [!WARNING]
> If you encounter memory issues during compilation, use `-j 1` or `-1` to limit parallel compilation and `-r` to skip memory checks.
