# Retraction

Retraction is the process of pulling the filament back into the nozzle to prevent oozing and stringing during non-print moves.  
If the retraction length is too short, it may not effectively prevent oozing, while if it's too long, it can lead to clogs or under-extrusion.  
Filaments like PETG and TPU are more prone to stringing, so they may require longer retraction lengths compared to PLA or ABS. You can override your printer's default retraction settings for each filament in [Material Setting Overrides](material_setting_overrides#retraction).

> [!TIP]
> Check out the [Retraction Test](retraction_calib) to help determine the optimal retraction settings for your filament.

- [Length](#length)
- [Extra length on restart](#extra-length-on-restart)
- [Retraction speed](#retraction-speed)
- [Deretraction speed](#deretraction-speed)
- [Travel distance threshold](#travel-distance-threshold)
- [Retract on layer change](#retract-on-layer-change)
- [Wipe while retracting](#wipe-while-retracting)
- [Wipe distance](#wipe-distance)
- [Retract amount before wipe](#retract-amount-before-wipe)
- [Retract amount after wipe](#retract-amount-after-wipe)
- [Retraction When Switching Materials](#retraction-when-switching-materials)
    - [Long retraction when cut (beta)](#long-retraction-when-cut-beta)

## Length

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `retraction_length[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--retraction-length=1`.  
When retraction is triggered before changing tool, filament is pulled back by the specified amount (the length is measured on raw filament, before it enters the extruder).

## Extra length on restart

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `retract_restart_extra[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--retract-restart-extra=1`.  
When the retraction is compensated after changing tool, the extruder will push this additional amount of filament.

## Retraction speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `retraction_speed[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--retraction-speed=1`.  
Speed for retracting filament from the nozzle.

## Deretraction speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `deretraction_speed[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--deretraction-speed=1`.  
Speed for reloading filament into the nozzle. Zero means same speed of retraction.

## Travel distance threshold

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `retraction_minimum_travel[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--retraction-minimum-travel=1`.  
Only trigger retraction when the travel distance is longer than this threshold.

## Retract on layer change

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `retract_when_changing_layer[extruder_idx]`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--retract-when-changing-layer=1`.  
This forces a retraction on layer changes.

## Wipe while retracting

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe[extruder_idx]`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--wipe=1`.  
This moves the nozzle along the last extrusion path when retracting to clean any leaked material on the nozzle. This can minimize blobs when printing a new part after traveling.

## Wipe distance

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_distance[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-distance=1`.  
Describe how long the nozzle will move along the last path when retracting.  
Depending on how long the wipe operation lasts, how fast and long the extruder/filament retraction settings are, a retraction move may be needed to retract the remaining filament.
Setting a value in the retract amount before wipe setting below will perform any excess retraction before the wipe, else it will be performed after.

## Retract amount before wipe

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `retract_before_wipe[extruder_idx]`.  
[Type](option_type#list-types): `Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--retract-before-wipe=20%`.  
This is the length of fast retraction before a wipe, relative to retraction length.

## Retract amount after wipe

[Mode](option_mode): `Expert`.  
[Variable](built_in_placeholders_variables): `retract_after_wipe[extruder_idx]`.  
[Type](option_type#list-types): `Percentage list`.  
[CLI Example](cli_mode#setting-overrides): `--retract-after-wipe=20%`.  

> [!IMPORTANT]
> NEW FEATURE: **Retract amount after wipe**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

This is the length of fast retraction after a wipe, relative to retraction length.  
Together with [Retract amount before wipe](#retract-amount-before-wipe), this lets you split the retraction across the wipe: some before, some after, and the remainder performed during the wipe move itself. The value is clamped by 100% minus the retract amount before wipe, so the two combined never exceed the total retraction length.  
Moving more of the retraction to after the wipe allows shorter wipe distances while keeping seams clean, which is helpful for high-detail models and stringing-prone filaments.

## Retraction When Switching Materials

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `retract_length_toolchange[extruder_idx]`, `retract_restart_extra_toolchange[extruder_idx]`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--retract-length-toolchange=1` (same pattern for the other variables above).  
Retraction settings specifically for material changes during tool changes in multi-material prints.

### Long retraction when cut (beta)

[Mode](option_mode): `Developer`.  
[Variables](built_in_placeholders_variables): `long_retractions_when_cut[extruder_idx]`, `retraction_distances_when_cut[extruder_idx]`.  
[Type](option_type): `long_retractions_when_cut` (Boolean list), `retraction_distances_when_cut` (Float list).  
[CLI Example](cli_mode#setting-overrides): `--long-retractions-when-cut=1` (`long_retractions_when_cut` shown; other variables above follow their own type).  
Experimental feature: Retracting and cutting off the filament at a longer distance during changes to minimize purge. While this reduces flush significantly, it may also raise the risk of nozzle clogs or other printing problems.
