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

If enabled, the machine limits will be emitted to G-code file.
This option will be ignored if the G-code flavor is set to Klipper.

## Resonance Avoidance

### Resonance Avoidance Speed

By reducing the speed of the outer wall to avoid the resonance zone of the printer, ringing on the surface of the model are avoided.

## Speed limitation

Safeguard maximum speeds for all axes.
This will cap the speed set by the process if it exceeds these values.

## Acceleration limitation

Safeguard maximum accelerations for all axes.
This will cap the acceleration set by the process if it exceeds these values.

## Jerk limitation

Safeguard maximum jerks for all axes.

### Maximum Junction Deviation

Maximum junction deviation (M205 J, only apply if JD > 0 for Marlin Firmware. If your Marlin 2 printer uses Classic Jerk set this value to 0.)

### Maximum Jerk

Maximum jerk for each axis (M205 X, Y, Z, E, only apply if JD = 0 for Marlin 2 Firmware)
