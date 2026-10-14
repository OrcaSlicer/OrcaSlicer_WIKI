# Fuzzy Skin

Fuzzy skin randomly perturbs the wall path to produce a deliberately rough, matte appearance on the model surface.  
These settings control where the effect is applied, how the noise is generated, and how aggressive the displacement or extrusion modulation is.

Useful for creating textures or hiding surface imperfections, but it increases print time and affects dimensional accuracy.

- [Fuzzy Skin Mode](#fuzzy-skin-mode)
    - [Contour](#contour)
    - [Hole](#hole)
    - [Contour and Hole](#contour-and-hole)
    - [Painted Only](#painted-only)
    - [All Walls](#all-walls)
    - [Disabled](#disabled)
- [Fuzzy Skin Generator Mode](#fuzzy-skin-generator-mode)
    - [Displacement](#displacement)
    - [Extrusion](#extrusion)
    - [Combined](#combined)
- [Noise Type](#noise-type)
    - [Classic](#classic)
    - [Perlin](#perlin)
    - [Billow](#billow)
    - [Ridged Multifractal](#ridged-multifractal)
    - [Voronoi](#voronoi)
    - [Ripple](#ripple)
        - [Ripples per layer](#ripples-per-layer)
        - [Ripple offset](#ripple-offset)
        - [Layers between ripple offset](#layers-between-ripple-offset)
- [Point distance](#point-distance)
- [Skin thickness](#skin-thickness)
- [Skin feature size](#skin-feature-size)
- [Skin Noise Octaves](#skin-noise-octaves)
- [Skin Noise Persistence](#skin-noise-persistence)
- [Apply fuzzy skin to first layer](#apply-fuzzy-skin-to-first-layer)
- [Credits](#credits)

## Fuzzy Skin Mode

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `none, external, hole, all, allwalls, disabled_fuzzy`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin=none`.  
Choose which parts of the model receive the fuzzy-skin effect.

### Contour

Apply fuzzy skin only to the outermost contour (external perimeter) of the model.  
Useful for creating a textured edge while keeping the inner surfaces smooth.

### Hole

Apply fuzzy skin only to interior holes and cutouts. This can add grip or visual interest to negative features without affecting the outer surface.

### Contour and Hole

Apply fuzzy skin to both the outer contour and interior holes. Useful when you want the rough texture to appear on negative features as well.

### Painted Only

Apply fuzzy skin only to areas that have been manually painted with the [Fuzzy Skin Paint Tool](prepare_paint_on_fuzzy_skin).  
This allows for precise control over where the texture is applied, ideal for adding grip to specific areas or creating custom patterns.

### All Walls

Apply fuzzy skin to every wall (external and internal). This gives the strongest overall textured appearance but will increase slicing and print time considerably.

### Disabled

The default. No fuzzy skin is applied, not even on areas painted with the [Fuzzy Skin Paint Tool](prepare_paint_on_fuzzy_skin), and the other fuzzy skin settings are hidden.  
This is what sets it apart from [Painted Only](#painted-only), which applies fuzzy skin to the painted areas only. If you paint an object while fuzzy skin is disabled, the paint tool warns that the painting won't take effect and offers to switch that object to Painted Only.

## Fuzzy Skin Generator Mode

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_mode`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `displacement, extrusion, combined`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-mode=displacement`.  
Select the underlying method used to produce the fuzzy effect. Each mode has different trade-offs for strength, speed and mechanical load.

### Displacement

![Fuzzy-skin-Displacement-mode](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-Displacement-mode.png?raw=true)

The classic method, where the pattern on the walls is created by shifting the print head perpendicular to the wall.  
It gives a predictable result, but it reduces the strength of the whole shell and opens pores inside the walls. It also increases the mechanical stress on the printer's kinematics and slows down printing overall.

### Extrusion

![Fuzzy-skin-Extrusion-mode](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-Extrusion-mode.png?raw=true)

The fuzzy skin effect is created by varying the amount of extruded plastic while the print head follows the original path. There is no extra load on the kinematics, no decrease in print speed, and no pores open, but the pattern is about half as pronounced. It is suitable for creating "loose" walls that reduce internal stress in the extruded plastic, or for masking print defects on the side walls with a matte effect.

> [!CAUTION]
> The **Fuzzy skin thickness** parameter cannot be more than about 70%-125% (selected individually for different conditions) of the nozzle diameter! This is a complex condition that also depends on the layer height, and determines how thin the lines can be extruded.  
> The [Arachne](quality_settings_wall_generator#arachne) wall generator must also be enabled.

### Combined

![Fuzzy-skin-Combined-mode](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-Combined-mode.png?raw=true)

This is a combination of the Displacement and Extrusion modes. The pattern is as sharp as in Displacement mode, but the walls remain strong and tight. The load on the kinematics is halved. Printing is faster than in Displacement mode, but still slower than in Extrusion mode.

> [!WARNING]
> The limits on line thickness and the Arachne requirement are the same as in the Extrusion mode.

## Noise Type

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_noise_type`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `classic, perlin, billow, ridgedmulti, voronoi, ripple`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-noise-type=classic`.  
Select the noise algorithm used to generate the random offsets. Different noise types produce distinct visual textures.

### Classic

Simple uniform random noise. Produces a coarse, irregular texture.

![Fuzzy-skin-classic](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-classic.png?raw=true)

### Perlin

[Perlin noise](https://en.wikipedia.org/wiki/Perlin_noise) generates smooth, natural-looking variations with coherent structure.

![Fuzzy-skin-perlin](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-perlin.png?raw=true)

### Billow

Billow noise is similar to Perlin noise, but has a clumpier appearance. It can create more pronounced features and is often used for natural textures.

![Fuzzy-skin-billow](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-billow.png?raw=true)

### Ridged Multifractal

Creates sharp, jagged features and high-contrast detail. Useful for stone- or marble-like textures.

![Fuzzy-skin-ridged-multifractal](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-ridged-multifractal.png?raw=true)

### Voronoi

[Voronoi noise](https://en.wikipedia.org/wiki/Worley_noise) divides the surface into Voronoi cells and displaces each cell independently, creating a patchwork or cellular texture.

![Fuzzy-skin-voronoi](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-voronoi.png?raw=true)

### Ripple

The Ripple noise type creates a regular, wave-like pattern of ripples across the surface.  
This is useful for decorative purposes on models that do not have abrupt changes in geometry or holes that create multiple print islands (closed loops), since the number of ripples is applied to each closed loop and can cause discontinuities between layers.

A clear example is a 3DBenchy, whose windows create small print islands that get the same number of ripples as the hull of the boat, where there is much more space for them.

![Fuzzy-skin-ripple](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-ripple.png?raw=true)
![Fuzzy-skin-ripple-example](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/Fuzzy-skin/Fuzzy-skin-ripple-example.jpg?raw=true)

#### Ripples per layer

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_ripples_per_layer`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-ripples-per-layer=1`.  
Controls how many full cycles of ripples will be added per layer.

#### Ripple offset

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_ripple_offset`.  
[Type](option_type#integer-float-percentage): `Percentage`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-ripple-offset=20%`.  
Shifts the ripple phase forward along the print path by the specified percentage of a wavelength each layer period. Values are specified between 0% and 100% (0% = no shift, 100% = a full-wavelength shift).

- 0% keeps every layer identical.
- 50% shifts the pattern by half a wavelength, effectively inverting the phase.
- 100% shifts the pattern by a full wavelength, returning to the original phase.

The shift is applied once every number of layers set by [Layers between ripple offset](#layers-between-ripple-offset), so layers within the same group are printed identically.

#### Layers between ripple offset

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_layers_between_ripple_offset`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-layers-between-ripple-offset=1`.  
Specifies how many consecutive layers share the same ripple phase before the offset is applied.  
For example, with the default 50% [Ripple offset](#ripple-offset):

- 1 = Layer 1 is printed with the base ripple pattern, then layer 2 is shifted by the configured offset, then layer 3 returns to the base pattern, and so on.
- 3 = Layers 1 to 3 are printed with the base ripple pattern, then layers 4 to 6 are shifted by the configured offset, then layers 7 to 9 return to the base pattern, etc.

## Point distance

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_point_distance`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-point-distance=1`.  
Average distance between random sample points along each line segment.  
Smaller values add more detail and increase computation; larger values produce coarser, faster results.

## Skin thickness

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_thickness`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-thickness=1`.  
Maximum lateral width (in mm) over which points can be displaced. This defines how far the wall can be jittered.  
Keep this below or near your outer wall line width and within nozzle/flow limits for reliable prints.

## Skin feature size

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_scale`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-scale=1`.  
Base size of coherent noise features, in mm. Larger values yield bigger, more prominent structures; smaller values give fine-grained texture.

## Skin Noise Octaves

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_octaves`.  
[Type](option_type#integer-float-percentage): `Integer`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-octaves=1`.  
The number of octaves of coherent noise to use. Higher values increase the detail of the noise, but also increase computation time.

## Skin Noise Persistence

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_persistence`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-persistence=1`.  
Controls how amplitude decays across octaves. Lower persistence results in smoother noise; higher persistence keeps finer-scale detail stronger.

## Apply fuzzy skin to first layer

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `fuzzy_skin_first_layer`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--fuzzy-skin-first-layer=1`.  
Enable to apply fuzzy skin to the first layer.

> [!CAUTION]
> Can impact bed adhesion and surface contact.

## Credits

- **Generator Mode author:** [@pi-squared-studio](https://github.com/pi-squared-studio).
