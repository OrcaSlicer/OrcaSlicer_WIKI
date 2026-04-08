# Support Filament

Support filament settings allow you to customize the material used for support structures in your 3D prints. This can include settings for the base layer, interface, and support style.

## Base

[Variable](built_in_placeholders_variables): `support_filament`.  
Filament to print support base and raft. "Default" means no specific filament for support and current filament is used.

## Interface

[Variable](built_in_placeholders_variables): `support_interface_filament`.  
Filament to print support interface. "Default" means no specific filament for support interface and current filament is used.

### Avoid interface filament for base

[Variable](built_in_placeholders_variables): `support_interface_not_for_body`.  
Avoid using support interface filament to print support base if possible.
