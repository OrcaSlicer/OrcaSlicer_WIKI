# Brim

Brim is a flat layer printed around a model's base to improve adhesion to the print bed. It is useful for models with small footprints or those prone to warping.

![brim](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/brim.png?raw=true)

- [Type](#type)
    - [Auto](#auto)
    - [Painted](#painted)
    - [Outer](#outer)
    - [Inner](#inner)
    - [Outer and Inner](#outer-and-inner)
    - [Mouse Ears](#mouse-ears)
        - [Ear max angle](#ear-max-angle)
        - [Ear detection radius](#ear-detection-radius)
    - [No-brim](#no-brim)
    - [Leading edge only](#leading-edge-only)
- [Brim ears outer only](#brim-ears-outer-only)
- [Width](#width)
- [Leading length](#leading-length)
- [Extra width](#extra-width)
- [Brim-Object Gap](#brim-object-gap)
    - [Brim Flow Ratio](#brim-flow-ratio)
    - [Brim use EFC outline](#brim-use-efc-outline)
- [Combine brims](#combine-brims)
    - [Combined](#combined)
    - [Uncombined](#uncombined)
- [Brim on belt printers](#brim-on-belt-printers)

## Type

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `brim_type`.  
[Type](option_type#choice): `Choice`.  
[Options](option_type#choice): `auto_brim, brim_ears, painted, outer_only, inner_only, outer_and_inner, no_brim, leading_edge_only`.  
[CLI Example](cli_mode#setting-overrides): `--brim-type=auto_brim`.  
Controls how the brim is generated on a model's outer and/or inner sides.

### Auto

The Auto brim feature computes an optimal brim width by evaluating material properties, part geometry, printing speed, and thermal characteristics.

- Model geometry
    - Uses the model's height and the shape of its first layer.
    - Height-to-area ratio: computed from the model's height and the second moment of area of its first layer.
- Printing speed
    - Higher maximum printing speeds generally increase the recommended brim width.
- Thermal length
    - Defined as the diagonal of the model's base.
    - Reference thermal lengths (material-specific):
        - ABS, PA-CF, PET-CF: 100
        - PC: 40
        - TPU: 1000
- Material adhesion coefficient
    - Default: 1
    - PETG/PCTG: 2
    - TPU: 0.5

The computed brim width is capped at 18 mm and at 1.5× the thermal length. If the final width is under 5 mm and also less than 1.5× the thermal length, no brim will be generated (width = 0).

### Painted

Generates a brim only on areas that [have been painted in the Prepare tab](prepare_brim_ears_painting).

### Outer

Creates a brim around the model's outer perimeter.  
Easier to remove than an inner brim, but may affect the model's appearance if not removed cleanly.

![brim-outer](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/brim-outer.png?raw=true)

### Inner

Creates a brim around inner perimeters.  
It is more difficult to remove and less effective than an outer brim, and it may obscure fine inner details, but it can hide the brim removal seam.

![brim-inner](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/brim-inner.png?raw=true)

### Outer and Inner

Creates a brim around both the outer and inner perimeters of the model.  
This approach combines the **disadvantages** of both brim types: it is more difficult to remove and may obscure fine details, but it improves overall adhesion.

![brim-outer-inner](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/brim-outer-inner.png?raw=true)

> [!TIP]
> Consider using a [raft](support_settings_raft) on complex models/materials.

### Mouse Ears

Mouse ears are small, local brim extensions (typically placed near corners and sharp features) that improve bed adhesion and reduce warping while using less material than a full brim.  
The geometry analysis routine selects candidate locations based on the configured angle threshold and detection radius.

![brim-mouse-ears](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/brim-mouse-ears.png?raw=true)

#### Ear max angle

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `brim_ears_max_angle`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--brim-ears-max-angle=1`.  
Angle threshold (degrees) used to decide where mouse ears may be placed:

- 0° — disabled; no mouse ears are generated.
- Between 0° and 180° — ears are created at features with local angles sharper (smaller) than the threshold.
- 180° — ears are allowed on almost any non-straight feature.

#### Ear detection radius

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `brim_ears_detection_length`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--brim-ears-detection-length=1`.  
The geometry is decimated before sharp angles are detected.  
This parameter sets the minimum deviation length used for the decimation.  
Set to 0 to disable.

### No-brim

No brim is printed around the model. The brims of neighboring objects are still kept one brim line away from it, so they don't touch it.  
Useful as a per-object setting to skip the brim on parts that don't need one. The other brim settings are disabled while it is selected.

### Leading edge only

> [!IMPORTANT]
> NEW FEATURE: **Leading edge only brim for belt printers**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Available only on [belt printers](belt_printing). Generates a brim at and ahead of the object's first contact with the belt, without extending along the rest of the object.

Use it with [Leading length](#leading-length) to anchor the leading edge without printing a brim along the entire part. The extension gives the brim material more time to adhere to the belt before the object begins printing. On printers without a belt, this type is printed as an [Outer](#outer) brim.

## Brim ears outer only

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `brim_ears_outer_only`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--brim-ears-outer-only=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Limit automatic and painted brim ears to outer contours**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

When enabled, brim ears are generated only on the model's outer contour. Ears that would otherwise be placed in holes or other enclosed sections are excluded.

This setting is available for both the **Mouse Ears** and **Painted** brim types. In Mouse Ears mode, it filters automatically detected ears. In Painted mode, it filters painted ears when the model is sliced.

## Width

[Mode](option_mode): `Simple`.  
[Variable](built_in_placeholders_variables): `brim_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--brim-width=1`.  
Distance between the model and the outermost brim line.  
Increasing this value widens the brim, which can improve adhesion but increases material usage.

On a [belt printer](#brim-on-belt-printers), the width is measured on the belt surface and applies to every brim type.

When **Brim type** is set to **Mouse ear**, this setting is labeled **Brim ear radius** *(Nightly builds and releases greater than 2.4.2)*. Its value sets the radius of each automatically generated ear. When **Brim type** is set to **Painted**, the size of brim ears is controlled in the [Brim ears Painting tool](prepare_brim_ears_painting).

## Leading length

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `leading_brim_length`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--leading-brim-length=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Leading brim length for belt printers**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Available only on belt printers. Extends the brim along the belt ahead of every leading edge of the object's contact area. This includes the object's first contact with the belt and any separate island that contacts the belt later in the print.

This extension, called an apron, is printed before the object's leading edge, providing an anchor already attached to the belt.

The length is measured on the belt surface and is added to the [Width](#width): the brim extends `Brim-object gap + Leading length + Width` ahead of the object. Set the [Brim-Object Gap](#brim-object-gap) to 0 so the apron touches the edge it anchors.

> [!NOTE]
> On a tilted belt, each layer contributes one strip of the brim. The resulting sheet's thickness is determined by flow rather than layer height. Use the [Brim Flow Ratio](#brim-flow-ratio) to adjust this thickness.

> [!WARNING]
> [Auto arrange](prepare_auto_arrange) does not reserve space for the leading brim. Leave enough room between objects along the belt for this extension.

Set to 0 to disable.

## Extra width

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `extra_brim_width`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--extra-brim-width=1`.  
> [!IMPORTANT]
> NEW FEATURE: **Extra brim width for belt printers**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Available only on belt printers. Widens the brim across the belt without extending it farther ahead of or behind the object. Use it when a part needs more adhesion along its length than the [Width](#width) setting alone provides.

The value is measured on the belt surface and is added to the [Width](#width): the brim extends `Brim-object gap + Width + Extra width` to each side of the object. To extend the brim ahead of the object instead, use [Leading length](#leading-length).

Set to 0 to disable.

## Brim-Object Gap

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `brim_object_gap`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--brim-object-gap=1`.  
Gap between the innermost brim line and the object.  
Increasing the gap makes the brim easier to remove but reduces its adhesion benefit; very large gaps may eliminate contact and negate the brim's purpose.

### Brim Flow Ratio

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `brim_flow_ratio`.  
[Type](option_type#integer-float-percentage): `Float`.  
[CLI Example](cli_mode#setting-overrides): `--brim-flow-ratio=1`.  
This factor affects the amount of material for [brims](#brim).
Setting this value slightly above 1.0 can help the brim hold the print on the plate, but it can also make brims harder to remove.
The actual brim [flow](quality_settings_wall_and_surfaces#surface-flow-ratio) used is calculated by multiplying this value by the [filament flow ratio](material_flow_ratio_and_pressure_advance#flow-ratio), and if set, the object's flow ratio.

> [!NOTE]
> The resulting value will not be affected by the [first-layer flow ratio](quality_settings_wall_and_surfaces#surface-flow-ratio).

### Brim use EFC outline

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `brim_use_efc_outline`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--brim-use-efc-outline=1`.  
When enabled, the brim is aligned with the first-layer perimeter geometry after [Elephant Foot Compensation](quality_settings_precision#elephant-foot-compensation) is applied.  
This option is intended for cases where [Elephant Foot Compensation](quality_settings_precision#elephant-foot-compensation) significantly alters the first-layer footprint.

If your current setup already works well, enabling it may be unnecessary and can cause the brim to fuse with upper layers.

![brim-use-efc-outline](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/brim-use-efc-outline.svg?raw=true)

## Combine brims

[Mode](option_mode): `Advanced`.  
[Variable](built_in_placeholders_variables): `combine_brims`.  
[Type](option_type#boolean): `Boolean`.  
[CLI Example](cli_mode#setting-overrides): `--combine-brims=1`.  
Combine adjacent brims into a single continuous brim when they touch.

- Disable: Each object's brim is generated and printed separately; each brim is completed before its object is printed.
- Enable: Brims that touch are merged and printed together as longer continuous loops, which can improve adhesion for small or closely spaced objects.

### Combined

![combined-brims](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/combined-brims.gif?raw=true)

### Uncombined

![uncombined-brims](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/brim/uncombined-brims.gif?raw=true)

## Brim on belt printers

> [!IMPORTANT]
> NEW FEATURE: **Belt printer brim**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

On a [belt printer](belt_printing), an object touches the belt along a narrow strip in each layer, so the entire brim cannot be printed in the first layer. Instead, the brim is printed on the tilted belt surface one strip at a time, across all layers that reach the belt.

This changes how the settings on this page behave:

- [Outer](#outer), [Inner](#inner), [Outer and Inner](#outer-and-inner) and [Leading edge only](#leading-edge-only) work as described.
- [Auto](#auto), [Mouse Ears](#mouse-ears) and [Painted](#painted) are printed as an Outer brim using the [Width](#width) setting.
- [Leading length](#leading-length) and [Extra width](#extra-width) become available.
- [Brim use EFC outline](#brim-use-efc-outline) and [Combine brims](#combine-brims) are disabled because both apply only to a flat first layer.
- A brim cannot be combined with [Spiral vase](others_settings_special_mode#spiral-vase).

A brim is only generated when the [belt tilt](printer_basic_information_belt_printer#belt-tilt) is between 1° and 85°.
