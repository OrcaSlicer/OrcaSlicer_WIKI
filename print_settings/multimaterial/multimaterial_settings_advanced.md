# Multimaterial Advanced

- [Interlocking Beam](#interlocking-beam)
- [Toolchange Ordering](#toolchange-ordering)
    - [Toolchange Order](#toolchange-order)
- [Interface Shells](#interface-shells)
- [Maximum Width of Segmented Region](#maximum-width-of-segmented-region)
- [Interlocking depth of Segmented Region](#interlocking-depth-of-segmented-region)
- [Interlocking Beam Width](#interlocking-beam-width)
- [Interlocking Direction](#interlocking-direction)
- [Interlocking Beam Layers](#interlocking-beam-layers)
- [Interlocking Depth](#interlocking-depth)
- [Interlocking Boundary Avoidance](#interlocking-boundary-avoidance)

## Interlocking Beam

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `interlocking_beam`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--interlocking-beam=1`.  
Generate interlocking beam structure at the locations where different filaments touch. This improves the adhesion between filaments, especially models printed in different materials.

## Toolchange Ordering

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `toolchange_ordering`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `default, cyclic`.  
[CLI Example](cli_mode#setting-overrides): `--toolchange-ordering=default`.  

> [!IMPORTANT]
> NEW FEATURE: **Toolchange ordering**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Determines the order of tool changes on each layer:

- **Default:** starts with the last used extruder to minimize tool changes.
- **Cyclic:** uses a fixed tool sequence each layer. This sacrifices speed for better surface quality, as the extra toolchanges allow layers more time to cool.

### Toolchange Order

[Mode](option_mode): `Expert`.  
[Variables](built_in_placeholders_variables): `toolchange_cyclic_order`, `toolchange_cyclic_first_layer`.  
[Type](option_type): `toolchange_cyclic_order` (Text), `toolchange_cyclic_first_layer` (Boolean).  
[CLI Example](cli_mode#setting-overrides): `--toolchange-cyclic-order=value` (`toolchange_cyclic_order` shown; other variables above follow their own type).  

> [!IMPORTANT]
> NEW FEATURE: **Custom cyclic toolchange sequence**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Only available when [Toolchange Ordering](#toolchange-ordering) is set to `Cyclic`.

**Cyclic order** sets the filament sequence the cyclic ordering follows, written as filament numbers separated by commas (e.g. `3,2,1,4`). Each layer prints its filaments in that order, and filaments left out of the sequence are printed last, in ascending order. Leave it empty to cycle through all filaments in ascending order.

Entries that cannot be used are dropped and the rest of the sequence still applies:

- Numbers outside the range of your filaments, such as `0` or a number higher than your filament count.
- Repeated numbers, where only the first occurrence counts.
- Anything that is not a plain number, such as `abc` or `2x`.

**Apply cyclic order to first layer** extends that sequence to the first layer as well. It is disabled by default, because the first layer is instead ordered for the best bed adhesion: filaments that print small, fragile first-layer features are printed last, so the following toolchanges and travel moves are less likely to knock those weakly anchored parts loose. This adhesion order also honors a custom first layer filament sequence when one is set, and the cooling benefit of the cyclic order does not apply to the first layer, which is printed slowly and hot for adhesion.

> [!TIP]
> Enable it only if you need the exact same tool sequence on every layer, including the first, at the cost of that adhesion optimization.

## Interface Shells

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `interface_shells`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--interface-shells=1`.  
Force the generation of solid shells between adjacent materials/volumes. Useful for multi-extruder prints with translucent materials or manual soluble support material.

## Maximum Width of Segmented Region

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `mmu_segmented_region_max_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--mmu-segmented-region-max-width=1`.  
Maximum width of a segmented region. Zero disables this feature.

## Interlocking depth of Segmented Region

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `mmu_segmented_region_interlocking_depth`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--mmu-segmented-region-interlocking-depth=1`.  
Interlocking depth of a segmented region. It will be ignored if \"mmu_segmented_region_max_width\" is zero or if \"mmu_segmented_region_interlocking_depth\" is bigger than \"mmu_segmented_region_max_width\". Zero disables this feature.

## Interlocking Beam Width

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `interlocking_beam_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--interlocking-beam-width=1`.  
The width of the interlocking structure beams.

## Interlocking Direction

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `interlocking_orientation`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--interlocking-orientation=1`.  
Orientation of interlock beams.

## Interlocking Beam Layers

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `interlocking_beam_layer_count`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--interlocking-beam-layer-count=1`.  
The height of the beams of the interlocking structure, measured in number of layers. Less layers is stronger, but more prone to defects.

## Interlocking Depth

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `interlocking_depth`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--interlocking-depth=1`.  
The distance from the boundary between filaments to generate interlocking structure, measured in cells. Too few cells will result in poor adhesion.

## Interlocking Boundary Avoidance

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `interlocking_boundary_avoidance`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--interlocking-boundary-avoidance=1`.  
The distance from the outside of a model where interlocking structures will not be generated, measured in cells.
