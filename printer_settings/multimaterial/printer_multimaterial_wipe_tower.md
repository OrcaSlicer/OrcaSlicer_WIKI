# Wipe Tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `wipe_tower_type`.  
The prime tower is a structure that is printed before the actual print to ensure that the nozzle is primed with the correct filament. It helps to prevent oozing and stringing during the print. The prime tower can be customized in various ways, such as its size, shape, and position.

## Purge in prime tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `purge_in_prime_tower`.  
Purge remaining filament into prime tower.

## Enable filament ramming

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `enable_filament_ramming`.  
Enable filament ramming

## Tool Change on Wipe Tower

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `tool_change_on_wipe_tower`.  
Force the toolhead to travel to the wipe tower before issuing the tool change command (Tx).  
Only relevant for multi-extruder (multi-toolhead) printers using a Type 2 wipe tower.  
By default Orca skips the travel on multi-toolhead machines because the firmware handles the head swap, which can result in the Tx command being issued above the printed part.

Enable this option if you want the tool change to always be issued above the wipe tower instead.

> [!IMPORTANT]
> NEW FEATURE: **Tool Change on Wipe Tower**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.3.2**.
