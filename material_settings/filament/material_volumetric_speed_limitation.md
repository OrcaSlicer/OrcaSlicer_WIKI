# Material Volumetric Speed Limitation

This setting allows you to limit the volumetric speed of extrusion for a specific material. It helps to prevent issues such as under-extrusion or poor layer adhesion that can occur when printing at high speeds.

## Adaptive volumetric speed

When enabled, the extrusion flow is limited by the smaller of the fitted value (calculated from line width and layer height) and the user-defined maximum flow. When disabled, only the user-defined maximum flow is applied.

## Max volumetric speed

This setting is the volume of filament that can be melted and extruded per second. Printing speed is limited by max volumetric speed, in case of too high and unreasonable speed setting. This value cannot be zero.
