# Material Multimaterial Settings

This page documents the settings used when printing with multiple materials in Orca Slicer. It explains wipe-tower parameters, tool-change behaviour for both single-extruder and multi-extruder multimaterial setups, and ramming/purge options that help ensure reliable, contamination-free material changes.

- [Multimaterial Wipe Tower Parameters](#multimaterial-wipe-tower-parameters)
    - [Minimal purge on wipe tower](#minimal-purge-on-wipe-tower)
- [Multi Filament](#multi-filament)
- [Tool change parameters with single extruder](#tool-change-parameters-with-single-extruder)
    - [Loading speed at the start](#loading-speed-at-the-start)
    - [Loading speed](#loading-speed)
    - [Unloading speed at the start](#unloading-speed-at-the-start)
    - [Unloading speed](#unloading-speed)
    - [Delay after unloading](#delay-after-unloading)
    - [Number of cooling moves](#number-of-cooling-moves)
    - [Speed of the first cooling move](#speed-of-the-first-cooling-move)
    - [Speed of the last cooling move](#speed-of-the-last-cooling-move)
    - [Stamping loading speed](#stamping-loading-speed)
    - [Stamping distance](#stamping-distance)
    - [Ramming parameters](#ramming-parameters)
        - [Total ramming](#total-ramming)
        - [Ramming line](#ramming-line)
- [Tool change parameters with multi extruder](#tool-change-parameters-with-multi-extruder)
    - [Enable ramming for multi-tool setups](#enable-ramming-for-multi-tool-setups)
        - [Multi-tool ramming volume](#multi-tool-ramming-volume)
        - [Multi-tool ramming flow](#multi-tool-ramming-flow)

## Multimaterial Wipe Tower Parameters

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `filament_minimal_purge_on_wipe_tower`, `filament_tower_interface_pre_extrusion_dist`, `filament_tower_interface_pre_extrusion_length`, `filament_tower_ironing_area`, `filament_tower_interface_purge_volume`, `filament_tower_interface_print_temp`.  
[Type](option_type): `filament_minimal_purge_on_wipe_tower` (Float list), `filament_tower_interface_pre_extrusion_dist` (Float list), `filament_tower_interface_pre_extrusion_length` (Float list), `filament_tower_ironing_area` (Float list), `filament_tower_interface_purge_volume` (Float list), `filament_tower_interface_print_temp` (Integer list).  
[CLI Example](cli_mode#setting-overrides): `--filament-minimal-purge-on-wipe-tower=1` (`filament_minimal_purge_on_wipe_tower` shown; other variables above follow their own type).  
Wipe towers are sacrificial structures printed alongside the main object to purge excess material from the nozzle after a tool change in multimaterial printing. This ensures that the next extrusion uses the correct filament color or type without contamination from the previous material.

### Minimal purge on wipe tower

After a tool change, the exact position of the newly loaded filament inside the nozzle may not be known, and the filament pressure is likely not yet stable. Before purging the print head into an infill or a sacrificial object, Orca Slicer will always prime this amount of material into the wipe tower to produce successive infill or sacrificial object extrusions reliably.

## Multi Filament

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `long_retractions_when_ec`, `retraction_distances_when_ec`.  
[Type](option_type): `long_retractions_when_ec` (Boolean list), `retraction_distances_when_ec` (Float list).  
[CLI Example](cli_mode#setting-overrides): `--long-retractions-when-ec=1` (`long_retractions_when_ec` shown; other variables above follow their own type).  
Enable long retraction when the extruder changes and set its retraction distance value for extruder changes.

## Tool change parameters with single extruder

These settings control filament loading and unloading for single-extruder multimaterial systems (where multiple filaments are fed to a single hotend). They govern how much filament is primed or purged on the wipe tower, the speeds used during load/unload phases, delays for flexible materials, cooling-move behaviour, stamping and the ramming routine. Proper tuning reduces cross-contamination between filaments and improves tool-change reliability.

### Loading speed at the start

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_loading_speed_start`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-loading-speed-start=1`.  
Speed used at the very beginning of loading phase.

### Loading speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_loading_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-loading-speed=1`.  
Speed used for loading the filament on the wipe tower.

### Unloading speed at the start

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_unloading_speed_start`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-unloading-speed-start=1`.  
Speed used for unloading the tip of the filament immediately after ramming.

### Unloading speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_unloading_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-unloading-speed=1`.  
Speed used for unloading the filament on the wipe tower (does not affect initial part of unloading just after ramming).

### Delay after unloading

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_toolchange_delay`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-toolchange-delay=1`.  
Time to wait after the filament is unloaded. May help to get reliable tool changes with flexible materials that may need more time to shrink to original dimensions.

### Number of cooling moves

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_cooling_moves`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-cooling-moves=1`.  
Filament is cooled by being moved back and forth in the cooling tubes. Specify desired number of these moves.

### Speed of the first cooling move

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_cooling_initial_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-cooling-initial-speed=1`.  
Cooling moves are gradually accelerating beginning at this speed.

### Speed of the last cooling move

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_cooling_final_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-cooling-final-speed=1`.  
Cooling moves are gradually accelerating towards this speed.

### Stamping loading speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_stamping_loading_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-stamping-loading-speed=1`.  
Speed used for stamping.

### Stamping distance

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_stamping_distance`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-stamping-distance=1`.  
Stamping distance measured from the center of the cooling tube.
If set to non-zero value, filament is moved toward the nozzle between the individual cooling moves ("stamping"). This option configures how long this movement should be before the filament is retracted again.

### Ramming parameters

This string is edited by RammingDialog and contains ramming specific parameters.

#### Total ramming

The total amount of filament that will be forcibly extruded (rammed) into the nozzle during the ramming stage. This value represents the full volume (or equivalent extrusion length) applied by the ramming routine to ensure the nozzle contains the intended material and pressure before printing resumes.

#### Ramming line

Defines the geometry or pattern used when ramming material (for example a short line or dot on the wipe tower). The ramming line parameters control where the rammed material is deposited so it is reliably captured by the wipe structure instead of contaminating the printed part.

## Tool change parameters with multi extruder

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_multitool_ramming`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-multitool-ramming=1`.  
These options apply to printers that use multiple independent extruders or hotends (multi-tool setups). When enabled, ramming and related parameters define a small, controlled extrusion on the wipe tower immediately before a tool change to ensure the outgoing tool is cleared and the incoming tool begins with consistent filament at the nozzle. Use these settings to tune multi-tool handoffs and avoid color or material mixing.

### Enable ramming for multi-tool setups

Perform ramming when using multi-tool printer (i.e. when the 'Single Extruder Multimaterial' in Printer Settings is unchecked). When checked, a small amount of filament is rapidly extruded on the wipe tower just before the tool change. This option is only used when the wipe tower is enabled.

#### Multi-tool ramming volume

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_multitool_ramming_volume`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-multitool-ramming-volume=1`.  
The volume to be rammed before the tool change.

#### Multi-tool ramming flow

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `filament_multitool_ramming_flow`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--filament-multitool-ramming-flow=1`.  
Flow used for ramming the filament before the tool change.
