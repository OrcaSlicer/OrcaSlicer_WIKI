# Top and Bottom Shells

Controls how the top and bottom solid layers (shells) are generated.

![top-bottom-shells](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/top-bottom-shells.png?raw=true)

- [Shell Layers](#shell-layers)
- [Shell Thickness](#shell-thickness)
- [Surface Density](#surface-density)
- [Infill/Wall Overlap](#infillwall-overlap)
- [Surface Pattern](#surface-pattern)
- [Surface Expansion](#surface-expansion)
    - [Surface Expansion Margin](#surface-expansion-margin)
    - [Surface Expansion Direction](#surface-expansion-direction)
- [Center Surface Pattern On](#center-surface-pattern-on)
- [Anisotropic Surfaces](#anisotropic-surfaces)

## Shell Layers

[Variables](built_in_placeholders_variables): `top_shell_layers`, `bottom_shell_layers`.  
This is the number of solid shell layers, including the surface layer.  
When the thickness calculated from this value is less than [shell thickness](#shell-thickness), the shell layers will be increased.

These layers are printed over the [sparse infill](strength_settings_infill), so increasing **shell layers** will increase overall part strength and top surface quality.
It's usually recommended to have at least 3 shell layers for most prints.

## Shell Thickness

[Variables](built_in_placeholders_variables): `top_shell_thickness`, `bottom_shell_thickness`.  
The number of solid layers is increased during slicing if the thickness calculated from shell layers is thinner than this value. This avoids having too thin a shell when layer height is small.  
0 means this setting is disabled and shell thickness is determined entirely by [shell layers](#shell-layers).

## Surface Density

[Variables](built_in_placeholders_variables): `top_surface_density`, `bottom_surface_density`.  
This setting controls the density of the top and bottom surfaces. A value of 100% means a solid surface, while lower values create a sparse surface.  
This can be used for aesthetic purposes, improving grip or creating interfaces.

## Infill/Wall Overlap

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `top_bottom_infill_wall_overlap`.  
The top solid infill area is slightly enlarged to overlap with walls for better bonding and to minimize pinholes where the infill meets the walls.  
A value of 25-30% is a good starting point. The percentage value is relative to the line width of the sparse infill.

> [!TIP]
> Check [Monotonic Line](strength_settings_patterns#monotonic-line) to learn about its overlaying differences with [Monotonic](strength_settings_patterns#monotonic) and [Rectilinear](strength_settings_patterns#rectilinear).

## Surface Pattern

[Variables](built_in_placeholders_variables): `top_surface_pattern`, `bottom_surface_pattern`.  
This setting controls the pattern of the surfaces.  
If [Shell Layers](#shell-layers) is greater than 1, the surface pattern will be applied to the outermost shell layer only and the rest will use [Internal Solid Infill Pattern](strength_settings_infill#internal-solid-infill).

> [!TIP]
> See [Infill Patterns Wiki List](strength_settings_patterns) with **detailed specifications**, including their strengths and weaknesses.

 The surface patterns are:

- **[Concentric](strength_settings_patterns#concentric)**
- **[Rectilinear](strength_settings_patterns#rectilinear)**
- **[Monotonic](strength_settings_patterns#monotonic)**
- **[Monotonic Line](strength_settings_patterns#monotonic-line)** Usually Recommended for Top.
- **[Aligned Rectilinear](strength_settings_patterns#aligned-rectilinear)**
- **[Hilbert Curve](strength_settings_patterns#hilbert-curve)**
- **[Archimedean Chords](strength_settings_patterns#archimedean-chords)**
- **[Octagram Spiral](strength_settings_patterns#octagram-spiral)**

> [!TIP]
> Enable [Align directions to model](strength_settings_advanced#align-directions-to-model) to make the top/bottom surface fill direction follow the model's orientation on the build plate.

## Surface Expansion

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `top_surface_expansion`.  

> [!IMPORTANT]
> NEW FEATURE: **Top surface expansion** (expansion, margin and direction)  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Expands the top surfaces by this distance (in mm) to connect distinct top surfaces and fill the gaps left where a feature rises through them.  
This is useful when the top surface is interrupted by a raised feature, such as text or a boss on a plane, or when overlapping objects would otherwise split it: expanding the surface removes the holes beneath these features, keeps the top-surface pattern uninterrupted, and anchors the solid infill for a cleaner finish when printing on top. It also improves [concentric](strength_settings_patterns#concentric) top surfaces, whose pattern would otherwise be broken up by those small holes.  
The expansion is applied to the original top surface, before any other processing such as bridging or overhang detection. Set to `0` to disable it.

- **Original**

![surface_expansion_original](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/surface_expansion_original.png?raw=true)

- **Expanded by 5 mm**

![surface_expansion_5mm](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/surface_expansion_5mm.png?raw=true)

Improved [concentric](strength_settings_patterns#concentric) top surface:

![surface_expansion_concentric](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/surface_expansion_concentric.png?raw=true)

### Surface Expansion Margin

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `top_surface_expansion_margin`.  
Using [Surface Expansion](#surface-expansion) may cause a surface that did not previously touch the model's outer walls to now reach them, which can create contraction marks (such as a hull line) on the outer walls.  
Adding a margin (in mm) keeps the expansion away from the walls where possible, so no hull line is created. The example below uses a 5 mm expansion with a 2 mm margin — compare it with the 5 mm expansion above, which reaches the walls.

![surface_expansion_margin](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/surface_expansion_margin.png?raw=true)

### Surface Expansion Direction

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `top_surface_expansion_direction`.  
Direction in which the [Surface Expansion](#surface-expansion) grows:

- **Inward:** grows into the holes and gaps left by features rising from the middle of a top surface.
  ![surface_expansion_direction_inward](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/surface_expansion_direction_inward.png?raw=true)
- **Outward:** grows the outer edge of the surface, connecting surfaces separated by features that can divide a surface, such as a lattice pattern.
  ![surface_expansion_direction_outward](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/surface_expansion_direction_outward.png?raw=true)
- **Inward and Outward:** does both. This is the default.
  ![surface_expansion_direction_inward_and_outward](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/surface_expansion_direction_inward_and_outward.png?raw=true)

## Center Surface Pattern On

[Mode](option_mode): `Expert`.  
[Variable](built_in_placeholders_variables): `center_of_surface_pattern`.  

> [!IMPORTANT]
> NEW FEATURE: **Center surface pattern on**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Chooses where the centering point of centered top/bottom surface patterns ([Archimedean Chords](strength_settings_patterns#archimedean-chords), [Octagram Spiral](strength_settings_patterns#octagram-spiral)) is placed.  
By default these patterns are centered individually on each surface, which does not keep the pattern continuous across a whole product — a drawback for some artistic prints where the surfaces should read as one piece. This setting widens the scope of the shared center:

- **Each Surface:** centers the pattern on every individual surface region, so each island is symmetric on its own. This is the previous behavior.

![center_of_surface_pattern_each_surface](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/center_of_surface_pattern_each_surface.png?raw=true)

- **Each Model:** combines all the surfaces of one model — or each shape in the assembly — under a single center. Parts that touch or overlap share one center; parts detached from the rest each get their own.

![center_of_surface_pattern_each_model](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/center_of_surface_pattern_each_model.png?raw=true)

- **Each Assembly:** all the surfaces of the assembly fall under a single shared center. Well suited for articulated models that should keep one continuous pattern across their parts.

![center_of_surface_pattern_each_assembly](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/top-bottom-shells/center_of_surface_pattern_each_assembly.png?raw=true)

## Anisotropic Surfaces

[Mode](option_mode): `Expert`.  
[Variable](built_in_placeholders_variables): `anisotropic_surfaces`.  

> [!IMPORTANT]
> NEW FEATURE: **Anisotropic surfaces**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Applies anisotropic patterns to the top and bottom surfaces using a co-directional printing mode. For certain patterns, omni-directional filling provides color dispersion when using multi-colored or silk filaments.  
This option disables gap fill and can increase printing time.

![anisotropic_surfaces](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/directions/anisotropic_surfaces.jpg?raw=true)
