# Auto Arrange

The Auto Arrange feature helps you quickly and efficiently position multiple models on the build plate for optimal printing based on the selected arrangement strategy.

## Parameters

- **Spacing**: Set the minimum distance between models.
- **Auto rotate for arrangement**: Automatically rotate models to fit better on the build plate.
- **Allow multiple materials on same plate**: Enable this option to allow models with different materials to be arranged together on the same build plate. If disabled for each material a separate plate will be created.
- **Align to Y axis**: Reduce bed motion by aligning models along Y to improve precision and reduce wobble on tall prints; especially useful for i3-style printers (bed moves in Y). On CoreXY or gantry systems with a fixed bed the benefit is minimal and it can increase toolhead travel.
