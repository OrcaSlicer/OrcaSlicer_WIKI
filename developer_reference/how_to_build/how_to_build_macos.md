# Build on macOS

How to building with Xcode on MacOS 64-bit.

- [MacOS Tools Required](#macos-tools-required)
- [MacOS Instructions](#macos-instructions)
- [Debugging in Xcode](#debugging-in-xcode)

## MacOS Tools Required

- Xcode
- CMake
- Git
- gettext
- libtool
- automake
- autoconf
- texinfo

> [!TIP]
> You can install most of them by running:
>
```bash
brew install cmake gettext libtool automake autoconf texinfo
```

> [!IMPORTANT]
> If you've recently upgraded Xcode, be sure to open Xcode at least once and install the required macOS build support.

Point the command-line tools at your Xcode installation and accept the license:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept   # if you haven't accepted it yet
```

## MacOS Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/OrcaSlicer/OrcaSlicer
   cd OrcaSlicer
   ```

2. Build the application:

   ```bash
   ./build_release_macos.sh
   ```

   > [!TIP]
   > If you're on the latest macOS and Xcode, set the deployment target explicitly so the build targets a supported SDK, e.g.:
   >
   > ```bash
   > ./build_release_macos.sh -s -t 15.4
   > ```

3. Open the application:

   ```bash
   open build/arm64/OrcaSlicer/OrcaSlicer.app
   ```

## Debugging in Xcode

To build and debug directly in Xcode:

1. Open the Xcode project:

   ```bash
   open build/arm64/OrcaSlicer.xcodeproj
   ```

2. In the menu bar:
    - **Product > Scheme > OrcaSlicer**
    - **Product > Scheme > Edit Scheme...**
        - Under **Run > Info**, set **Build Configuration** to `RelWithDebInfo`
        - Under **Run > Options**, uncheck **Allow debugging when browsing versions**
    - **Product > Run**
