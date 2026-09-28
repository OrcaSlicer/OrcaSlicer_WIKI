# Precise Seam

> [!IMPORTANT]
> NEW FEATURE: **Precise Seam modifiers**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

A Precise Seam modifier is a helper body that decides where the seam goes. You attach it to an object like any other modifier, and on every layer the seam is placed where the body crosses the outer wall. You can pin the seam to an exact point, or mark zones where the seam is preferred or forbidden.

Unlike [Seam Painting](prepare_seam_painting), the modifier is a separate body. It still works after you replace or edit the model, so you do not need to repaint seams after each design revision. A thin body swept along a path drawn on the model makes the seam follow that path exactly.

Precise Seam modifiers are not printed and have no filament.

> [!TIP]
> Watch the [Precise Seam demo video](https://www.youtube.com/watch?v=F-In1N7AquQ) to see every modifier type in use.

- [Adding a modifier](#adding-a-modifier)
- [Modifier types](#modifier-types)
    - [Strong modifiers](#strong-modifiers)
    - [Weak modifiers](#weak-modifiers)
- [Priority](#priority)
- [Designing a modifier](#designing-a-modifier)
- [Warnings and limitations](#warnings-and-limitations)
- [Project compatibility](#project-compatibility)

## Adding a modifier

Right-click an object in the object list or in the 3D view, choose **Add Precise Seam**, then pick a shape (Cube, Cylinder, Sphere, Cone, Disc or Torus) or **Load...** to use your own mesh. The new modifier is of type *Seam Center*.

You can also turn an existing part or modifier of an object into a Precise Seam modifier: right-click it, choose **Change Type** and select **Precise Seam**. An object must keep at least one part, so a single-part object cannot be converted; put the helper body in the same object as the model first. Text and SVG parts cannot be converted.

To change the type of a Precise Seam modifier, right-click it and choose **Precise Seam Type**. This submenu is only shown when every selected item is a Precise Seam modifier. Several modifiers can be changed at once.

## Modifier types

There are six types, in two groups. Each type has its own icon in the object list and its own color in the 3D view.

### Strong modifiers

A strong modifier sets the seam to one exact point where it crosses the outer wall. The [Seam Position](quality_settings_seam#seam-position) setting cannot move it.

| Type | Seam position | Color |
| --- | --- | --- |
| **Seam Center** | Middle of the crossing | Orange |
| **Seam Left** | Left end of the crossing | Gold |
| **Seam Right** | Right end of the crossing | Dark orange |

Left and Right are seen from outside the object. On the wall of a hole, seen from inside the hole, they are swapped.

On a wall that a strong modifier crosses, every other point is blocked, and weak modifiers and seam painting have no effect there.

### Weak modifiers

A weak modifier marks the part of the outer wall inside it as a zone, like painting seams by hand. The [Seam Position](quality_settings_seam#seam-position) setting still chooses the seam, but it uses the Enforced zones and avoids the Blocked ones.

| Type | Zone | Color |
| --- | --- | --- |
| **Seam Enforced** | Preferred for the seam | Green |
| **Seam Blocked** | Avoided by the seam | Red |
| **Seam Neutral** | Neither preferred nor avoided | Gray |

Weak modifiers override [Seam Painting](prepare_seam_painting) inside their zone. A *Seam Neutral* modifier clears painted seams where it crosses the wall.

## Priority

The order in the object list is the priority order: a modifier higher in the list wins over the ones below it.

- Strong modifiers are always listed above weak ones. If you change a modifier's type from one group to the other, it moves to the bottom of its new group.
- Drag and drop modifiers to reorder them within their group.
- On each wall, the first strong modifier that crosses it sets the seam, and all modifiers below it are ignored for that wall.
- Where weak modifiers overlap, the one higher in the list decides the zone.

## Designing a modifier

- **Reach the middle of the outer wall.** The modifier is compared with the centerline of the outer wall, which lies half an outer wall line width inside the surface. Let the body extend at least that far into the model; going deeper is safer.
- **Cross each wall once.** A strong modifier sets only one seam per wall, so extra crossings on the same layer are ignored.
- **Do not cut through the whole wall loop.** A body that passes through the entire outline of a layer, for example a slab cutting across a cylinder, crosses the wall twice and only one of the crossings is used.
- **Use solid bodies.** On any layer where the modifier's cross-section has a hole, such as a Torus lying flat, the modifier is ignored. Split such a body into two modifiers.
- **Do not enclose the layer.** A modifier that contains the whole outline of a layer is ignored on that layer.

To make the seam follow a curve, draw the path on the model's surface in your CAD software and sweep a small profile along it. A circle is the easiest profile, as its orientation does not matter; a triangle or a regular polygon works too and gives a lighter mesh. Save the helper body once and reuse it.

The modifier acts on the outer walls of each layer, including the walls around holes. Inner walls follow the outer seam as usual, so [Staggered inner seams](quality_settings_seam#staggered-inner-seams) still applies.

> [!NOTE]
> If you import the model together with its helper bodies as parts, change the helper bodies to modifiers before using [Lay on Face](prepare_object_manipulation#lay-on-face) or other placement tools. While they are parts, they count as printable geometry.

## Warnings and limitations

When a modifier shape cannot be applied as intended, slicing shows a single warning starting with **Precise Seam:** that lists every problem found:

- **multiple intersections with a perimeter detected:** a strong modifier crosses one wall in more than one place. Only one crossing is used.
- **modifier fully crosses the printable perimeter:** a modifier cuts through the whole outline of a layer. Only one of its two crossings is used.
- **modifier shape is not solid (has holes inside) and was ignored:** the modifier's cross-section has a hole on some layers.
- **perimeter is fully contained inside modifier and was ignored:** a modifier encloses the whole outline of a layer.

In each case the seam on the affected walls may differ from what you expect. Adjust the modifier as described in [Designing a modifier](#designing-a-modifier).

## Project compatibility

Precise Seam modifiers are saved in the project 3MF. Versions of OrcaSlicer without this feature open them as ordinary modifiers without settings, so they do not change the print there. If such a version saves the project again, the modifiers stay ordinary modifiers.

Precise Seam modifiers have no per-object settings. If you convert a part or modifier that had settings, they are kept and come back when you change it back to a part or modifier.
