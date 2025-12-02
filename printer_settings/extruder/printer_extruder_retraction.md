# Retraction

Retraction is the process of pulling the filament back into the nozzle to prevent oozing and stringing during non-print moves.
If the retraction length is too short, it may not effectively prevent oozing, while if it's too long, it can lead to clogs or under-extrusion.
Filaments like PETG and TPU are more prone to stringing, so they may require longer retraction lengths compared to PLA or ABS. You can override your printer's default retraction settings for each filament in [Material Setting Overrides](material_setting_overrides#retraction).

> [!TIP]
> Check out the [Retraction Test](retraction-calib) to help determine the optimal retraction settings for your filament.

- [Length](#length)
- [Extra length on restart](#extra-length-on-restart)
- [Retraction speed](#retraction-speed)
- [Deretraction speed](#deretraction-speed)
- [Travel distance threshold](#travel-distance-threshold)
- [Retract on layer change](#retract-on-layer-change)
- [Wipe while retracting](#wipe-while-retracting)
- [Wipe distance](#wipe-distance)
- [Retract amount before wipe](#retract-amount-before-wipe)
- [Retraction When Switching Materials](#retraction-when-switching-materials)
  - [Long retraction when cut (beta)](#long-retraction-when-cut-beta)

## Length

When retraction is triggered before changing tool, filament is pulled back by the specified amount (the length is measured on raw filament, before it enters the extruder).

## Extra length on restart

When the retraction is compensated after changing tool, the extruder will push this additional amount of filament.

## Retraction speed

Speed for retracting filament from the nozzle.

## Deretraction speed

Speed for reloading filament into the nozzle. Zero means same speed of retraction.

## Travel distance threshold

Only trigger retraction when the travel distance is longer than this threshold.

## Retract on layer change

This forces a retraction on layer changes.

## Wipe while retracting

This moves the nozzle along the last extrusion path when retracting to clean any leaked material on the nozzle. This can minimize blobs when printing a new part after traveling.

## Wipe distance

Describe how long the nozzle will move along the last path when retracting.
Depending on how long the wipe operation lasts, how fast and long the extruder/filament retraction settings are, a retraction move may be needed to retract the remaining filament.
Setting a value in the retract amount before wipe setting below will perform any excess retraction before the wipe, else it will be performed after.

## Retract amount before wipe

This is the length of fast retraction before a wipe, relative to retraction length.

## Retraction When Switching Materials

Retraction settings specifically for material changes during tool changes in multi-material prints.

### Long retraction when cut (beta)

Experimental feature: Retracting and cutting off the filament at a longer distance during changes to minimize purge. While this reduces flush significantly, it may also raise the risk of nozzle clogs or other printing problems.
