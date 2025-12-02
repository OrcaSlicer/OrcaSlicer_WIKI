# Material Volumetric Speed Limitation

Each material profile includes a **maximum volumetric speed** setting, which limits your [print speed](speed_settings_other_layers_speed) to prevent issues like nozzle clogs, under-extrusion, or poor layer adhesion.

> [!TIP]
> Calibrating the maximum volumetric speed for each filament you use is highly recommended. Refer to the [Max Volumetric Speed (FlowRate) Calibration](volumetric-speed-calib) guide for detailed instructions on how to perform this calibration.

## Adaptive volumetric speed

When enabled, the extrusion flow is limited by the smaller of the fitted value (calculated from line width and layer height) and the user-defined maximum flow. When disabled, only the user-defined maximum flow is applied.

## Max volumetric speed

This setting is the volume of filament that can be melted and extruded per second. Printing speed is limited by max volumetric speed, in case of too high and unreasonable speed setting. This value cannot be zero.
