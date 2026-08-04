# Brim ears Painting

This painting tool allows you to paint brim ears on the base of your 3D model to improve bed adhesion during printing.  
It also includes an Auto-generate feature that automatically detects and applies brim ears to suitable areas of the model.

> [!IMPORTANT]
> NEW FEATURE: **The Head diameter control is renamed Brim ear radius and now accepts values from 0.1 mm to 100 mm.**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

## Parameters

- **Head diameter** *(OrcaSlicer 2.4.2)*: Controls the nominal diameter of painted brim ears. The value is limited to 20 mm. Because of a sizing issue in 2.4.2, the sliced ear may not exactly match the entered diameter.
- **Brim ear radius** *(Nightly builds and releases greater than 2.4.2)*: Sets the radius of brim ears placed manually or with Auto-generate. Values from 0.1 mm to 100 mm are supported.
- **Max angle**: Defines the maximum angle at which brim ears will be applied with Auto-generate.
- **Detection radius**: Lower values can detect more candidate positions. Sets the radius for detecting areas (using the [Ramer–Douglas–Peucker algorithm](https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm)) where Auto-generate may place brim ears.
- **Section view**: Adjusts the section view height to better visualize brim ear placement.

When **Brim type** is set to **Painted**, enable [Brim ears outer only](others_settings_brim#brim-ears-outer-only) *(Nightly builds and releases greater than 2.4.2)* in **Process > Others > Brim** to exclude painted ears placed in holes or other enclosed sections when slicing.
