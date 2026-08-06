# Support Filament

Support filament settings allow you to customize the material used for support structures in your 3D prints. This can include settings for the base layer, interface, and support style.

- [Base](#base)
- [Interface](#interface)
    - [Avoid interface filament for base](#avoid-interface-filament-for-base)
    - [Interface filament transitions](#interface-filament-transitions)

## Base

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `support_filament`.  
Filament to print support base and raft. "Default" means no specific filament for support and current filament is used.

## Interface

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `support_interface_filament`.  
Filament to print support interface. "Default" means no specific filament for support interface and current filament is used.

### Avoid interface filament for base

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `support_interface_not_for_body`.  
Avoid using support interface filament to print support base if possible.

This affects the support **body** only. It is a separate thing from the bonding layer described below, which is part of the interface itself.

### Interface filament transitions

When you give the interface its own filament, the two materials have to meet somewhere. Rather than stacking the interface material straight onto the support body, Orca prints the **last** interface layer — the one at the back of the interface, touching the support body and furthest from the model — in the base filament. That layer is still shaped like an interface, with the same spacing and density, so the interface material lands on a solid, well matched surface instead of on open support lines.

How many layers you get of each material depends on the [Interface layers](support_settings_advanced#interface-layers) count:

| Interface layers | Interface filament | Base filament |
| --- | --- | --- |
| 1 | 1 (the layer facing the model) | 0 |
| 2 | 1 | 1 |
| 3 | 2 | 1 |
| N | N − 1 | 1 |

The layer facing the model is always the interface material, so if you want the interface printed purely in its own filament, set the count to `1`. From `2` upwards you always get exactly one bonding layer in the base filament, no matter how thick the interface is or what [Z distance](support_settings_advanced#z-distance) you use. Top and bottom interfaces are worked out separately, each from its own count.

> [!NOTE]
> A soluble interface sitting directly on a non-soluble base, with no Z gap, is split differently: up to half the layers, and never more than two, are printed in the non-soluble filament, so the soluble material has something rigid underneath it.

Worth knowing:

- Going from `1` to `2` interface layers does more than add a layer — it brings a second material into the interface, which means extra tool changes and purge on a multi-material printer.
- The bonding layer counts as support base, so speed and cooling settings you have tuned for the interface do not apply to it.
- If **Base** is left as `Default`, that layer prints in whatever filament is already loaded, normally the one the model is being printed with.
- Choosing an interface filament while **Base** is `Default` still counts as two different materials, because support filaments cannot be used for the support body.
