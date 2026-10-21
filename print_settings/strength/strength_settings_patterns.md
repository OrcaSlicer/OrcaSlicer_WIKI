# Patterns

Patterns determine how material is distributed within a print. Different patterns can affect strength, flexibility and print speed using the same density setting.  
The infill pattern also impacts the uniformity of the layer times, since the patterns may be constant, or present significant variations between adjacent layers.

There is no one-size-fits-all solution, as the best pattern depends on the specific print and its requirements.

Many patterns may look similar and have similar overall specifications, but they can behave very differently in practice.  
As with most settings in 3D printing, experience is the best way to determine which pattern works best for your specific needs.

> [!TIP]
> Quickly compare patterns with the [Patterns Quick Reference Table](strength_settings_patterns_quick_reference).

## Analysis parameters

The ratings are the mean of a 100 mm cube, a 3DBenchy and the Stanford bunny, sliced on a Qidi Q2 with a 0.4 mm nozzle, the 0.20mm Standard profile and QIDI PLA Rapido at 5, 15, 30 and 50% sparse infill density, measuring only the sparse infill and the travel in the layers that print it, and compared with each other on the same model and density. The patterns that only print solid infill are measured on their internal solid infill at 100% and rated against the other solid infill patterns. See the [Patterns Quick Reference](strength_settings_patterns_quick_reference) for how the analysis was made.

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
> These are OrcaSlicer's own time estimates, the ones its preview shows.  
> A printer's real times can differ, especially with complex patterns.

### Layer Time Variability

Layer time variability refers to the differences in time it takes to print each layer of a pattern. Some patterns may have consistent layer times, while others may experience significant fluctuations. These variations can potentially impact the outer appearance of the print due to differences in cooling and material flow between layers.  
It is measured on the cube alone, whose layers all have the same shape, so that the changes come from the pattern and not from the model.

![fill-layer-time-variability](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/fill-layer-time-variability.png?raw=true)

### Slicing Time

How long OrcaSlicer takes to slice each run and write its G-code, from the command line and one run at a time. Patterns with more and shorter lines take longer to generate, order and write.  
It depends on the computer, so only the comparison between patterns applies.

### G-code Size

The size of each run's G-code file. Patterns made of many short moves give larger files, which take longer to send to the printer.

### Multiline

The patterns that support [Fill Multiline](strength_settings_infill#fill-multiline) are also rated with 2 and 3 lines. **Print Time** is rated like the pattern's own, against the other patterns printed with one line, followed by how much faster or slower it is than the same pattern printed with one line on the same model and density.

## Monotonic

[Rectilinear](#rectilinear) in a uniform direction for a smoother visual surface.

- **Strength**
    - **Horizontal (X-Y):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** N/A
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** N/A
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** N/A
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
    - **Slicing Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** N/A
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** N/A
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** N/A
- **Applies to:**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-monotonic-line](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-monotonic-line.png?raw=true)

## Rectilinear

Parallel lines spaced according to infill density. Each layer is printed perpendicular to the previous, resulting in low vertical bonding. Consider using [Zig Zag](#zig-zag) infill instead.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (4% Faster over single line)
        - **3 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (6% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**
    - **[Ironing](quality_settings_ironing)**
    - **[Support Base](support_settings_advanced#base-pattern)**
    - **[Support Interface](support_settings_advanced#interface-pattern)**

![infill-top-rectilinear](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-rectilinear.png?raw=true)

## Aligned Rectilinear

Parallel lines spaced by the infill spacing, each layer printed in the same direction as the previous layer. Good horizontal strength perpendicular to the lines, but very poor in the parallel direction.
Recommended with layer anchoring to improve non-perpendicular strength.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (4% Faster over single line)
        - **3 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (6% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-aligned-rectilinear](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-aligned-rectilinear.png?raw=true)

## Zig Zag

Similar to [rectilinear](#rectilinear), with a consistent pattern between layers.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** Yes
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-zig-zag](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-zig-zag.png?raw=true)

## Cross Zag

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `infill_shift_step`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--infill-shift-step=1`.  
Similar to [Zig Zag](#zig-zag), but each layer is shifted by the **Infill shift step** parameter.

- **Strength**
    - **Horizontal (X-Y):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** Yes
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-cross-zag](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-cross-zag.png?raw=true)

## Locked Zag

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `skin_infill_density`, `skeleton_infill_density`, `infill_lock_depth`, `skin_infill_depth`, `skin_infill_line_width`, `skeleton_infill_line_width`.  
[Type](option_type): `skin_infill_density` (Percentage), `skeleton_infill_density` (Percentage), `infill_lock_depth` (Float), `skin_infill_depth` (Float), `skin_infill_line_width` (Float or Percentage), `skeleton_infill_line_width` (Float or Percentage).  
[CLI Example](cli_mode#setting-overrides): `--skin-infill-density=20%` (`skin_infill_density` shown; other variables above follow their own type).  
Version of [Zig Zag](#zig-zag) that adds extra skin.
When using this fill, you can individually modify the density of the skeleton and skin, as well as the size of the skin and how much interconnection there is between the skin and the skeleton (a lock depth of 50% of the skin depth is recommended).  
**Skin line width** and **Skeleton line width** set the line width of the skin and skeleton paths. If expressed as a %, they are computed over the nozzle diameter.  
The **Infill shift step** of [Cross Zag](#cross-zag) also applies to Locked Zag, but it only shifts the skin. The skeleton is not shifted.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
- **Density Calculation:** Similar to [Zig Zag](#zig-zag).
Skeleton density * (Infill area - Skin area + Lock depth area) + (Skin density * Skin area).
    - **Material Usage:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
    - **Print Time:** Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true)
        - **Material/Time (Higher better):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **G-code Size:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** Yes
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
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
        - **Material/Time (Higher better):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** No
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-line](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-line.png?raw=true)

## Grid

Two sets of perpendicular lines on every layer, forming a grid. Overlapping points may cause noise or artifacts.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
        - **2 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (78% Slower over single line)
        - **3 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (57% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** [Multiline](strength_settings_infill#fill-multiline) only
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Support Interface](support_settings_advanced#interface-pattern)**

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
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
        - **2 lines:** Print Time Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true) (32% Slower over single line)
        - **3 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (21% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** [Multiline](strength_settings_infill#fill-multiline) only
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
    - **Print Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
        - **2 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (87% Slower over single line)
        - **3 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (61% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** [Multiline](strength_settings_infill#fill-multiline) only
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
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
        - **2 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (68% Slower over single line)
        - **3 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (51% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** [Multiline](strength_settings_infill#fill-multiline) only
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
        - **Material/Time (Higher better):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
        - **Layer time Variability:** Possibly Noticeable
    - **Slicing Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
        - **2 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (50% Slower over single line)
        - **3 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (46% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
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
    - **Slicing Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (60% Slower over single line)
        - **3 lines:** Print Time Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true) (25% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-quarter-cubic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-quarter-cubic.png?raw=true)

## Support Cubic

Support Cubic is a variation of the [Cubic](#cubic) infill pattern that is specifically designed to support top layers. It uses more material than Lightning infill but provides better strength. Nevertheless, it is still a low-density infill pattern.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:** % of layer before top shell layers
    - **Material Usage:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
    - **Print Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
        - **Material/Time (Higher better):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
        - **Layer time Variability:** Likely Noticeable
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
        - **2 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (55% Slower over single line)
        - **3 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (71% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-support-cubic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-support-cubic.png?raw=true)

## Lightning

[Mode](option_mode): `Expert`.  
[Variables](built_in_placeholders_variables): `lightning_overhang_angle`, `lightning_prune_angle`, `lightning_straightening_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--lightning-overhang-angle=1` (same pattern for the other variables above).  
Ultra-fast, ultra-low material infill. Designed for speed and efficiency, ideal for quick prints or non-structural prototypes.

### Overhang Angle

Similar to the [overhang](quality_settings_overhangs) angle used for support generation, but specifically for Lightning infill.  
It determines how far the infill can extend from walls before needing support.

### Prune Angle

Controls how aggressively short/unsupported branches of the Lightning infill are pruned.  
A higher angle will result in more pruning, while a lower angle will keep longer branches.

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
    - **Print Time:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
        - **Material/Time (Higher better):** Extra-Low ![level-to-better-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-1.svg?raw=true)
        - **Layer time Variability:** Likely Noticeable
    - **Slicing Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true) (21% Faster over single line)
        - **3 lines:** Print Time Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true) (25% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Support Base](support_settings_advanced#base-pattern)**

![infill-top-lightning](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-lightning.png?raw=true)

## Honeycomb

Hexagonal pattern balancing strength and material use. Double walls in each hexagon increase material consumption.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
    - **Print Time:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
    - **G-code Size:** Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true) (19% Faster over single line)
        - **3 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (30% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Support Base](support_settings_advanced#base-pattern)**

![infill-top-honeycomb](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-honeycomb.png?raw=true)

## 3D Honeycomb

This infill tries to generate a printable honeycomb structure by printing squares and octagons maintaining a vertical angle high enough to maintain contact with the previous layer.

### Fill pattern tops

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `infill_complete_top`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--infill-complete-top=1`.  

> [!IMPORTANT]
> NEW FEATURE: **Fill pattern tops**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

The square at the top of each cell is left open by default. This option covers those squares.

Whenever the pattern changes its print direction, extra lines are bridged across the squares of the previous layer. This is added on top of the normal pattern, which keeps its structural stability.

- **Disabled (default):** the squares are left open.
- **Enabled:** the squares are covered.

The option is only shown when the [Sparse infill pattern](strength_settings_infill#sparse-infill-pattern) is **3D Honeycomb** and the [Sparse infill density](strength_settings_infill#sparse-infill-density) is above 0%.

Useful for:

- **Functional parts**, for example keeping two channels (air and water) separate.
- **Artistic prints** where the upper surface of the pattern should be filled in.

> [!NOTE]
> It is disabled by default because the direction reversals and non-extrusion moves needed to cover the squares substantially slow down the print.

Behavior with other settings:

- **[Fill Multiline](strength_settings_infill#fill-multiline):** the cover is not multiplied by the number of lines. It is printed as a single zigzag pass, built up over as many layers as there are lines and changing direction on every layer.
- **Density:** the squares get smaller as the density increases (and larger with more [Fill Multiline](strength_settings_infill#fill-multiline) lines). When a square is too small to fit a cover line, none is generated, so the option has no effect at high densities.
- **Line spacing:** the cover lines are intentionally closer together than the line width, so the squares close without gaps.

> [!NOTE]
> The covers are bridges, and small pinholes can remain in them. Test your print if it must be airtight or watertight.

- **Strength**
    - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
    - **Vertical (Z):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:** Unknown
    - **Material Usage:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **Print Time:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
    - **Slicing Time:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
    - **G-code Size:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Non-Crossing](strength_settings_infill#non-crossing-strategy)
        - **2 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (20% Faster over single line)
        - **3 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (30% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-3d-honeycomb](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-3d-honeycomb.png?raw=true)

## Lateral Honeycomb

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `infill_overhang_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--infill-overhang-angle=1`.  
Vertical honeycomb pattern with acceptable torsional stiffness, developed for low-density structures like wings. An improvement over [Lateral Lattice](#lateral-lattice), it offers the same performance at lower densities. This infill includes an **Infill overhang angle** parameter to improve the contact between layers and reduce the risk of delamination.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Possibly Noticeable
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (7% Faster over single line)
        - **3 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (10% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-lateral-honeycomb](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-lateral-honeycomb.png?raw=true)

## Lateral Lattice

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `lateral_lattice_angle_1`, `lateral_lattice_angle_2`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--lateral-lattice-angle-1=1` (same pattern for the other variables above).  
Low-strength pattern with good flexibility. You can adjust **Angle 1** and **Angle 2** to optimize the infill for your specific model. Each angle sets the tilt in the Z direction of one of the two sets of lattice elements. 0° is vertical.

- **Strength**
    - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
    - **Vertical (Z):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** Extra-Low ![level-to-worse-1](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-1.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (8% Faster over single line)
        - **3 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (10% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-lateral-lattice](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-lateral-lattice.png?raw=true)

## Cross Hatch

Similar to [Gyroid](#gyroid) but with linear patterns, creating weak points at internal corners.
Easier to slice but consider using [TPMS-D](#tpms-d) or [Gyroid](#gyroid) for better strength and flexibility.

- **Strength**
    - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
    - **Vertical (Z):** Normal-High ![level-to-better-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
        - **Material/Time (Higher better):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
        - **Layer time Variability:** Likely Noticeable
    - **Slicing Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **G-code Size:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true) (12% Faster over single line)
        - **3 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (18% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** Yes
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
    - **Slicing Time:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
    - **G-code Size:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (14% Faster over single line)
        - **3 lines:** Print Time Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true) (22% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
    - **[Adaptive Density](#adaptive-density):** Yes
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
    - **Print Time:** Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Possibly Noticeable
    - **Slicing Time:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
    - **G-code Size:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (21% Faster over single line)
        - **3 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (31% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
    - **[Adaptive Density](#adaptive-density):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-tpms-fk](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-tpms-fk.png?raw=true)

## Adaptive TPMS

> [!IMPORTANT]
> NEW FEATURE: **Adaptive TPMS density**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

[Gyroid](#gyroid), [TPMS-D](#tpms-d) and [TPMS-FK](#tpms-fk) can grade their density inside the object: fine cells next to the walls and the top and bottom surfaces, where the infill supports the shells, growing continuously towards the center of the object, where they save material and print time.

### Adaptive Density

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `adaptive_infill_mode`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `disabled, distance_warp, smooth_blend, stepped_shells, lobes, normal_z, normal_y, normal_x`.  
[CLI Example](cli_mode#setting-overrides): `--adaptive-infill-mode=disabled`.  
Grades the Gyroid and TPMS infill inside the object: its cells grow from the surface of the object towards its center. The [Sparse infill density](strength_settings_infill#sparse-infill-density) is used at the surface and the [Interior Density](#interior-density) at the center.

| Mode | Follows | Use it for |
| --- | --- | --- |
| Disabled | Nothing: the regular pattern at the sparse infill density. | |
| Distance warp | The distance to the nearest surface, with one continuous pattern warped around the lobe centers. | A smooth, connected concentric grading; the pattern is sheared in plates and long parts, and long parts are graded partly along their length. |
| Smooth blend | The distance to the nearest surface, with the patterns of neighboring densities blended into each other. | A concentric grading without steps; small loops where the densities blend. |
| Stepped shells | The distance to the nearest surface, including the top and bottom, like concentric shells: each shell gets the regular pattern at its density, about 1.5 times apart, with its lines joined along the shell. | A concentric grading with an undistorted pattern; the density changes in steps. |
| Lobes | The whole 3D shape of the object, including its top and bottom: every lobe, a part joined to the rest by a narrower neck, towards its own center. | Most objects. |
| Normal Z | Each section of the object normal to Z, so the density does not change with the height. | Profiles extruded along Z, like tall prisms and tubes. |
| Normal Y, Normal X | Each section of the object normal to that axis, so the density does not change along it. | Profiles extruded along X or Y, like beams and bars lying on the bed. |

- The object is measured from its slices, so holes, negative parts and the union of overlapping parts are taken into account.
- Every separate body of the object, and every lobe of a body joined to the rest by a neck, like two united spheres, is graded towards its own center, its deepest point. The neck between two lobes is graded halfway. With Lobes, the center of a tall object is at its middle height, so the infill is sparsest there and not along its whole height.
- The lines stay continuous: the pattern is scaled around the center, with round cells at the center and cells flattened along the surface near it.
- The parts that the center cannot reach in a straight line, like the far side of the hole of a ring, keep the sparse infill density.
- In Distance warp, Smooth blend and Stepped shells the interior density is at the point farthest from the surface, so a tall object keeps its whole core sparse and a plate is graded through its thickness. On spheres and cubes, Distance warp is the same as Lobes.
- Smooth blend and Stepped shells print more lines than their target where their densities meet, along the shells or where the patterns blend, so they save less material than Lobes for the same densities.
- In the Normal modes every section is graded the same way within its own outline. Along the axis, the cells keep the interior density, so near the surface they are stretched along the axis. With Normal X or Y, the layers next to the sides stay at the sparse infill density.
- The Gyroid [Z-buckling bias optimization](#gyroid-optimized) does not apply to adaptive infill.
- At a [Sparse infill density](strength_settings_infill#sparse-infill-density) of 100% the sparse infill is printed solid, so the adaptive options are hidden.
- Objects made only of parts thinner than the field grid cells (0.5 mm, up to a few mm for very large objects) use the regular pattern.

### Interior Density

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `adaptive_infill_interior_density`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--adaptive-infill-interior-density=20%`.  
Density of the adaptive infill at the center of the object.  
It can also be higher than the sparse infill density, to make the core denser than the surface.

### Adaptive Gradient

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `adaptive_infill_gradient`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `linear, quadratic, exponential`.  
[CLI Example](cli_mode#setting-overrides): `--adaptive-infill-gradient=linear`.  
How the density changes from the surface (depth `0`) to the center of the object (depth `1`), where `S` is the sparse infill density and `I` the interior density:

| Gradient | Density at depth `t` | Behavior |
| --- | --- | --- |
| Linear | `S + (I - S) × t` | Changes at a constant rate. |
| Quadratic | `S + (I - S) × t²` | Stays close to the sparse infill density near the surface and changes faster towards the center. Uses the most material when the surface is denser. |
| Exponential | `S × (I / S)ᵗ` | Changes quickly just below the surface and levels off towards the center. Uses the least material when the surface is denser. |

## Gyroid

Mathematical, isotropic surface providing equal strength in all directions. Excellent for strong, flexible prints and resin filling due to its interconnected structure. Since it does not contain straight lines over long stretches, it helps reduce warping, as the material's contraction is distributed along its curved lines. This pattern may require more time to slice because of all the points needed to generate each curve. If your model has complex geometry, consider using a simpler infill pattern like [TPMS-D](#tpms-d) or [Cross Hatch](#cross-hatch).

### Gyroid Optimized

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `gyroid_optimized`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--gyroid-optimized=1`.  

Tightens the gyroid wave along the Z (vertical) axis at low infill density to shorten the effective vertical column length and improve Z-axis compression buckling resistance. Filament use is preserved. No effect at ~30% sparse infill density and above. Only applies when Sparse infill pattern is set to Gyroid.

- **Strength**
    - **Horizontal (X-Y):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
    - **Vertical (Z):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **Print Time:** Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true)
        - **Material/Time (Higher better):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
        - **Layer time Variability:** Unnoticeable
    - **Slicing Time:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
    - **G-code Size:** Ultra-High ![level-to-worse-8](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-8.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (17% Faster over single line)
        - **3 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (29% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
    - **[Adaptive Density](#adaptive-density):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**

![infill-top-gyroid](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-gyroid.png?raw=true)

## Concentric

Fills the area with progressively smaller versions of the outer contour, creating a concentric pattern. Ideal for 100% infill or flexible prints.

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**  % of  total infill volume
    - **Material Usage:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
    - **Print Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
        - **Material/Time (Higher better):** High ![level-to-better-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-6.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
    - **G-code Size:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (18% Slower over single line)
        - **3 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (25% Slower over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**
    - **[Ironing](quality_settings_ironing)**
    - **[Support Interface](support_settings_advanced#interface-pattern)**

![infill-top-concentric](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-concentric.png?raw=true)

## Spiral Inset

> [!IMPORTANT]
> NEW FEATURE: **Spiral Inset pattern**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Version of [Concentric](#concentric) that joins its loops into one continuous spiral: each loop is cut short and runs straight into the next loop inside it, instead of being printed as a separate closed loop.

The outer end of the spiral is at a convex corner of the outer loop, preferably one close to a right angle, and each loop inside it continues from the point nearest to the end of the loop outside it.  
The step from one loop to the next is extruded, not traveled. When the next loop cannot be reached with a short step inside the surface (it belongs to another island, is more than four loop spacings away, or the step would cross a hole or a notch), the spiral ends and a new one starts.

On solid top and bottom surfaces, the loops use variable line widths, as in the [Arachne](quality_settings_wall_generator#arachne) wall generator, to fill the gaps that fixed-width loops would leave. Internal solid infill, support interfaces and surfaces below 100% density use fixed-width loops, and a short line into the center fills the small hole the innermost loop can leave there.  
On top and bottom surfaces, the direction of the spiral is set by [Fill Order](strength_settings_top_bottom_shells#fill-order).

- **Strength**
    - **Horizontal (X-Y):** Low ![level-to-better-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-2.svg?raw=true)
    - **Vertical (Z):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:** Same as [Concentric](#concentric).
    - **Material Usage:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **Print Time:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
        - **Material/Time (Higher better):** Normal ![level-to-better-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-4.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
    - **G-code Size:** Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** N/A
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** N/A
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** N/A
- **Applies to:**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**
    - **[Support Interface](support_settings_advanced#interface-pattern)**

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
    - **Slicing Time:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
    - **G-code Size:** High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time High ![level-to-worse-6](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-6.svg?raw=true) (20% Faster over single line)
        - **3 lines:** Print Time Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true) (31% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** Yes
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
    - **Slicing Time:** Normal-High ![level-to-worse-5](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-5.svg?raw=true)
    - **G-code Size:** Extra-High ![level-to-worse-7](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-7.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (3% Faster over single line)
        - **3 lines:** Print Time Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true) (7% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** No
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
        - **Material/Time (Higher better):** Normal-Low ![level-to-better-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-better-3.svg?raw=true)
        - **Layer time Variability:** None
    - **Slicing Time:** Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true)
    - **G-code Size:** Low ![level-to-worse-2](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-2.svg?raw=true)
- **Extra:**
    - **[Multiline](strength_settings_infill#fill-multiline):** [Classic](strength_settings_infill#classic-strategy)
        - **2 lines:** Print Time Normal ![level-to-worse-4](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-4.svg?raw=true) (4% Faster over single line)
        - **3 lines:** Print Time Normal-Low ![level-to-worse-3](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/level-to-worse-3.svg?raw=true) (9% Faster over single line)
    - **[Symmetric infill Y axis](strength_settings_infill#symmetric-infill-y-axis):** No
    - **[Smooth Factor](strength_settings_infill#sparse-infill-smooth-factor):** Yes
- **Applies to:**
    - **[Sparse Infill](strength_settings_infill#sparse-infill-density)**
    - **[Solid Infill](strength_settings_infill#internal-solid-infill)**
    - **[Surface](strength_settings_top_bottom_shells)**

![infill-top-octagram-spiral](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/fill/infill-top-octagram-spiral.png?raw=true)
