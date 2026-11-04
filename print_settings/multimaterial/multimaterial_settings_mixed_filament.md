# Mixed Filament

A mixed filament combines two or more loaded filaments of the same type into an extra filament slot, so you can print colors you don't have loaded. You create one in the **Mixed Filament** section under the filament list in the sidebar.

## Mixed color sublayer

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `enable_mixed_color_sublayer`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--enable-mixed-color-sublayer=1`.  
Splits each layer that uses a mixed filament into sub-layers, one for each component filament. The height of each sub-layer follows the mix ratio. This blends the colors more finely. The first layer is not split, to keep bed adhesion.

When this option is off, each layer prints a single component filament and the components alternate layer by layer. The mix ratio is rounded to a simple fraction for this.

A gradient mixed filament needs this option. If it is off, the slicer shows a warning and the gradient is not printed.

> [!NOTE]
> Variable layer height and height ranges change the sub-layer heights from layer to layer, which can reduce the quality of the color mix. The slicer warns you when you combine them with this option.
