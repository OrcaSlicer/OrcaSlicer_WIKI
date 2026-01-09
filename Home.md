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

![printer](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/printer.svg?raw=true) Settings related to the 3D printer hardware and its configuration.

- Basic Information
    - [![param_printable_space](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_printable_space.svg?raw=true) Printable space](printer_basic_information_printable_space)
    - [![param_advanced](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true) Advanced](printer_basic_information_advanced)
    - [![param_cooling_fan](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_cooling_fan.svg?raw=true) Cooling Fan](printer_basic_information_cooling_fan)
    - [![param_extruder_clearance](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_clearance.svg?raw=true) Extruder Clearance](printer_basic_information_extruder_clearance)
    - [![param_adaptive_mesh](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_adaptive_mesh.svg?raw=true) Adaptive bed mesh](printer_basic_information_adaptive_bed_mesh)
    - [![param_accessory](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_accessory.svg?raw=true) Accessory](printer_basic_information_accessory)
- [![param_gcode](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true) Machine G_Code](printer_machine_gcode)
- Multimaterial
    - [![param_multi_material](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_multi_material.svg?raw=true) Multimaterial setup](printer_multimaterial_setup)
    - [![param_tower](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_tower.svg?raw=true) Wipe tower](printer_multimaterial_wipe_tower)
    - [![param_settings](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_settings.svg?raw=true) Single extruder multi_material parameters](printer_multimaterial_semm_parameters)
    - [![param_advanced](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true) Advanced](printer_multimaterial_advanced)
- Extruder
    - [![param_information](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_information.svg?raw=true) Basic Information](printer_extruder_basic_information)
    - [![param_retraction](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_retraction.svg?raw=true) Retraction](printer_extruder_retraction)
        - [![param_retraction_material_change](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_retraction_material_change.svg?raw=true) Retraction when switching materials](printer_extruder_retraction#retraction-when-switching-materials)
    - [![param_extruder_lift_enforcement](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_lift_enforcement.svg?raw=true) Z_Hop](printer_extruder_z_hop)
- [![param_acceleration](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_acceleration.svg?raw=true) Motion ability](printer_motion_ability)

## Material Settings

![filament-preset](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/filament-preset.png?raw=true)

![filament](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/filament.svg?raw=true) Settings related to the 3D printing material.

- Material settings
    - [![param_information](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_information.svg?raw=true) Basic Information](material_basic_information)
    - [![param_flow_ratio_and_pressure_advance](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_flow_ratio_and_pressure_advance.svg?raw=true) Flow Ratio and Pressure Advance](material_flow_ratio_and_pressure_advance)
    - [![param_extruder_temp](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_temp.svg?raw=true) Material temperatures](material_temperatures)
        - [![param_chamber_temp](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_chamber_temp.svg?raw=true) Print Chamber temperature](material_temperatures#print-chamber-temperature)
        - [![param_extruder_temp](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_temp.svg?raw=true) Print temperature](material_temperatures#nozzle)
        - [![param_bed_temp](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_bed_temp.svg?raw=true) Bed temperature](material_temperatures#bed)
    - [![param_volumetric_speed](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_volumetric_speed.svg?raw=true) Volumetric Speed limitation](material_volumetric_speed_limitation)
- [![param_cooling_part_fan](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_cooling_part_fan.svg?raw=true) Material Cooling](material_cooling)
- [![param_settings](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_settings.svg?raw=true) Setting Overrides](material_setting_overrides)
- [![param_gcode](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true) Advanced](material_advanced)
- [![custom-gcode_multi_material](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_multi_material.svg?raw=true) Multimaterial](material_multimaterial)
- [![param_dependencies_printers](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_dependencies_printers.svg?raw=true) Dependencies](material_dependencies)

## Process Settings

![process-preset](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process-preset.png?raw=true)

![process](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/process.svg?raw=true) Settings related to the 3D printing process.

### Quality Settings

![custom-gcode_quality](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_quality.svg?raw=true) Settings related to print quality and aesthetics.  
![process-quality](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-quality.png?raw=true)

- [![param_layer_height](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_layer_height.svg?raw=true) Layer Height Settings](quality_settings_layer_height)
- [![param_line_width](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_line_width.svg?raw=true) Line Width Settings](quality_settings_line_width)
- [![param_seam](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_seam.svg?raw=true) Seam Settings](quality_settings_seam)
- [![param_precision](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_precision.svg?raw=true) Precision](quality_settings_precision)
- [![param_ironing](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_ironing.svg?raw=true) Ironing](quality_settings_ironing)
- [![param_wall_generator](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_wall_generator.svg?raw=true) Wall generator](quality_settings_wall_generator)
- [![param_wall_surface](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_wall_surface.svg?raw=true) Walls and surfaces](quality_settings_wall_and_surfaces)
- [![param_bridge](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_bridge.svg?raw=true) Bridging](quality_settings_bridging)
- [![param_overhang](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_overhang.svg?raw=true) Overhangs](quality_settings_overhangs)

### Strength Settings

![custom-gcode_strength](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_strength.svg?raw=true) Settings related to print strength and durability.  
![process-strength](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-strength.png?raw=true)

- [![param_wall](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_wall.svg?raw=true) Walls](strength_settings_walls)
- [![param_shell](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_shell.svg?raw=true) Top and Bottom Shells](strength_settings_top_bottom_shells)
- [![param_infill](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_infill.svg?raw=true) Infill](strength_settings_infill)
    - [![param_concentric](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_concentric.svg?raw=true) Fill Patterns](strength_settings_patterns)
    - [![param_gcode](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true) Template Metalanguage for infill rotation](strength_settings_infill_rotation_template_metalanguage)
- [![param_advanced](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true) Advanced](strength_settings_advanced)

### Speed Settings

![custom-gcode_speed](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_speed.svg?raw=true) Settings related to print speed and movement.  
![process-speed](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-speed.png?raw=true)

- [![param_speed_first](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_speed_first.svg?raw=true) Initial Layer Speed](speed_settings_initial_layer_speed)
- [![param_speed](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_speed.svg?raw=true) Other Layers Speed](speed_settings_other_layers_speed)
- [![param_overhang_speed](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_overhang_speed.svg?raw=true) Overhang Speed](speed_settings_overhang_speed)
- [![param_travel_speed](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_travel_speed.svg?raw=true) Travel Speed](speed_settings_travel)
- [![param_acceleration](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_acceleration.svg?raw=true) Acceleration](speed_settings_acceleration)
- [![param_jerk](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_jerk.svg?raw=true) Jerk (XY)](speed_settings_jerk_xy)
- [![param_advanced](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true) Advanced / Extrusion rate smoothing](speed_settings_advanced)

### Support Settings

![custom-gcode_support](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_support.svg?raw=true) Settings related to support structures and their properties.  
![process-support](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-support.png?raw=true)

- [![param_support](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_support.svg?raw=true) Support](support_settings_support)
- [![param_raft](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_raft.svg?raw=true) Raft](support_settings_raft)
- [![param_support_filament](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_support_filament.svg?raw=true) Support Filament](support_settings_filament)
- [![param_ironing](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_ironing.svg?raw=true) Support Ironing](support_settings_ironing)
- [![param_advanced](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true) Advanced](support_settings_advanced)
- [![param_support_tree](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_support_tree.svg?raw=true) Tree Supports](support_settings_tree)

### Multimaterial Settings

![custom-gcode_multi_material](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_multi_material.svg?raw=true) Settings related to multimaterial printing.  
![process-multimaterial](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-multimaterial.png?raw=true)

- [![param_tower](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_tower.svg?raw=true) Prime Tower](multimaterial_settings_prime_tower)
- [![param_filament_for_features](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_filament_for_features.svg?raw=true) Filament for Features](multimaterial_settings_filament_for_features)
- [![param_ooze_prevention](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_ooze_prevention.svg?raw=true) Ooze Prevention](multimaterial_settings_ooze_prevention)
- [![param_flush](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_flush.svg?raw=true) Flush Options](multimaterial_settings_flush_options)
- [![param_advanced](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_advanced.svg?raw=true) Advanced](multimaterial_settings_advanced)

### Others Settings

![custom-gcode_other](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/custom-gcode_other.svg?raw=true) Settings related to various other print settings.  
![process-others](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/GUI/process/process-others.png?raw=true)

- [![param_skirt](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_skirt.svg?raw=true) Skirt](others_settings_skirt)
- [![param_adhension](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_adhension.svg?raw=true) Brim](others_settings_brim)
- [![param_special](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_special.svg?raw=true) Special Mode](others_settings_special_mode)
- [![fuzzy_skin](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/fuzzy_skin.svg?raw=true) Fuzzy Skin](others_settings_fuzzy_skin)
- [![param_gcode](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true) G-Code Output](others_settings_g_code_output)
- [![param_gcode](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_gcode.svg?raw=true) Post Processing Scripts](others_settings_post_processing_scripts)
- [![note](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/note.svg?raw=true) Notes](others_settings_notes)

## Prepare

![tab_3d_active](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/tab_3d_active.svg?raw=true) First steps to prepare your model/s for printing.

- [STL Transformation](stl-transformation)
- Toolbar
  - [Basic](prepare_basic)
    - [![toolbar_open_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_open_dark.svg?raw=true)Add Objects](prepare_basic#add-objects)
    - [![toolbar_add_plate_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_add_plate_dark.svg?raw=true)Add Plate](prepare_basic#add-plate)
    - [Instances](prepare_basic#instances)
    - [Measure Tool](prepare_basic#measure-tool)
  - [![toolbar_orient_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_orient_dark.svg?raw=true)Auto Orient](prepare_auto_orient)
  - [![toolbar_arrange_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_arrange_dark.svg?raw=true)Auto Arrange](prepare_auto_arrange)
  - [![split_parts_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/split_parts_dark.svg?raw=true)Split](prepare_split)
  - [![toolbar_variable_layer_height_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_variable_layer_height_dark.svg?raw=true)Variable Layer Height](prepare_variable_layer_height)
  - [Object Manipulation](prepare_object_manipulation)
    - [![toolbar_move_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_move_dark.svg?raw=true)Move](prepare_object_manipulation#move)
    - [![toolbar_rotate_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_rotate_dark.svg?raw=true)Rotate](prepare_object_manipulation#rotate)
    - [![toolbar_scale_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_scale_dark.svg?raw=true)Scale](prepare_object_manipulation#scale)
    - [![toolbar_flatten_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_flatten_dark.svg?raw=true)Lay on Face](prepare_object_manipulation#lay-on-face)
  - [![toolbar_cut_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_cut_dark.svg?raw=true)Cutting Tool](prepare_cutting_tool)
  - [![toolbar_meshboolean_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_meshboolean_dark.svg?raw=true)Mesh Boolean](prepare_mesh_boolean)
  - Painting/Marking Tools
    - [![objlist_support_painting](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/objlist_support_painting.svg?raw=true)Support Painting](prepare_support_painting)
    - [![objlist_seam_painting](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/objlist_seam_painting.svg?raw=true)Seam Painting](prepare_seam_painting)
    - [![toolbar_fuzzy_skin_paint_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_fuzzy_skin_paint_dark.svg?raw=true)Paint-on fuzzy skin](prepare_paint_on_fuzzy_skin)
    - [![objlist_color_painting](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/objlist_color_painting.svg?raw=true)Color Painting](prepare_color_painting)
    - [![toolbar_text_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_text_dark.svg?raw=true)Emboss](prepare_emboss)
    - [![toolbar_brimears_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_brimears_dark.svg?raw=true)Brim Ears Painting](prepare_brim_ears_painting)
  - [Assembly Tools](prepare_assembly_tools)
    - [![toolbar_assembly_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_assembly_dark.svg?raw=true)Assemble](prepare_assembly_tools#assemble)
    - [![toolbar_assemble_dark](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/toolbar_assemble_dark.svg?raw=true)Assembly View](prepare_assembly_tools#assembly-view)
- Right-Click Menu
  - Work In Progress...

## Calibrations

![tab_calibration_active](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/tab_calibration_active.svg?raw=true) The [Calibration Guide](Calibration) outlines Orca’s key calibration tests and their suggested order of execution.

- [![param_extruder_temp](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_extruder_temp.svg?raw=true) Temperature](temp-calib)
- [![param_volumetric_speed](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_volumetric_speed.svg?raw=true) Volumetric Speed](volumetric-speed-calib)
- [![param_flow_ratio_and_pressure_advance](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_flow_ratio_and_pressure_advance.svg?raw=true) Pressure Advance](pressure-advance-calib)
    - [Adaptive Pressure Advance Guide](adaptive-pressure-advance-calib)
- [![param_line_width](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_line_width.svg?raw=true) Flow Rate](flow-rate-calib)
- [![param_retraction](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_retraction.svg?raw=true) Retraction](retraction-calib)
- [![param_precision](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_precision.svg?raw=true) Tolerance](tolerance-calib)
- Advanced:
    - [![param_jerk](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_jerk.svg?raw=true) Cornering (Jerk & Junction Deviation)](cornering-calib)
    - [![param_resonance_avoidance](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/param_resonance_avoidance.svg?raw=true) Input Shaping](input-shaping-calib)
        - [VFA](vfa-calib)

## General Settings

- [Keyboard Shortcuts](keyboard-shortcuts)

## Developer Section

![im_code](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/im_code.svg?raw=true) This is a documentation from someone exploring the code and is by no means complete or even completely accurate. Please edit the parts you might find inaccurate. This is probably going to be helpful nonetheless.

- [How to build OrcaSlicer](How-to-build)
- [How to run tests](How-to-test)
- [Localization and translation guide](Localization_guide)
- [How to create profiles](How-to-create-profiles)
- [How to contribute to the wiki](How-to-wiki)
- [Preset, PresetBundle and PresetCollection](Preset-and-bundle)
- [Plater, Sidebar, Tab, ComboBox](plater-sidebar-tab-combobox)
- [Built-in placeholders & variables](Built-in-placeholders-variables)
- [Slicing Call Hierarchy](slicing-hierarchy)
