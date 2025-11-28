# Cooling Fan

Machine cooling fan settings.

## Fan speed-up time

Start the fan this number of seconds earlier than its target start time (you can use fractional seconds). It assumes infinite acceleration for this time estimation, and will only take into account G1 and G0 moves (arc fitting is unsupported).
It won't move fan commands from custom G-code (they act as a sort of 'barrier').
It won't move fan commands into the start G-code if the 'only custom start G-code' is activated.
Use 0 to deactivate.

### Only overhangs

Will only take into account the delay for the cooling of overhangs.

## Fan kick-start time

Emit a max fan speed command for this amount of seconds before reducing to target speed to kick-start the cooling fan.
This is useful for fans where a low PWM/power may be insufficient to get the fan started spinning from a stop, or to get the fan up to speed faster.
Set to 0 to deactivate.
