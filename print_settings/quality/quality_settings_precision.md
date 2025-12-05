# Precision

This section covers the settings that affect the precision of your prints. These settings can help you achieve better dimensional accuracy, reduce artifacts, and improve overall print quality.

- [Slice gap closing radius](#slice-gap-closing-radius)
- [Resolution](#resolution)
- [Arc fitting](#arc-fitting)
- [X-Y Compensation](#x-y-compensation)
  - [X-Y hole compensation](#x-y-hole-compensation)
  - [X-Y contour compensation](#x-y-contour-compensation)
- [Elephant foot compensation](#elephant-foot-compensation)
- [Precise wall](#precise-wall)
  - [Technical explanation](#technical-explanation)
- [Precise Z Height](#precise-z-height)
- [Polyholes](#polyholes)

## Slice gap closing radius

Cracks smaller than 2x gap closing radius are being filled during the triangle mesh slicing.  
The gap closing operation may reduce the final print resolution, therefore it is advisable to keep the value reasonably low.

## Resolution

The G-code path is generated after simplifying the contour of models to avoid too many points and G-code lines.  
Smaller value means higher resolution and more time to slice. If you are using big models in low processing power machines, you may want to increase this value to speed up the slicing process.

## Arc fitting

Enable this to combine moves by approximating multiple straight segments into fewer arcs which use [G2 and G3](https://marlinfw.org/docs/gcode/G002-G003.html) moves. __Ensure first that the printer supports said commands__.

This combination results in a "compression" of the G-Code, which will need fewer commands to print arcs. This is the main purpose of this feature, since printers receiving G-code via USB are likely to be overloaded by the number of short moves required to print arcs. It can also be useful when a long series of quick segments is generated, for example like those used to perform spiral Z hop.

This feature could potentially improve the print quality of some _low resolution_ STL models if curved surfaces were approximated using rough segments. In such models, the printer will also be able to move in a more fluid manner, since the rough moves are replaced with a smoother motion. 

__Good quality STLs and modern printers will not benefit from this feature and could experience a reduction the surface quality__, therefore use arc fitting only where needed, which is typically for USB-connected printers and for some low quality models for which a higher resolution is not available.

![arc-fitting](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/arc-fitting.svg?raw=true)

> [!IMPORTANT]
> The printer will internally convert the arcs back into a series of segments, which are in many printers by default less accurate than those already defined in high quality, modern STLs.
>
> For Klipper printers see the [documentation](https://www.klipper3d.org/Config_Reference.html#gcode_arcs) for setting the resolution of the arcs generated internally.
>
> In general, this feature should be used to solve problems and not as a default setting, unless the settings of the printer firmware are carefully checked to ensure a sufficiently high resolution which _exceeds_ the resolution of the original STL.
> 
> The internal generation of segments from arcs requires higher CPU usage from the printer microcontroller and therefore it might cause slow-downs (and reduced surface quality) on printers using 8-bit microcontrollers.

## X-Y Compensation

Used to compensate external dimensions of the model.
With this option you can compensate material expansion or shrinkage, which can occur due to various factors such as the type of filament used, temperature fluctuations, or printer calibration issues.

> [!TIP]
> Follow the [Calibration Guide](https://github.com/OrcaSlicer/OrcaSlicer/wiki/Calibration) and [Filament Tolerance Calibration](https://github.com/OrcaSlicer/OrcaSlicer/wiki/tolerance-calib) to determine the correct value for your printer and filament combination.

### X-Y hole compensation

Holes in objects will expand or contract in the XY plane by the configured value.  
Positive values make holes bigger, negative values make holes smaller.  
This function is used to adjust sizes slightly when the objects have assembling issues.

### X-Y contour compensation

Contours of objects will expand or contract in the XY plane by the configured value.  
Positive values make contours bigger, negative values make contours smaller.  
This function is used to adjust sizes slightly when the objects have assembling issues.

## Elephant foot compensation

This feature compensates for the "elephant foot" effect, which occurs when the first few layers of a print are wider than the rest due:

- Weight of the material above them.
- Thermal expansion of the material.
- Bed temperature being too high.
- Inaccurate bed height.

![elephant-foot](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/elephant-foot.svg?raw=true)

To mitigate this effect, OrcaSlicer allows you to specify a negative distance that will be applied to the first specified number of layers. This adjustment effectively reduces the width of the first few layers, helping to achieve a more accurate final print size.

![elephant-foot-compensation](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/elephant-foot-compensation.png?raw=true)

The compensation works as follows:  
When the `current_layer` is <= `input_compensation_layers`
```c++
compensation = input_compensation_distance - (input_compensation_distance / input_compensation_layers) × (current_layer - 1)
```
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

## Precise wall

The 'Precise Wall' is a distinctive feature introduced by OrcaSlicer, aimed at improving the dimensional accuracy of prints and minimizing layer inconsistencies by slightly increasing the spacing between the outer wall and the inner wall when printing in [Inner Outer wall order](quality_settings_wall_and_surfaces#innerouter).

### Technical explanation

First, it's important to understand some basic concepts like flow, extrusion width, and space.  
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

This feature ensures the accurate Z height of the model after slicing, even if the model height is not a multiple of the [layer height](quality_settings_layer_height).

For example, slicing a 20mm x 20mm x 20.1mm cube with a layer height of 0.2mm would typically result in a final height of 20.2mm due to the layer height increments.

By enabling this parameter, the layer height of the last five layers is adjusted so that the final sliced height matches the actual object height, resulting in an accurate 20.1mm (as shown in the picture).

- **Precise Z Height Off**

  ![PreciseZOff](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PreciseZOff.png?raw=true)

- **Precise Z Height On**

  ![PreciseZOn](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PreciseZOn.png?raw=true)

## Polyholes

A polyhole is a technique used in FFF 3D printing to improve the accuracy of circular holes. Instead of modeling a perfect circle, the hole is represented as a polygon with a reduced number of flat sides. This simplification forces the slicer to treat each segment as a straight line, which prints more reliably. By carefully choosing the number of sides and ensuring the polygon sits on the outer boundary of the hole, you can produce openings that more closely match the intended diameter.

![PolyHoles](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Precision/PolyHoles.png?raw=true)

- Original implementation: [SuperSlicer Polyholes](https://github.com/supermerill/SuperSlicer/wiki/Polyholes)
- Idea and mathematics: [Hydraraptor](https://hydraraptor.blogspot.com/2011/02/polyholes.html)
