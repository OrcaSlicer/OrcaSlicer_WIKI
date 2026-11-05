# Multicolor

These settings control how colors are printed: how far the colors applied with [Color Painting](prepare_color_painting) reach into the model, and how mixed filaments are layered.

- [Paint Penetration Layers](#paint-penetration-layers)
- [Horizontal Paint Penetration](#horizontal-paint-penetration)
- [Mixed Color Sublayer](#mixed-color-sublayer)

## Paint Penetration Layers

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `top_color_penetration_layers`, `bottom_color_penetration_layers`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--top-color-penetration-layers=1` (same pattern for the other variables above).  

> [!IMPORTANT]
> NEW FEATURE: **Paint penetration layers**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

When a top or bottom surface is painted with [Color Painting](prepare_color_painting), its color is also printed in the layers under a painted top surface and over a painted bottom surface, so the filament behind the paint doesn't show through. This is the number of layers that take the color, including the surface layer.  
Each layer further from the surface is colored about two line widths narrower than the one before, so the color tapers into the model instead of reaching its walls.

- **0:** uses the [Shell Layers](strength_settings_top_bottom_shells#shell-layers) count. This is the default, and how painted surfaces were always printed before this setting existed.
- **Lower values:** keep a thick shell for strength while printing fewer layers in the painted color, saving a filament change and its purge on each layer left out.
- **Higher values:** give a deeper, more saturated color, which helps with translucent or light filaments that let the layers behind them show through.

> [!WARNING]
> Keep the value within the shell, which is the larger of [Shell Layers](strength_settings_top_bottom_shells#shell-layers) and the layers needed to reach [Shell Thickness](strength_settings_top_bottom_shells#shell-thickness). A larger value also colors the [sparse infill](strength_settings_infill) under or over the painted area, adding filament changes where they can't be seen.

## Horizontal Paint Penetration

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `mmu_segmented_region_max_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--mmu-segmented-region-max-width=1`.  
How far a color painted on a side surface reaches into the model, measured in millimeters from the outer surface. It is the side counterpart of the [Paint Penetration Layers](#paint-penetration-layers) of top and bottom surfaces.

- **0:** the color reaches the middle of the model, halfway to the opposite side. This is the default.
- **Other values:** the color stops at this depth and the rest of the layer keeps the base filament, saving the painted filament that would never be seen. A value around the thickness of the [walls](strength_settings_walls#wall-loops) leaves the color in the walls only.

Hidden and ignored when [Interlocking Beam](multimaterial_settings_advanced#interlocking-beam) is enabled.

## Mixed Color Sublayer

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `enable_mixed_color_sublayer`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--enable-mixed-color-sublayer=1`.  
A mixed filament combines two or more loaded filaments of the same type into an extra filament slot, so you can print colors you don't have loaded. You create one in the **Mixed Filament** section under the filament list in the sidebar.

This setting splits each layer that uses a mixed filament into sub-layers, one for each component filament. The height of each sub-layer follows the mix ratio. This blends the colors more finely. The first layer is not split, to keep bed adhesion.

When this option is off, each layer prints a single component filament and the components alternate layer by layer. The mix ratio is rounded to a simple fraction for this.

A gradient mixed filament needs this option. If it is off, the slicer shows a warning and the gradient is not printed.

> [!NOTE]
> Variable layer height and height ranges change the sub-layer heights from layer to layer, which can reduce the quality of the color mix. The slicer warns you when you combine them with this option.
