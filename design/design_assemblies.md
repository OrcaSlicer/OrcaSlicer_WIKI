# Assemblies

> [!IMPORTANT]
> NEW FEATURE: **Design tab — parametric CAD inside the slicer**  
> Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

The [Design tab](design_tab) can hold more than one body, and **Mate** positions one body against another by aligning their [coordinate systems](design_reference_geometry#coordinate-systems). It is how you check that a lid sits on a box, or that a shaft passes through a bearing seat, before either is printed.

- [Mate](#mate)
- [Mate connectors](#mate-connectors)
- [Check interference](#check-interference)
- [Limitations](#limitations)

## Mate

<img alt="design_c_coincident" src="https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/design_c_coincident.svg?raw=true" height="22"> **Mate** aligns two coordinate systems and moves one body onto the other. One connector is the fixed reference; the body carrying the other connector is the one that moves.

Five kinds, and each one leaves something free:

| Kind | Leaves free |
| --- | --- |
| Fastened | Nothing — all 6 degrees of freedom are locked |
| Planar | Sliding in the plane |
| Revolute | Rotation about the axis |
| Slider | Sliding along the axis |
| Cylindrical | Rotation **and** sliding |

A free degree of freedom is **preserved from the body's current placement**, not zeroed — a revolute mate lines the axes up without spinning the part back to some arbitrary zero.

Each mate also takes an **offset** along the reference axis, an **angle** about it, and a **flip** that opposes the two axes for a face-to-face fit.

> [!TIP]
> All five kinds are always listed, in the same order, with the ones that cannot apply dimmed and labelled with the reason. If the kind you want is greyed out, the list tells you why.

If a mate ends up conflicting with another, selecting it in the [feature tree](design_features#the-feature-tree) reports the conflict on the status line and names the one action that resolves it — the eye on that row suppresses the mate.

## Mate connectors

A mate connector is a [Coord Sys](design_reference_geometry#coordinate-systems) feature (`Shift + C`). Build one on each body, then mate them.

By default a connector is drawn as a **small face** rather than as the conventional disc with a roll quadrant, because a face's orientation reads without being learned. Turn **Draw mate connectors as a face** off under **Preferences > General > Camera** for the conventional CAD representation.

## Check interference

**Interference** reports every overlapping pair of solids together with the overlapping volume, so a clash is a number rather than an impression.

Bodies that merely touch enclose no volume and are not reported — only real overlap counts.

## Limitations

> [!WARNING]
> Mate resolves by composing transforms directly. There is **no 3D assembly solver**, so mates are applied in the order they appear in the feature tree rather than solved simultaneously, and **mate limits are not implemented**.

In practice that means a chain of mates behaves predictably as long as each one builds on the placement the previous one produced. Reorder the mates in the feature tree if the result is not what you expected.
