# Tree Support

This section contains specific settings for tree support structures.

[Tip Diameter](#tip-diameter), [Branch Density](#branch-density), [Branch Diameter Angle](#branch-diameter-angle) and [Preferred Branch Angle](#preferred-branch-angle) apply only to the [Organic](support_settings_support#organic) style. [Branch Distance](#branch-distance), [Branch Diameter](#branch-diameter) and [Branch Angle](#branch-angle) have separate values for the Organic style and for the Tree Slim, Tree Strong and Tree Hybrid styles. [Auto brim width](#auto-brim-width) and [Tree support brim width](#tree-support-brim-width) apply only to the Tree Slim, Tree Strong and Tree Hybrid styles.

## Tip Diameter

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `tree_support_tip_diameter`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-tip-diameter=1`.  
Branch tip diameter for organic supports.

## Branch Distance

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `tree_support_branch_distance`, `tree_support_branch_distance_organic`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-branch-distance=1` (same pattern for the other variables above).  
This setting determines the distance between neighboring tree support nodes.

## Branch Density

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `tree_support_top_rate`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-top-rate=20%`.  
Adjusts the density of the support structure used to generate the tips of the branches. A higher value results in better overhangs, but the supports are harder to remove. It is therefore recommended to enable top support interfaces instead of using a high branch density value if dense interfaces are needed.

## Branch Diameter

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `tree_support_branch_diameter`, `tree_support_branch_diameter_organic`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-branch-diameter=1` (same pattern for the other variables above).  
This setting determines the initial diameter of support nodes.

## Branch Diameter Angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `tree_support_branch_diameter_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-branch-diameter-angle=1`.  
The angle of the branches' diameter as they gradually become thicker towards the bottom. An angle of 0 will cause the branches to have uniform thickness over their length. A bit of an angle can increase the stability of the organic support.

## Branch Angle

[Mode](option_mode): `Advanced`.  
[Variables](built_in_placeholders_variables): `tree_support_branch_angle`, `tree_support_branch_angle_organic`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-branch-angle=1` (same pattern for the other variables above).  
This setting determines the maximum overhang angle that the branches of tree support are allowed to make. If the angle is increased, the branches can be printed more horizontally, allowing them to reach farther.

### Preferred Branch Angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `tree_support_angle_slow`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-angle-slow=1`.  
The preferred angle of the branches, when they do not have to avoid the model. Use a lower angle to make them more vertical and more stable. Use a higher angle for branches to merge faster.

## Auto brim width

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `tree_support_auto_brim`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-auto-brim=1`.  
On the first layer, each branch is widened by a brim that helps it stick to the build plate. When this is enabled, the brim width is calculated per branch as half the branch height divided by its radius at the plate, so tall, thin branches get a wider brim: a 40 mm tall branch with a 2 mm radius gets a 10 mm brim. It is never less than 2 mm, and is otherwise capped so that a branch and its brim stay within 12 mm of the branch center.

The brim is only added when there is no raft. With the Tree Hybrid style, it is added to the branches only; the parts printed as normal support use [Initial layer expansion](support_settings_support#initial-layer-expansion) instead.

### Tree support brim width

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `tree_support_brim_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--tree-support-brim-width=1`.  
The brim width used when [Auto brim width](#auto-brim-width) is disabled: the distance from the edge of each branch to the outer edge of its brim. `0` disables the brim.
