# Assembly Tools

There are two assembly tools in OrcaSlicer, one for generating assemblies on the bed from multiple imported [objects](prepare_object set) and another for viewing an imported assembly that has been disassembled on the bed to optimize printing.

## Assemble

Use the Assemble tool to create an bed assembly from multiple objects.

> [!TIP]
> Is recommended to merge the objects into one before using this function.  
> This way the assembly will be considered as parts after they are merged, and can be adjusted freely on the z-axis.  
> If the objects are not merged, the assembly will be considered as separate objects and each part must have a face that touches the heatbed.

### Point and Print Assembly

Use the Point and Print Assembly tool to create assembly instructions by selecting points on your 3D model.  
Press and hold the `Shift` key while clicking on the model to select assembly points.

### Face and Face Assembly

Use the Face and Face Assembly tool to create assembly instructions by selecting faces on your 3D model.  
After selecting both faces to be joined, you can select the alignment method:

- **Parallel**: Aligns the faces so that they are parallel to each other.
- **Center coincidence**: Aligns the centers of the faces.
- **Flip by Face 2**: Flips the orientation of object 2 based on the normal of face 2.

## Assembly View

When importing a STEP Assembly file, you can use the Assembly View to see the hierarchical structure of the assembly.  
It's recommended to [split compound and compsolid into multiple objects](import_export#split-compound-and-compsolid-into-multiple-objects) when importing and then [Split](prepare_object_set#split-to-objects) for better manipulation.  
This way you can Auto arrange all objects and still keep the assembly structure in the Assembly View.

![assembly_bed_view](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/assembly/assembly_bed_view.png?raw=true)

![assembly_view](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/assembly/assembly_view.png?raw=true)
