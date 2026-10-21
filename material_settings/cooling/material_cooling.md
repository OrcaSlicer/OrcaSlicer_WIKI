# Material Cooling

- [Material Cooling for Specific Layer](#material-cooling-for-specific-layer)
    - [No cooling for the first](#no-cooling-for-the-first)
    - [First layer fan speed](#first-layer-fan-speed)
    - [Full fan speed at layer](#full-fan-speed-at-layer)
- [Material Part Cooling Fan](#material-part-cooling-fan)
    - [Fan speed threshold](#fan-speed-threshold)
        - [Min fan speed threshold](#min-fan-speed-threshold)
        - [Max fan speed threshold](#max-fan-speed-threshold)
    - [Keep fan always on](#keep-fan-always-on)
    - [Slow printing down for better layer cooling](#slow-printing-down-for-better-layer-cooling)
        - [How the slowdown is calculated](#how-the-slowdown-is-calculated)
    - [Don't slow down outer walls](#dont-slow-down-outer-walls)
    - [Min print speed](#min-print-speed)
    - [Force cooling for overhangs and bridges](#force-cooling-for-overhangs-and-bridges)
    - [Overhang cooling activation threshold](#overhang-cooling-activation-threshold)
    - [Overhangs and external bridges fan speed](#overhangs-and-external-bridges-fan-speed)
    - [Internal bridges fan speed](#internal-bridges-fan-speed)
    - [Support interface fan speed](#support-interface-fan-speed)
    - [Ironing fan speed](#ironing-fan-speed)
    - [Auxiliary part cooling fan](#auxiliary-part-cooling-fan)
    - [Exhaust fan](#exhaust-fan)
        - [Activate air filtration](#activate-air-filtration)
        - [During print](#during-print)
        - [Complete print](#complete-print)

## Material Cooling for Specific Layer

This setting allows you to customize the cooling behavior of your 3D printer for specific layers of your print.  
Proper cooling is essential for achieving high-quality prints, especially when dealing with overhangs and bridges.

### No cooling for the first

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `close_fan_the_first_x_layers`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--close-fan-the-first-x-layers=1`.  
Number of initial layers during which part-cooling fans are disabled.
Disabling the fan for the first few layers improves build-plate adhesion and reduces early-layer warping.

### First layer fan speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `initial_layer_fan_speed`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--initial-layer-fan-speed=1`.  

> [!IMPORTANT]
> NEW FEATURE: **First layer fan speed**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Sets an exact fan speed (in %) for the first layer, overriding all other cooling settings.  
This is useful for protecting 3D-printed toolhead parts (e.g. Voron-style ABS/ASA ducts) from a hot bed: a small amount of airflow cools the ducts down without using full cooling, which may in certain conditions hurt first-layer adhesion. From the second layer onwards, normal cooling resumes.  
If [Full fan speed at layer](#full-fan-speed-at-layer) is also set, the fan ramps smoothly from this value on the first layer up to your target by the chosen layer.  
Only available when [No cooling for the first](#no-cooling-for-the-first) is 0. Set to `-1` to disable it.

### Full fan speed at layer

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `full_fan_speed_layer`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--full-fan-speed-layer=1`.  
Fan speed is increased linearly from 0% starting at the layer specified by [close_fan_the_first_x_layers](#no-cooling-for-the-first) up to the maximum part-cooling speed at this specified layer.  
If this layer is less than or equal to [close_fan_the_first_x_layers](#no-cooling-for-the-first), it is ignored and the fan will reach the maximum allowed speed on the layer immediately after [close_fan_the_first_x_layers](#no-cooling-for-the-first) (i.e. at layer [close_fan_the_first_x_layers](#no-cooling-for-the-first) + 1).  
Set this option to `0` to disable the automatic ramp.

## Material Part Cooling Fan

[Mode](option_mode): `Simple`.  
[Variables](built_in_placeholders_variables): `fan_min_speed`, `fan_cooling_layer_time`, `fan_max_speed`, `slow_down_layer_time`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--fan-min-speed=1` (same pattern for the other variables above).  
These settings control the behavior of the part cooling fan during printing. Proper configuration of these parameters can significantly enhance print quality by optimizing cooling for different features and layer times.

### Fan speed threshold

These settings define how the slicer manages part-cooling behavior and printing speed based on the estimated time it takes to print each layer.

#### Min fan speed threshold

When a layer’s estimated print time falls below the minimum time, the slicer begins enabling the part-cooling fan. The fan speed is gradually interpolated between the configured minimum and maximum fan speeds, depending on how short the layer time is.
If a minimum speed threshold is defined, the slicer may also slow down the G-code printing speed for layers faster than this value to ensure adequate cooling.

#### Max fan speed threshold

Layers with an estimated time below the maximum time may trigger additional print-speed reduction to improve cooling.
When auto-cooling is enabled, the fan speed may increase as needed, up to the defined maximum fan speed, which acts as the upper limit for cooling adjustments.

### Keep fan always on

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `reduce_fan_stop_start_freq`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--reduce-fan-stop-start-freq=1`.  
Enabling this setting means that part cooling fan will never stop entirely and will instead run at least at minimum speed to reduce the frequency of starting and stopping.

### Slow printing down for better layer cooling

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `slow_down_for_layer_cooling`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--slow-down-for-layer-cooling=1`.  
Enable this option to slow printing speed down to ensure that the final layer time is not shorter than the **Layer time** threshold in [Max fan speed threshold](#max-fan-speed-threshold), so that the layer can be cooled for a longer time. This can improve the quality for small details.

This happens after the [print speeds](speed_settings_other_layers_speed) have been applied, so on small or fast layers the printed speed can be lower than the value you set. It applies to every layer, including the first one, and the slowed-down speeds are written into the G-code: you can see them in the Preview **Speed** view.

The slowdown has a floor: no extrusion is slowed down below the filament's [Min print speed](#min-print-speed).  
If the layer would still be shorter than the Layer time with every extrusion at Min print speed, everything that can be slowed down prints at Min print speed and the layer finishes earlier than the target.

> [!TIP]
> If small layers still don't cool enough because Min print speed was reached, print several copies of the part at once so each layer takes longer.

#### How the slowdown is calculated

1. **Estimate the layer time.** For each layer, OrcaSlicer adds up the time of every move (extrusions, travels and dwells) as `length / speed`, starting at the first extrusion of the layer. Acceleration is not taken into account, so the real layer time is usually a bit longer than the estimate.
2. **Compare it with the Layer time.** If the estimate is equal or longer, the layer is not changed.
3. **Find the missing time.** Otherwise the missing time is `Layer time - estimated time`.
4. **Slow down the fastest extrusions first.** Only extrusion moves are slowed down: travels and wipes keep their speed but still count towards the layer time. Instead of scaling every speed by the same factor, OrcaSlicer finds a speed cap $F$. Every extrusion faster than $F$ is lowered to $F$, and slower extrusions keep their speed. $F$ is chosen so that the extra time equals the missing time:

$$
\sum_{v_i > F} t_i \left(\frac{v_i}{F} - 1\right) = \text{Layer time} - \text{Estimated time}
$$

Where $v_i$ is the speed and $t_i$ the time of each extrusion faster than $F$.  
$F$ is never lower than the [Min print speed](#min-print-speed).

For example, a layer with a Layer time of 15 s:

| Feature | Length | Set speed | Time | Speed after slowdown | Time after slowdown |
| --- | --- | --- | --- | --- | --- |
| Outer wall | 200 mm | 100 mm/s | 2 s | 100 mm/s | 2 s |
| Inner wall | 600 mm | 200 mm/s | 3 s | 150 mm/s | 4 s |
| Sparse infill | 1200 mm | 300 mm/s | 4 s | 150 mm/s | 8 s |
| Travel | - | - | 1 s | - | 1 s |
| **Total** | | | **10 s** | | **15 s** |

5 s are missing. The infill and inner wall are capped at $F = \frac{600 + 1200}{3 + 4 + 5} = 150$ mm/s, and the outer wall, which is already slower than 150 mm/s, is not touched.

> [!NOTE]
> - The part cooling fan speed is calculated from the layer time **after** the slowdown.
> - When a layer prints with several filaments, the time of all of them is added up and only the filaments with the slowdown enabled are slowed down.
> - If Min print speed is set to `0`, there is no floor and all the extrusions are slowed down by the same factor instead.

### Don't slow down outer walls

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `dont_slow_down_outer_wall`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--dont-slow-down-outer-wall=1`.  
If enabled, this setting will ensure external perimeters are not slowed down to meet the minimum layer time. This is particularly helpful in the below scenarios:

1. To avoid changes in shine when printing glossy filaments
2. To avoid changes in external wall speed which may create slight wall artifacts that appear like Z banding
3. To avoid printing at speeds which cause VFAs (fine artifacts) on the external walls

When enabled, the outer walls are left out of the slowdown: they always print at their [outer wall speed](speed_settings_other_layers_speed#outer-wall) and their time counts as fixed time, like travels.

The whole missing time is then taken from the rest of the extrusions, so:

- Inner walls, infill and other features are slowed down more than they would be otherwise, and can end up slower than the outer wall.
- [Min print speed](#min-print-speed) is reached sooner, so small layers are more likely to finish faster than the Layer time.
- Overhang walls are still slowed down, as they are a different feature from the outer wall.

Using the [previous example](#how-the-slowdown-is-calculated) with a Layer time of 22 s (12 s missing):

| Feature | Without the option | With the option |
| --- | --- | --- |
| Outer wall | 95.2 mm/s | 100 mm/s |
| Inner wall | 95.2 mm/s | 94.7 mm/s |
| Sparse infill | 95.2 mm/s | 94.7 mm/s |

Without the option, the cap reaches the outer wall and all three print at $\frac{2000}{9 + 12} \approx 95.2$ mm/s.  
With it, the outer wall keeps its 100 mm/s and the inner wall and infill drop to $\frac{1800}{7 + 12} \approx 94.7$ mm/s.

This keeps the outer surface consistent between layers at the cost of less cooling time on small layers.

### Min print speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `slow_down_min_speed`.  
[Type](option_type#list-types): `Float list`.  
[CLI Example](cli_mode#setting-overrides): `--slow-down-min-speed=1`.  
The minimum print speed to which the printer slows down to maintain the minimum layer time defined above when the slowdown for better layer cooling is enabled.  
See [How the slowdown is calculated](#how-the-slowdown-is-calculated).

### Force cooling for overhangs and bridges

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `enable_overhang_bridge_fan`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--enable-overhang-bridge-fan=1`.  
Enable this option to allow adjustment of the part cooling fan speed for specifically for overhangs, internal and external bridges. Setting the fan speed specifically for these features can improve overall print quality and reduce warping.

### Overhang cooling activation threshold

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `overhang_fan_threshold`.  
[Type](option_type#list-types): `Choice list`.  
[Options](option_type#choice): `0%, 10%, 25%, 50%, 75%, 95%`.  
[CLI Example](cli_mode#setting-overrides): `--overhang-fan-threshold=0%`.  
When the overhang exceeds this specified threshold, force the cooling fan to run at the 'Overhang Fan Speed' set below. This threshold is expressed as a percentage, indicating the portion of each line's width that is unsupported by the layer beneath it. Setting this value to 0% forces the cooling fan to run for all outer walls, regardless of the overhang degree.

### Overhangs and external bridges fan speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `overhang_fan_speed`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--overhang-fan-speed=1`.  
Use this part cooling fan speed when printing bridges or overhang walls with an overhang threshold that exceeds the value set in the 'Overhangs cooling threshold' parameter above. Increasing the cooling specifically for overhangs and bridges can improve the overall print quality of these features.

Please note, this fan speed is clamped on the lower end by the minimum fan speed threshold set above. It is also adjusted upwards up to the maximum fan speed threshold when the minimum layer time threshold is not met.

### Internal bridges fan speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `internal_bridge_fan_speed`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--internal-bridge-fan-speed=1`.  
The part cooling fan speed used for all internal bridges. Set to -1 to use the overhang fan speed settings instead.

Reducing the internal bridges fan speed, compared to your regular fan speed, can help reduce part warping due to excessive cooling applied over a large surface for a prolonged period of time.

### Support interface fan speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_material_interface_fan_speed`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--support-material-interface-fan-speed=1`.  
This part cooling fan speed is applied when printing support interfaces. Setting this parameter to a higher than regular speed reduces the layer binding strength between supports and the supported part, making them easier to separate.  
Set to -1 to disable it.  
This setting is overridden by disable_fan_first_layers.

### Ironing fan speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `ironing_fan_speed`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--ironing-fan-speed=1`.  
This part cooling fan speed is applied when ironing. Setting this parameter to a lower than regular speed reduces possible nozzle clogging due to the low volumetric flow rate, making the interface smoother.  
Set to -1 to disable it.

### Auxiliary part cooling fan

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `additional_cooling_fan_speed`.  
[Type](option_type#list-types): `Integer list`.  
[CLI Example](cli_mode#setting-overrides): `--additional-cooling-fan-speed=1`.  
Set the speed for the auxiliary part-cooling fan if your printer provides one (see [auxiliary part-cooling fan](printer_basic_information_accessory#auxiliary-part-cooling-fan)). The auxiliary fan runs during printing but is disabled for the initial layers defined by [No cooling for the first](#no-cooling-for-the-first).

G-code command: `M106 P2 S(0-255)`

### Exhaust fan

#### Activate air filtration

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `activate_air_filtration`.  
[Type](option_type#list-types): `Boolean list`.  
[CLI Example](cli_mode#setting-overrides): `--activate-air-filtration=1`.  
Activate for better air filtration.

G-code command: `M106 P3 S(0-255)`

#### During print

[Mode](option_mode): `Simple`.  
[Variables](built_in_placeholders_variables): `activate_air_filtration_during_print`, `during_print_exhaust_fan_speed`.  
[Type](option_type): `activate_air_filtration_during_print` (Boolean list), `during_print_exhaust_fan_speed` (Integer list).  
[CLI Example](cli_mode#setting-overrides): `--activate-air-filtration-during-print=1` (`activate_air_filtration_during_print` shown; other variables above follow their own type).  
Speed of exhaust fan during printing. This speed will override the speed in filament custom G-code.

#### Complete print

[Mode](option_mode): `Simple`.  
[Variables](built_in_placeholders_variables): `activate_air_filtration_on_completion`, `complete_print_exhaust_fan_speed`.  
[Type](option_type): `activate_air_filtration_on_completion` (Boolean list), `complete_print_exhaust_fan_speed` (Integer list).  
[CLI Example](cli_mode#setting-overrides): `--activate-air-filtration-on-completion=1` (`activate_air_filtration_on_completion` shown; other variables above follow their own type).  
Speed of exhaust fan after printing completes.
