# Material Cooling

- [Material Cooling for Specific Layer](#material-cooling-for-specific-layer)
  - [No cooling for the first](#no-cooling-for-the-first)
  - [Full fan speed at layer](#full-fan-speed-at-layer)
- [Material Part Cooling Fan](#material-part-cooling-fan)
  - [Fan speed threshold](#fan-speed-threshold)
    - [Min fan speed threshold](#min-fan-speed-threshold)
    - [Max fan speed threshold](#max-fan-speed-threshold)
  - [Keep fan always on](#keep-fan-always-on)
  - [Slow printing down for better layer cooling](#slow-printing-down-for-better-layer-cooling)
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

Number of layers to turn off cooling fans.
Turn off all cooling fans for the first few layers. This can be used to improve build plate adhesion.

### Full fan speed at layer

Fan speed will be ramped up linearly from zero at layer "close_fan_the_first_x_layers" to maximum at layer "full_fan_speed_layer". "full_fan_speed_layer" will be ignored if lower than "close_fan_the_first_x_layers", in which case the fan will be running at maximum allowed speed at layer "close_fan_the_first_x_layers" + 1.

## Material Part Cooling Fan

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

Enabling this setting means that part cooling fan will never stop entirely and will instead run at least at minimum speed to reduce the frequency of starting and stopping.

### Slow printing down for better layer cooling

Enable this option to slow printing speed down to ensure that the final layer time is not shorter than the layer time threshold in "Max fan speed threshold", so that the layer can be cooled for a longer time. This can improve the quality for small details.

### Don't slow down outer walls

If enabled, this setting will ensure external perimeters are not slowed down to meet the minimum layer time. This is particularly helpful in the below scenarios:

1. To avoid changes in shine when printing glossy filaments
2. To avoid changes in external wall speed which may create slight wall artifacts that appear like Z banding
3. To avoid printing at speeds which cause VFAs (fine artifacts) on the external walls

### Min print speed

The minimum print speed to which the printer slows down to maintain the minimum layer time defined above when the slowdown for better layer cooling is enabled.

### Force cooling for overhangs and bridges

Enable this option to allow adjustment of the part cooling fan speed for specifically for overhangs, internal and external bridges. Setting the fan speed specifically for these features can improve overall print quality and reduce warping.

### Overhang cooling activation threshold

When the overhang exceeds this specified threshold, force the cooling fan to run at the 'Overhang Fan Speed' set below. This threshold is expressed as a percentage, indicating the portion of each line's width that is unsupported by the layer beneath it. Setting this value to 0% forces the cooling fan to run for all outer walls, regardless of the overhang degree.

### Overhangs and external bridges fan speed

Use this part cooling fan speed when printing bridges or overhang walls with an overhang threshold that exceeds the value set in the 'Overhangs cooling threshold' parameter above. Increasing the cooling specifically for overhangs and bridges can improve the overall print quality of these features.

Please note, this fan speed is clamped on the lower end by the minimum fan speed threshold set above. It is also adjusted upwards up to the maximum fan speed threshold when the minimum layer time threshold is not met.

### Internal bridges fan speed

The part cooling fan speed used for all internal bridges. Set to -1 to use the overhang fan speed settings instead.

Reducing the internal bridges fan speed, compared to your regular fan speed, can help reduce part warping due to excessive cooling applied over a large surface for a prolonged period of time.

### Support interface fan speed

This part cooling fan speed is applied when printing support interfaces. Setting this parameter to a higher than regular speed reduces the layer binding strength between supports and the supported part, making them easier to separate.
Set to -1 to disable it.
This setting is overridden by disable_fan_first_layers.

### Ironing fan speed

This part cooling fan speed is applied when ironing. Setting this parameter to a lower than regular speed reduces possible nozzle clogging due to the low volumetric flow rate, making the interface smoother.
Set to -1 to disable it.

### Auxiliary part cooling fan

Enable this option if [machine has auxiliary](printer_basic_information_accessory#auxiliary-part-cooling-fan) part cooling fan. G-code command: M106 P2 S(0-255).

### Exhaust fan

#### Activate air filtration

Activate for better air filtration. G-code command: M106 P3 S(0-255)

#### During print

Speed of exhaust fan during printing. This speed will override the speed in filament custom G-code.

#### Complete print

Speed of exhaust fan after printing completes.
