# Patterns

Patterns determine how material is distributed within a print. Different patterns can affect strength, flexibility and print speed using the same density setting.  
The infill pattern also impacts the uniformity of the layer times, since the patterns may be constant, or present significant variations between adjacent layers.

There is no one-size-fits-all solution, as the best pattern depends on the specific print and its requirements.

Many patterns may look similar and have similar overall specifications, but they can behave very differently in practice.  
As most settings in 3D printing, experience is the best way to determine which pattern works best for your specific needs.

> [!TIP]
> Quickly compare patterns with the [Patterns Quick Reference Table](strength_settings_patterns_quick_reference).

## Analysis parameters

### Strength

- **X-Y Direction**: The strength of the print in the "Horizontal" X-Y plane. Affected by the pattern's connections between walls, contact between layers, and path.
- **Z Direction**: The strength of the print in the "Vertical" Z direction. Affected by contact between layers.

### Material Usage

Not all patterns use the same amount of material due to their **Density Calculations** and adjustments to the paths.  
This leads to patterns that do not use the specified percentage but rather variations of it.

### Print Time

Print time can vary significantly between patterns due to differences in their pathing and infill strategies.  
Some patterns may complete faster due to more efficient use of the print head's movement, while others may take longer due to more complex paths.

> [!NOTE]
> OrcaSlicer Time estimations are not always accurate, especially with complex patterns.  
> This analysis was estimated with [Klipper Estimator](https://github.com/Annex-Engineering/klipper_estimator).

### Layer Time Variability

Layer time variability refers to the differences in time it takes to print each layer of a pattern. Some patterns may have consistent layer times, while others may experience significant fluctuations. These variations can potentially impact the outer appearance of the print due to differences in cooling and material flow between layers.

![fill-layer-time-variability](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/fill-layer-time-variability.png?raw=true)

## Monotonic

[Rectilinear](#rectilinear) in a uniform direction for a smoother visual surface.

- **Strength**
    - **Horizontal (X-Y):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** N/A
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** N/A
- **Applies to:**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-monotonic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-monotonic.png?raw=true)

## Monotonic line

[Monotonic](#monotonic) but avoids overlapping with the perimeter, reducing excess material at joints. May introduce visible seams and increase print time.

- **Strength**
    - **Horizontal (X-Y):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** N/A
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** N/A
- **Applies to:**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-monotonic-line](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-monotonic-line.png?raw=true)

## Rectilinear

Parallel lines spaced according to infill density. Each layer is printed perpendicular to the previous, resulting in low vertical bonding. Consider using new [Zig Zag](#zig-zag) infill instead.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**
    - **[Ironing](quality_settings_ironing)**

![infill-top-rectilinear](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-rectilinear.png?raw=true)

## Aligned Rectilinear

Parallel lines spaced by the infill spacing, each layer printed in the same direction as the previous layer. Good horizontal strength perpendicular to the lines, but terrible in parallel direction.
Recommended with layer anchoring to improve not perpendicular strength.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-aligned-rectilinear](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-aligned-rectilinear.png?raw=true)

## Zig Zag

Similar to [rectilinear](#rectilinear) with consistent pattern between layers.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-zig-zag](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-zig-zag.png?raw=true)

## Cross Zag

Similar to [Zig Zag](#zig-zag) but displacing each layer with Infill shift step parameter.

- **Strength**
    - **Horizontal (X-Y):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-cross-zag](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-cross-zag.png?raw=true)

## Locked Zag

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `skin_infill_density`, `skeleton_infill_density`, `infill_lock_depth`, `skin_infill_depth`, `skin_infill_line_width`, `skeleton_infill_line_width`.  
Version of [Zig Zag](#zig-zag) that adds extra skin.
When using this fill, you can individually modify the density of the skeleton and skin, as well as the size of the skin and how much interconnection there is between the skin and the skeleton (a lock depth of 50% of the skin depth is recommended).

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
- **Density Calculation:** Similar to [Zig Zag](#zig-zag).
Skin density * ( Infill Area - Skin Area + lock depth area) + ( Skin density * Skin area).
    - **Material Usage:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
    - **Print Time:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
        - **Material/Time (Higher better):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-locked-zag](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-locked-zag.png?raw=true)

## Line

Similar to [rectilinear](#rectilinear), but each line is slightly rotated to improve print speed.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-line](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-line.png?raw=true)

## Grid

Two-layer pattern of perpendicular lines, forming a grid. Overlapping points may cause noise or artifacts.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-grid](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-grid.png?raw=true)

## Triangles

Triangle-based grid, offering strong X-Y strength but with triple overlaps at intersections.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-triangles](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-triangles.png?raw=true)

## Tri-hexagon

Similar to the [triangles](#triangles) pattern but offset to prevent triple overlaps at intersections. This design combines triangles and hexagons, providing excellent X-Y strength.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-tri-hexagon](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-tri-hexagon.png?raw=true)

## Cubic

3D cube pattern with corners facing down, distributing force in all directions. Triangles in the horizontal plane provide good X-Y strength.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-cubic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-cubic.png?raw=true)

## Adaptive Cubic

[Cubic](#cubic) pattern with adaptive density: denser near walls, sparser in the center. Saves material and time while maintaining strength, ideal for large prints.

- **Strength**
    - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
    - **Vertical (Z):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:** Same as [Cubic](#cubic) but reduced in the center
    - **Material Usage:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
    - **Print Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
        - **Material/Time (Higher better):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-adaptive-cubic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-adaptive-cubic.png?raw=true)

## Quarter Cubic

[Cubic](#cubic) pattern with extra internal divisions, improving X-Y strength.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-quarter-cubic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-quarter-cubic.png?raw=true)

## Support Cubic

Support |Cubic is a variation of the [Cubic](#cubic) infill pattern that is specifically designed for support top layers. Will use more material than Lightning infill but will provide better strength. Nevertheless, it is still a low-density infill pattern.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:** % of layer before top shell layers
    - **Material Usage:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
    - **Print Time:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Likely Noticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-support-cubic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-support-cubic.png?raw=true)

## Lightning

Ultra-fast, ultra-low material infill. Designed for speed and efficiency, ideal for quick prints or non-structural prototypes.

### Overhang Angle

Similar to the [overhang](quality_settings_overhangs) angle used for support generation, but specifically for Lightning infill.  
It determines how far the infill can extend from walls before needing support.

### Prune Angle

Controls how aggressively short/unsupported branches of the Lightning infill are pruned.  
A lower angle will result in more pruning, while a higher angle will allow for more unsupported branches.

### Straightening Angle

Limits how far junctions in the Lightning infill can be moved to straighten lines.  
Using a low value will result in a low lateral distortion between layers, but may cause more pruning.  
A higher value will allow for more straightening, improving strength but increasing lateral distortion.

![infill-top-lightning-straightening](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-lightning-straightening.png?raw=true)  
![infill-top-front-lightning-straightening](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-front-lightning-straightening.png?raw=true)  
![infill-front-lightning-straightening](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-front-lightning-straightening.png?raw=true)

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:** % of layer before top shell layers
    - **Material Usage:** Ultra-Low ![level-to-worse-0](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-0.svg?raw=true)
    - **Print Time:** Ultra-Low ![level-to-worse-0](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-0.svg?raw=true)
        - **Material/Time (Higher better):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
        - **Layer time Variability:** Likely Noticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-lightning](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-lightning.png?raw=true)

## Honeycomb

Hexagonal pattern balancing strength and material use. Double walls in each hexagon increase material consumption.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
    - **Print Time:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-honeycomb](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-honeycomb.png?raw=true)

## 3D Honeycomb

This infill tries to generate a printable honeycomb structure by printing squares and octagons maintaining a vertical angle high enough to maintain contact with the previous layer.

- **Strength**
    - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
    - **Vertical (Z):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:** Unknown
    - **Material Usage:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **Print Time:** Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Possibly Noticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-3d-honeycomb](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-3d-honeycomb.png?raw=true)

## Lateral Honeycomb

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `infill_overhang_angle`.  
Vertical Honeycomb pattern. Acceptable torsional stiffness. Developed for low densities structures like wings. Improve over [Lateral Lattice](#lateral-lattice) offers same performance with lower densities.This infill includes a Overhang angle parameter to improve the point of contact between layers and reduce the risk of delamination.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Possibly Noticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-lateral-honeycomb](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-lateral-honeycomb.png?raw=true)

## Lateral Lattice

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `lateral_lattice_angle_1`, `lateral_lattice_angle_2`.  
Low-strength pattern with good flexibility. You can adjust **Angle 1** and **Angle 2** to optimize the infill for your specific model. Each angle adjusts the plane of each layer generated by the pattern. 0° is vertical.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-lateral-lattice](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-lateral-lattice.png?raw=true)

## Cross Hatch

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `infill_shift_step`.  
Similar to [Gyroid](#gyroid) but with linear patterns, creating weak points at internal corners.
Easier to slice but consider using [TPMS-D](#tpms-d) or [Gyroid](#gyroid) for better strength and flexibility.

- **Strength**
    - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
    - **Vertical (Z):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Likely Noticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-cross-hatch](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-cross-hatch.png?raw=true)

## TPMS-D

Triply Periodic Minimal Surface (Schwarz Diamond). Hybrid between [Cross Hatch](#cross-hatch) and [Gyroid](#gyroid), combining rigidity and smooth transitions. Isotropic and strong in all directions. This geometry is faster to slice than Gyroid, but slower than Cross Hatch.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Possibly Noticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-tpms-d](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-tpms-d.png?raw=true)

## TPMS-FK

Triply Periodic Minimal Surface (Fischer–Koch S) pattern. Its smooth, continuous geometry resembles trabecular bone microstructure, offering a balance between rigidity and energy absorption. Compared to [TPMS-D](#tpms-d), it has more complex curvature, which can improve load distribution and shock absorption in functional parts.

- **Strength**
    - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
    - **Vertical (Z):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Possibly Noticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-tpms-fk](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-tpms-fk.png?raw=true)

## Gyroid

Mathematical, isotropic surface providing equal strength in all directions. Excellent for strong, flexible prints and resin filling due to its interconnected structure. Since it does not contain straight lines over long stretches, it helps reduce warping, as the material's contraction is distributed along its curved lines. This pattern may require more time to slice because of all the points needed to generate each curve. If your model has complex geometry, consider using a simpler infill pattern like [TPMS-D](#tpms-d) or [Cross Hatch](#cross-hatch).

### Gyroid Optimized

[Variable](built_in_placeholders_variables): `gyroid_optimized`.  
> [!IMPORTANT]
> NEW FEATURE: **Z-buckling bias optimization (experimental)**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.3.2**.

Tightens the gyroid wave along the Z (vertical) axis at low infill density to shorten the effective vertical column length and improve Z-axis compression buckling resistance. Filament use is preserved. No effect at ~30% sparse infill density and above. Only applies when Sparse infill pattern is set to Gyroid.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-gyroid](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-gyroid.png?raw=true)

## Concentric

Fills the area with progressively smaller versions of the outer contour, creating a concentric pattern. Ideal for 100% infill or flexible prints.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**
    - **[Ironing](quality_settings_ironing)**

![infill-top-concentric](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-concentric.png?raw=true)

## Hilbert Curve

Hilbert Curve is a space-filling curve that can be used to create a continuous infill pattern. It is known for its aesthetic appeal and ability to fill space efficiently.
Print speed is very low due to the complexity of the path, which can lead to longer print times. It is not recommended for structural parts but can be used for aesthetic purposes.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-hilbert-curve](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-hilbert-curve.png?raw=true)

## Archimedean Chords

Spiral pattern that fills the area with concentric arcs, creating a smooth and continuous infill. Can be filled with resin thanks to its interconnected hollow structure, which allows the resin to flow through it and cure properly.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-archimedean-chords](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-archimedean-chords.png?raw=true)

## Octagram Spiral

Aesthetic pattern with low strength and high print time.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
        - **Material/Time (Higher better):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
        - **Layer time Variability:** None
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-octagram-spiral](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-octagram-spiral.png?raw=true)
