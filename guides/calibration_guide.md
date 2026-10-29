# Calibration Guide

This guide offers a structured and comprehensive overview of the calibration process for OrcaSlicer.

It covers key aspects such as flow ratio, pressure advance, temperature towers, retraction tests, and advanced calibration techniques. Each section includes step-by-step instructions and visuals to help you better understand and carry out each calibration effectively.

To access the calibration features, you can find them in the **Calibration** section of the OrcaSlicer interface.

![calibration](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/calibration.png?raw=true)

> [!IMPORTANT]
> After completing the calibration process, remember to create a new project in order to exit the calibration mode.

> [!TIP]
> <strong class="orca-video-title">Recommended</strong>
>
> <span class="orca-video-description">Filament Calibration Masterclass</span>
>
> <div class="orca-video-embed">
>   <a class="orca-video-poster-link" href="https://www.youtube.com/watch?v=gVU5If1VsAM" aria-label="Watch Filament Calibration Masterclass video by Factorian Designs">
>     <img alt="factorian-calibration-029" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/video/factorian-calibration-029.png?raw=true">
>   </a>
> </div>
>
> <span class="orca-video-credit">Video by <strong>Factorian Designs</strong>, with consent.</span>

The calibrations are split into two groups. Follow them in the order shown, as each test builds on the results of the ones before it.

> [!NOTE]
> These tests assume the extruder itself is already calibrated in the printer firmware (E-steps or rotation distance). Most modern printers ship with this set correctly. Small differences between filaments are corrected later in the [Flow Ratio](flow_ratio_calib) step.

## Filament Calibration

Repeat these tests for each new filament.

1. **[Temperature](temp_calib):** Start by calibrating the nozzle temperature. This is crucial as it affects the viscosity of the filament, which in turn influences how well it flows through the nozzle and adheres to the print bed, so every following test depends on it. The test is quick, easy to read and works with any material on any printer. It is especially important for materials with a narrow temperature range.  
   <img alt="temp-tower" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Temp-calib/temp-tower.jpg?raw=true" height="200">
2. **[Max Volumetric Speed](volumetric_speed_calib):** With the temperature set, find the maximum volumetric speed the hotend can reach with this filament. This sets a safe limit so the following tests don't under-extrude or clog the nozzle. Some manufacturers overstate this value, so don't rely on the one on the spool. Use a value 10–20% below the result as a safety margin.  
   <img alt="mvf_measurement_point" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/MVF/mvf_measurement_point.jpg?raw=true" height="200">
3. **[Pressure Advance](pressure_advance_calib):** Calibrate the pressure advance settings to improve print quality and reduce artifacts caused by pressure fluctuations in the nozzle. It is done before Flow Ratio because it is the value most often wrong (or never calibrated at all), while the flow ratio in most filament profiles is already close. A tuned pressure advance also gives cleaner line ends and corners, which makes the Flow Ratio test easier to read.  
   <img alt="pa-tower" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/pa/pa-tower.jpg?raw=true" height="200">
4. **[Flow Ratio](flow_ratio_calib):** Calibrate the flow ratio to ensure that the correct amount of filament is being extruded. This is important for achieving accurate dimensions and good layer adhesion. The test starts from the flow ratio of the selected filament profile, so it is usually a small correction.  
   <img alt="flowcalibration-example" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Flow-Rate/flowcalibration-example.png?raw=true" height="200">
5. **[Retraction](retraction_calib):** Calibrate the retraction settings to minimize stringing and improve print quality. The default values usually work well, but if you calibrate them, do it after Pressure Advance and Flow Ratio, as both change the pressure in the nozzle. Retraction doesn't depend on the advanced tests below, so it is part of the filament calibration.  
   <img alt="retraction_test_print" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/retraction/retraction_test_print.jpg?raw=true" height="200">

> [!TIP]
> Pressure advance and flow ratio affect each other slightly, so either can be calibrated first. If the flow ratio changed a lot in the Flow Ratio step, run a quick Pressure Advance test again.

## Advanced Calibration

These tests are optional. Most of them tune the printer rather than the filament, so they only need to be repeated after hardware changes. Do them after the filament calibration, as a badly tuned filament affects their results.

1. **[Cornering](cornering_calib):** Calibrate the Jerk/Junction Deviation settings to improve print quality and reduce artifacts caused by sharp corners and changes in direction. It is mainly used to raise cornering speed. Most printers don't need it, as their firmware already limits cornering: above that limit (especially in Klipper) a higher value doesn't make real prints any faster, and OrcaSlicer has no way to check it.  
   <img alt="jd_second_print_measure" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/JunctionDeviation/jd_second_print_measure.jpg?raw=true" height="200">
2. **[Input Shaping](input_shaping_calib):** Reduce ringing and improve print quality by compensating for mechanical vibrations in the printer. Most recent printers have their own automatic input shaping calibration, which is usually more accurate than this manual test, so use it when available.  
   <img alt="IS_damp_marlin_print_measure" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/InputShaping/IS_damp_marlin_print_measure.jpg?raw=true" height="200">
3. **[VFA](vfa_calib):** A VFA speed test is available to find resonance speeds. Do it after Input Shaping to find the Vertical Fine Artifacts that input shaping didn't remove.  
   <img alt="vfa_test_print" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/vfa/vfa_test_print.jpg?raw=true" height="200">
4. **[Adaptive Pressure Advance](adaptive_pressure_advance_calib):** Adjusts the pressure advance value for different flow rates and accelerations. It needs a calibrated Pressure Advance and Flow Ratio, and its tests [should not go above the acceleration limit found with Input Shaping](adaptive_pressure_advance_calib#defining-the-calibration-sets).  
   <img alt="apa-expected-results" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/pa/apa-expected-results.jpg?raw=true" height="200">

---

**[Tolerance](tolerance_calib):** Calibrate the tolerances of your printer to ensure that it can accurately reproduce the dimensions of the model being printed. This is important for achieving a good fit between parts and for ensuring that the final print meets the desired specifications. Do it after the calibrations above, as the result depends on all of them.  
<img alt="OrcaToleranceTes_m6" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Tolerance/OrcaToleranceTes_m6.jpg?raw=true" height="200">

**[Ironing Flow](ironing_flow_calib):** Find the ironing flow that hides the lines of the top surface without over-extruding. This advanced test is optional and only needed if you use ironing. It depends on the filament, so repeat it for each filament you iron, after the other calibrations: ironing only adds a finish to a top surface that is already well printed.  
<img alt="ironing-flow-calib-reading" src="https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/IroningFlow/ironing-flow-calib-reading.jpg?raw=true" height="200">

---

_Credits:_

- _The Flow test and retraction test is inspired by [SuperSlicer](https://github.com/supermerill/SuperSlicer)._
- _The PA Line method is inspired by [K-factor Calibration Pattern](https://marlinfw.org/tools/lin_advance/k-factor.html)._
- _The PA Tower method is inspired by [Klipper](https://www.klipper3d.org/Pressure_Advance.html)._
- _The temp tower model is remixed from [Smart compact temperature calibration tower](https://www.thingiverse.com/thing:2729076)._
- _The max flowrate test was inspired by Stefan (CNC Kitchen), and the model used in the test is a remix of his [Extrusion Test Structure](https://www.printables.com/model/342075-extrusion-test-structure)._
- _ZV Input Shaping is inspired by [Marlin Input Shaping](https://marlinfw.org/docs/features/input_shaping.html) and [Ringing Tower 3D STL](https://marlinfw.org/assets/stl/ringing_tower.stl)._
