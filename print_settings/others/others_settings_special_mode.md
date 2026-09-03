# Special Mode

These settings control advanced slicing and printing behaviours, such as how layers are processed, object printing order, and special effects like spiral vase mode.

- [Slicing Mode](#slicing-mode)
    - [Regular](#regular)
    - [Close Holes](#close-holes)
    - [Even Odd](#even-odd)
- [Print Sequence](#print-sequence)
    - [By Layer](#by-layer)
        - [Intra-layer order](#intra-layer-order)
    - [By Object](#by-object)
- [Spiral vase](#spiral-vase)
    - [Smooth Spiral](#smooth-spiral)
        - [Max XY Smoothing](#max-xy-smoothing)
    - [Spiral starting flow ratio](#spiral-starting-flow-ratio)
    - [Spiral finishing flow ratio](#spiral-finishing-flow-ratio)
- [Timelapse](#timelapse)
    - [Traditional](#traditional)
    - [Smooth](#smooth)

## Slicing Mode

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `slicing_mode`.  
The slicing mode determines how the model is sliced into layers and how the G-code is generated. Different modes can be used to achieve various printing effects or to optimize the print process.

### Regular

This is the default slicing mode. It slices the model layer by layer, generating G-code for each layer.  
Use this for most prints where no special modifications are needed.

### Close Holes

Use "Close holes" to automatically close all holes in the model during slicing in the XY plane.  
This can help with models that have gaps or incomplete surfaces, ensuring a more solid print.

![close-holes](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/slicing-mode/close-holes.png?raw=true)

### Even Odd

Use "Even-odd" for specific models like [3DLabPrint](https://3dlabprint.com) airplane models. This mode applies a special slicing algorithm that may be required for certain proprietary or experimental prints.

## Print Sequence

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `print_sequence`.  
This setting controls how multiple objects are printed in a single print job.

### By Layer

This option prints all objects layer by layer, one layer at a time. This is efficient for multi-part prints as it minimises travel time between objects and can improve overall print speed.

#### Intra-layer order

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `print_order`.  
Determines the order in which object instances are visited within a single layer, which controls how much travel is spent moving between them.

Shorter, more cyclic paths reduce oozing and avoid dragging the nozzle over parts that have already been printed, which can make [Z Hop](printer_extruder_z_hop) and [Avoid crossing walls](quality_settings_wall_and_surfaces#avoid-crossing-walls) unnecessary in many plates.

> [!IMPORTANT]
> NEW FEATURE: **Snake and Best of all (shortest path) intra-layer ordering**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

- **Default**: Nearest-neighbour chaining, refined with 2-opt and crossing removal. A good general choice and the recommended option for most plates.
- **As object list**: Instances are printed in the same order as the object list, without any path optimisation. Use it when you need a predictable, manually controlled order, for custom sequencing or debugging.
- **Snake**: Serpentine, row-by-row traversal (objects are grouped into rows and each row is traversed in the opposite direction to the previous one), refined with 2-opt. Well suited to regular grids of many small parts.
- **Best of all (shortest path)**: Every strategy is evaluated and the shortest one is used. The object instance order is decided once for the whole print, while the ordering of individual islands is decided per layer, so different layers may end up using different strategies. Slightly slower to slice.

> [!NOTE]
> Ordering is applied at the island level, not only per instance, so each separate region of a layer is ordered individually. This mainly benefits assemblies and objects whose layers overlap.
>
> With multiple filaments or tools in the same layer, minimising tool changes takes priority: objects are grouped by filament first, and this setting only orders the instances within each filament group. The overall sequence may therefore not look like the shortest path across the plate.

### By Object

This option prints each object completely before moving on to the next object. This is better for prints where objects need to cool separately or when using different materials per object, but it may increase total print time due to more travel moves.

This setting requires more models separation and may not be suitable for all print scenarios.

## Spiral vase

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `spiral_mode`.  
Spiral vase mode transforms a solid model into a single-walled print with solid bottom layers, eliminating seams by continuously spiralling the outer contour.  
This creates a smooth, vase-like appearance.

### Smooth Spiral

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `spiral_mode_smooth`.  
When enabled, Smooth Spiral smooths out X and Y moves as well, resulting in no visible seams even on non-vertical walls.  
This produces the smoothest possible spiral print.

> [!NOTE]
> If you are using absolute e distances, the smoothing may not work as expected.

#### Max XY Smoothing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `spiral_mode_max_xy_smoothing`.  
Maximum distance to move points in XY to achieve a smooth spiral. If expressed as a percentage, it is calculated relative to the nozzle diameter.  
Higher values allow more smoothing but may distort the model slightly.

### Spiral starting flow ratio

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `spiral_starting_flow_ratio`.  
Sets the starting flow ratio when transitioning from the last bottom layer to the spiral.  
Normally, the flow scales from 0% to 100% during the first loop, which can sometimes cause under-extrusion at the start.  
Adjust this to fine-tune the transition and prevent issues.

### Spiral finishing flow ratio

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `spiral_finishing_flow_ratio`.  
Sets the finishing flow ratio when ending the spiral. Normally, the flow scales from 100% to 0% during the last loop, which can lead to under-extrusion at the end.  
Use this to control the ending and ensure consistent extrusion.

## Timelapse

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `timelapse_type`.  
Timelapse controls how OrcaSlicer asks the printer to capture a frame at layer changes. The generated commands come from the printer profile's [Timelapse G-code](printer_machine_gcode#timelapse-g-code) or layer-change G-code.

The Timelapse selector is shown for Bambu Lab printers and for printer profiles that opt in with `support_smooth_timelapse = 1`.

A profile that supports Smooth timelapse should also provide G-code that branches on `timelapse_type`, for example:

```gcode
{if timelapse_type == 1} ; smooth timelapse
; move to a safe/waste position
TIMELAPSE_TAKE_FRAME
{elsif timelapse_type == 0} ; traditional timelapse
TIMELAPSE_TAKE_FRAME
{endif}
```

### Traditional

Traditional mode (`0`) is intended for printers that can capture a frame at the current layer-change position. It usually has the least effect on print time and toolhead motion, but the toolhead may appear in the timelapse and object framing may vary between layers.

Printer profiles commonly implement this with a simple frame command such as `TIMELAPSE_TAKE_FRAME` in `time_lapse_gcode` or `layer_change_gcode`.

### Smooth

Smooth mode (`1`) is intended for printer profiles that define a safe parking sequence before each frame. The profile G-code typically retracts, raises Z, moves the toolhead to a waste chute or other safe position, triggers the frame capture, and returns to printing.

> [!NOTE]
> Smooth timelapse functionality is entirely dictated by the machine's G-code, OrcaSlicer just presents the value as a variable to the profile. Whether a prime or wipe tower is necessary is entirely up to how this functionality is implemented for your specific printer profile.


