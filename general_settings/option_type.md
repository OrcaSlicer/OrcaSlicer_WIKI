# Option Types

Every setting holds a particular kind of value. This page explains what each `[Type]` shown on an option's page means, and — since this determines exactly how you write it — how to provide that value both in the GUI and on the [command line](cli_mode).

- [Boolean](#boolean)
- [Integer / Float / Percentage](#integer-float-percentage)
- [Text](#text)
- [Choice](#choice)
- [Point](#point)
- [List Types](#list-types)

## Boolean

An on/off toggle (a checkbox in the GUI).

On the CLI, presence of the flag alone enables it — no value needed:

```
--use-relative-e-distances
```

An explicit value is also accepted, but only `1` (true) or `0` (false), and only using `=` — not a space, and not a colon:

```
--use-relative-e-distances=1
--use-relative-e-distances=0
```

> [!WARNING]
> `--use-relative-e-distances 0` (space-separated) does **not** turn the option off. Since boolean flags never consume the next token as a value, the flag is simply enabled, and `0` is left over as a separate, unrelated argument — which OrcaSlicer will try to load as an input file. Always use `=` to set a boolean explicitly.

## Integer / Float / Percentage

A number. Integer accepts whole numbers only; Float accepts decimals; Percentage is a float written with or without a trailing `%`. Some Floats carry a unit (mm, °, s, mm/s) shown next to the option's value in the GUI — the CLI value is always the bare number, without the unit.

```
--mtcpp=1000000
--scale=1.5
--sparse-infill-density=20%
```

## Text

A string value — a filename, a label, a small snippet.

```
--outputdir=/home/user/exports
```

## Choice

One of a fixed set of values (an enum, a dropdown in the GUI). The option's page lists the exact accepted values under its `[Type]` tag — use one of those values verbatim, not the human-readable label shown in the GUI.

```
--seam-position=aligned_back
```

## Point

An X,Y coordinate pair, written as two comma-separated numbers.

```
--align-xy=100,100
```

## List Types

Any of the types above can also come as a **list** — one value per extruder, filament, or object, following the [vector flag syntax](cli_mode#vector-multi-value-flags): a comma-separated list where position = index, with padding and append behavior to be aware of before using one.

```
--retraction-length=0.8,0.8,1.2,0.8
```
