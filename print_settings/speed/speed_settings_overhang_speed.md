# Overhang Speed

- [Slow down for overhang](#slow-down-for-overhang)
    - [Slow down for curled perimeters](#slow-down-for-curled-perimeters)
    - [Speed](#speed)
- [Bridge speed](#bridge-speed)

## Slow down for overhang

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `enable_overhang_speed`.  
Enable this option to slow printing down for different overhang degree.
This can help improve print quality and reduce issues like stringing or sagging.

### Slow down for curled perimeters

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `slowdown_for_curled_perimeters`.  
Enable this option to slow down printing in areas where perimeters may have curled upwards.  
For example, additional slowdown will be applied when printing overhangs on sharp corners like the front of the Benchy hull, reducing curling which compounds over multiple layers.

![slow-down-for-curled-perimeters](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/speed/slow-down-for-curled-perimeters.png?raw=true)

It is generally recommended to have this option switched on unless your printer cooling is powerful enough or the print speed is slow enough that perimeter curling does not happen.  
If printing with a high external perimeter speed, this parameter may introduce wall artifacts when slowing down, due to the potentially large variance in print speeds causing the extruder to be unable to keep up with the requested flow change.  
Root cause of these artifacts is most likely PA tuning being slightly off, especially when combined with a high PA smooth time.

> [!TIP]
> When enabling this option:
>
> 1. For Klipper machines: Reduce Pressure Advance smooth time to 0.015 - 0.02 so the extruder reacts quickly to the speed changes.
> 2. Increase the minimum print speeds to limit the magnitude of the slowdown and reduce the variance between fast and slow segments.
> 3. If artifacts still appear, enable [Extrusion rate smoothing](speed_settings_advanced) to further smooth the flow transitions.

> [!NOTE]
> When this option is enabled, overhang perimeters are treated like overhangs, meaning the overhang speed is applied even if the overhanging perimeter is part of a bridge.  
> For example, when the perimeters are 100% overhanging, with no wall supporting them from underneath, the 100% overhang speed will be applied.

### Speed

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `overhang_1_4_speed`, `overhang_2_4_speed`, `overhang_3_4_speed`, `overhang_4_4_speed`.  
This is the speed for various overhang degrees. Overhang degrees are expressed as a percentage of [line width](quality_settings_line_width).  

> [!NOTE]
> 0 speed means no slowing down for the overhang degree range and wall speed is used.

## Bridge speed

Set speed for external and internal bridges.  
It's usually recommended to increase internal bridge speed to reduce print time, while external bridge speed should be reduced to improve print quality.
