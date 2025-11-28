# Material Flow Ratio and Pressure Advance

Flow ratio and pressure advance settings for the selected material.

## Flow Ratio

The material may have volumetric change after switching between molten and crystalline states. This setting changes all extrusion flow of this filament in G-code proportionally.  
The recommended value range is between 0.95 and 1.05. You may be able to tune this value to get a nice flat surface if there is slight overflow or underflow.  
The final object flow ratio is this value multiplied by the filament flow ratio.

### Pressure Advance

Pressure advance (Klipper) AKA Linear advance factor (Marlin).

> [!NOTE]
> Auto calibration result will be overwritten once enabled

### Enable adaptive Pressure Advance (beta)

With increasing print speeds (and hence increasing volumetric flow through the nozzle) and increasing accelerations, it has been observed that the effective PA value typically decreases. This means that a single PA value is not always 100% optimal for all features and a compromise value is usually used that does not cause too much bulging on features with lower flow speed and accelerations while also not causing gaps on faster features.

This feature aims to address this limitation by modeling the response of your printer's extrusion system depending on the volumetric flow speed and acceleration it is printing at. Internally, it generates a fitted model that can extrapolate the needed pressure advance for any given volumetric flow speed and acceleration, which is then emitted to the printer depending on the current print conditions.

When enabled, the pressure advance value above is overridden. However, a reasonable default value above is strongly recommended to act as a fallback and for when tool changing.
