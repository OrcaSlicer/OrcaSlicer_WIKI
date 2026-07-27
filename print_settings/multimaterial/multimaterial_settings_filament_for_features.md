# Filament for Features

These options are available for multi-material printers (multi-extruder and single-extruder multi-material setups such as AMS, CFS, Mosaic).

<div class="orca-video-embed">
  <a class="orca-video-poster-link" href="https://www.youtube.com/watch?v=hcuQw55OzjU" aria-label="Watch filament for features video">
    <img alt="filament-for-features-video" src="https://img.youtube.com/vi/hcuQw55OzjU/maxresdefault.jpg">
  </a>
</div>

![filament_for_features](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/filament-for-features/filament_for_features.png?raw=true)

## Outer Walls

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `outer_wall_filament_id`.  
Filament to print outer walls.  
This can also be used to use a translucent filament for outer walls to achieve a frosted glass effect.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), it's recommended to use the smaller nozzle for outer walls to achieve better surface quality and detail.

## Surface / outer wall override

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `surface_wall_override_filament`.  

> [!IMPORTANT]
> NEW FEATURE: **Surface / outer wall override filament**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Filament for the outermost N perimeter loops and/or the top/bottom external solid surfaces. Set to `0` (default) to disable the override — all walls and surfaces then use the regular [Outer Walls](#outer-walls) filament.

Useful when you want a cosmetic or structural contrast between the visible exterior of a print and its interior without per-volume painting. Common uses:

- A coloured outer shell over a different infill filament.
- Embedded text or logos in a contrasting filament on the top surface.
- A higher-strength outer skin over a different inner material.

The override stacks on top of per-volume / paint extruder assignments: the painted extruder becomes the *base* filament for the volume, while the outermost N loops (and/or surfaces, depending on [Apply to](#apply-to)) still take the override filament.

When the override filament belongs to a different polymer family than [Walls](#walls), a warning is shown — cross-polymer-family layer adhesion may be poor.

**Trade-off:** the override introduces extra toolchanges per island (one when entering each top/bottom surface, plus per-loop changes when applied to walls and the wall sequence isn't outer-first/last). This increases [wipe tower](multimaterial_settings_prime_tower) volume and total print time. Pick the narrowest [Apply to](#apply-to) value that meets your need.

## Outer wall count

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `outer_wall_count`.  

> [!IMPORTANT]
> NEW FEATURE: **Outer wall count**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Number of outermost perimeter loops (counted from the outside in) that use the [Surface / outer wall override](#surface--outer-wall-override) filament. Only meaningful when the override filament is set and [Apply to](#apply-to) includes `Walls`. Default is `1` — only the outermost loop is overridden.

## Apply to

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `surface_wall_override_filament_target`.  

> [!IMPORTANT]
> NEW FEATURE: **Surface / outer wall override target**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Controls *where* the [Surface / outer wall override](#surface--outer-wall-override) filament is applied:

- **`Walls`** — outermost N perimeter loops only.
- **`Surfaces`** — top and bottom external solid surfaces only (including the ironing pass over them); walls keep using the regular [Walls](#walls) filament.
- **`Both`** *(default)* — walls **and** top/bottom surfaces.

`Surfaces` and `Both` add extra toolchanges per layer, which increases wipe-tower volume noticeably. Pick `Walls` if you only need contrasting perimeters with minimal wipe-tower overhead.

Only takes effect when [Surface / outer wall override](#surface--outer-wall-override) is non-zero.

## Infill