# ORPM v1 Preview Mesh Specification

ORPM is OrcaSlicer's binary transport for an immutable, indexed final-toolpath Preview mesh.
The `orca.visualization` [Visualization](visualization) capability receives a published ORPM
path instead of Python objects or JSON geometry. This page is the normative v1 wire contract.

ORPM v1 represents the **complete final FFF extrusion scene** for one plate and completed slice
result. It uses OrcaSlicer's authoritative Preview tessellation, including its joins and caps.
Travel moves are excluded. Preview layer-slider range, top-layer mode, role visibility, and other
view filters do not change this scope.

## Scalar and Coordinate Conventions

- All multibyte integers and IEEE 754 binary32 (`f32`) values are **little-endian**.
- All positions, bounds, plate points, `z_offset`, and `printable_height` are in
  **millimeters**. UV values and normalized normals are unitless.
- Coordinates use OrcaSlicer's right-handed printer/plate space: X and Y lie in the build-plate
  plane and +Z points upward from the plate. No renderer-specific axis conversion is stored.
- Each consecutive index triple is one triangle. Vertices are counter-clockwise when viewed
  from the outward side in this right-handed coordinate system; stored normals point outward.
- Offsets are absolute byte offsets from the beginning of the file. Counts are record counts,
  not byte counts.
- Reserved bytes and bits are written as zero. A compatible reader ignores reserved values it
  does not understand.

The v1.0 writer emits a 256-byte header, 32-byte vertex records, 24-byte group records, and
8-byte point records. The header carries those sizes so a reader can skip fields appended by a
compatible minor version. Material records are fixed at 40 bytes for major version 1.

## File Layout

Sections are ordered and non-overlapping:

1. header
2. vertices
3. indices
4. groups
5. material slots
6. printable-area points
7. excluded-area points
8. string table

The v1.0 writer places each section immediately after the previous one with no alignment
padding. A reader must use the declared offsets and record strides rather than assuming this
contiguity. Every declared section must end at or before the next declared section, and the
string table extends from `strings_offset` to `file_size`.

## Header

The header is 256 bytes. Types below use `u8`, `u16`, `u32`, `u64`, `i32`, and `f32` for
fixed-width unsigned, signed, and binary32 values.

| Offset | Size | Type | Field | v1 meaning |
|---:|---:|---|---|---|
| 0 | 4 | bytes | `magic` | ASCII `ORPM` |
| 4 | 2 | `u16` | `major_version` | `1` |
| 6 | 2 | `u16` | `minor_version` | `0` for the v1.0 writer |
| 8 | 4 | `u32` | `header_size` | `256` for v1.0; at least 256 for major 1 |
| 12 | 4 | `u32` | `vertex_record_size` | `32` for v1.0; at least 32 |
| 16 | 4 | `u32` | `group_record_size` | `24` for v1.0; at least 24 |
| 20 | 4 | `u32` | `point_record_size` | `8` for v1.0; at least 8 |
| 24 | 8 | `u64` | `scene_id` | process-scoped completed-slice identity |
| 32 | 4 | `i32` | `plate_index` | zero-based plate index; `-1` means no plate |
| 36 | 4 | `u32` | `flags` | [flags](#flags) |
| 40 | 8 | `u64` | `vertex_count` | number of vertex records; nonzero |
| 48 | 8 | `u64` | `index_count` | number of `u32` indices; nonzero and divisible by 3 |
| 56 | 8 | `u64` | `group_count` | number of group records; nonzero |
| 64 | 4 | `u32` | `material_slot_count` | number of 40-byte material records; nonzero |
| 68 | 4 | `u32` | `printable_area_count` | number of printable-area point records |
| 72 | 4 | `u32` | `excluded_area_count` | total bed plus wrapping exclusion points |
| 76 | 4 | `u32` | `bed_excluded_area_count` | bed-exclusion prefix length; at most `excluded_area_count` |
| 80 | 8 | `u64` | `vertices_offset` | first vertex record |
| 88 | 8 | `u64` | `indices_offset` | first index |
| 96 | 8 | `u64` | `groups_offset` | first group record |
| 104 | 8 | `u64` | `materials_offset` | first material record |
| 112 | 8 | `u64` | `printable_area_offset` | first printable-area point |
| 120 | 8 | `u64` | `excluded_area_offset` | first excluded-area point |
| 128 | 8 | `u64` | `strings_offset` | first string byte |
| 136 | 8 | `u64` | `file_size` | exact total file size in bytes |
| 144 | 4 | `f32` | `z_offset` | configured printer Z offset in millimeters |
| 148 | 4 | `f32` | `printable_height` | configured maximum printable height from the plate |
| 152 | 12 | `f32[3]` | `bounds_min` | minimum X, Y, and Z over all mesh positions |
| 164 | 12 | `f32[3]` | `bounds_max` | maximum X, Y, and Z over all mesh positions |
| 176 | 80 | bytes | reserved | all zero in v1.0 |

`z_offset` describes the offset used to produce the final scene. Mesh positions are already in
final Preview coordinates, so a consumer must not add the offset again. Bounds cover the
extrusion mesh, not the printable-area or exclusion polygons. Each minimum must be less than or
equal to its corresponding maximum, and every vertex position must lie within the declared
bounds apart from normal binary32 rounding tolerance.

### Flags

| Bit | Mask | Name | Meaning |
|---:|---:|---|---|
| 0 | `0x00000001` | `SPIRAL_VASE` | the slice was produced in spiral-vase mode |
| 1 | `0x00000002` | `INDEXED` | geometry uses the index section; required in ORPM v1 |
| 2-31 | | reserved | written as zero by v1.0; ignored by compatible readers |

## Vertex Records

Each vertex record is 32 bytes.

| Record offset | Size | Type | Field | Meaning |
|---:|---:|---|---|---|
| 0 | 12 | `f32[3]` | `position` | X, Y, Z position in millimeters |
| 12 | 12 | `f32[3]` | `normal` | outward X, Y, Z unit normal |
| 24 | 8 | `f32[2]` | `uv` | U, V texture coordinates; v1.0 emits `(0, 0)` |

Every component must be finite. Writers must emit normalized normals. OrcaSlicer's v1
transport validator accepts squared normal length from `0.25` through `2.25` as a corruption
bound; consumers should normalize accepted values before use and may apply a tighter check to
content they control.

## Index Records

The index section is an array of little-endian `u32` vertex indices. `index_count` is divisible
by three, and each index is less than `vertex_count`. The `INDEXED` flag must be set.

## Group Records

A group describes one contiguous triangle range with common Preview metadata. Each record is
24 bytes.

| Record offset | Size | Type | Field | Meaning |
|---:|---:|---|---|---|
| 0 | 4 | `u32` | `first_index` | first element in the index section |
| 4 | 4 | `u32` | `index_count` | nonzero triangle-index count, divisible by 3 |
| 8 | 2 | `u16` | `material_slot` | zero-based index into the material section |
| 10 | 1 | `u8` | `extrusion_role` | [extrusion-role value](#extrusion-roles) |
| 11 | 1 | `u8` | `extruder_id` | zero-based extruder/tool index |
| 12 | 1 | `u8` | `color_id` | zero-based toolpath color/change index |
| 13 | 3 | bytes | reserved | all zero in v1.0 |
| 16 | 4 | `u32` | `layer_id` | zero-based final Preview layer index |
| 20 | 4 | bytes | reserved | all zero in v1.0 |

Groups are in index order and exactly partition the whole index section: the first group starts
at zero, each later `first_index` equals the end of the preceding group, and the last group ends
at `index_count`. Empty, overlapping, gapped, or out-of-range groups are invalid.

`material_slot` selects appearance metadata. `extruder_id`, `color_id`, `layer_id`, and
`extrusion_role` preserve the corresponding authoritative Preview classifications and are not
array offsets unless stated above. A consumer may batch on any of them without retessellating.

### Extrusion Roles

Values are the v1 `libvgcode::EGCodeExtrusionRole` wire mapping:

| Value | Role | Value | Role |
|---:|---|---:|---|
| 0 | None | 10 | Skirt |
| 1 | Perimeter | 11 | Support material |
| 2 | External perimeter | 12 | Support material interface |
| 3 | Overhang perimeter | 13 | Wipe tower |
| 4 | Internal infill | 14 | Custom |
| 5 | Solid infill | 15 | Bottom surface |
| 6 | Top solid infill | 16 | Internal bridge infill |
| 7 | Ironing | 17 | Brim |
| 8 | Bridge infill | 18 | Support transition |
| 9 | Gap fill | 19 | Mixed |

Values 20-255 are reserved in ORPM v1. A reader should retain an unknown value as unknown rather
than reinterpret it as a known role.

## Material Records

Each material slot record is 40 bytes.

| Record offset | Size | Type | Field | Meaning |
|---:|---:|---|---|---|
| 0 | 1 | `u8` | `extruder_id` | zero-based extruder/tool index represented by this slot |
| 1 | 1 | `u8` | `red` | sRGB red channel |
| 2 | 1 | `u8` | `green` | sRGB green channel |
| 3 | 1 | `u8` | `blue` | sRGB blue channel |
| 4 | 1 | `u8` | `alpha` | alpha, 0 transparent through 255 opaque |
| 5 | 3 | bytes | reserved | all zero in v1.0 |
| 8 | 8 | `u64` | `preset_id_offset` | absolute byte offset into the string table |
| 16 | 4 | `u32` | `preset_id_length` | byte length, excluding any terminator |
| 20 | 4 | `u32` | `display_name_length` | byte length, excluding any terminator |
| 24 | 8 | `u64` | `display_name_offset` | absolute byte offset into the string table |
| 32 | 8 | bytes | reserved | all zero in v1.0 |

The slot's RGBA value is OrcaSlicer's resolved Preview color for the extruder. Group
`material_slot` is the authoritative lookup; do not assume it always equals the group's
`extruder_id`, even though the v1.0 producer commonly assigns slots that way. Preset ID and
display name may be empty.

Strings are un-terminated UTF-8 byte sequences. Each `(offset, length)` range must lie wholly
between `strings_offset` and `file_size`; ranges may be adjacent and need not be aligned.
Embedded NUL bytes have no terminator meaning but writers should not emit them in text. Each
length is limited to `2^32 - 1` bytes, the complete string table is limited to `2^32 - 1`
bytes, and the total-file limit is stricter once other sections are present.

## Point Records and Plate Areas

Each point record is 8 bytes:

| Record offset | Size | Type | Field | Meaning |
|---:|---:|---|---|---|
| 0 | 4 | `f32` | `x` | plate-space X in millimeters |
| 4 | 4 | `f32` | `y` | plate-space Y in millimeters |

Coordinates must be finite. Point order preserves OrcaSlicer's polygon order; polygons are
implicitly closed, so the first point is not repeated at the end.

The printable-area section contains `printable_area_count` points. The excluded-area section
contains exactly `excluded_area_count` points in this order:

1. `bed_excluded_area_count` bed-exclusion points;
2. `excluded_area_count - bed_excluded_area_count` wrapping-exclusion points.

Either count may be zero. Consumers must keep the two exclusion classes distinct even if they
render them identically.

## Limits

A conforming v1 writer and reader enforce all of these bounds before allocation or pointer
arithmetic:

- total file size is at most **4 GiB** (`4,294,967,296` bytes) and equals header `file_size`;
- section-size multiplication and offset addition must not overflow `u64` or the platform's
  addressable size;
- vertices, indices, and groups are nonempty; indices are triangle-aligned;
- vertex indices and group range fields are `u32`, so values outside their representable domain
  are invalid; the 4 GiB file limit imposes a smaller practical count;
- material, printable-point, and excluded-point counts fit `u32`; at most **65,536** material
  slots are addressable by a group's `u16 material_slot`;
- each string and the aggregate string table fit `u32` byte lengths;
- the declared header and record sizes meet the major-1 minimums and every computed region lies
  inside the declared file.

Applications may configure a smaller file-size limit. They must reject a file before allocating
from untrusted counts when that local limit is exceeded.

## Validation Requirements

A consumer must reject a snapshot before use if any of these checks fail:

1. magic, supported version, minimum header/record sizes, exact declared file size, and local
   size limits;
2. checked count-by-stride arithmetic, in-bounds sections, required section order, and no
   overlap;
3. required nonzero counts, `INDEXED`, triangle-aligned indices and groups, and valid bed
   exclusion split;
4. finite header, vertex, and point floats; ordered bounds; positions within bounds; acceptable
   normalized normals;
5. every vertex index in range and groups exactly covering the index domain;
6. every group material slot in range and every material string range inside the string table;
7. valid UTF-8 for nonempty material text.

Validation is required even when the path came from OrcaSlicer. A renderer should map or read the
file read-only and must not trust C/C++ structure packing to match the wire layout.

## Version Compatibility

Major versions change incompatible semantics or layouts. A v1 reader rejects any
`major_version` other than `1`.

Minor versions are additive within major 1. A 1.x writer must preserve every v1.0 field and
meaning, increase header or record sizes for appended fields, leave the v1.0 prefixes intact,
and use reserved flags only for optional behavior. A v1 reader accepts a later minor version
when the declared sizes meet the v1 minimums, skips unknown record tails using the declared
strides, and ignores unknown optional flag bits. A feature that cannot be safely ignored requires
a new major version.

The typed context repeats the format and version so a plugin can reject an unsupported major
without opening the file. The header remains authoritative and must match the context descriptor.

## Publication, Ownership, and Lifetime

OrcaSlicer serializes and validates a snapshot to a temporary file beside its final destination,
flushes it, and publishes it with a rename only after the complete file is ready. Each scene uses
a distinct final path; published files are never modified in place. Python callbacks receive
only the final path after publication, so they observe either no snapshot or a complete snapshot,
not a partially written one.

The file is host-owned and read-only to the plugin. After a successful visualization `open()`, it
remains valid until a successful replacement or session close. After a successful `update()`, the
new file has the same guarantee and the old file may be removed as soon as the callback returns.
A failed, skipped, or cancelled update leaves the previous successful file alive. The host removes
rejected, superseded, and closed-session snapshots; plugins must release mappings and handles and
must not delete, rename, or rewrite the files themselves.

See [Visualization](visualization) for callback ordering and [Registry](registry) for capability
registration and result handling.
