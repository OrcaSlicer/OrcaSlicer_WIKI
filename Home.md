# Welcome to the OrcaSlicer Wiki

OrcaSlicer is a powerful open source slicer for FFF (FDM) 3D Printers. This wiki page aims to provide an detailed explanation of the slicer settings, how to get the most out of them as well as how to calibrate and setup your printer.

- [Printer Settings](#printer-settings)
- [Material Settings](#material-settings)
- [Process Settings](#process-settings)
    - [Quality Settings](#quality-settings)
    - [Strength Settings](#strength-settings)
    - [Speed Settings](#speed-settings)
    - [Support Settings](#support-settings)
    - [Multimaterial Settings](#multimaterial-settings)
    - [Others Settings](#others-settings)
- [Prepare](#prepare)
- [Calibrations](#calibrations)
- [General Settings](#general-settings)
- [Developer Section](#developer-section)

> [!WARNING]
> This wiki is community-maintained.  
> Some pages may be **outdated** while others may be **newer** and present only in [nightly build](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or [latest release](https://github.com/OrcaSlicer/OrcaSlicer/releases).

> [!NOTE]
> Please consider contributing to the wiki following the [How to contribute to the wiki](How-to-wiki) guide.

## Printer Settings

![printer-preset](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/printer-preset.png?raw=true)  
<img alt="printer" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/printer.svg?raw=true" height="22"> Settings related to the 3D printer hardware and its configuration.

- Basic Information
    - [<img alt="param_printable_space" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_printable_space.svg?raw=true" height="22"> Printable space](printer_basic_information_printable_space)
    - [<img alt="param_advanced" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true" height="22"> Advanced](printer_basic_information_advanced)
    - [<img alt="param_cooling_fan" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_cooling_fan.svg?raw=true" height="22"> Cooling Fan](printer_basic_information_cooling_fan)
    - [<img alt="param_extruder_clearance" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_clearance.svg?raw=true" height="22"> Extruder Clearance](printer_basic_information_extruder_clearance)
    - [<img alt="param_adaptive_mesh" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_adaptive_mesh.svg?raw=true" height="22"> Adaptive bed mesh](printer_basic_information_adaptive_bed_mesh)
    - [<img alt="param_accessory" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_accessory.svg?raw=true" height="22"> Accessory](printer_basic_information_accessory)
- [<img alt="param_gcode" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true" height="22"> Machine G_Code](printer_machine_gcode)
- Multimaterial
    - [<img alt="param_multi_material" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_multi_material.svg?raw=true" height="22"> Multimaterial setup](printer_multimaterial_setup)
    - [<img alt="param_tower" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_tower.svg?raw=true" height="22"> Wipe tower](printer_multimaterial_wipe_tower)
    - [<img alt="param_settings" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_settings.svg?raw=true" height="22"> Single extruder multi_material parameters](printer_multimaterial_semm_parameters)
    - [<img alt="param_advanced" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true" height="22"> Advanced](printer_multimaterial_advanced)
- Extruder
    - [<img alt="param_information" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_information.svg?raw=true" height="22"> Basic Information](printer_extruder_basic_information)
    - [<img alt="param_retraction" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_retraction.svg?raw=true" height="22"> Retraction](printer_extruder_retraction)
        - [<img alt="param_retraction_material_change" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_retraction_material_change.svg?raw=true" height="22"> Retraction when switching materials](printer_extruder_retraction#retraction-when-switching-materials)
    - [<img alt="param_extruder_lift_enforcement" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_lift_enforcement.svg?raw=true" height="22"> Z_Hop](printer_extruder_z_hop)
- [<img alt="param_acceleration" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_acceleration.svg?raw=true" height="22"> Motion ability](printer_motion_ability)

## Material Settings

![filament-preset](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/filament-preset.png?raw=true)  
<img alt="filament" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/filament.svg?raw=true" height="22"> Settings related to the 3D printing material.

- Material settings
    - [<img alt="param_information" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_information.svg?raw=true" height="22"> Basic Information](material_basic_information)
    - [<img alt="param_flow_ratio_and_pressure_advance" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_flow_ratio_and_pressure_advance.svg?raw=true" height="22"> Flow Ratio and Pressure Advance](material_flow_ratio_and_pressure_advance)
    - [<img alt="param_extruder_temp" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_temp.svg?raw=true" height="22"> Material temperatures](material_temperatures)
        - [<img alt="param_chamber_temp" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_chamber_temp.svg?raw=true" height="22"> Print Chamber temperature](material_temperatures#print-chamber-temperature)
        - [<img alt="param_extruder_temp" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_temp.svg?raw=true" height="22"> Print temperature](material_temperatures#nozzle)
        - [<img alt="param_bed_temp" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_bed_temp.svg?raw=true" height="22"> Bed temperature](material_temperatures#bed)
    - [<img alt="param_volumetric_speed" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_volumetric_speed.svg?raw=true" height="22"> Volumetric Speed limitation](material_volumetric_speed_limitation)
- [<img alt="param_cooling_part_fan" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_cooling_part_fan.svg?raw=true" height="22"> Material Cooling](material_cooling)
- [<img alt="param_settings" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_settings.svg?raw=true" height="22"> Setting Overrides](material_setting_overrides)
- [<img alt="param_gcode" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true" height="22"> Advanced](material_advanced)
- [<img alt="custom-gcode_multi_material" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_multi_material.svg?raw=true" height="22"> Multimaterial](material_multimaterial)
- [<img alt="param_dependencies_printers" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_dependencies_printers.svg?raw=true" height="22"> Dependencies](material_dependencies)

## Process Settings

![process-preset](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process-preset.png?raw=true)  
<img alt="process" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/process.svg?raw=true" height="22"> Settings related to the 3D printing process.

### Quality Settings

![process-quality](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-quality.png?raw=true)  
<img alt="custom-gcode_quality" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_quality.svg?raw=true" height="22"> Settings related to print quality and aesthetics.

- [<img alt="param_layer_height" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_layer_height.svg?raw=true" height="22"> Layer Height Settings](quality_settings_layer_height)
- [<img alt="param_line_width" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_line_width.svg?raw=true" height="22"> Line Width Settings](quality_settings_line_width)
- [<img alt="param_seam" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_seam.svg?raw=true" height="22"> Seam Settings](quality_settings_seam)
- [<img alt="param_precision" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_precision.svg?raw=true" height="22"> Precision](quality_settings_precision)
- [<img alt="param_ironing" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_ironing.svg?raw=true" height="22"> Ironing](quality_settings_ironing)
- [<img alt="param_wall_generator" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_wall_generator.svg?raw=true" height="22"> Wall generator](quality_settings_wall_generator)
- [<img alt="param_wall_surface" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_wall_surface.svg?raw=true" height="22"> Walls and surfaces](quality_settings_wall_and_surfaces)
- [<img alt="param_bridge" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_bridge.svg?raw=true" height="22"> Bridging](quality_settings_bridging)
- [<img alt="param_overhang" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_overhang.svg?raw=true" height="22"> Overhangs](quality_settings_overhangs)

### Strength Settings

![process-strength](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-strength.png?raw=true)  
<img alt="custom-gcode_strength" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_strength.svg?raw=true" height="22"> Settings related to print strength and durability.

- [<img alt="param_wall" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_wall.svg?raw=true" height="22"> Walls](strength_settings_walls)
- [<img alt="param_shell" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_shell.svg?raw=true" height="22"> Top and Bottom Shells](strength_settings_top_bottom_shells)
- [<img alt="param_infill" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_infill.svg?raw=true" height="22"> Infill](strength_settings_infill)
    - [<img alt="param_concentric" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_concentric.svg?raw=true" height="22"> Fill Patterns](strength_settings_patterns)
    - [<img alt="param_gcode" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true" height="22"> Template Metalanguage for infill rotation](strength_settings_infill_rotation_template_metalanguage)
- [<img alt="param_advanced" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true" height="22"> Advanced](strength_settings_advanced)

### Speed Settings

![process-speed](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-speed.png?raw=true)  
<img alt="custom-gcode_speed" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_speed.svg?raw=true" height="22"> Settings related to print speed and movement.

- [<img alt="param_speed_first" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_speed_first.svg?raw=true" height="22"> Initial Layer Speed](speed_settings_initial_layer_speed)
- [<img alt="param_speed" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_speed.svg?raw=true" height="22"> Other Layers Speed](speed_settings_other_layers_speed)
- [<img alt="param_overhang_speed" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_overhang_speed.svg?raw=true" height="22"> Overhang Speed](speed_settings_overhang_speed)
- [<img alt="param_travel_speed" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_travel_speed.svg?raw=true" height="22"> Travel Speed](speed_settings_travel)
- [<img alt="param_acceleration" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_acceleration.svg?raw=true" height="22"> Acceleration](speed_settings_acceleration)
- [<img alt="param_jerk" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_jerk.svg?raw=true" height="22"> Jerk (XY)](speed_settings_jerk_xy)
- [<img alt="param_advanced" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true" height="22"> Advanced / Extrusion rate smoothing](speed_settings_advanced)

### Support Settings

![process-support](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-support.png?raw=true)  
<img alt="custom-gcode_support" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_support.svg?raw=true" height="22"> Settings related to support structures and their properties.

- [<img alt="param_support" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_support.svg?raw=true" height="22"> Support](support_settings_support)
- [<img alt="param_raft" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_raft.svg?raw=true" height="22"> Raft](support_settings_raft)
- [<img alt="param_support_filament" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_support_filament.svg?raw=true" height="22"> Support Filament](support_settings_filament)
- [<img alt="param_ironing" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_ironing.svg?raw=true" height="22"> Support Ironing](support_settings_ironing)
- [<img alt="param_advanced" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true" height="22"> Advanced](support_settings_advanced)
- [<img alt="param_support_tree" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_support_tree.svg?raw=true" height="22"> Tree Supports](support_settings_tree)

### Multimaterial Settings

![process-multimaterial](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-multimaterial.png?raw=true)  
<img alt="custom-gcode_multi_material" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_multi_material.svg?raw=true" height="22"> Settings related to multimaterial printing.

- [<img alt="param_tower" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_tower.svg?raw=true" height="22"> Prime Tower](multimaterial_settings_prime_tower)
- [<img alt="param_filament_for_features" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_filament_for_features.svg?raw=true" height="22"> Filament for Features](multimaterial_settings_filament_for_features)
- [<img alt="param_ooze_prevention" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_ooze_prevention.svg?raw=true" height="22"> Ooze Prevention](multimaterial_settings_ooze_prevention)
- [<img alt="param_flush" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_flush.svg?raw=true" height="22"> Flush Options](multimaterial_settings_flush_options)
- [<img alt="param_advanced" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true" height="22"> Advanced](multimaterial_settings_advanced)

### Others Settings

![process-others](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-others.png?raw=true)  
<img alt="custom-gcode_other" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_other.svg?raw=true" height="22"> Settings related to various other print settings.

- [<img alt="param_skirt" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_skirt.svg?raw=true" height="22"> Skirt](others_settings_skirt)
- [<img alt="param_adhension" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_adhension.svg?raw=true" height="22"> Brim](others_settings_brim)
- [<img alt="param_special" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_special.svg?raw=true" height="22"> Special Mode](others_settings_special_mode)
- [<img alt="fuzzy_skin" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/fuzzy_skin.svg?raw=true" height="22"> Fuzzy Skin](others_settings_fuzzy_skin)
- [<img alt="param_gcode" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true" height="22"> G-Code Output](others_settings_g_code_output)
- [<img alt="param_gcode" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true" height="22"> Post Processing Scripts](others_settings_post_processing_scripts)
- [<img alt="note" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/note.svg?raw=true" height="22"> Notes](others_settings_notes)

## Prepare

<img alt="tab_3d_active" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/tab_3d_active.svg?raw=true" height="22"> First steps to prepare your model/s for printing.

- Right-Click Menu
    - [STL Transformation](prepare_stl_transformation)
        - [Simplify model](prepare_stl_transformation#simplify-model)
        - [Fix model](prepare_stl_transformation#fix-model)
    - Work In Progress...
- Toolbar
    - [Basic](prepare_basic)
        - [<img alt="toolbar_open_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_open_dark.svg?raw=true" height="22"> Add Objects](prepare_basic#add-objects)
        - [<img alt="toolbar_add_plate_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_add_plate_dark.svg?raw=true" height="22"> Add Plate](prepare_basic#add-plate)
        - [<img alt="toolbar_measure_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_measure_dark.svg?raw=true" height="22"> Measure Tool](prepare_basic#measure-tool)
    - [<img alt="toolbar_orient_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_orient_dark.svg?raw=true" height="22"> Auto Orient](prepare_auto_orient)
    - [<img alt="toolbar_arrange_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_arrange_dark.svg?raw=true" height="22"> Auto Arrange](prepare_auto_arrange)
    - [<img alt="custom-gcode_object-info" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_object-info.svg?raw=true" height="22"> Object Set](prepare_object_set)
        - [<img alt="instance_add_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/instance_add_dark.svg?raw=true" height="22"> Add/Remove Instances](prepare_object_set#part)
        - [<img alt="split_objects_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/split_objects_dark.svg?raw=true" height="22"> Split to Objects](prepare_object_set#split-to-objects)
        - [<img alt="split_parts_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/split_parts_dark.svg?raw=true" height="22"> Split to Parts](prepare_object_set#split-to-parts)
    - [<img alt="toolbar_variable_layer_height_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_variable_layer_height_dark.svg?raw=true" height="22"> Variable Layer Height](prepare_variable_layer_height)
    - [Object Manipulation](prepare_object_manipulation)
        - [<img alt="toolbar_move_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_move_dark.svg?raw=true" height="22"> Move](prepare_object_manipulation#move)
        - [<img alt="toolbar_rotate_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_rotate_dark.svg?raw=true" height="22"> Rotate](prepare_object_manipulation#rotate)
        - [<img alt="toolbar_scale_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_scale_dark.svg?raw=true" height="22"> Scale](prepare_object_manipulation#scale)
        - [<img alt="toolbar_flatten_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_flatten_dark.svg?raw=true" height="22"> Lay on Face](prepare_object_manipulation#lay-on-face)
    - [<img alt="toolbar_cut_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_cut_dark.svg?raw=true" height="22"> Cutting Tool](prepare_cutting_tool)
    - [<img alt="toolbar_meshboolean_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_meshboolean_dark.svg?raw=true" height="22"> Mesh Boolean](prepare_mesh_boolean)
    - Painting/Marking Tools
        - [<img alt="toolbar_fuzzy_skin_paint_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_fuzzy_skin_paint_dark.svg?raw=true" height="22"> Support Painting](prepare_support_painting)
        - [<img alt="toolbar_seam_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_seam_dark.svg?raw=true" height="22"> Seam Painting](prepare_seam_painting)
        - [<img alt="toolbar_fuzzy_skin_paint_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_fuzzy_skin_paint_dark.svg?raw=true" height="22"> Paint-on fuzzy skin](prepare_paint_on_fuzzy_skin)
        - [<img alt="mmu_segmentation_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/mmu_segmentation_dark.svg?raw=true" height="22"> Color Painting](prepare_color_painting)
        - [<img alt="toolbar_text_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_text_dark.svg?raw=true" height="22"> Emboss](prepare_emboss)
        - [<img alt="toolbar_brimears_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_brimears_dark.svg?raw=true" height="22"> Brim Ears Painting](prepare_brim_ears_painting)
    - [Assembly Tools](prepare_assembly_tools)
        - [<img alt="toolbar_assembly_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_assembly_dark.svg?raw=true" height="22"> Assemble](prepare_assembly_tools#assemble)
        - [<img alt="toolbar_assemble_dark" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_assemble_dark.svg?raw=true" height="22"> Assembly View](prepare_assembly_tools#assembly-view)

## Calibrations

<img alt="tab_calibration_active" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/tab_calibration_active.svg?raw=true" height="22"> The [Calibration Guide](Calibration) outlines Orca’s key calibration tests and their suggested order of execution.

- [<img alt="param_extruder_temp" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_temp.svg?raw=true" height="22"> Temperature](temp-calib)
- [<img alt="param_volumetric_speed" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_volumetric_speed.svg?raw=true" height="22"> Volumetric Speed](volumetric-speed-calib)
- [<img alt="param_flow_ratio_and_pressure_advance" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_flow_ratio_and_pressure_advance.svg?raw=true" height="22"> Pressure Advance](pressure-advance-calib)
    - [Adaptive Pressure Advance Guide](adaptive-pressure-advance-calib)
- [<img alt="param_line_width" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_line_width.svg?raw=true" height="22"> Flow Rate](flow-rate-calib)
- [<img alt="param_retraction" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_retraction.svg?raw=true" height="22"> Retraction](retraction-calib)
- [<img alt="param_precision" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_precision.svg?raw=true" height="22"> Tolerance](tolerance-calib)
- Advanced:
    - [<img alt="param_jerk" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_jerk.svg?raw=true" height="22"> Cornering (Jerk & Junction Deviation)](cornering-calib)
    - [<img alt="param_resonance_avoidance" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_resonance_avoidance.svg?raw=true" height="22"> Input Shaping](input-shaping-calib)
        - [VFA](vfa-calib)

## General Settings

- [Import and Export](import_export)
- [Keyboard Shortcuts](keyboard-shortcuts)

## Developer Section

<img alt="im_code" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/im_code.svg?raw=true" height="22"> This is a documentation from someone exploring the code and is by no means complete or even completely accurate. Please edit the parts you might find inaccurate. This is probably going to be helpful nonetheless.

- [How to build OrcaSlicer](How-to-build)
- [How to run tests](How-to-test)
- [Localization and translation guide](Localization_guide)
- [How to create profiles](How-to-create-profiles)
- [How to contribute to the wiki](How-to-wiki)
- [Preset, PresetBundle and PresetCollection](Preset-and-bundle)
- [Plater, Sidebar, Tab, ComboBox](plater-sidebar-tab-combobox)
- [Built-in placeholders & variables](Built-in-placeholders-variables)
- [Slicing Call Hierarchy](slicing-hierarchy)
- [How to Download Pull Requests Artifacts for Testing](How-to-download-PR-artifacts)
