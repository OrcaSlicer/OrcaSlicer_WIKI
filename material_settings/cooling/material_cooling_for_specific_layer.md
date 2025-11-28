# Material Cooling for Specific Layer

This setting allows you to customize the cooling behavior of your 3D printer for specific layers of your print.  
Proper cooling is essential for achieving high-quality prints, especially when dealing with overhangs and bridges.

## No cooling for the first

Number of layers to turn off cooling fans.  
Turn off all cooling fans for the first few layers. This can be used to improve build plate adhesion.

## Full fan speed at layer

Fan speed will be ramped up linearly from zero at layer "close_fan_the_first_x_layers" to maximum at layer "full_fan_speed_layer". "full_fan_speed_layer" will be ignored if lower than "close_fan_the_first_x_layers", in which case the fan will be running at maximum allowed speed at layer "close_fan_the_first_x_layers" + 1.
