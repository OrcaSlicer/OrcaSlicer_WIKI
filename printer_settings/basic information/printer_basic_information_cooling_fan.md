# Cooling Fan

Machine cooling fan settings.

- [Fan speed-up time](#fan-speed-up-time)
    - [Only overhangs](#only-overhangs)
- [Fan kick-start time](#fan-kick-start-time)
- [Minimum non-zero part cooling fan speed](#minimum-non-zero-part-cooling-fan-speed)

## Fan speed-up time

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `fan_speedup_time`, `fan_speedup_overhangs`.  
Start the fan this number of seconds earlier than its target start time (you can use fractional seconds). It assumes infinite acceleration for this time estimation, and will only take into account G1 and G0 moves (arc fitting is unsupported).
It won't move fan commands from custom G-code (they act as a sort of 'barrier').
It won't move fan commands into the start G-code if the 'only custom start G-code' is activated.
Use 0 to deactivate.

### Only overhangs

Will only take into account the delay for the cooling of overhangs.

## Fan kick-start time

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `fan_kickstart`.  
Emit a max fan speed command for this amount of seconds before reducing to target speed to kick-start the cooling fan.
This is useful for fans where a low PWM/power may be insufficient to get the fan started spinning from a stop, or to get the fan up to speed faster.
Set to 0 to deactivate.

## Minimum non-zero part cooling fan speed

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `part_cooling_fan_min_pwm`.  
Some part-cooling fans cannot start spinning when commanded below a certain PWM duty cycle.
When set above 0, any non-zero part-cooling fan command will be raised to at least this percentage so the fan reliably starts.  
A fan command of 0 (fan off) is always honoured exactly.  
This clamp is applied after every other fan calculation (first-layer ramp, layer-time interpolation, overhang/bridge/support-interface/ironing overrides), so scaling still operates within the range [this value, 100%].  
If your firmware already disables the fan below a threshold (for example Klipper's [fan] off_below: 0.10 shuts the fan off whenever the commanded duty cycle is below 10%), this option and the firmware threshold should ideally be set to the same value.  
Matching them (e.g. off_below: 0.10 in Klipper and 10% here) guarantees the slicer never emits a non-zero value that the firmware would silently drop, and the fan never receives a value below the one you know it can actually spool at.  
Set to 0 to deactivate.
