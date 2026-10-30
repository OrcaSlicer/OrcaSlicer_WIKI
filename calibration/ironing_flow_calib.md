# Ironing Flow

[Ironing](quality_settings_ironing) smooths the top surface of a print by passing the hot nozzle over it a second time while extruding a little filament. The [ironing flow](quality_settings_ironing#flow) sets how much: too little leaves the lines of the top layer visible, too much leaves a rough, over-extruded surface.

This test prints a single ironed band whose ironing flow grows steadily from one end to the other, so one print shows the whole range of flows side by side.

> [!IMPORTANT]
> NEW FEATURE: **Ironing flow calibration**
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

> [!IMPORTANT]
> This test is only useful if you use ironing. The best ironing flow depends on the filament, so repeat it for each filament you iron.

> [!TIP]
> Follow the recommended calibration order in the [Calibration Guide](calibration_guide).

## The test piece

The test piece is a thin plate made of:

- **The ironed band** at the back. Only its top layer is ironed, with lines running from front to back. The ironing flow grows linearly from the minimum at the left end of the band to the maximum at its right end.
- **Labels** in front of the band, with a mark and its ironing flow value at regular steps, and a name strip identifying the filament.

![ironing-flow-calib-model](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/IroningFlow/ironing-flow-calib-model.png?raw=true)

## Calibration

1. Pre-requisites:
    1. Calibrate the filament first, at least [Temperature](temp_calib), [Pressure Advance](pressure_advance_calib) and [Flow Ratio](flow_ratio_calib). The ironing flow is a percentage of the normal flow, so a wrong flow ratio shifts the result.
    2. Set the ironing settings you want to keep, as the test uses them: [Line spacing](quality_settings_ironing#line-spacing), [Inset](quality_settings_ironing#inset) and [Ironing speed](speed_settings_other_layers_speed#ironing-speed), or their [filament overrides](material_setting_overrides#ironing).
2. Open **Calibration → Ironing flow** and set:
    - **Minimum ironing flow** and **Maximum ironing flow**: the range of the band, between `0` and `100`%. The default `0` to `70`% covers most filaments.
    - **Length**: the length of the band. A longer band spreads the range over more millimeters, which makes it easier to read. The default is `140` mm, which puts a mark every 5%. The test is 10 mm longer than the band (5 mm on each side with constant flow value), and it must fit on the bed.

    ![ironing-flow-calib-dialog](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/IroningFlow/ironing-flow-calib-dialog.png?raw=true)

3. Slice and print the test. The test sets the ironing settings it needs (topmost surface only, rectilinear pattern, fixed angle) and a layer height of `0.12` mm.

    ![ironing-flow-calib-preview](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/IroningFlow/ironing-flow-calib-preview.png?raw=true)

4. Look at the band with light reflected on it, turning it until the light shows the surface texture:
    - On the left, where the flow is too low, the lines of the top layer are still visible.
    - On the right, where the flow is too high, the surface becomes rough with over-extruded filament.
    - In between, the lower flows give a matte surface and the higher ones a glossier one.
5. Choose the point where the lines just disappear and the surface is still smooth, and read its flow on the labels. Between two marks, estimate the value from the distance to each mark.

    ![ironing-flow-calib-reading](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/IroningFlow/ironing-flow-calib-reading.jpg?raw=true)

6. Save the value:
    - In the filament profile (**RECOMMENDED**), as the result depends on the filament: Filament settings → Setting Overrides → [Ironing](material_setting_overrides#ironing) → Ironing flow.
    - Or in the process profile: Process → Quality → Ironing → [Flow](quality_settings_ironing#flow).

> [!WARNING]
> **The ironing flow depends on the layer height.**  
> It is a percentage of the flow of one layer, so the same percentage extrudes more filament on a thicker layer. The test prints at `0.12` mm. To keep the same amount of filament at another layer height, scale the result:
>
> $$
> \text{Flow} = \text{Test flow} \times \frac{0.12}{\text{Layer height}}
> $$
>
> For example, 30% at 0.12 mm becomes 18% at 0.20 mm.

> [!NOTE]
> The test changes the process settings it needs. When you finish, create a new project to leave the calibration and discard those changes.

## Credits

- **Ironing Flow Calibration** [@Pacazo](https://github.com/Pacazo)
