# Tree Support

[Variables](built_in_placeholders_variables): `tree_support_auto_brim`, `tree_support_brim_width`.  
[Type](option_type): `tree_support_auto_brim` (Boolean), `tree_support_brim_width` (Float).  
[CLI Example](cli_mode#setting-overrides): `--tree-support-auto-brim=1` (`tree_support_auto_brim` shown; other variables above follow their own type).  
This section contains specific settings for tree support structures.

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
Adjusts the density of the support structure used to generate the tips of the branches. A higher value results in better overhangs but the supports are harder to remove, thus it is recommended to enable top support interfaces instead of a high branch density value if dense interfaces are needed.

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
The angle of the branches' diameter as they gradually become thicker towards the bottom. An angle of 0 will cause the branches to have uniform thickness over their length. A bit of an angle can increase stability of the organic support.

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
