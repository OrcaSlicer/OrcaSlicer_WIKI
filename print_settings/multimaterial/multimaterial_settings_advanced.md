# Multimaterial Advanced

- [Interlocking Beam](#interlocking-beam)
- [Interface Shells](#interface-shells)
- [Maximum Width of Segmented Region](#maximum-width-of-segmented-region)
- [Interlocking depth of Segmented Region](#interlocking-depth-of-segmented-region)
- [Interlocking Beam Width](#interlocking-beam-width)
- [Interlocking Direction](#interlocking-direction)
- [Interlocking Beam Layers](#interlocking-beam-layers)
- [Interlocking Depth](#interlocking-depth)
- [Interlocking Boundary Avoidance](#interlocking-boundary-avoidance)

## Interlocking Beam

[Variable](Built-in-placeholders-variables): `interlocking_beam`.  
Generate interlocking beam structure at the locations where different filaments touch. This improves the adhesion between filaments, especially models printed in different materials.

## Interface Shells

[Variable](Built-in-placeholders-variables): `interface_shells`.  
Force the generation of solid shells between adjacent materials/volumes. Useful for multi-extruder prints with translucent materials or manual soluble support material.

## Maximum Width of Segmented Region

[Variable](Built-in-placeholders-variables): `mmu_segmented_region_max_width`.  
Maximum width of a segmented region. Zero disables this feature.

## Interlocking depth of Segmented Region

[Variable](Built-in-placeholders-variables): `mmu_segmented_region_interlocking_depth`.  
Interlocking depth of a segmented region. It will be ignored if \"mmu_segmented_region_max_width\" is zero or if \"mmu_segmented_region_interlocking_depth\" is bigger than \"mmu_segmented_region_max_width\". Zero disables this feature.

## Interlocking Beam Width

[Variable](Built-in-placeholders-variables): `interlocking_beam_width`.  
The width of the interlocking structure beams.

## Interlocking Direction

[Variable](Built-in-placeholders-variables): `interlocking_orientation`.  
Orientation of interlock beams.

## Interlocking Beam Layers

[Variable](Built-in-placeholders-variables): `interlocking_beam_layer_count`.  
The height of the beams of the interlocking structure, measured in number of layers. Less layers is stronger, but more prone to defects.

## Interlocking Depth

[Variable](Built-in-placeholders-variables): `interlocking_depth`.  
The distance from the boundary between filaments to generate interlocking structure, measured in cells. Too few cells will result in poor adhesion.

## Interlocking Boundary Avoidance

[Variable](Built-in-placeholders-variables): `interlocking_boundary_avoidance`.  
The distance from the outside of a model where interlocking structures will not be generated, measured in cells.
