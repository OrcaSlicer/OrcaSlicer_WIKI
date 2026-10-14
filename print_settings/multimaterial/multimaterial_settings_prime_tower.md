# Prime Tower

[Modes](option_mode):  
`Simple` [Variables](built_in_placeholders_variables): `enable_prime_tower`, `prime_volume`.  
`Advanced` [Variables](built_in_placeholders_variables): `prime_tower_skip_points`, `enable_tower_interface_features`, `enable_tower_interface_cooldown_during_tower`, `prime_tower_enable_framework`, `prime_tower_infill_gap`, `single_extruder_multi_material_priming`.  
[Type](option_type): `enable_prime_tower` (Boolean), `prime_volume` (Float), `prime_tower_skip_points` (Boolean), `enable_tower_interface_features` (Boolean), `enable_tower_interface_cooldown_during_tower` (Boolean), `prime_tower_enable_framework` (Boolean), `prime_tower_infill_gap` (Percentage), `single_extruder_multi_material_priming` (Boolean).  
[CLI Example](cli_mode#setting-overrides): `--enable-prime-tower=1` (`enable_prime_tower` shown; other variables above follow their own type).  
The prime tower can be used to clean up residue on the nozzle and stabilize the chamber pressure inside the nozzle, in order to avoid appearance defects when printing objects.

> [!NOTE]
> Some settings on this page depend on the printer's [Wipe tower type](printer_multimaterial_wipe_tower). Bambu Lab printers always use the Type 1 tower. [Wipe Tower Rotation Angle](#wipe-tower-rotation-angle), [Maximal bridging distance](#maximal-bridging-distance), [Wipe tower purge lines spacing](#wipe-tower-purge-lines-spacing), [Extra flow for purge](#extra-flow-for-purge), [Maximum wipe tower print speed](#maximum-wipe-tower-print-speed) and [Stabilization cone apex angle](#stabilization-cone-apex-angle) are only shown with the Type 2 tower.

## Skip points

Leaves a short gap in the outer wall of the prime tower where each tool change starts its purge, so the nozzle enters the tower through the gap instead of crossing the printed wall. Enabled by default. It has no effect on the [Cone](#cone) wall of the Type 2 tower.

## Enable tower interface features

Changes how the prime tower is printed on interface layers, where different materials meet. On these layers the nozzle is heated to the filament's **Interface layer print temperature** (its maximum recommended nozzle temperature when set to -1), and extra filament can be pre-extruded before the purge. These values are set per filament in [Multimaterial Wipe Tower Parameters](material_multimaterial#multimaterial-wipe-tower-parameters).

The Type 1 tower applies this on the layers where a material category starts or stops being printed on the tower. The Type 2 tower applies it on every layer with a filament change, and also adds the filament's **Interface layer purge length** to the purge.

### Cool down from interface boost during prime tower

Only shown when [Enable tower interface features](#enable-tower-interface-features) is enabled, and only used by the Type 2 tower. After heating to the interface temperature, the nozzle is set back to its print temperature at the start of the purge, so it cools down while the tower is printed. When disabled, the print temperature is restored only after the purge is finished.

## Internal ribs

Adds internal ribs to increase the stability of the prime tower. Only used by the Type 1 tower, where each purge section of the tower keeps its full size up to the top instead of shrinking on upper layers that need less purging.

## Width

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `prime_tower_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--prime-tower-width=1`.  
Width of the prime tower.

## Prime volume

Volume of material, in mm³, printed on the prime tower after each tool change to prime the new extruder. Default is 45 mm³.

Unless the printer is a single extruder multi-material printer with [Purge in prime tower](printer_multimaterial_wipe_tower#purge-in-prime-tower) enabled, the Type 2 tower purges this fixed volume at each tool change instead of the flushing volumes. On such printers the tower purges the flushing volumes and this option is hidden. The Type 1 tower takes the prime volume from each filament profile and uses this value only as a fallback.

## Brim width

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `prime_tower_brim_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--prime-tower-brim-width=1`.  
Width of the brim around the prime tower.

## Infill gap

Spacing of the purge lines on the Type 1 prime tower, as a percentage of the line width. At 100% the lines are placed right next to each other; higher values leave gaps between them and make the tower larger for the same purge volume. Default is 150%.

The Type 2 tower ignores it and uses [Wipe tower purge lines spacing](#wipe-tower-purge-lines-spacing) instead.

## Wipe Tower Rotation Angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_rotation_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-rotation-angle=1`.  
Wipe tower rotation angle with respect to the X axis.

## Maximal bridging distance

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_bridging`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-bridging=1`.  
Maximal distance between supports on sparse infill sections.

## Wipe tower purge lines spacing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_extra_spacing`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-extra-spacing=20%`.  
Spacing of purge lines on the wipe tower.

## Extra flow for purge

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_extra_flow`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-extra-flow=20%`.  
Extra flow used for the purging lines on the wipe tower. This makes the purging lines thicker than they normally would be. The spacing is adjusted automatically.

## Maximum wipe tower print speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_max_purge_speed`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-max-purge-speed=1`.  
The maximum print speed when purging in the wipe tower and printing the wipe tower sparse layers. When purging, if the sparse infill speed or calculated speed from the filament max volumetric speed is lower, the lowest will be used instead.  
When printing the sparse layers, if the sparse infill speed or calculated speed from the filament max volumetric speed is lower, the lowest will be used instead.  
Increasing this speed may affect the tower's stability as well as increase the force with which the nozzle collides with any blobs that may have formed on the wipe tower.  
Before increasing this parameter beyond the default of 90 mm/s, make sure your printer can reliably bridge at the increased speeds and that ooze when tool changing is well controlled.  
The wipe tower external perimeters use the inner wall speed, also limited by this setting.

## Wall type

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_wall_type`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `rectangle, cone, rib`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-wall-type=rectangle`.  
Wipe tower outer wall type.

### Rectangle

A rectangle with fixed width and height.

### Cone

A cone with a fillet at the bottom to help stabilize the wipe tower. Only the Type 2 tower builds the cone. The Type 1 tower prints a rectangle instead, and on Bambu Lab printers Orca switches this option back to Rectangle.

#### Stabilization cone apex angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_cone_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-cone-angle=1`.  
Angle at the apex of the cone that is used to stabilize the wipe tower. A larger angle means a wider base.

### Rib

The default wall type. Adds four ribs to the tower wall for enhanced stability and makes the tower square, so [Width](#width) cannot be set.

#### Extra rib length

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_extra_rib_length`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-extra-rib-length=1`.  
Positive values can increase the size of the rib wall, while negative values can reduce the size. However, the size of the rib wall cannot be smaller than that determined by the purge volume.

#### Rib width

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_rib_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-rib-width=1`.  
Width of the rib wall.

#### Fillet wall

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_fillet_wall`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-fillet-wall=1`.  
Rounds the corners of the prime tower's rib wall.

## No sparse layers

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_no_sparse_layers`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-no-sparse-layers=1`.  

> [!IMPORTANT]
> NEW FEATURE: **No sparse layers on every prime tower type**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

If enabled, the prime tower is not printed on layers with no tool changes. The tower therefore stays low while the model keeps rising, and on the next layer that does have a tool change the extruder travels back down to print it.

Because the tower ends up below the model, the toolhead has to reach down to it past everything already printed. Orca checks the plate for that before slicing and rejects layouts where the nozzle, the toolhead body or the gantry rod would hit an object, highlighting the collision area and the height limit it would exceed. Move the model further from the tower, lower its height, or turn this option off.

> [!TIP]
> If the plate layout can't avoid a collision, [Combine sparse layers](#combine-sparse-layers) also cuts the time spent on sparse tower layers while keeping the tower level with the model.

> [!NOTE]
> This option has no effect when [smooth timelapse](others_settings_special_mode#timelapse) or [clumping detection](others_settings_special_mode#enable-clumping-detection) is enabled, because both keep every sparse layer of the tower. Enabling it while smooth timelapse is selected switches timelapse to traditional, and selecting smooth timelapse turns this option off.

## Combine sparse layers

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_sparse_layers_combination`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-sparse-layers-combination=1`.  

> [!IMPORTANT]
> NEW FEATURE: **Combine sparse prime tower layers**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

If enabled, consecutive layers on which the prime tower has no filament change (sparse layers) are printed as a single thicker tower layer instead of one thin layer each, the same way [Infill Combination](strength_settings_advanced#infill-combination) merges sparse infill. The merged layer is printed on the last layer of the run, at the combined height of all the layers it covers, and the layers below it skip the tower entirely.

This removes most of the travel moves to the tower on sparse layers, which shortens print time. It saves less than [No sparse layers](#no-sparse-layers), but the tower keeps rising with the model, so the toolhead never has to reach down to it: there is no collision risk and no restriction on the plate layout.

Layers are merged following these rules:

- Only whole layers are merged, so a merged layer always ends at an object layer height.
- The merged height never exceeds the maximum layer height of the nozzle printing the tower (see [Extruder Layer Height Limits](printer_extruder_basic_information#extruder-layer-height-limits)), or three quarters of the nozzle diameter when that limit is set to 0.
- Layers with a filament change are never merged, so every purge is still printed at its own height.
- The first layer is never merged.

> [!TIP]
> At least two layers have to fit under the maximum layer height before anything is merged, so this option has no effect at common layer heights. For example, with a 0.3 mm maximum layer height, 0.2 mm layers are not merged (2 × 0.2 mm = 0.4 mm), while 0.1 mm layers are merged three at a time (3 × 0.1 mm = 0.3 mm). Use a lower layer height or raise the extruder's maximum layer height to benefit from it.

> [!NOTE]
> This option is only shown when [No sparse layers](#no-sparse-layers) is disabled, since dropping the sparse layers leaves nothing to combine. It also has no effect when [smooth timelapse](others_settings_special_mode#timelapse) or [clumping detection](others_settings_special_mode#enable-clumping-detection) is enabled, because both keep every sparse layer of the tower.

## Prime all printing extruders

If enabled, all extruders used in the print are primed at the start of the print, before the first layer, by printing a short purge area for each of them side by side along the front edge of the bed. Only shown for printers using the Type 2 tower, and hidden when [Single Extruder Multi Material](printer_multimaterial_setup#single-extruder-multi-material) is enabled.

With Marlin firmware, the printer beeps and pauses after priming: if the print overlaps the priming area, it waits for you to remove the priming extrusions, otherwise it continues after 10 seconds. With other firmware, Orca warns when the print is too close to the priming area.

## Belt purge tower width

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `belt_purge_tower_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--belt-purge-tower-width=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Belt purge tower**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Sets the width of the [belt purge tower](printer_multimaterial_wipe_tower#belt-purge-tower), measured across the belt. This tower replaces the prime tower on belt printers. The setting is shown when the belt purge tower is enabled in the printer settings.

Only the width is set here. The length follows the printed parts along the belt, and the height is calculated from the maximum purge volume required in a single layer. Increasing the width therefore reduces the tower's height.
