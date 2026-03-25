# Support Advanced

- [Z distance](#z-distance)
- [Support wall loops](#support-wall-loops)
- [Base Pattern](#base-pattern)
    - [Base pattern spacing](#base-pattern-spacing)
- [Pattern angle](#pattern-angle)
- [Interface layers](#interface-layers)
- [Interface pattern](#interface-pattern)
- [Interface spacing](#interface-spacing)
- [Normal support expansion](#normal-support-expansion)
- [Support/object XY distance](#supportobject-xy-distance)
- [Support/object first layer gap](#supportobject-first-layer-gap)
- [Don't support bridges](#dont-support-bridges)
- [Independent support layer height](#independent-support-layer-height)

## Z distance

[Variables](Built-in-placeholders-variables): `support_top_z_distance`, `support_bottom_z_distance`.  
The Z gap between support interface and object.

## Support wall loops

[Variable](Built-in-placeholders-variables): `tree_support_wall_count`.  
This setting specifies the count of support walls in the range of [0,2]. 0 means auto.

## Base Pattern

[Variable](Built-in-placeholders-variables): `support_base_pattern`.  
Line pattern for the base of the support.

### Base pattern spacing

[Variable](Built-in-placeholders-variables): `support_base_pattern_spacing`.  
Spacing between support lines.

## Pattern angle

[Variable](Built-in-placeholders-variables): `support_angle`.  
Use this setting to rotate the support pattern on the horizontal plane.

## Interface layers

[Variables](Built-in-placeholders-variables): `support_interface_top_layers`, `support_interface_bottom_layers`.  
The number of interface layers.

## Interface pattern

[Variable](Built-in-placeholders-variables): `support_interface_pattern`.  
The pattern used for the support interface.

## Interface spacing

[Variables](Built-in-placeholders-variables): `support_interface_spacing`, `support_bottom_interface_spacing`.  
Spacing of interface lines. Zero means solid interface.

## Normal support expansion

[Variable](Built-in-placeholders-variables): `support_expansion`.  
Expand (+) or shrink (-) the horizontal span of normal support.

## Support/object XY distance

[Variable](Built-in-placeholders-variables): `support_object_xy_distance`.  
XY separation between an object and its support.

## Support/object first layer gap

[Variable](Built-in-placeholders-variables): `support_object_first_layer_gap`.  
XY separation between an object and its support at the first layer.

## Don't support bridges

[Variable](Built-in-placeholders-variables): `bridge_no_support`.  
Don't support the whole bridge area which make support very large. Bridges can usually be printed directly without support if not very long.

## Independent support layer height

[Variable](Built-in-placeholders-variables): `independent_support_layer_height`.  
Support layer uses layer height independent with object layer. This is to support customizing z-gap and save print time. This option will be invalid when the prime tower is enabled.
