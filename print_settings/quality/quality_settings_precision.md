# Precision

This section covers the settings that affect the precision of your prints. These settings can help you achieve better dimensional accuracy, reduce artifacts, and improve overall print quality.

- [Slice gap closing radius](#slice-gap-closing-radius)
- [Resolution](#resolution)
- [Arc fitting](#arc-fitting)
- [X-Y Compensation](#x-y-compensation)
    - [X-Y hole compensation](#x-y-hole-compensation)
    - [X-Y contour compensation](#x-y-contour-compensation)
- [Elephant foot compensation](#elephant-foot-compensation)
    - [Elephant Foot Compensation Density](#elephant-foot-compensation-density)
- [Precise wall](#precise-wall)
    - [Technical explanation](#technical-explanation)
- [Precise Z Height](#precise-z-height)
- [Polyholes](#polyholes)
    - [Polyhole detection margin](#polyhole-detection-margin)
    - [Polyhole twist](#polyhole-twist)
    - [Maximum Polyhole edge count](#maximum-polyhole-edge-count)

## Slice gap closing radius

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `slice_closing_radius`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--slice-closing-radius=1`.  
Cracks smaller than 2x the gap closing radius are filled during the triangle mesh slicing.  
The gap closing operation may reduce the final print resolution, therefore it is advisable to keep the value reasonably low.

## Resolution

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `resolution`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--resolution=1`.  
The G-code path is generated after simplifying the contour of models to avoid too many points and G-code lines.  
Smaller values mean higher resolution and more time to slice. If you are slicing big models on machines with low processing power, you may want to increase this value to speed up the slicing process.

## Arc fitting

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `enable_arc_fitting`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `disabled, enabled, sparse_infill`.  
[CLI Example](cli_mode#setting-overrides): `--enable-arc-fitting=disabled`.  
> [!IMPORTANT]
> NEW FEATURE: **Sparse infill only arc fitting**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Replaces many short straight moves (G1 segments) with fewer circular arc commands using [G2 and G3](https://marlinfw.org/docs/gcode/G002-G003.html).  

- **Disabled**: only straight G1 moves are written.
- **Enabled**: arcs are fitted to all toolpaths.
- **Sparse infill only**: arcs are fitted to the sparse infill only, so curved patterns such as Gyroid, TPMS or a [smoothed sparse infill](strength_settings_infill#sparse-infill-smooth-factor) get smaller while walls, surfaces and supports stay as G1 moves.

Walls and surfaces are fitted within the [Resolution](#resolution), while sparse infill, supports and the wipe tower use fixed tolerances.

Arc fitting mainly changes how the toolpath is *encoded* in G-code. It can be beneficial in some workflows, but it is not a feature to improve print quality.

![arc-fitting](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/arc-fitting.svg?raw=true)

> [!IMPORTANT]
> Ensure that the printer supports G2/G3 commands!

Arc fitting is not available on [belt printers](belt_printing#features-that-are-not-available) or while [Extrusion rate smoothing](speed_settings_advanced) is enabled. Enabling Extrusion rate smoothing also turns arc fitting off.

**Advantages**

- Smaller G-code files:
    - Faster upload.
    - Less storage usage.
    - Fewer reads/writes to memory, so an SD card uses less of its already limited TBW (total bytes written).
- Fewer moves for the firmware planner to process:
    - Helps slower controllers when doing simultaneous tasks, like saving the status for [Power Loss Recovery](printer_basic_information_advanced#power-loss-recovery).
    - Helps on limited connections.
- Smoother curves when using a low poly model.

> [!NOTE]
> A `.gcode.3mf` (**Use 3MF instead of G-code** in Printer settings → Basic information → Advanced) already compresses the G-code to a quarter or a third of its size, usually more than arcs save: on 3DBenchy and the Stanford bunny, Sparse infill only saved about 5% with Grid infill and 13% to 35% with Gyroid.

**Disadvantages / risks**

- Compatibility varies: some firmware ignores G2/G3.
- Arcs can make the print slower. An arc keeps one radius, so a curve that tightens or loosens along its length, like most model curves or a smoothed infill corner, meets the next move with a sharper change of direction than the original path had. The firmware then splits each arc back into lines, and a short arc becomes a few sharp bends that the printer slows down for.
- Arcs introduce *approximation*: converting segments → arcs in OrcaSlicer and arcs → segments in firmware can slightly change the path.
- The final smoothness depends on the firmware's arc segmentation resolution; coarse settings can make curves look faceted.
- Arc-to-segment conversion increases CPU load on the printer, which can cause slow-downs (and reduced surface quality) on older/8-bit microcontrollers.

Additionally, modern STLs often have a higher resolution than the segments generated by most printer firmwares.

> [!TIP]
> For Klipper printers, **Disabled** is recommended. Klipper splits each arc into lines of its [arc resolution](https://www.klipper3d.org/Config_Reference.html#gcode_arcs), 1.0 mm by default, which is very rough, and an arc shorter than that becomes a single line. OrcaSlicer's time estimate splits arcs much more finely, so it shows less of the slowdown than the printer. Klipper's author also doubts that G2/G3 are worth it, see [Klipper issue #202](https://github.com/Klipper3d/klipper/issues/202).  
> For Marlin printers, you can adjust the variables under `#define ARC_SUPPORT` in `Configuration_adv.h`.

> [!WARNING]
> The internal generation of segments from arcs requires higher CPU usage from the printer microcontroller and therefore it might cause slow-downs (and reduced surface quality) on printers using 8-bit microcontrollers.

## X-Y Compensation

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `xy_hole_compensation`, `xy_contour_compensation`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--xy-hole-compensation=1` (same pattern for the other variables above).  
Used to compensate the XY dimensions of the model.
With these options you can compensate material expansion or shrinkage, which can occur due to various factors such as the type of filament used, temperature fluctuations, or printer calibration issues.

> [!TIP]
> Follow the [Calibration Guide](calibration_guide) and [Filament Tolerance Calibration](tolerance_calib) to determine the correct value for your printer and filament combination.

### X-Y hole compensation

Holes in objects will expand or contract in the XY plane by the configured value.  
Positive values make holes bigger, negative values make holes smaller.  
This function is used to adjust sizes slightly when objects have assembly issues.

### X-Y contour compensation

Contours of objects will expand or contract in the XY plane by the configured value.  
Positive values make contours bigger, negative values make contours smaller.  
This function is used to adjust sizes slightly when objects have assembly issues.

## Elephant foot compensation

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `elefant_foot_compensation`, `elefant_foot_compensation_layers`.  
[Type](option_type): `elefant_foot_compensation` (Float), `elefant_foot_compensation_layers` (Integer).  
[CLI Example](cli_mode#setting-overrides): `--elefant-foot-compensation=1` (`elefant_foot_compensation` shown; other variables above follow their own type).  
This feature compensates for the "elephant foot" effect, which occurs when the first few layers of a print are wider than the rest due to:

- Weight of the material above them.
- Thermal expansion of the material.
- Bed temperature being too high.
- Inaccurate bed height/leveling.

![elephant-foot](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/elephant-foot.svg?raw=true)

To mitigate this effect, OrcaSlicer allows you to specify a positive distance by which the first layer is shrunk, decreasing linearly over the specified number of layers. This adjustment effectively reduces the width of the first few layers, helping to achieve a more accurate final print size.

The compensation is only applied when the object is printed directly on the build plate. It is skipped when a [raft](support_settings_raft) is used.

![elephant-foot-compensation](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/elephant-foot-compensation.png?raw=true)

The compensation works as follows:  
When $\mathrm{current\_layer} \le \mathrm{input\_compensation\_layers}$

$$
\mathrm{compensation} = \mathrm{input\_compensation\_distance} - \frac{\mathrm{input\_compensation\_distance}}{\mathrm{input\_compensation\_layers}} \times (\mathrm{current\_layer} - 1)
$$

According to the equation, we can establish the following rules:

- In the 1st layer, since it is layer `1 - 1 = 0`, compensation is 100%.
- The intermediate layers (between the first and input_compensation_layers) will have linear compensation.
- Layers above the specified amount will not be compensated.

Assuming the compensation value is 0.25 mm:

- Elephant Foot Compensation Layers = 1 :
    - 1st layer: `0.25mm` compensation (100%)
    - 2nd layer and beyond: No compensation (0 mm)
- Elephant Foot Compensation Layers = 2 :
    - 1st layer: `0.25mm` compensation (100%)
    - 2nd layer: `0.25 − (0.25 / 2) × (2 - 1) = 0.125mm` compensation (50%)
    - 3rd layer and beyond: No compensation (0 mm).
- Elephant Foot Compensation Layers = 5 :
    - 1st layer: `0.25mm` compensation (100%)
    - 2nd layer: `0.25 − (0.25 / 5) × (2 - 1) = 0.2mm` compensation (80%)
    - 3rd layer: `0.25 − (0.25 / 5) × (3 - 1) = 0.15mm` compensation (60%)
    - 4th layer: `0.25 − (0.25 / 5) × (4 - 1) = 0.1mm` compensation (40%)
    - 5th layer: `0.25 − (0.25 / 5) × (5 - 1) = 0.05mm` compensation (20%)
    - 6th layer and beyond: No compensation (0 mm).

> [!NOTE]
> This feature makes the part look like it has a smaller footprint on the build plate in the preview, but the final print (if calibrated correctly) will have the correct dimensions.  
> That's why the brim may look disconnected from the object when this feature is enabled. But in the final print, the brim will be correctly attached to the object.  
> If you use a high Elephant foot compensation value, you may want to enable the [Brim use EFC outline](others_settings_brim#brim-use-efc-outline) option to ensure proper brim attachment.

### Elephant Foot Compensation Density

[Mode](option_mode): `Expert`.  
[Variable](built_in_placeholders_variables): `elefant_foot_layers_density`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--elefant-foot-layers-density=20%`.  
Controls the [internal solid infill](strength_settings_infill#internal-solid-infill) density used on Elephant Foot Compensation layers above the bottom layer.  
This helps reduce excess material buildup and ripple/nozzle-scrape artifacts on early solid layers when first-layer squish is high.

- Range: `50%` to `100%`
- Default: `100%` (feature disabled)

This option works together with [Elephant foot compensation layers](#elephant-foot-compensation).
For each compensated layer above the bottom layer, OrcaSlicer applies:

$$
\mathrm{effective\_density} = 1 - (1 - \mathrm{elefant\_foot\_layers\_density}) \times \frac{elefant\_foot\_compensation\_layers - (layer\_id - 1)}{elefant\_foot\_compensation\_layers}
$$

Where:

- `elefant_foot_layers_density` = 80%.
- `elefant_foot_compensation_layers` = 4.
- `layer_id` = Layer index, starting from 0 for the bottom layer.
- [Bottom Shell Layers](strength_settings_top_bottom_shells#shell-layers) > `elefant_foot_compensation_layers`. Otherwise, the adjustment will be applied only to the number of internal solid infill layers available.

Results in:

- 1st layer - Uncompensated, normal internal solid infill density (`100%`).
- 2nd layer - 1st compensated layer: `80%` density.
- 3rd layer - 2nd compensated layer: `85%` density.
- 4th layer - 3rd compensated layer: `90%` density.
- 5th layer - 4th compensated layer: `95%` density.
- Higher layers: normal internal solid infill density (`100%`).

> [!NOTE]
> This only affects internal solid infill inside the compensation zone.  
> It does not change sparse infill, top surfaces, or the bottommost layer.  
> Start with `80-90%` and `1-2` compensation layers, then tune based on visible ripples or nozzle scraping on lower solid layers.

## Precise wall

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `precise_outer_wall`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--precise-outer-wall=1`.  
The 'Precise Wall' is a distinctive feature introduced by OrcaSlicer, aimed at improving the dimensional accuracy of prints and minimizing layer inconsistencies by slightly increasing the spacing between the outer wall and the inner wall when printing in [Inner/Outer wall order](quality_settings_wall_and_surfaces#innerouter).

### Technical explanation

First, it's important to understand some basic concepts like flow, extrusion width, and spacing.  
Slic3r has an excellent document that covers these topics in detail. You can refer to this [article](https://manual.slic3r.org/advanced/flow-math).

Slic3r and its forks, such as PrusaSlicer, SuperSlicer and OrcaSlicer, assume that the extrusion path has an oval shape, which accounts for the overlaps. For example, if we set the wall width to 0.4mm and the layer height to 0.2mm, the combined thickness of two walls laid side by side is 0.714mm instead of 0.8mm due to the overlapping.

- **Precise Wall Off**

  ![PreciseWallOff](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PreciseWallOff.svg?raw=true)

- **Precise Wall On**

  ![PreciseWallOn](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PreciseWallOn.svg?raw=true)

This approach enhances the strength of 3D-printed parts. However, it does have some side effects. For instance, when the inner-outer wall order is used, the outer wall can be pushed outside, leading to potential size inaccuracy and more layer inconsistency.

It's important to keep in mind that this approach to handling flow is specific to Slic3r and its forks. Other slicing software, such as Cura, assumes that the extrusion path is rectangular and, therefore, does not include overlapping. Two 0.4 mm walls will result in a 0.8 mm shell thickness in Cura.

OrcaSlicer adheres to Slic3r's approach to handling flow. To address the downsides mentioned earlier, OrcaSlicer introduced the 'Precise Wall' feature. When this feature is enabled in OrcaSlicer, the overlap between the outer wall and its adjacent inner wall is set to zero. This ensures that the overall strength of the printed part is unaffected, while the size accuracy and layer consistency are improved.

## Precise Z Height

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `precise_z_height`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--precise-z-height=1`.  
This feature ensures the accurate Z height of the model after slicing, even if the model height is not a multiple of the [layer height](quality_settings_layer_height).

For example, slicing a 20mm x 20mm x 20.1mm cube with a layer height of 0.2mm would typically result in a final height of 20.2mm due to the layer height increments.

By enabling this parameter, the layer height of the last five layers is adjusted so that the final sliced height matches the actual object height, resulting in an accurate 20.1mm (as shown in the picture).

- **Precise Z Height Off**

  ![PreciseZOff](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PreciseZOff.png?raw=true)

- **Precise Z Height On**

  ![PreciseZOn](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PreciseZOn.png?raw=true)

## Polyholes

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `hole_to_polyhole`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--hole-to-polyhole=1`.  
A polyhole is a technique used in FFF 3D printing to improve the accuracy of circular holes. Instead of modeling a perfect circle, the hole is represented as a polygon with a reduced number of flat sides. This simplification forces the slicer to treat each segment as a straight line, which prints more reliably. By carefully choosing the number of sides and ensuring the polygon sits on the outer boundary of the hole, you can produce openings that more closely match the intended diameter.

![PolyHoles](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PolyHoles.png?raw=true)

- Original implementation: [SuperSlicer Polyholes](https://github.com/supermerill/SuperSlicer/wiki/Polyholes)
- Idea and mathematics: [Hydraraptor](https://hydraraptor.blogspot.com/2011/02/polyholes.html)

### Polyhole detection margin

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `hole_to_polyhole_threshold`.  
[Type](option_type#integer-float-percentage): `Float or Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--hole-to-polyhole-threshold=20%`.  
How far the points of a hole may deviate from its estimated circle for the hole to still be detected as circular, in mm or as a percentage of the hole radius. Cylinders are often exported with triangles of varying size, so their points are not always exactly on the circumference; a larger margin broadens the detection.

Only convex holes with more than 8 points are considered. The same margin is used to match a hole across consecutive layers, and a hole is only converted if it spans at least two layers or is on the first layer.

This option is only shown when *Convert holes to polyholes* is enabled.

### Polyhole twist

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `hole_to_polyhole_twisted`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--hole-to-polyhole-twisted=1`.  
Rotates the polyhole on every layer so its corners don't line up vertically. Each layer uses one of five orientations, spaced a fifth of the angle between two corners apart, and the sequence repeats every five layers. When disabled, every layer uses the same polygon.

This option is only shown when *Convert holes to polyholes* is enabled.

### Maximum Polyhole edge count

[Mode](option_mode): `Expert`.  
[Variable](built_in_placeholders_variables): `hole_to_polyhole_max_edges`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--hole-to-polyhole-max-edges=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Maximum Polyhole edge count**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Limits the number of sides a polyhole can have. The number of sides is calculated from the hole size and the nozzle diameter: about twice the hole diameter in mm with a 0.4 mm nozzle, proportionally fewer with larger nozzles, and never fewer than 3. With the default of 50, holes larger than about 25 mm are capped when using a 0.4 mm nozzle.

This option is only shown when *Convert holes to polyholes* is enabled.
