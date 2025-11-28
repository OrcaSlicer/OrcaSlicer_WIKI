# Printable Space

This section defines the printer’s physical build area and how the slicer maps models to it. Configure the bed shape, dimensions and origin so the virtual bed matches your machine; use a circular or rectangular profile for standard beds or supply an STL for custom shapes. Add a texture or model to improve visual alignment in the 3D view.

Specify any excluded (unprintable) regions as a polygon so the arranger avoids them. Set the printable height to your maximum Z travel, and use Z offset to correct endstop inaccuracies (this value is added to every Z coordinate in exported G‑code). The best object position is a normalized [0–1] preference used by automatic arranging, and preferred orientation controls automatic Z-axis alignment on import.

- [Printable area (Bed Shape)](#printable-area-bed-shape)
  - [Shape](#shape)
  - [Settings](#settings)
  - [Texture](#texture)
  - [Model](#model)
- [Excluded bed area](#excluded-bed-area)
- [Printable height](#printable-height)
- [Support multi bed types](#support-multi-bed-types)
- [Best object position](#best-object-position)
- [Z offset](#z-offset)
- [Preferred orientation](#preferred-orientation)

## Printable area (Bed Shape)

Defines the printable area on the print bed.

### Shape

Shape of the printable area on the print bed.

- Rectangular: Standard rectangular print bed.
- Circular: Circular print bed.
- Custom: Custom shape defined by STL file.

### Settings

- Size: Size in X and Y of the rectangular plate.
- Origin: Distance of the 0,0 G-code coordinate from the front left corner of the rectangle.

### Texture

SVG or PNG texture image file to be used as a background for the print bed in the 3D view.

### Model

STL file defining the custom shape of the print bed.

## Excluded bed area

Unprintable area in XY plane. For example, X1 Series printers use the front left corner to cut filament during filament change. The area is expressed as polygon by points in following format: "XxY, XxY, ..."

## Printable height

This is the maximum printable height which is limited by the height of the build area.

## Support multi bed types

You can enable it in printer settings.

Once enabled, you can select the bed type in the drop-down menu, corresponding bed temperature will be set automatically.
You can set the bed temperature for each bed type in the filament settings as demonstrated in the following image.

![bed-types](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/bed-types.gif?raw=true)//TODO: UPDATE IMAGE

Orca also support `curr_bed_type` variable in custom G-code.
For example, the following sample G-codes can detect the selected bed type and adjust the G-code offset accordingly for Klipper:

```c++
{if curr_bed_type=="Textured PEI Plate"}
  SET_GCODE_OFFSET Z=-0.05
{else}
  SET_GCODE_OFFSET Z=0.0
{endif}
```

Available bed types are:

- Cool Plate
- Engineering Plate
- High Temp Plate
- Textured PEI Plate

## Best object position

Best auto arranging position in range [0,1] w.r.t. bed shape.

## Z offset

This value will be added (or subtracted) from all the Z coordinates in the output G-code. It is used to compensate for bad Z endstop position: for example, if your endstop zero actually leaves the nozzle 0.3mm far from the print bed, set this to -0.3 (or fix your endstop).

## Preferred orientation

Automatically orient STL files on the Z axis upon initial import.
