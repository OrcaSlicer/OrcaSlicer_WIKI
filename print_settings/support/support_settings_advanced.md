# Support Advanced

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `support_interface_loop_pattern`, `max_bridge_length`.  

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

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `support_top_z_distance`, `support_bottom_z_distance`.  
The Z gap between support interface and object.

## Support wall loops

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `tree_support_wall_count`.  
This setting specifies the count of support walls in the range of [0,2]. 0 means auto.

## Base Pattern

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_base_pattern`.  
Line pattern for the base of the support.

### Base pattern spacing

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_base_pattern_spacing`.  
Spacing between support lines.

## Pattern angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_angle`.  
Use this setting to rotate the support pattern on the horizontal plane.

## Interface layers

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `support_interface_top_layers`, `support_interface_bottom_layers`.  
The number of interface layers.

The number you set is the total thickness of the dense interface, counted in printed layers and including the layer that faces the model. Set `1` and you get a single dense layer; set `3` and you get three. More layers give a flatter, better supported surface but take longer to print and are harder to peel off.

The top and bottom interfaces are set separately:

- **Top interface layers** (`support_interface_top_layers`) are the layers printed under an overhang, below the [Z distance](#z-distance) gap. These are the ones that determine the finish of the supported surface.
- **Bottom interface layers** (`support_interface_bottom_layers`) are the layers printed where a support lands on top of the model, protecting that surface from the support body. `Same as top` reuses the top value. You can use bottom interfaces on their own, with top interface layers set to `0`.

With both set to `0` there is no interface at all: the support prints all the way through with the [Base Pattern](#base-pattern), which is fastest and easiest to remove but leaves the roughest overhangs.

> [!TIP]
> When the interface has its own filament assigned, this number also decides how the layers are shared between the two materials. See [Interface filament transitions](support_settings_filament#interface-filament-transitions).

## Interface pattern

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_interface_pattern`.  
The pattern used for the support interface.

Each option lays the interface lines out differently, and all of them are measured from [Pattern angle](#pattern-angle), so rotating that rotates the interface with it. The same rules apply to normal and tree supports.

| Option | What you get |
| --- | --- |
| `Default` | Straight lines crossing the support at 90° to Pattern angle. Switches to concentric loops when the interface touches the model, which is the usual case for soluble supports. |
| `Rectilinear` | Straight lines at 90° to Pattern angle. With the [Snug](support_settings_support#snug) style they are rotated a further 45°. |
| `Concentric` | Loops following the outline of the interface, which peel off in one piece and leave no line ends on the surface. |
| `Rectilinear Interlaced` | Straight lines that swing 45° one way then the other on each successive layer, so the layers cross instead of stacking. This ties the interface together and makes it stiffer under the overhang. |
| `Grid` | Straight lines running along Pattern angle, in line with the [Base Pattern](#base-pattern) below. |

If [Interface spacing](#interface-spacing) is wide enough that the interface is no longer solid, the straight-line options switch to the base support pattern so that the sparse lines still anchor to each other.

## Interface spacing

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `support_interface_spacing`, `support_bottom_interface_spacing`.  
Spacing of interface lines. Zero means solid interface.

The top (`support_interface_spacing`) and bottom (`support_bottom_interface_spacing`) values are set separately and neither one affects the other, so a bottom interface keeps the spacing you gave it even if you have turned top interfaces off.

## Normal support expansion

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_expansion`.  
Expand (+) or shrink (-) the horizontal span of normal support.

## Support/object XY distance

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_object_xy_distance`.  
XY separation between an object and its support.

## Support/object first layer gap

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_object_first_layer_gap`.  
XY separation between an object and its support at the first layer.

## Don't support bridges

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `bridge_no_support`.  
Don't support the whole bridge area which make support very large. Bridges can usually be printed directly without support if not very long.

## Independent support layer height

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `independent_support_layer_height`.  
Support layer uses layer height independent with object layer. This is to support customizing z-gap and save print time. This option will be invalid when the prime tower is enabled.

Turning this on changes the height of the support layers, not their number: you still get exactly the [Interface layers](#interface-layers) you asked for, including with the `Tree Slim`, `Tree Strong` and `Tree Hybrid` styles.
