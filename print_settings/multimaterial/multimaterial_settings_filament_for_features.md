# Filament for Features

These settings allow you to specify which extruder to use for different features of the print, such as walls, infill, and wipe tower.

<div class="orca-video-embed">
  <a class="orca-video-poster-link" href="https://www.youtube.com/watch?v=hcuQw55OzjU" aria-label="Watch filament for features video">
    <img alt="filament-for-features-video" src="https://img.youtube.com/vi/hcuQw55OzjU/maxresdefault.jpg">
  </a>
</div>

![filament_for_features](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/filament-for-features/filament_for_features.png?raw=true)

## Outer Walls

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `outer_wall_filament_id`.  
Filament to print outer walls.  
This can also be used to use a translucent filament for outer walls to achieve a frosted glass effect.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), it's recommended to use the smaller nozzle for outer walls to achieve better surface quality and detail.

## Inner Walls

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `inner_wall_filament_id`.  
Filament to print inner walls.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), you can use a larger nozzle for inner walls to speed up printing while maintaining good layer adhesion.

## Sparse Infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `sparse_infill_filament_id`.  
Filament to print internal sparse infill.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), you can use a larger nozzle for infill to speed up printing while maintaining good layer adhesion.

## Internal Solid Infill

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `internal_solid_filament_id`.  
Filament to print internal solid infill.
When using a [mixed nozzle size setup](mixed_nozzle_sizes), you can use a larger nozzle for internal solid infill to speed up printing while maintaining good layer adhesion.

## Top Surface

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `top_surface_filament_id`.  
Filament to print top surfaces.  
It's recommended to use the same filament for top surfaces as for outer walls to achieve a consistent appearance.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), it's recommended to use the smaller nozzle for top surfaces to achieve better surface quality and detail.

## Bottom Surface

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `bottom_surface_filament_id`.  
Filament to print bottom surfaces.  
This can be used to use a different filament for the bottom layer, such as a more adhesive filament to improve bed adhesion.  
When using a [mixed nozzle size setup](mixed_nozzle_sizes), you can use a larger nozzle for bottom surfaces to speed up printing while maintaining good layer adhesion.

## Wipe Tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_filament`.  
The extruder to use when printing perimeter of the wipe tower. Set to 0 to use the one that is available (non-soluble would be preferred).
