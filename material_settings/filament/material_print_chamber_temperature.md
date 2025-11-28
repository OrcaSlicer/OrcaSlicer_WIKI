# Material Print Chamber Temperature

Enable this option for automated chamber temperature control. This option activates the emitting of an M191 command before the "machine_start_gcode" which sets the chamber temperature and waits until it is reached.  
In addition, it emits an M141 command at the end of the print to turn off the chamber heater, if present.

This option relies on the firmware supporting the M191 and M141 commands either via macros or natively and is usually used when an active chamber heater is installed.
