# Skirt

A skirt is one or more additional perimeters printed around the model outline on the first layer(s). It helps prime the hotend, stabilize extrusion before the model starts, and can act as a basic wind/draft shield when built taller.

- [Loops](#loops)
- [Type](#type)
    - [Combined](#combined)
    - [Per object](#per-object)
- [Minimum extrusion Length](#minimum-extrusion-length)
- [Distance](#distance)
- [Start point](#start-point)
- [Speed](#speed)
- [Height](#height)
- [Shield](#shield)
- [Single loop after first layer](#single-loop-after-first-layer)

## Loops

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `skirt_loops`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--skirt-loops=1`.  
Number of skirt loops to print.  
Usually 2 loops are recommended, but more loops improve priming and give a larger buffer between the nozzle and the part, at the cost of extra filament and time.  
Set to 0 to disable the skirt.

![skirt](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/skirt/skirt.png?raw=true)

## Type

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `skirt_type`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `combined, perobject`.  
[CLI Example](cli_mode#setting-overrides): `--skirt-type=combined`.  

### Combined

A single skirt that surrounds all objects on the bed.
  Recommended for general use.

![skirt-combined](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/skirt/skirt-combined.png?raw=true)

### Per object

Each object gets its own skirt printed separately. Objects close enough for their skirts to overlap share a single skirt.
  Recommended when using [Print sequence by object](others_settings_special_mode#by-object).

![skirt-per-object](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/skirt/skirt-per-object.png?raw=true)

## Minimum extrusion Length

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `min_skirt_length`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--min-skirt-length=1`.  
Minimum filament extrusion length in mm when printing the skirt. Zero means this feature is disabled.  
Using a non-zero value is useful if the printer is set up to print without a prime line.  
The final number of loops is not taken into account when arranging objects or validating the distance between them. Increase the number of loops in that case.

## Distance

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `skirt_distance`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--skirt-distance=1`.  
Distance from skirt to brim or object.  
Increasing this distance can help avoid collisions with brims or supports, but will increase the footprint of the skirt and filament usage.

## Start point

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `skirt_start_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--skirt-start-angle=1`.  
Start angle for the skirt relative to the object center. 0° is the right-most position (along the +X axis), angles increase counter-clockwise.  
Use this to control where the skirt begins to better align with part features or prime locations.

## Speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `skirt_speed`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--skirt-speed=1`.  
Printing speed for the skirt in mm/s. Set to 0 to use the [First layer infill](speed_settings_initial_layer_speed#initial-layer-infill) speed on the first layer and the [Support](speed_settings_other_layers_speed#support) speed on higher layers.  
Slower speeds give a more reliable prime; very fast skirt speeds may not adhere properly and come off, causing problems with the part.

## Height

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `skirt_height`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--skirt-height=1`.  
Number of layers the skirt should be printed for. Usually 1 layer for priming. Increase the height if you want a taller draft shield effect.

## Shield

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `draft_shield`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `disabled, enabled`.  
[CLI Example](cli_mode#setting-overrides): `--draft-shield=disabled`.  
When enabled, the skirt is printed as a draft shield: a taller wall surrounding the part to help protect prints (especially ABS/ASA) from drafts and sudden temperature changes.  
This is most useful for open-frame printers without an enclosure.

- Enabled: the shield is as tall as the tallest printed model on the bed.
- Disabled: the skirt uses the [Height](#height) value.

> [!NOTE]
> The skirt is printed at the [skirt distance](#distance) from the brim, or from the object if it has no brim, so the draft shield does not intersect brims.

## Single loop after first layer

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `single_loop_draft_shield`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--single-loop-draft-shield=1`.  
When enabled, limits the skirt or draft shield to a single wall after the first layer (i.e. only one loop is printed on subsequent layers). This reduces filament and print time but makes the shield less robust and more prone to warping or cracking.
