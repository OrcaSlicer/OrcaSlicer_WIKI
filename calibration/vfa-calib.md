# VFA

Vertical Fine Artifacts (VFA) are small surface imperfections that appear on vertical walls, especially near sharp corners or sudden directional changes. These artifacts are typically caused by mechanical vibrations, motor resonance, or rapid directional shifts that impact print quality.

- **Mechanical adjustments**, such as tuning or replacing motors, belts, or pulleys.
- **MMR (Motor Resonance Rippling)** is a common subtype of VFA caused by stepper motors vibrating at resonant frequencies, leading to periodic ripples on the surface.
- **[Jerk/Junction Deviation](cornering-calib)** settings can also contribute to VFA, as they control how the printer handles rapid changes in direction.
- **[Input Shaping](input-shaping-calib)** can help mitigate VFA by reducing vibrations during printing.

## VFA Test

The VFA Speed Test in OrcaSlicer helps identify which print speeds trigger MRR artifacts. It prints a vertical tower with walls at various angles while progressively increasing the print speed.

1. Set the VFA test parameters in OrcaSlicer:  
   ![vfa_test_menu](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/vfa/vfa_test_menu.png?raw=true)
    - **Speeds**: Define your Speed range you want to test. This has to cover the full range of Outer Wall Speeds used in your prints (e.g., 20 mm/s to 200 mm/s).
    - **Step:**: Define the speed increment between each section of the tower (e.g., 10 mm/s).  
2. Check that Max Volumetric Speed is not limiting your speeds for this material. If it is, use a higher Volumetric Speed Material or recreate the test with a lower max speed.
3. Print the VFA test:
   ![vfa_test_speed_check](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/vfa/vfa_test_speed_check.png?raw=true)
4. Inspect the tower for MRR artifacts. Look for speeds where the surface becomes visibly smoother or rougher. This allows you to pinpoint problematic speed ranges.  
   In this example, you can see how the Speed is Capping at 162 mm/s.
   ![vfa_test_print](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/vfa/vfa_test_print.jpg?raw=true)
5. Configure the [Resonance Avoidance Speed Range](printer_motion_ability#resonance-avoidance-speed) in the printer profile to skip speeds that cause visible artifacts.
   ![vfa_resonance_avoidance](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/vfa/vfa_resonance_avoidance.png?raw=true)
