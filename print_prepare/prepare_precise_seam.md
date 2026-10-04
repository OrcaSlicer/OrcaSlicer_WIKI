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

Seam painting on a part has no effect once the part becomes a Precise Seam modifier or any other kind of modifier. The painting is kept and works again if you change the volume back to a part.

To change the type of a Precise Seam modifier, right-click it and choose **Precise Seam Type**. This submenu is only shown when every selected item is a Precise Seam modifier. Several modifiers can be changed at once.

## Modifier types

There are six types, in two groups. Each type has its own icon in the object list and its own color in the 3D view. The three strong types use close shades of orange, so use the icons in the object list to tell them apart.

### Strong modifiers

A strong modifier sets the seam to one exact point where it crosses the outer wall. The [Seam Position](quality_settings_seam#seam-position) setting cannot move it.

| Type | Seam position | Color |
| --- | --- | --- |
| **Seam Center** | Middle of the crossing | Orange |
| **Seam Left** | Left end of the crossing | Gold |
| **Seam Right** | Right end of the crossing | Dark orange |

Left and Right are seen from outside the object. On the wall of a hole, seen from inside the hole, they are swapped. Mirroring an object does not swap them: the seam stays at the left or right end as seen after mirroring, which is the other end of the mirrored modifier. Change the type if you want the seam to follow the mirrored model.

If a strong modifier crosses the same wall in more than one place, the longest crossing is used. When crossings have exactly the same length, the one nearest the back of the plate wins, then the one furthest to the left.

A strong modifier that contains a whole wall is skipped on that wall, as there is no crossing to place the seam on.

On a wall that a strong modifier crosses, every other point is blocked, and weak modifiers and seam painting have no effect there.

### Weak modifiers

A weak modifier marks the part of the outer wall inside it as a zone, like painting seams by hand. The [Seam Position](quality_settings_seam#seam-position) setting still chooses the seam, but it uses the Enforced zones and avoids the Blocked ones. A weak modifier applies everywhere it crosses the wall, so a body that passes through the whole object marks the wall on both sides.

| Type | Zone | Color |
| --- | --- | --- |
| **Seam Enforced** | Preferred for the seam | Green |
| **Seam Blocked** | Avoided by the seam | Red |
| **Seam Neutral** | Neither preferred nor avoided | Gray |

Weak modifiers override [Seam Painting](prepare_seam_painting) inside their zone. A *Seam Neutral* modifier clears painted seams where it crosses the wall.

A weak modifier can also contain a whole wall:

- **Seam Enforced** marks the whole wall as preferred, like painting it all round. The [Seam Position](quality_settings_seam#seam-position) setting then picks the best spot on it.
- **Seam Neutral** clears the whole wall, removing painting and the zones of lower modifiers.
- **Seam Blocked** is skipped on that wall, because the seam has to go somewhere. Lower modifiers and painting still apply there.

## Priority

The order in the object list is the priority order: a modifier higher in the list wins over the ones below it.

- Strong modifiers are always listed above weak ones. If you change a modifier's type from one group to the other, it moves to the bottom of its new group.
- Drag and drop modifiers to reorder them within their group.
- On each wall, the first strong modifier that crosses it sets the seam, and all modifiers below it are ignored for that wall. A strong modifier that contains the whole wall does not count as crossing it.
- Where weak modifiers overlap, the one higher in the list decides the zone.

## Designing a modifier

- **Reach the middle of the outer wall.** The modifier is compared with the centerline of the outer wall, which lies half an outer wall line width inside the surface. Let the body extend at least that far into the model; going deeper is safer. A modifier that only touches the centerline may have no effect.
- **Cross each wall once with strong modifiers.** A strong modifier sets only one seam per wall, so if it crosses a wall in several places, only the longest crossing is used. Crossings of nearly the same length, such as both sides of a thin wall, can make the seam jump between them from layer to layer.
- **Any shape works.** Bodies with holes, such as a Torus lying flat, and bodies that pass through the whole object are supported. Each part of the wall inside the body counts as a crossing.
- **Enclose a whole wall only with Seam Enforced or Seam Neutral.** Strong modifiers and *Seam Blocked* are skipped on a wall they fully contain.

To make the seam follow a curve, draw the path on the model's surface in your CAD software and sweep a small profile along it. A circle is the easiest profile, as its orientation does not matter; a triangle or a regular polygon works too and gives a lighter mesh. Save the helper body once and reuse it.

The modifier acts on the outer walls of each layer, including the walls around holes. Inner walls follow the outer seam as usual, so [Staggered inner seams](quality_settings_seam#staggered-inner-seams) still applies. [Scarf joint seam](quality_settings_seam#scarf-joint-seam), [Seam gap](quality_settings_seam#seam-gap) and wiping start from the chosen point as they would from any other seam. In [Spiral vase](others_settings_special_mode#spiral-vase) mode, Precise Seam modifiers have no effect.

> [!NOTE]
> If you import the model together with its helper bodies as parts, change the helper bodies to modifiers before using [Lay on Face](prepare_object_manipulation#lay-on-face) or other placement tools. While they are parts, they count as printable geometry.

## Warnings and limitations

When a modifier cannot be applied as intended, slicing shows a single warning starting with **Precise Seam:** that lists every problem found and ends with *Seam placement may differ from expected.* Each problem names the modifier types involved, for example *(Seam Left, Seam Enforced)*:

- **failed to process some intersections:** in a rare geometry case, a crossing could not be matched to the wall and was ignored. The other crossings are still used.
- **multiple intersections with a perimeter, only one was used:** a strong modifier crosses one wall in more than one place. Only the longest crossing is used.
- **a perimeter is fully inside a modifier, the modifier was not applied to it:** a strong or *Seam Blocked* modifier contains a whole wall and was skipped there.
- **modifier "name" of "object" had no effect on the seam (it might not reach the centerline of the printed perimeter):** a modifier never crossed the middle of an outer wall. Only the first such modifier is named; when there are several, the warning shows how many in total, and the log lists all of them.

In each case the seam on the affected walls may differ from what you expect. Adjust the modifier as described in [Designing a modifier](#designing-a-modifier).

On a wall that touches itself, a zone edge or strong seam point that falls exactly on the touching point may be applied on the other side of the touch.

## Project compatibility

Precise Seam modifiers are saved in the project 3MF. Versions of OrcaSlicer without this feature open them as ordinary modifiers without settings, so they do not change the print there. If such a version saves the project again, the modifiers stay ordinary modifiers.

Precise Seam modifiers have no per-object settings. If you convert a part or modifier that had settings, they are kept and come back when you change it back to a part or modifier.
