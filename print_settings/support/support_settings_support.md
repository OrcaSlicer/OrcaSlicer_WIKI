# Support

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `enable_support`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--enable-support=1`.  
Support structures are used in 3D printing to provide stability to overhangs and complex geometries.

- [Type](#type)
    - [Normal](#normal)
    - [Tree](#tree)
        - [Support critical regions only](#support-critical-regions-only)
    - [Auto](#auto)
    - [Manual](#manual)
- [Style](#style)
    - [Grid](#grid)
    - [Snug](#snug)
    - [Organic](#organic)
    - [Tree Slim](#tree-slim)
    - [Tree Strong](#tree-strong)
    - [Tree Hybrid](#tree-hybrid)
- [Threshold angle](#threshold-angle)
- [Threshold overlap](#threshold-overlap)
- [Initial layer density](#initial-layer-density)
- [Initial layer expansion](#initial-layer-expansion)
- [On build plate only](#on-build-plate-only)
- [Ignore small overhangs](#ignore-small-overhangs)

## Type

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `support_type`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `normal(auto), tree(auto), normal(manual), tree(manual)`.  
[CLI Example](cli_mode#setting-overrides): `--support-type=normal(auto)`.  
There are several support types, each suited for different printing needs:

### Normal

Normal support structures are projected straight down from the overhangs, providing a stable base for overhangs and complex geometries.

### Tree

Tree-like support structures are designed to minimize material usage while still providing adequate support. They branch out from a central trunk, allowing for more efficient printing.

#### Support critical regions only

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_critical_regions_only`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--support-critical-regions-only=1`.  
Only creates support for critical regions, such as sharp tails and cantilevers. Available only with `Tree (auto)`.

### Auto

Automatically generates support wherever the model's overhangs need it, as well as where support enforcers are placed in the Prepare view.

### Manual

Only generates support where support enforcers are placed in the Prepare view.

## Style

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_style`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `default, grid, snug, organic, tree_slim, tree_strong, tree_hybrid`.  
[CLI Example](cli_mode#setting-overrides): `--support-style=default`.  
Style and shape of the support.  
Grid and Snug apply to normal supports, while Organic, Tree Slim, Tree Strong and Tree Hybrid apply to tree supports. `Default (Grid/Organic)` uses Grid for normal supports and Organic for tree supports.

### Grid

Default for normal supports. Projecting the supports into a regular grid creates more stable supports.

### Snug

Snug support towers save material and reduce object scarring.

### Organic

Default style for tree supports. Like Tree Slim, it merges branches more aggressively and saves a lot of material.

### Tree Slim

Slim tree support branches are designed to be more delicate and use less material while still providing adequate support.

### Tree Strong

Strong tree support branches are designed to be more robust and provide additional support for heavier overhangs.

### Tree Hybrid

Creates a structure similar to normal support under large flat overhangs.

## Threshold angle

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `support_threshold_angle`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--support-threshold-angle=1`.  
Support will be generated for overhangs whose slope angle is below the threshold. The smaller this value is, the steeper the overhang that can be printed without support.  
If set to `0`, normal supports use the [Threshold overlap](#threshold-overlap) instead, while tree supports use 30°.

## Threshold overlap

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `support_threshold_overlap`.  
[Type](option_type#integer-float-percentage): `Float or Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--support-threshold-overlap=20%`.  
If [Threshold angle](#threshold-angle) is zero, support will be generated for overhangs whose overlap with the layer below is below the threshold. A percentage is relative to the outer wall line width.
The smaller this value is, the steeper the overhang that can be printed without support.  
Tree supports don't use this setting, so it is hidden for them.

## Initial layer density

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `raft_first_layer_density`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--raft-first-layer-density=20%`.  
Density of the first raft or support layer.

## Initial layer expansion

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `raft_first_layer_expansion`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--raft-first-layer-expansion=1`.  
Expands the first raft or support layer to improve build plate adhesion. It is disabled for the Tree Slim and Tree Strong styles unless a raft is used.

## On build plate only

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `support_on_build_plate_only`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--support-on-build-plate-only=1`.  
Don't create support on the model surface, only on the build plate.

## Ignore small overhangs

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `support_remove_small_overhang`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--support-remove-small-overhang=1`.  
With this setting, small overhangs that possibly don't need support are ignored by support generation.
