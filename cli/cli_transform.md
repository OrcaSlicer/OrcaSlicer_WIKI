# CLI Transform

Transform options change the loaded model's geometry or placement before slicing. See [CLI Mode](cli_mode) for general flag syntax.

> [!IMPORTANT]
> Transform flags are applied in the order they appear on the command line, not in the order listed on this page. `--rotate 90 --scale 2` rotates then scales; `--scale 2 --rotate 90` scales then rotates. For most of these options the end result is identical either way, but it's worth being deliberate about ordering when combining several.

- [Arrangement](#arrangement)
- [Geometry](#geometry)
- [Object Handling](#object-handling)

## Arrangement

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--arrange` | `option` (int) | Arrange objects on the plate: `0` = disable, `1` = force enable, any other value = auto. See [Auto Arrange](prepare_auto_arrange) for the underlying behavior. | |
| `--ensure-on-bed` | boolean | Lift any object that is partially below the bed so it sits on top of it. | Disabled by default. |
| `--orient` | `option` (int) | Auto-orient objects: `0` = disable, `1` = force enable, any other value = auto. See [Auto Orient](prepare_auto_orient). | |

## Geometry

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--convert-unit` | boolean | Detect models saved in meters or inches and convert them to millimeters. | |
| `--rotate` | degrees (float) | Rotate every loaded object around the Z axis. See [Rotate](prepare_object_manipulation#rotate). | |
| `--rotate-x` | degrees (float) | Rotate every loaded object around the X axis. | |
| `--rotate-y` | degrees (float) | Rotate every loaded object around the Y axis. | |
| `--scale` | `factor` (float) | Scale every loaded object by this factor. See [Scale](prepare_object_manipulation#scale). | Must be greater than `0`. |

## Object Handling

| Flag | Input | Description | Notes |
| --- | --- | --- | --- |
| `--repetitions` | `count` (int) | Duplicate the whole model this many times on the plate. | Requires [`--slice`](cli_actions#slicing) to target a single plate (not `0`/all-plates). Cannot exceed the plate count. |
| `--assemble` | boolean | Merge all loaded models into a single object on one plate, so subsequent actions apply to it as a whole. | Cannot be combined with [`--clone-objects`](cli_misc#object-selection). |
