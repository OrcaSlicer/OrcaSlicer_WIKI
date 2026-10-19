#!/usr/bin/env python3
"""
Rate the infill patterns of the wiki from OrcaSlicer's own estimates.

Slices three models through the OrcaSlicer CLI and its --export-statistics output on the Qidi Q2 0.4 nozzle, with its
0.20mm Standard process and QIDI PLA Rapido and the changes in SETTINGS: a 100 mm cube written here, and the 3DBenchy and
Stanford bunny OrcaSlicer ships as handy models. Each pattern is sliced at 5, 15, 30 and 50% sparse infill density, the
patterns that only print solid infill at 100%, and the patterns that support multiline also with 2 and 3 lines.

Only the infill is measured: the sparse infill of a sparse run, and the internal solid infill of a 100% run, which a
pattern is rated on against the other patterns' 100% runs. A pattern is rated on the mean of its runs: material usage,
print time (of the infill extrusions and the travel of the layers that print them), material per time, slicing time and G-code size (of the infill
blocks). Slicing time is the wall time of each CLI run, so slices run one at a time unless --jobs says otherwise; slices
that run together compete for the CPU and take longer, unless --keep-slicing-time takes the times from the last
infill_analysis_runs.csv. Layer time variability comes from the cube alone, as the other models change their
cross-section along their height. With 2 and 3 lines, the print time is also compared with the pattern's own one-line
runs. The ratings are written into strength_settings_patterns.md and
strength_settings_patterns_quick_reference.md, the ratings' values into infill_analysis_results.csv and every run into
infill_analysis_runs.csv. Strength is not measured: XY-N and Z-N are set by hand in infill_patterns.csv.

Usage:
    python infill_analysis.py --orca "C:/Program Files/OrcaSlicer/orca-slicer.exe"
    python infill_analysis.py --orca ./orca-slicer --out out              # keep the G-code and statistics in out/
    python infill_analysis.py --out out --reuse                           # rate again from the statistics in out/
    python infill_analysis.py --orca ./orca-slicer --dry-run              # print the ratings, write nothing
    python infill_analysis.py --orca ./orca-slicer --keep-slicing-time --jobs 6   # keep the slicing times, slice in parallel
"""

import argparse
import csv
import json
import re
import statistics
import struct
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from time import perf_counter

HERE = Path(__file__).resolve().parent
PATTERNS_CSV = HERE / "infill_patterns.csv"
RESULTS_CSV = HERE / "infill_analysis_results.csv"
RUNS_CSV = HERE / "infill_analysis_runs.csv"
PATTERNS_PAGE = HERE.parent / "strength_settings_patterns.md"
QUICK_REFERENCE_PAGE = HERE.parent / "strength_settings_patterns_quick_reference.md"

# The cube is written as an STL; the other models are OrcaSlicer's handy models.
MODELS = {"cube": None, "benchy": "3DBenchy.drc", "bunny": "Stanford_Bunny.drc"}
CUBE = 100
# System presets of OrcaSlicer's profiles, as (vendor, name).
PRINTER = ("Qidi", "Qidi Q2 0.4 nozzle")
PROCESS = ("Qidi", "0.20mm Standard @Qidi Q2")
FILAMENT = ("Qidi", "QIDI PLA Rapido @Qidi Q2 0.4 nozzle")
# What the runs change in the process and the filament. The shell thicknesses make the one top and bottom layer the only
# ones, and without the slow down for layer cooling a short layer is not slowed to the layer time.
SETTINGS = {
    "infill_anchor_max": "0", "infill_combination": "0", "reduce_infill_retraction": "1", "wall_loops": "1",
    "top_shell_layers": "1", "bottom_shell_layers": "1", "top_shell_thickness": "0", "bottom_shell_thickness": "0",
    "gap_fill_target": "nowhere", "separated_infills": "1", "wall_generator": "classic", "is_infill_first": "1",
    "wall_sequence": "inner wall/outer wall", "fuzzy_skin": "disabled_fuzzy", "detect_thin_wall": "0",
    "slow_down_for_layer_cooling": "0",
}
SPARSE_FEATURE = "Sparse infill"
SOLID_FEATURE = "Internal solid infill"
DENSITIES = (5, 15, 30, 50)
SOLID = 100
MULTILINES = (2, 3)
# The solid pattern whose fill measures each model's volume.
REFERENCE = "monotonic"

# The rating of a ratio is the first level whose limit is not below it. Strength levels are set by hand.
LEVELS = [(0.15, "Ultra-Low"), (0.4, "Extra-Low"), (0.75, "Low"), (0.925, "Normal-Low"), (1.075, "Normal"),
          (1.25, "Normal-High"), (1.6, "High"), (1.85, "Extra-High"), (9.99, "Ultra-High")]
NORMAL = 4
# Of twice the standard deviation of the layer times over their mean: the limit, the rating and its icon level.
VARIABILITY = [(0.01, "None", 0), (0.3, "Unnoticeable", 2), (0.75, "Possibly Noticeable", 5),
               (float("inf"), "Likely Noticeable", 8)]


def level(ratio):
    return next(n for n, (limit, _) in enumerate(LEVELS) if ratio <= limit)


def icon(kind, n):
    name = f"level-to-{kind}-{n}"
    return f"![{name}](https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/misc/{name}.svg?raw=true)"


def rated(kind, n):
    return f"{LEVELS[n][1]} {icon(kind, n)}"


def find_models(orca, models):
    if models:
        return Path(models)
    exe = Path(orca).resolve().parent
    for candidate in (exe / "resources" / "handy_models", exe.parent / "Resources" / "handy_models"):
        if candidate.is_dir():
            return candidate
    sys.exit("OrcaSlicer's handy_models folder was not found next to --orca; pass it with --models")


def preset_file(models, kind, preset):
    vendor, name = preset
    found = next((models.parent / "profiles" / vendor / kind).rglob(f"{name}.json"), None)
    if found is None:
        sys.exit(f"the {kind} preset '{name}' was not found in the profiles next to the handy_models folder")
    return found


def write_cube(path):
    vertices = [(x, y, z) for z in (0, CUBE) for y in (0, CUBE) for x in (0, CUBE)]
    faces = [(0, 2, 3, 1), (4, 5, 7, 6), (0, 1, 5, 4), (2, 6, 7, 3), (0, 4, 6, 2), (1, 3, 7, 5)]
    triangles = [t for a, b, c, d in faces for t in ((a, b, c), (a, c, d))]
    data = bytearray(80) + struct.pack("<I", len(triangles))
    for triangle in triangles:
        data += struct.pack("<3f", 0, 0, 0) + b"".join(struct.pack("<3f", *vertices[i]) for i in triangle) + b"\0\0"
    path.write_bytes(bytes(data))


def model_files(models, out):
    cube = out / "models" / "cube.stl"
    cube.parent.mkdir(parents=True, exist_ok=True)
    write_cube(cube)
    return {name: cube if file is None else models / file for name, file in MODELS.items()}


def runs(patterns):
    for model in MODELS:
        for p in patterns:
            if p["test"] == "sparse":
                for density in DENSITIES:
                    yield model, p["pattern"], density, 1
                    if p["multiline"]:
                        for lines in MULTILINES:
                            yield model, p["pattern"], density, lines
            if p["solid"]:
                yield model, p["pattern"], SOLID, 1


def statistics_file(out, key):
    model, pattern, density, lines = key
    return out / "runs" / model / f"{pattern}_{density}_{lines}" / "plate_1.statistics.json"


def slicing_file(out, key):
    return statistics_file(out, key).with_name("slicing.json")


def feature_of(density):
    return SOLID_FEATURE if density == SOLID else SPARSE_FEATURE


def infill_size(gcode, feature):
    """The bytes of the G-code blocks that print the feature."""
    size, inside = 0, False
    with open(gcode, "rb") as file:
        for line in file:
            if line.startswith(b";TYPE:"):
                inside = line[6:].strip() == feature.encode()
            if inside:
                size += len(line)
    return size


def slice_run(orca, out, files, presets, key):
    model, pattern, density, lines = key
    target = statistics_file(out, key).parent
    target.mkdir(parents=True, exist_ok=True)
    option = "internal_solid_infill_pattern" if density == SOLID else "sparse_infill_pattern"
    options = {**SETTINGS, option: pattern, "sparse_infill_density": f"{density}%", "fill_multiline": str(lines)}
    command = [orca, "--load-settings", presets[0], "--load-filaments", presets[1], "--slice", "0",
               *(f"--{name.replace('_', '-')}={value}" for name, value in options.items()),
               "--export-statistics", "--outputdir", str(target), str(files[model])]
    # In the output folder, which gets the log the CLI writes to its working directory.
    start = perf_counter()
    run = subprocess.run(command, cwd=target, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, errors="replace")
    seconds = perf_counter() - start
    if run.returncode != 0:
        raise RuntimeError(f"{key}: OrcaSlicer exited with {run.returncode}\n{run.stderr.strip()}")
    slicing = {"slicing_time": seconds, "gcode_size": infill_size(target / "plate_1.gcode", feature_of(density))}
    slicing_file(out, key).write_text(json.dumps(slicing), encoding="utf-8")
    print(f"sliced {model} {pattern} {density}% x{lines} in {seconds:.1f} s", flush=True)


def measure(stats, slicing, name):
    # Of the layers that print the feature, a layer without it such as a shell is not measured. The statistics give the
    # travel of a layer, not of a feature, so the time of the feature is its extrusions and the travel of its layers.
    layers = [layer for layer in stats["layers"] if name in layer["features"]]
    layer_times = [layer["features"][name]["time"] + layer["travel_time"] for layer in layers]
    mean = statistics.fmean(layer_times)
    return {
        "time": sum(layer_times),
        "weight": sum(layer["features"][name]["weight"] for layer in layers),
        "layer_time": mean,
        "variability": 2 * statistics.pstdev(layer_times) / mean,
        "slicing_time": slicing["slicing_time"],
        "gcode_size": slicing["gcode_size"],
    }


def kept_slicing_times():
    with open(RUNS_CSV, encoding="utf-8", newline="") as file:
        return {(row["model"], row["pattern"], int(row["density"]), int(row["lines"])): float(row["slicing_s"])
                for row in csv.DictReader(file)}


def rate(patterns, measured):
    # The material of a run against the density of the model's volume.
    volume = {model: measured[(model, REFERENCE, SOLID, 1)]["weight"] for model in MODELS}
    for (model, _, density, _), m in measured.items():
        m["usage"] = m["weight"] / (volume[model] * density / 100)
    # Time, material per time, slicing time and G-code size are rated against the single-line runs of normal material
    # usage on the same model and density.
    groups = {}
    for key, m in measured.items():
        if key[3] == 1:
            groups.setdefault((key[0], key[2]), []).append(m)
    baselines = {}
    for group, runs_in_group in groups.items():
        normal = [m for m in runs_in_group if level(m["usage"]) == NORMAL] or runs_in_group
        baselines[group] = (statistics.fmean(m["time"] for m in normal), statistics.fmean(m["weight"] / m["time"] for m in normal),
                            statistics.fmean(m["slicing_time"] for m in normal), statistics.fmean(m["gcode_size"] for m in normal))
    for (model, _, density, _), m in measured.items():
        time, rate_, slicing, size = baselines[(model, density)]
        m["time_ratio"] = m["time"] / time
        m["rate_ratio"] = m["weight"] / m["time"] / rate_
        m["slicing_ratio"] = m["slicing_time"] / slicing
        m["size_ratio"] = m["gcode_size"] / size

    results = []
    for p in patterns:
        densities = DENSITIES if p["test"] == "sparse" else (SOLID,)

        def mean(name, lines=1, models=MODELS):
            return statistics.fmean(measured[(model, p["pattern"], density, lines)][name] for model in models for density in densities)

        def against_one_line(lines):
            return statistics.fmean(measured[(model, p["pattern"], density, lines)]["time"] / measured[(model, p["pattern"], density, 1)]["time"]
                                    for model in MODELS for density in densities)

        r = {**p, "usage": mean("usage"), "time_ratio": mean("time_ratio"), "rate_ratio": mean("rate_ratio"),
             "variability": mean("variability", models=("cube",)), "slicing_ratio": mean("slicing_ratio"), "size_ratio": mean("size_ratio")}
        r["usage_level"], r["time_level"], r["rate_level"] = level(r["usage"]), level(r["time_ratio"]), level(r["rate_ratio"])
        r["slicing_level"], r["size_level"] = level(r["slicing_ratio"]), level(r["size_ratio"])
        r["variability_name"], r["variability_level"] = next(
            (name, n) for limit, name, n in VARIABILITY if r["variability"] <= limit)
        r["lines"] = {lines: (mean("usage", lines), mean("time_ratio", lines), against_one_line(lines))
                      for lines in MULTILINES} if p["multiline"] else {}
        results.append(r)
    return results


def replace_value(lines, label, value):
    pattern = re.compile(r"^(\s*- \*\*" + re.escape(label) + r"\*\* )[^\r\n]*")
    hits = [i for i, line in enumerate(lines) if pattern.match(line)]
    if len(hits) != 1:
        raise ValueError(f"expected one '{label}' line, found {len(hits)}")
    lines[hits[0]] = pattern.sub(lambda m: m.group(1) + value, lines[hits[0]])


def replace_multiline(lines, r):
    hits = [i for i, line in enumerate(lines) if "**[Multiline](strength_settings_infill#fill-multiline):**" in line]
    if len(hits) != 1:
        raise ValueError(f"expected one Multiline line, found {len(hits)}")
    i = hits[0]
    while i + 1 < len(lines) and re.match(r"\s*- \*\*\d lines:\*\*", lines[i + 1]):
        del lines[i + 1]
    indent = re.match(r"\s*", lines[i]).group(0) + "    "
    eol = lines[i][len(lines[i].rstrip("\r\n")):]
    for n, (_, time, against_one) in reversed(list(r["lines"].items())):
        change = f"{abs(against_one - 1) * 100:.0f}% {'Faster' if against_one < 1 else 'Slower'}"
        lines.insert(i + 1, f"{indent}- **{n} lines:** Print Time {rated('worse', level(time))} ({change} over single line){eol}")


def update_patterns_page(text, results):
    sections = re.split(r"(?m)^(?=## )", text)
    by_name = {re.match(r"## ([^\r\n]+)", s).group(1).strip(): i for i, s in enumerate(sections) if s.startswith("## ")}
    for r in results:
        if r["name"] not in by_name:
            raise ValueError(f"{PATTERNS_PAGE.name} has no '## {r['name']}' section")
        i = by_name[r["name"]]
        lines = sections[i].splitlines(keepends=True)
        try:
            replace_value(lines, "Horizontal (X-Y):", rated("better", r["xy_n"]))
            replace_value(lines, "Vertical (Z):", rated("better", r["z_n"]))
            replace_value(lines, "Material Usage:", rated("worse", r["usage_level"]))
            replace_value(lines, "Print Time:", rated("worse", r["time_level"]))
            replace_value(lines, "Material/Time (Higher better):", rated("better", r["rate_level"]))
            replace_value(lines, "Layer time Variability:", r["variability_name"])
            replace_value(lines, "Slicing Time:", rated("worse", r["slicing_level"]))
            replace_value(lines, "G-code Size:", rated("worse", r["size_level"]))
            replace_multiline(lines, r)
        except ValueError as error:
            raise ValueError(f"{PATTERNS_PAGE.name}, {r['name']}: {error}") from None
        sections[i] = "".join(lines)
    return "".join(sections)


def update_quick_reference(text, results):
    by_name = {r["name"]: r for r in results}
    seen = set()
    lines = text.splitlines(keepends=True)
    for i, line in enumerate(lines):
        cells = line.rstrip("\r\n").split("|")
        name = re.match(r"\s*\[([^\]]+)\]", cells[2]) if len(cells) == 10 else None
        if not name or name.group(1) not in by_name:
            continue
        r = by_name[name.group(1)]
        cells[3] = f" X-Y: {icon('better', r['xy_n'])}<br> Z: {icon('better', r['z_n'])} "
        cells[4] = f" {icon('worse', r['usage_level'])} "
        cells[5] = f" {icon('worse', r['time_level'])} "
        cells[6] = f" {icon('worse', r['variability_level'])} "
        cells[8] = " " + "<br> ".join(f"{n}: {icon('worse', level(usage))} {icon('worse', level(time))}"
                                       for n, (usage, time, _) in r["lines"].items()) + " " if r["lines"] else " - "
        lines[i] = "|".join(cells) + line[len(line.rstrip("\r\n")):]
        seen.add(r["name"])
    missing = set(by_name) - seen
    if missing:
        raise ValueError(f"{QUICK_REFERENCE_PAGE.name} has no row for {', '.join(sorted(missing))}")
    return "".join(lines)


def write_csv(path, rows):
    with open(path, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerows(rows)


def write_results(results, measured):
    rows = [["pattern", "name", "material_usage", "print_time", "material_per_time", "layer_time_variability",
             "slicing_time", "gcode_size", "xy", "z", "material_usage_rating", "print_time_rating",
             "material_per_time_rating", "layer_time_variability_rating", "slicing_time_rating", "gcode_size_rating"]
            + [f"{n}_lines_{column}" for n in MULTILINES for column in ("material_usage", "print_time", "print_time_vs_1_line")]]
    for r in results:
        rows.append([r["pattern"], r["name"], f"{r['usage']:.3f}", f"{r['time_ratio']:.3f}", f"{r['rate_ratio']:.3f}",
                     f"{r['variability']:.3f}", f"{r['slicing_ratio']:.3f}", f"{r['size_ratio']:.3f}", LEVELS[r["xy_n"]][1],
                     LEVELS[r["z_n"]][1], LEVELS[r["usage_level"]][1], LEVELS[r["time_level"]][1], LEVELS[r["rate_level"]][1],
                     r["variability_name"], LEVELS[r["slicing_level"]][1], LEVELS[r["size_level"]][1]]
                    + [f"{value:.3f}" if r["lines"] else "" for n in MULTILINES for value in r["lines"].get(n, (0, 0, 0))])
    write_csv(RESULTS_CSV, rows)
    rows = [["model", "pattern", "density", "lines", "time_min", "weight_g", "slicing_s", "gcode_mb", "material_usage",
             "print_time", "material_per_time", "layer_time_s", "layer_time_variability", "slicing_time", "gcode_size"]]
    for (model, pattern, density, lines), m in sorted(measured.items()):
        rows.append([model, pattern, density, lines, f"{m['time'] / 60:.2f}", f"{m['weight']:.3f}", f"{m['slicing_time']:.2f}",
                     f"{m['gcode_size'] / 1e6:.2f}", f"{m['usage']:.3f}", f"{m['time_ratio']:.3f}", f"{m['rate_ratio']:.3f}",
                     f"{m['layer_time']:.3f}", f"{m['variability']:.3f}", f"{m['slicing_ratio']:.3f}", f"{m['size_ratio']:.3f}"])
    write_csv(RUNS_CSV, rows)


def rewrite(path, update, results):
    with open(path, encoding="utf-8", newline="") as file:
        text = file.read()
    new_text = update(text, results)
    if new_text != text:
        with open(path, "w", encoding="utf-8", newline="") as file:
            file.write(new_text)
        print(f"updated {path.name}")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--orca", help="the orca-slicer executable; needed unless --reuse finds every statistics file")
    parser.add_argument("--models", help="OrcaSlicer's resources/handy_models folder; found next to --orca if not given")
    parser.add_argument("--out", type=Path, help="where to keep the G-code and statistics; a temporary folder if not given")
    parser.add_argument("--reuse", action="store_true", help="do not slice a run whose statistics are already in --out")
    parser.add_argument("--jobs", type=int, default=1,
                        help="runs to slice at the same time (default 1); more are faster but make the slicing times longer")
    parser.add_argument("--keep-slicing-time", action="store_true",
                        help="take each run's slicing time from infill_analysis_runs.csv instead of the slice, so --jobs does not matter")
    parser.add_argument("--dry-run", action="store_true", help="print the ratings without writing any file")
    args = parser.parse_args()

    with open(PATTERNS_CSV, encoding="utf-8", newline="") as file:
        patterns = [{**row, "solid": row["solid"] == "1", "multiline": row["multiline"] == "1",
                     "xy_n": int(row["xy_n"]), "z_n": int(row["z_n"])} for row in csv.DictReader(file)]
    keys = list(runs(patterns))
    kept = kept_slicing_times() if args.keep_slicing_time else {}

    with tempfile.TemporaryDirectory() as temporary:
        # Absolute, as the CLI runs in the output folder.
        out = (args.out or Path(temporary)).resolve()
        todo = [key for key in keys if not (args.reuse and statistics_file(out, key).exists() and slicing_file(out, key).exists())]
        if todo:
            if not args.orca:
                sys.exit(f"--orca is needed to slice {len(todo)} run(s)")
            orca = str(Path(args.orca).resolve()) if Path(args.orca).exists() else args.orca
            models = find_models(orca, args.models)
            files = model_files(models, out)
            presets = (f"{preset_file(models, 'machine', PRINTER)};{preset_file(models, 'process', PROCESS)}",
                       str(preset_file(models, "filament", FILAMENT)))
            with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
                list(pool.map(lambda key: slice_run(orca, out, files, presets, key), todo))
        measured = {}
        for key in keys:
            slicing = json.loads(slicing_file(out, key).read_text(encoding="utf-8"))
            if kept:
                slicing["slicing_time"] = kept[key]
            with open(statistics_file(out, key), encoding="utf-8") as file:
                measured[key] = measure(json.load(file), slicing, feature_of(key[2]))

    results = rate(patterns, measured)
    for r in results:
        print(f"{r['name']:<20} usage {r['usage']:6.3f} {LEVELS[r['usage_level']][1]:<12} time {r['time_ratio']:6.3f} "
              f"{LEVELS[r['time_level']][1]:<12} g/t {r['rate_ratio']:6.3f} {LEVELS[r['rate_level']][1]:<12} "
              f"layers {r['variability']:6.3f} {r['variability_name']:<20} slicing {r['slicing_ratio']:6.3f} "
              f"{LEVELS[r['slicing_level']][1]:<12} size {r['size_ratio']:6.3f} {LEVELS[r['size_level']][1]:<12}"
              + "".join(f" x{n}: {u:5.3f} {t:5.3f} {a:5.3f}" for n, (u, t, a) in r["lines"].items()))
    if args.dry_run:
        return
    write_results(results, measured)
    rewrite(PATTERNS_PAGE, update_patterns_page, results)
    rewrite(QUICK_REFERENCE_PAGE, update_quick_reference, results)


if __name__ == "__main__":
    main()
