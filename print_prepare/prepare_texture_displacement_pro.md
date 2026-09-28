# Texture Displacement Pro Mode

> [!IMPORTANT]
> NEW FEATURE: **Texture displacement**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Pro mode is the second position of the switch at the top of the [Texture Displacement](prepare_texture_displacement) panel. It adds the mesh preparation and result controls that Standard mode keeps out of the way, for models that need more than the built-in recipe.

Everything on this page is optional. Painting, layers, mapping and baking work the same in both modes.

- [Why the mesh matters](#why-the-mesh-matters)
- [Subdivision](#subdivision)
- [Remeshing](#remeshing)
- [Result](#result)

## Why the mesh matters

Displacement moves the vertices a model already has. A plain imported box has eight of them, so a height map applied to it has nothing to move and produces nothing visible, however deep the texture is set. The answer is more triangles under the paint - which is what subdivision and remeshing are for.

The Standard mode Bake already does this for you at the resolution shown in its footer. Reach for the controls here when you want to see and control that step: to refine once and then try several textures on the same prepared mesh, to even out a badly tessellated import before painting it, or to keep the triangle count under control on a model where the automatic choice is too generous.

## Subdivision

Splits triangles to give the texture something to displace.

**Only painted area (adaptive)** adds triangles only where you painted, instead of everywhere. On a large part with a small decal that is the difference between thousands of triangles and millions, and your paint survives the refinement. With it off, subdivision is uniform: **Steps** splits every triangle of the model into four, that many times over - each step quadruples the count, so three steps turn 100 k triangles into 6.4 M.

With the adaptive mode on:

| Control | What it does |
| --- | --- |
| **Follow texture detail** | Spends the triangles where the texture actually bends - packed along ridges and edges, sparse over flat ground - instead of spreading them evenly. The same detail for fewer triangles on most textures. |
| **Max edge** / **Target edge** | No triangle in the painted area stays larger than this. With **Follow texture detail** on it is a baseline that keeps the detail test able to see the texture at all; with it off, it is simply the size everything is split down to. |
| **Detail** | How far the mesh may sit from the shape the texture describes, in millimetres. Smaller follows fine detail and costs triangles; larger only chases the big features. |
| **Min edge** | A floor on triangle size, so a sharp step in the texture cannot be chased forever. Lower it for finer relief, raise it if the count runs away at hard edges. |
| **Edge detail** | Triangle size along the outline of the painted area, where the relief drops back to the bare surface. Lower it if that rim looks jagged; it only costs triangles along the outline, and 0 turns it off. |
| **Colour detail** | Triangle size where two colours meet. Only shown when a layer is using [colours](prepare_texture_displacement#colours). Each triangle prints in one filament, so a colour edge can only be as sharp as the triangles along it, and nothing else refines there - the surface is flat across a change of colour. |

The refinement works to a triangle budget, set by the slider in the panel footer. It always splits the triangle that fits worst first, so even a run that spends the whole budget has spent it where it shows most.

- **Preview subdivision** shows what the refinement would produce, as a wireframe, without touching the model. The preview follows your paint while it is open, and the panel reports the triangle count it would produce. **Hide preview** ends it.
- **Subdivide** commits it. In adaptive mode the paint is carried onto the finer mesh and the rest of the model is left alone; uniform subdivision replaces the whole geometry and clears any not-yet-baked paint on it.

## Remeshing

Rebuilds the whole model with triangles close to one size, splitting the big ones and merging the small ones. It is the fix for an uneven import, where displacement on triangles of wildly different sizes gives wildly different detail.

| Control | What it does |
| --- | --- |
| **Target edge** | Triangle size the model is rebuilt with, in millimetres. Seeded with the model's current average. |
| **Keep sharp edges** | Holds hard edges and open borders in place while the rest is remeshed. Without it the remesher slides vertices along the surface and rounds every crisp edge off - a cube comes back with wobbly edges. The slider beside it sets how sharp a fold has to be, in degrees, to count as an edge worth keeping. |
| **Remesh** | Runs it. The geometry is replaced, and your paint is carried onto the new triangles by position, so it survives. Relief that is already baked in is kept. |

## Result

Settings for the whole texture stack rather than for one layer. They ride along with both the preview and the bake.

| Control | What it does |
| --- | --- |
| **Displace up to the border** | Lets the relief run right to the edge of the painted area. Turn it off to hold that outer ring flat, which keeps the displacement strictly inside your paint but flattens the pattern at the border. |
| **Smooth result** | Smooths the geometry after the texture has been applied, to take the hard steps out of a low-resolution image. Only what the displacement moved is touched. |
| **Strength** | How far each smoothing pass pulls a vertex towards its neighbours. High values round the relief off quickly; low values need more passes but keep more of the detail. |
| **Passes** | How many smoothing passes to run. More passes spread the smoothing further across the surface. |
| **Ignore outer ring** | Keeps the outer ring of the painted area out of the smoothing. Its neighbours outside the paint never move, so smoothing that ring drags the relief down and leaves the pattern half-melted at the border. |
| **Smooth baked mesh now** | Applies the smoothing settings above to the model itself, right now, within the painted area - for relief that is already baked in. Anything not yet baked is smoothed by Bake instead. |

> [!NOTE]
> **Smooth result** and a layer's own **Smoothing** slider are different things. Smoothing blurs the image before it is used; Smooth result relaxes the geometry after the displacement has been applied.
