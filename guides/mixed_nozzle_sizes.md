# Mixed Nozzle Sizes

Since v2.2.0-beta, OrcaSlicer allows you to use different nozzle sizes in the same print.  
This feature is extremely useful with the growing popularity of multi-nozzle printers, enabling faster and stronger prints while improving quality.

![cube_line_width](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/multi-tool/cube_line_width.png?raw=true)

## Setup

### Machine

To use mixed nozzle sizes, you need to set each extruder's nozzle diameter in the [Machine settings / Extruder [Number] / Basic Information](printer_extruder_basic_information#nozzle-diameter) section.

For example:

- Extruder 1: `0.4mm` Standard nozzle
- Extruder 2: `0.6mm` Big nozzle for faster surface printing
- Extruder 3: `0.2mm` Small nozzle for fine details at Walls
- Extruder 4: `1.0mm` Extra-large nozzle for very fast infill

![multi_nozzle_diam](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/extruder/multi_nozzle_diam.gif?raw=true)

### Process

For MultiNozzle processes, you need to make the profile Nozzle agnostic by setting each [line width](quality_settings_line_width) to a percentage of the nozzle diameter.  
This allows the slicer to automatically adjust the line width for each extruder based on its nozzle size, ensuring consistent print quality across different nozzle sizes.

![line_width](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/multi-tool/line_width.png?raw=true)

A quick way to make the profile Nozzle agnostic is to divide each line width by the nozzle diameter and set it as a percentage.  
For example, if the line width is set to `0.4mm` and the nozzle diameter is `0.4mm`, you would set the line width to `100%` of the nozzle diameter.  
If the line width is set to `0.48mm` and the nozzle diameter is `0.4mm`, you would set the line width to `120%` of the nozzle diameter.

### Material

Pressure advance changes with different nozzle sizes, so you may need to calibrate it for each extruder and create a Filament profile for each material and nozzle size combination.
Most of the other settings can be shared between the different nozzle sizes, but you may want to create separate profiles if you want to use different line widths or other settings for each nozzle size.

> [!NOTE]
> On printers with more than one extruder of a different type, such as the X2D (Bowden and Direct Drive), the material settings will have tabs with different configuration groups for each type.

## Selecting Nozzle Sizes

To assign specific nozzle sizes to different features of the print, you can use the [Filament for Features](multimaterial_settings_filament_for_features) settings or the [Color Painting Tool](prepare_color_painting).
