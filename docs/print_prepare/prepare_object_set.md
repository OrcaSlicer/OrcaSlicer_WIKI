# Object Set

The object set is the basic structure used to organize and manage 3D models within OrcaSlicer. It allows users to group multiple objects and their respective parts for easier manipulation, configuration, and slicing.

## Part

Each Object Set consists of one or more Parts.  
A Part represents a single 3D model or mesh that has been imported into the project. Each Part can have its own unique settings, such as print parameters, supports, and modifiers.

## Instance

An instance is a specific instance of an Object Set placed on the print bed.  
All instances of the same Object Set share the same Parts, size, and settings. However, each instance can have its own position and rotation on the print bed.  
This could be useful when printing multiple copies of the same model while keeping same painted settings ([Color](prepare_color_painting), [Fuzzy Skin](prepare_paint_on_fuzzy_skin), [Seams](prepare_seam_painting), [supports](prepare_support_painting), etc).

## Splitting

### Split to Objects

When selecting an Object Set with multiple Parts, users can choose to split the Object Set into individual Objects.  
Each Object will contain a single Part from the original Object Set.

### Split to Parts

When selecting an Object with a single Part that contains multiple meshes, users can choose to split the Object into individual Parts.  
Each Part will represent a single mesh from the original Object and will allow for independent manipulation and settings.
