# Input Shaping

This Calibration guide will help you to calibrate the [Input Shaping](printer_motion_ability#input-shaping) feature in your printer firmware.

> [!NOTE]
> Some Printers have built-in accelerometers that can be used to **automatically** measure the resonant frequencies of the printer.  
> If your printer has one, consider using it as it can provide more accurate results in less time and usually is autosaved into the printer firmware.

> [!TIP]
> It's usually recommended to perform Input Shaping calibration once a year or after any mechanical or structural changes such as relocation, changing the support surface, new belts, motors, frame, etc.

- [Calibration](#calibration)
- [Credits](#credits)

## Calibration

Pre-requisites:

- Use an opaque, high-gloss filament to make the ringing more visible.
- In OrcaSlicer, set:
    - Acceleration high enough to trigger ringing (e.g., 20000 mm/s²).
    - Speed high enough to trigger ringing (e.g., 200 mm/s).

> [!IMPORTANT]
> It's recommended to use the fastest [acceleration](speed_settings_acceleration), [speed](speed_settings_other_layers_speed) and [Jerk/Junction Deviation](speed_settings_jerk_xy) your printer can handle without losing steps.  
> This test **will set the values to high values** limited by your printer's motion ability and the filament's max volumetric speed (avoid materials below 10 mm³/s).

1. Select the Test Model ´Ringing Tower´ (Recommended) or ´Fast Tower´ (Reduced version useful for printers with high ringing).
2. Select the [Input Shaper Type](printer_motion_ability#input-shaping-type) you want to test. Each firmware has different types available and each type has different performance.
3. Select a range of frequencies to test. The Default 15hz to 110hz range is usually a good start.
4. Select your damping. Usually, a value between 0.1 and 0.2 is a good start but you can change it to 0 and your printer will use the firmware default value (if available).  
   ![IS_freq_menu](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_freq_menu.png?raw=true)
    1. **Measure the X and Y heights** and read the frequency set at that point in OrcaSlicer.  
    ![IS_freq_marlin_print_measure](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_freq_marlin_print_measure.jpg?raw=true)
        - Marlin:  
          ![IS_freq_marlin_slicer_measure](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_freq_marlin_slicer_measure.png?raw=true)
        - Klipper:  
          ![IS_freq_klipper_slicer_measure](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_freq_klipper_slicer_measure.png?raw=true)
    2. If not a clear result, you can measure a X and Y min and max acceptable heights and repeat the test with that min and max value.
5. **Print the Damping test** setting your X and Y frequency to the value you found in the previous step.  
   ![IS_damp_menu](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_damp_menu.png?raw=true)
    1. Measure the X and Y heights and read the damping set at that point in OrcaSlicer.  
       ![IS_damp_marlin_print_measure](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_damp_marlin_print_measure.jpg?raw=true)
        - Marlin:  
        ![IS_damp_marlin_slicer_measure](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_damp_marlin_slicer_measure.png?raw=true)
        - Klipper:  
        ![IS_damp_klipper_slicer_measure](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_damp_klipper_slicer_measure.png?raw=true)
6. **Restore your 3D Printer settings to avoid keep using high acceleration and jerk values.**
7. **Save the settings**
    - Into your printer firmware settings save the values you found (Type, frequency/cies and damp)
    - Save it into Orca's printer profile settings:
        - Motion ability → Resonance Compensation (**Marlin**/**RepRap**):
            1. [Go to Printer settings → Motion ability → Resonance Compensation](printer_motion_ability#resonance-compensation):
            2. Set your Type, Frequencies and Damping values.  
            ![inputshaping_printer](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/inputshaping_printer.png?raw=true)
        - Machine start G-code:
            - Klipper:
                - Skeleton:

                ```pwsh
                SET_INPUT_SHAPER SHAPER_TYPE=TYPE SHAPER_FREQ_X=#Xfrequency DAMPING_RATIO_X=#XDamping SHAPER_FREQ_Y=#Yfrequency     DAMPING_RATIO_Y=#YDamping
                ```

                - Example:

                ```pwsh
                SET_INPUT_SHAPER SHAPER_TYPE=MZV SHAPER_FREQ_X=37.25 DAMPING_RATIO_X=0.16 SHAPER_FREQ_Y=37.5 DAMPING_RATIO_Y=0.06
                ```

            - Marlin:
                - Skeleton:

                ```gcode
                M593 X F#Xfrequency D#XDamping
                M593 Y F#Yfrequency D#YDamping
                M500
                ```

                - Example

                ```gcode
                M593 X F37.25 D0.16
                M593 Y F37.5 D0.06
                M500
                ```

            - RepRap:
                - Skeleton: for RepRap 3.3 and later

                ```gcode
                M593 P#Type F#frequency S#Damping
                ```

                - Example RepRap 3.4 and later

                ```gcode
                M593 P"ZVD" F37.25 S0.16
                ```

                - Skeleton: for RepRap 3.2 and earlier

                ```gcode
                M593 F#frequency
                ```

                - Example Legacy (RepRap 3.2 and earlier)

                ```gcode
                M593 F37.25
                ```

## Credits

- **Input Shaping Calibration:** [@IanAlexis](https://github.com/IanAlexis) and [@RF47](https://github.com/RF47)
- **Klipper testing:** [@ShaneDelmore](https://github.com/ShaneDelmore)
