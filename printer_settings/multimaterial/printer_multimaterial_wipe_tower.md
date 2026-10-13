# Wipe Tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_type`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `type1, type2`.  
[CLI Example](cli_mode#setting-overrides): `--wipe-tower-type=type1`.  
The prime tower is a structure that is printed before the actual print to ensure that the nozzle is primed with the correct filament. It helps to prevent oozing and stringing during the print. The prime tower can be customized in various ways, such as its size, shape, and position.

## Purge in prime tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `purge_in_prime_tower`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--purge-in-prime-tower=1`.  
Purge remaining filament into prime tower.

## Enable filament ramming

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `enable_filament_ramming`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--enable-filament-ramming=1`.  
Enable filament ramming

## Tool Change on Wipe Tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `tool_change_on_wipe_tower`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--tool-change-on-wipe-tower=1`.  
Force the toolhead to travel to the wipe tower before issuing the tool change command (Tx).  
Only relevant for multi-extruder (multi-toolhead) printers using a Type 2 wipe tower.  
By default Orca skips the travel on multi-toolhead machines because the firmware handles the head swap, which can result in the Tx command being issued above the printed part.

Enable this option if you want the tool change to always be issued above the wipe tower instead.

## Wait for Temperature on Wipe Tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wait_for_temp_on_wipe_tower`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--wait-for-temp-on-wipe-tower=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Wait for temperature on wipe tower**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Only relevant for multi-extruder (multi-toolhead) printers using a Type 2 wipe tower.  
By default, the new tool's temperature wait happens immediately after the tool change command, wherever the toolhead is at that moment, which can leave ooze from the heat-up on top of the printed part.

Enable this option to defer that wait instead: the incoming tool's target temperature is raised ahead of the tool change rather than blocked on, the toolhead travels to the wipe tower, and only once parked beside it, right before purging, does it wait to actually reach temperature. Ooze from the heat-up then lands next to the tower instead of on the model, and the travel overlaps with the heat-up instead of adding to it.

> [!CAUTION]
> Your firmware or tool change macro must not already wait for the temperature itself, or the toolhead will end up waiting twice.

## Belt purge tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `enable_belt_purge_tower`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--enable-belt-purge-tower=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Belt purge tower**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

![belt_purge_tower_printer_option](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/belt/belt_purge_tower_printer_option.png?raw=true)

Enables a replacement for the prime tower on [belt printers](belt_printing). This option is only shown when [belt printing](printer_basic_information_belt_printer#enable-belt-printing) is enabled.

The standard prime tower cannot be used on a belt because it requires a flat bed and its G-code is not transformed for the tilted gantry. When this option is enabled and a plate uses more than one filament, OrcaSlicer adds a **Belt Purge Tower** object to that plate:

- It is a long, thin bar positioned beside the parts along the belt, flush with the belt's far edge.
- It appears in the object list and is sliced with the same tilted layers as the parts.
- Material is purged into it at every filament change, in the same way as [flushing into an object](multimaterial_settings_flush_options).
- It is created, resized and removed automatically as parts, filaments and settings change. Do not edit it by hand.

The tower's width is set by [Belt purge tower width](multimaterial_settings_prime_tower#belt-purge-tower-width) in the process settings, and its length follows the parts along the belt. Its height is calculated so that a single tilted layer through the tower can accommodate the maximum purge volume required in any layer. This calculation uses the flushing volumes for a single-extruder multi-material printer with [Purge in prime tower](#purge-in-prime-tower) enabled, and the prime volume otherwise.

The printed tower is smaller than the object shown in Prepare: it ends after the last filament change, and infill that is not needed for purging is omitted.

> [!NOTE]
> The belt purge tower is not generated when the print sequence is **By object**. In this mode, no purge is performed at filament changes.
