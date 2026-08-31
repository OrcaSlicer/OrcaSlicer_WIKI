# Multimaterial Advanced

- [Interlocking Beam](#interlocking-beam)
- [Toolchange Ordering](#toolchange-ordering)
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
