# Import and Export

OrcaSlicer offers various export options to import and export 3D models, projects and configurations.

- [Model](#model)
    - [Import Model](#import-model)
    - [Export Model](#export-model)
- [Project](#project)
    - [Import Project](#import-project)
    - [Export Project](#export-project)
- [Sliced](#sliced)
    - [Export Sliced](#export-sliced)
    - [Import Sliced](#import-sliced)
- [Presets](#presets)
    - [Export Preset Bundle](#export-preset-bundle)
    - [Import Preset Bundle](#import-preset-bundle)
- [Supported File Formats](#supported-file-formats)
    - [STL](#stl)
    - [3MF](#3mf)
    - [STEP](#step)
        - [Importing STEP files](#importing-step-files)
            - [Parameters](#parameters)
            - [Split compound and compsolid into multiple objects](#split-compound-and-compsolid-into-multiple-objects)
            - [Don't show again](#dont-show-again)
    - [DRC](#drc)
        - [Draco Compression](#draco-compression)
            - [Draco Quantization Bits](#draco-quantization-bits)
    - [OBJ](#obj)
    - [AMF](#amf)
    - [SVG](#svg)
    - [ZIP](#zip)

## Model

Models are the basic objects that you work with in OrcaSlicer. They represent the basic feature that you want to slice and print.

### Import Model

You can import 3D models from [different file formats](#supported-file-formats) into OrcaSlicer using one of the following methods:

- **File Menu:** Go to `File` > `Import` and select the desired 3D model file.
- **[Prepare Toolbar Add Button](prepare_basic#add-objects):** Click on the `Add` button in the toolbar to open the file dialog and select your 3D model file.
- **Drag and Drop:** Simply drag and drop the 3D model file into the OrcaSlicer window.

### Export Model

Use the `Export Model` (under `File` > `Export` > `...`) option to export 3D models or assemblies in various file formats. This is useful for sharing specific models or assemblies without including the entire project.

The available export formats are:

- **[STL](#stl):** Export the current model as an STL file.
- **[DRC](#drc):** Export the current model as a Draco-compressed file.
- **[Generic 3MF](#3mf):** Export the current model as a generic 3MF file without printer, material, or process information.

## Project

Projects are a convenient way to save and manage your work in OrcaSlicer, allowing you to keep in a single file all the objects, print settings, and configurations related to a specific project.

### Import Project

Use the `Import Project` (under `File` > `Open Project...`) option to open a previously saved project file. This will load all the objects, print settings, and configurations associated with that project, allowing you to continue working on it or review its details.

### Export Project

Use the `Export Project` (under `File` > `Save Project...`) option to save your entire project, including all objects, print settings, and configurations, into a single file that can be easily shared or backed up.

This is very useful for saving your work in progress or sharing your project with others while preserving all the details and settings.

## Sliced

After slicing a model, you can export the sliced result for printing.

### Export Sliced

- **G-code:** Export the sliced model as a G-code file that can be directly sent to a 3D printer for printing.
- **Gcode.3MF:** Export the sliced model as a Gcode.3MF file that includes the resulting G-code file along with printer, material, and process information. This is useful for sharing the sliced model with all the necessary information for printing.
- **Toolpaths as OBJ:** Export the sliced model 3D preview as an OBJ file.

![export_toolpaths_obj](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/import_export/export_toolpaths_obj.png?raw=true)

### Import Sliced

OrcaSlicer also allows you to import sliced files in G-code. This can help you visualize the toolpaths of a G-code file, which can be useful for analyzing the slicing results or for comparing different slicing configurations.

> [!TIP]
> G-code files will only contain the toolpaths and will not include any printer, material, or process information.  
> If you want to import a sliced file with all the necessary information for printing, it's recommended to use the Gcode.3MF format.

## Presets

Presets are a convenient way to save and manage specific settings and configurations in OrcaSlicer, allowing you to easily apply them to different models or projects.

### Export Preset Bundle

This tool allows you to export a bundle of presets that you can use to share specific settings and configurations with others or to back up your presets for future use.

- **Printer config bundle:** Export Printer and all the filament and process presets that belongs to the printer in a `.orca_printer` format.
- **Filament bundle:** Export user's filamnets presets set in a `.orca_filaments` format.
- **Printer presets:** Export user's printer presets set in a `.zip` file.
- **Filament presets:** Export user's filament presets set in a `.zip` file.
- **Process presets:** Export user's process presets set in a `.zip` file.

### Import Preset Bundle

To import a preset bundle, use the `Import Configs` (under `File` > `Import` > `Preset Configs`) option and select the desired preset bundle file. This will import the presets contained in the bundle and make them available for use in your projects.

## Supported File Formats

OrcaSlicer supports the following 3D model file formats for import:

### STL

[STL](https://en.wikipedia.org/wiki/STL_(file_format)) is a widely used file format for 3D printing that represents the surface geometry of a 3D object using triangular facets.

> [!NOTE]
> This is the basic file format used for the slicing process in OrcaSlicer. Any other supported file formats (e.g., STEP, 3MF, OBJ) are converted to STL during the import process.

It's main advantage is its simplicity and wide compatibility with various 3D modeling software and slicers.   However, STL files can have limitations in terms of mesh quality and may not capture intricate details accurately.  
If the original model was designed in a Mesh-based software, such as Blender or ZBrush, the STL file will likely be a good representation of the original design.  
However, if the original model was created in a CAD software, such as SolidWorks or Fusion 360, the STL file may not capture all the details and features of the original design accurately and will depend on the CAD's export settings.

### 3MF

3MF is a modern file format designed for 3D printing that provides a more efficient and comprehensive way to represent 3D models, including support for colors, materials, and multiple objects within a single file.

Some 3MF files may contain Printer, Material, and Process information that can be used to automatically configure print settings in OrcaSlicer.  
When importing a 3MF file, OrcaSlicer will attempt to extract this information and apply it to the imported model.  
If the 3MF information is not compatible with OrcaSlicer, it will be ignored and the model will be imported with default settings.

> [!TIP]
> You can open 3MF files as a ZIP archive to inspect the included information and files.

### STEP

[STEP](https://en.wikipedia.org/wiki/ISO_10303-21) is a comprehensive file format that represents 3D models using a more detailed and accurate representation of the original design. It is commonly used in engineering and manufacturing applications.

#### Importing STEP files

This setting determines how STEP files are converted into STL files and is displayed during the STEP file import process.

![stl-transformation](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/STL-Transformation/stl-transformation.png?raw=true)

##### Parameters

The transformation uses [Linear Deflection and Angular Deflection](https://dev.opencascade.org/doc/overview/html/occt_user_guides__mesh.html) parameters to control the mesh quality.
A finer mesh will result in a more accurate representation of the original surface, but it will also increase the file size and processing time.

![stl-transformation-params](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/STL-Transformation/stl-transformation-params.svg?raw=true)

- **Linear Deflection:** Specifies the maximum distance allowed between the original surface and its polygonal approximation. Lower values produce a mesh that more accurately follows the original curvature.
- **Angular Deflection:** Defines the maximum allowable angle difference between the actual surface and its tessellated counterpart. Smaller angular deflection values yield a more precise mesh.

##### Split compound and compsolid into multiple objects

Enabling this option will split the imported 3D file into separate [parts of the same object](prepare_object_set#split-to-parts). This is especially useful for adjusting individual part positions, tweaking print settings, or optimizing the model through simplification while maintaining the original design [assembly](prepare_assembly_tools).

![stl-transformation-split](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/STL-Transformation/stl-transformation-split.png?raw=true)

##### Don't show again

This option will hide the STL transformation dialog when opening a STEP file.
To restore the dialog, go to "Preferences" (Ctrl + P) > "Show the STEP mesh parameter setting dialog".

![stl-transformation-enable](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/STL-Transformation/stl-transformation-enable.png?raw=true)

### DRC

[Draco (DRC)](https://github.com/google/draco) is a compression library developed by Google that is designed to compress and decompress 3D geometric meshes.  
Its main advantage is its ability to significantly reduce the file size of 3D models while maintaining a high level of visual fidelity.

#### Draco Compression

Draco uses several compression techniques to achieve high compression ratios, like file compression (used at maximum level in OrcaSlicer), duplicated vertex removal, and Quantization Bits.

##### Draco Quantization Bits

This technique reduces the precision of the vertex attributes (such as position, normal, and texture coordinates) to further decrease the file size.  
By default, OrcaSlicer disables quantization by setting the quantization bits to 0, which means that the original precision of the vertex attributes is preserved. This will create a almost Lossless compression (~15% of the original size) but it can be adjusted to achieve a smaller file size at the cost of some loss in visual fidelity.

Using a quantization bit value of 25 will result in a even smaller file size (around 5% of the original size) while still maintaining a good level of visual fidelity and dimensional accuracy for most models.
Using a quantization bit value of 16 or lower may result in a significant loss of visual fidelity, especially for models with fine details. For some artistic models where precision is not important, lower values can be used to achieve a very small file size (around 1% of the original size).

### OBJ

Similar to STL, OBJ is a widely used file format for 3D models that represents the geometry of a 3D object using vertices, edges, and faces. It also supports texture mapping and material properties.

### AMF

AMF (Additive Manufacturing File Format) is an XML-based file format designed for 3D printing that provides a more flexible and comprehensive way to represent 3D models, including support for colors, materials, and multiple objects within a single file.

### SVG

SVG (Scalable Vector Graphics) is a file format used for 2D vector graphics. It can be imported into OrcaSlicer to create 3D models by extruding the 2D shapes defined in the SVG file.

### ZIP

OrcaSlicer also supports importing ZIP files that contain one of the supported 3D model file formats (e.g., STL, 3MF, OBJ). When you import a ZIP file, OrcaSlicer will extract the contents and look for supported 3D model files to import.
