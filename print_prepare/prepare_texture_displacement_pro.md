# Texture Displacement Pro Mode

> [!IMPORTANT]
> NEW FEATURE: **Texture displacement**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Displacement moves the vertices a model already has. A plain imported box has eight of them, so a height map applied to it has nothing to move and produces nothing visible, however deep the texture is set. Somewhere between painting and relief, the mesh has to gain triangles.

Standard mode does that inside **Bake**, at the resolution in its footer, and never shows you the intermediate mesh. Pro mode - the second position of the switch at the top of the [Texture Displacement](prepare_texture_displacement) panel - hands you the same machinery as separate steps you run and inspect yourself.

Everything here is optional. Painting, layers, mapping and baking work identically in both modes.

- [When to use Pro mode](#when-to-use-pro-mode)
- [Order of operations](#order-of-operations)
- [Subdivision](#subdivision)
- [Remeshing](#remeshing)
- [Result](#result)

## When to use Pro mode

- **Trying several textures on one model.** Refine once, then audition textures against a mesh that is already fine enough, instead of paying for refinement on every bake.
- **A badly tessellated import.** A model whose triangles range from 0.05 mm to 20 mm gives wildly uneven relief. [Remeshing](#remeshing) evens it out first.
- **Keeping the triangle count down.** The automatic choice is deliberately generous. If the part is going into a large project, refining by hand to exactly what the texture needs is worth the trouble.
- **Softening a baked result.** [Smooth baked mesh now](#result) is the only way to relax relief that is already committed.

## Order of operations

The steps are not interchangeable, because each one interacts differently with your paint:

1. **Remesh first, before painting** if the import is uneven. Remesh carries paint across by position, but it is cleanest to do it on a bare model.
2. **Paint.**
3. **Subdivide with Only painted area (adaptive)**, which carries the paint onto the finer mesh. Uniform subdivision replaces the whole geometry and clears any not-yet-baked paint.
4. **Bake.**

> [!WARNING]
> Uniform **Subdivide** and any other tool that replaces the triangle list - [Simplify](prepare_stl_transformation#simplify-model) included - drop paint that has not been baked. Relief already baked in is unaffected.

## Subdivision

Splits triangles so the texture has something to displace.

**Only painted area (adaptive)** adds triangles only where you painted. On a large part with a small decal that is the difference between thousands of triangles and millions, and your paint survives. With it off, subdivision is uniform: **Steps** splits every triangle of the model into four, that many times over - each step quadruples the count, so three steps turn 100 k triangles into 6.4 M.

With adaptive on:

| Control | What it does |
| --- | --- |
| **Follow texture detail** | Spends triangles where the texture actually bends - packed along ridges and edges, sparse over flat ground - instead of spreading them evenly. The same detail for fewer triangles on most textures |
| **Max edge** / **Target edge** | No triangle in the painted area stays larger than this. With **Follow texture detail** on it is a baseline that keeps the curvature test able to see the texture at all; with it off it is simply the size everything is split down to |
| **Detail** | How far the mesh may sit from the shape the texture describes. Smaller follows fine detail and costs triangles; larger only chases the big features |
| **Min edge** | A floor on triangle size, so a sharp step in the texture cannot be chased forever. Lower it for finer relief, raise it if the count runs away at hard edges |
| **Edge detail** | Triangle size along the outline of the painted area, where the relief drops back to the bare surface. Lower it if that rim looks jagged - it only costs triangles along the outline. 0 turns it off |
| **Colour detail** | Triangle size where two colours meet. Only shown when a layer is using [colours](prepare_texture_displacement#colours). Each triangle prints in one filament, so a colour edge is only as sharp as the triangles along it - and nothing else refines there, because the surface is flat across a change of colour |

The refinement works to a triangle budget, set in the panel footer. It always splits the triangle that fits worst first, so even a run that spends the whole budget has spent it where it shows most.

- **Preview subdivision** shows what the refinement would produce, as a wireframe, without touching the model. It follows your paint while it is open and reports the triangle count it would produce. **Hide preview** ends it.
- **Subdivide** commits it.

## Remeshing

Rebuilds the whole model with triangles close to one size, splitting the big ones and merging the small ones.

| Control | What it does |
| --- | --- |
| **Target edge** | Triangle size the model is rebuilt with. Seeded with the model's current average |
| **Keep sharp edges** | Holds hard edges and open borders in place. Without it the remesher slides vertices along the surface and rounds every crisp edge off - a cube comes back with wobbly edges. The slider sets how sharp a fold has to be, in degrees, to count |
| **Remesh** | Runs it. The geometry is replaced, and your paint is carried onto the new triangles by position. Relief already baked in is kept |

> [!TIP]
> Remeshing is a blunt instrument: it touches the whole model, including parts that will never carry a texture. If the part is large and the texture is local, adaptive subdivision alone is usually the better answer.

## Result

Settings for the whole texture stack rather than for one layer. They ride along with both the preview and the bake.

| Control | What it does |
| --- | --- |
| **Displace up to the border** | Lets the relief run right to the edge of the painted area. Turn it off to hold that outer ring flat, which keeps the displacement strictly inside your paint but flattens the pattern at the border |
| **Smooth result** | Relaxes the geometry after the texture has been applied, to take the hard steps out of a low-resolution image. Only what the displacement moved is touched |
| **Strength** | How far each pass pulls a vertex towards its neighbours. High values round the relief off quickly; low values need more passes but keep more detail |
| **Passes** | How many passes to run. More passes spread the smoothing further |
| **Ignore outer ring** | Keeps the outermost ring of the painted area out of the smoothing. Its neighbours outside the paint never move, so smoothing that ring drags the relief down and leaves the pattern half-melted at the border |
| **Smooth baked mesh now** | Applies these settings to the model itself, right now, within the painted area - for relief that is already baked in. Anything not yet baked is smoothed by Bake instead |

> [!NOTE]
> **Smooth result** and a layer's own **Smoothing** are different tools for similar-looking problems. Smoothing blurs the *image* before it is used, so it costs fine detail everywhere. Smooth result relaxes the *geometry* afterwards, so it rounds off steps the mesh could not represent cleanly. A harsh, grainy source image wants the first; a stepped, low-resolution one wants the second.
