# Motion Ability

Settings related to the motion capabilities of the printer.

- [Emit limits to G-code](#emit-limits-to-g-code)
- [Resonance Avoidance](#resonance-avoidance)
    - [Resonance Avoidance Speed](#resonance-avoidance-speed)
- [Speed limitation](#speed-limitation)
- [Acceleration limitation](#acceleration-limitation)
- [Jerk limitation](#jerk-limitation)
    - [Maximum Junction Deviation](#maximum-junction-deviation)
    - [Maximum Jerk](#maximum-jerk)

## Emit limits to G-code

[Variable](Built-in-placeholders-variables): `emit_machine_limits_to_gcode`.  
If enabled, the machine limits will be emitted to G-code file.
This option will be ignored if the G-code flavor is set to Klipper.

## Resonance Avoidance

[Variable](Built-in-placeholders-variables): `resonance_avoidance`.  

### Resonance Avoidance Speed

[Variables](Built-in-placeholders-variables): `min_resonance_avoidance_speed`, `max_resonance_avoidance_speed`.  
By reducing the speed of the outer wall to avoid the resonance zone of the printer, ringing on the surface of the model are avoided.

> [!TIP]
> Check the [VFA Calibration](vfa-calib).

## Speed limitation

Safeguard maximum speeds for all axes.
This will cap the speed set by the process if it exceeds these values.

## Acceleration limitation

[Variables](Built-in-placeholders-variables): `machine_max_acceleration_x`, `machine_max_acceleration_y`, `machine_max_acceleration_z`, `machine_max_acceleration_e`, `machine_max_acceleration_extruding`, `machine_max_acceleration_retracting`, `machine_max_acceleration_travel`.  
Safeguard maximum accelerations for all axes.
This will cap the acceleration set by the process if it exceeds these values.

## Jerk limitation

Safeguard maximum jerks for all axes.

> [!TIP]
> Check the [Cornering Calibration](cornering-calib).

### Maximum Junction Deviation

[Variable](Built-in-placeholders-variables): `machine_max_junction_deviation`.  
Maximum junction deviation (M205 J, only apply if JD > 0 for Marlin Firmware. If your Marlin 2 printer uses Classic Jerk set this value to 0.)

### Maximum Jerk

[Variables](Built-in-placeholders-variables): `machine_max_jerk_x`, `machine_max_jerk_y`, `machine_max_jerk_e`, `machine_max_jerk_z`.  
Maximum jerk for each axis (M205 X, Y, Z, E, only apply if JD = 0 for Marlin 2 Firmware)
