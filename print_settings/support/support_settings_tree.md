# Tree Support

This section contains specific settings for tree support structures.

## Tip Diameter

[Variable](Built-in-placeholders-variables): `tree_support_tip_diameter`.  
Branch tip diameter for organic supports.

## Branch Distance

[Variables](Built-in-placeholders-variables): `tree_support_branch_distance`, `tree_support_branch_distance_organic`.  
This setting determines the distance between neighboring tree support nodes.

## Branch Density

[Variable](Built-in-placeholders-variables): `tree_support_top_rate`.  
Adjusts the density of the support structure used to generate the tips of the branches. A higher value results in better overhangs but the supports are harder to remove, thus it is recommended to enable top support interfaces instead of a high branch density value if dense interfaces are needed.

## Branch Diameter

[Variables](Built-in-placeholders-variables): `tree_support_branch_diameter`, `tree_support_branch_diameter_organic`.  
This setting determines the initial diameter of support nodes.

## Branch Diameter Angle

[Variable](Built-in-placeholders-variables): `tree_support_branch_diameter_angle`.  
The angle of the branches' diameter as they gradually become thicker towards the bottom. An angle of 0 will cause the branches to have uniform thickness over their length. A bit of an angle can increase stability of the organic support.

## Branch Angle

[Variables](Built-in-placeholders-variables): `tree_support_branch_angle`, `tree_support_branch_angle_organic`.  
This setting determines the maximum overhang angle that the branches of tree support are allowed to make. If the angle is increased, the branches can be printed more horizontally, allowing them to reach farther.

### Preferred Branch Angle

[Variable](Built-in-placeholders-variables): `tree_support_angle_slow`.  
The preferred angle of the branches, when they do not have to avoid the model. Use a lower angle to make them more vertical and more stable. Use a higher angle for branches to merge faster.
