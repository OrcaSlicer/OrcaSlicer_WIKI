#!/usr/bin/env python3
"""
Rate the infill patterns of the wiki from OrcaSlicer's own estimates.

Slices three models with the settings of infill_calculator.3mf through the OrcaSlicer CLI and its --export-statistics
output: the project's 100 mm cube, and the 3DBenchy and Stanford bunny OrcaSlicer ships as handy models, swapped into a
copy of the project. Each pattern is sliced at 5, 15, 30 and 50% sparse infill density, the patterns that only print
solid infill at 100%, and the patterns that support multiline also with 2 and 3 lines.

A pattern is rated on the mean of its runs: material usage, print time, material per time, slicing time and G-code
size. Slicing time is the wall time of each CLI run, so slices run one at a time unless --jobs says otherwise; slices
that run together compete for the CPU and take longer. Layer time variability comes from the cube alone, as the other
models change their cross-section along their height. With 2 and 3 lines, the print time is also compared with the
pattern's own one-line runs. The ratings are written into strength_settings_patterns.md and
strength_settings_patterns_quick_reference.md, the ratings' values into infill_analysis_results.csv and every run into
infill_analysis_runs.csv. Strength is not measured: XY-N and Z-N are set by hand in infill_patterns.csv.

Usage:
    python infill_analysis.py --orca "C:/Program Files/OrcaSlicer/orca-slicer.exe"
    python infill_analysis.py --orca ./orca-slicer --out out              # keep the G-code and statistics in out/
    python infill_analysis.py --out out --reuse                           # rate again from the statistics in out/
    python infill_analysis.py --orca ./orca-slicer --dry-run              # print the ratings, write nothing
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
import zipfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from time import perf_counter

HERE = Path(__file__).resolve().parent
PROJECT = HERE / "infill_calculator.3mf"
PATTERNS_CSV = HERE / "infill_patterns.csv"
RESULTS_CSV = HERE / "infill_analysis_results.csv"
RUNS_CSV = HERE / "infill_analysis_runs.csv"
PATTERNS_PAGE = HERE.parent / "strength_settings_patterns.md"
QUICK_REFERENCE_PAGE = HERE.parent / "strength_settings_patterns_quick_reference.md"

# Plate 1 of the project holds the cube; the other models replace its mesh in a copy. The models are OrcaSlicer's.
MODELS = {"cube": None, "benchy": "3DBenchy.drc", "bunny": "Stanford_Bunny.drc"}
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


def read_stl(path):
    data = path.read_bytes()
    count = struct.unpack("<I", data[80:84])[0]
    index, vertices, triangles = {}, [], []
    for i in range(count):
        triangle = []
        for k in range(3):
            start = 84 + 50 * i + 12 + 12 * k
            point = struct.unpack("<3f", data[start:start + 12])
            if point not in index:
                index[point] = len(vertices)
                vertices.append(point)
            triangle.append(index[point])
        triangles.append(triangle)
    return vertices, triangles


def model_project(orca, models, out, name):
    """A copy of the project whose plate 1 holds the model instead of the cube."""
    project = out / "models" / f"{name}.3mf"
    if project.exists():
        return project
    project.parent.mkdir(parents=True, exist_ok=True)
    source = models / MODELS[name]
    run = subprocess.run([orca, "--export-stls", str(project.parent), str(source)], cwd=project.parent,
                         stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, errors="replace")
    stl = project.parent / f"obj_1_{source.name}.stl"
    if run.returncode != 0 or not stl.exists():
        raise RuntimeError(f"{name}: OrcaSlicer could not export {source} as STL\n{run.stderr.strip()}")
    vertices, triangles = read_stl(stl)
    low = [min(v[a] for v in vertices) for a in range(3)]
    high = [max(v[a] for v in vertices) for a in range(3)]
    center = [(lo + hi) / 2 for lo, hi in zip(low, high)]
    mesh = "<vertices>\n" + "".join(
        f'     <vertex x="{x - center[0]:.6g}" y="{y - center[1]:.6g}" z="{z - center[2]:.6g}"/>\n' for x, y, z in vertices)
    mesh += "    </vertices>\n    <triangles>\n" + "".join(
        f'     <triangle v1="{a}" v2="{b}" v3="{c}"/>\n' for a, b, c in triangles) + "    </triangles>"
    with zipfile.ZipFile(PROJECT) as source_zip, zipfile.ZipFile(project, "w", zipfile.ZIP_DEFLATED) as target:
        for info in source_zip.infolist():
            text = source_zip.read(info.filename)
            if info.filename == "3D/Objects/Cube_29.model":
                # The cube's mesh stays for the other plates, which share it.
                model = re.sub(r"<vertices>.*</triangles>", lambda m: mesh, text.decode("utf-8"), flags=re.S)
                target.writestr("3D/Objects/Model.model", model)
            elif info.filename == "3D/3dmodel.model":
                text = text.decode("utf-8")
                cube = re.search(r'<object id="2".*?</object>', text, re.S).group(0)
                text = text.replace(cube, cube.replace("/3D/Objects/Cube_29.model", "/3D/Objects/Model.model"))
                text = re.sub(r'(<item objectid="2"[^>]*transform=")[^"]*"',
                              lambda m: m.group(1) + f'1 0 0 0 1 0 0 0 1 128 128 {(high[2] - low[2]) / 2:.6g}"', text)
                text = text.encode("utf-8")
            elif info.filename == "3D/_rels/3dmodel.model.rels":
                text = text.decode("utf-8").replace("</Relationships>", ' <Relationship Target="/3D/Objects/Model.model" '
                    'Id="rel-model" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>\n</Relationships>')
                text = text.encode("utf-8")
            elif info.filename == "Metadata/model_settings.config":
                text = text.decode("utf-8")
                cube = re.search(r'<object id="2">.*?</object>', text, re.S).group(0)
                text = text.replace(cube, cube.replace('value="Cube"', f'value="{name}"')).encode("utf-8")
            target.writestr(info, text)
    return project


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


def slice_run(orca, out, projects, key):
    model, pattern, density, lines = key
    target = statistics_file(out, key).parent
    target.mkdir(parents=True, exist_ok=True)
    option = "--internal-solid-infill-pattern" if density == SOLID else "--sparse-infill-pattern"
    # Without walls and shells Lightning leaves the lower part of a model empty. The first layer must not be, so every
    # run gets a bottom shell there and is measured from the second layer; the empty layers above only warn, unless
    # --no-check comes before --slice, as the CLI runs its actions in order.
    command = [orca, "--no-check", "--slice", "1", option, pattern, "--sparse-infill-density", f"{density}%",
               "--fill-multiline", str(lines), "--bottom-shell-layers", "1", "--export-statistics",
               "--outputdir", str(target), str(projects[model])]
    # In the output folder, which gets the log the CLI writes to its working directory.
    start = perf_counter()
    run = subprocess.run(command, cwd=target, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, errors="replace")
    seconds = perf_counter() - start
    if run.returncode != 0:
        raise RuntimeError(f"{key}: OrcaSlicer exited with {run.returncode}\n{run.stderr.strip()}")
    slicing = {"slicing_time": seconds, "gcode_size": (target / "plate_1.gcode").stat().st_size}
    slicing_file(out, key).write_text(json.dumps(slicing), encoding="utf-8")
    print(f"sliced {model} {pattern} {density}% x{lines} in {seconds:.1f} s", flush=True)


def measure(stats, slicing):
    # The first layer holds the bottom shell and the start G-code, the last one the end G-code.
    layers = stats["layers"][1:]
    layer_times = [layer["time"] for layer in layers[:-1] if layer["time"] > 0]
    mean = statistics.fmean(layer_times)
    return {
        "time": sum(layer["time"] for layer in layers),
        "weight": sum(feature["weight"] for layer in layers for name, feature in layer["features"].items() if name != "Custom"),
        "layer_time": mean,
        "variability": 2 * statistics.pstdev(layer_times) / mean,
        "slicing_time": slicing["slicing_time"],
        "gcode_size": slicing["gcode_size"],
    }


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
    parser.add_argument("--dry-run", action="store_true", help="print the ratings without writing any file")
    args = parser.parse_args()

    with open(PATTERNS_CSV, encoding="utf-8", newline="") as file:
        patterns = [{**row, "solid": row["solid"] == "1", "multiline": row["multiline"] == "1",
                     "xy_n": int(row["xy_n"]), "z_n": int(row["z_n"])} for row in csv.DictReader(file)]
    keys = list(runs(patterns))

    with tempfile.TemporaryDirectory() as temporary:
        # Absolute, as the CLI runs in the output folder.
        out = (args.out or Path(temporary)).resolve()
        todo = [key for key in keys if not (args.reuse and statistics_file(out, key).exists() and slicing_file(out, key).exists())]
        if todo:
            if not args.orca:
                sys.exit(f"--orca is needed to slice {len(todo)} run(s)")
            orca = str(Path(args.orca).resolve()) if Path(args.orca).exists() else args.orca
            models = find_models(orca, args.models)
            projects = {name: PROJECT if file is None else model_project(orca, models, out, name) for name, file in MODELS.items()}
            with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
                list(pool.map(lambda key: slice_run(orca, out, projects, key), todo))
        measured = {}
        for key in keys:
            with open(statistics_file(out, key), encoding="utf-8") as file:
                measured[key] = measure(json.load(file), json.loads(slicing_file(out, key).read_text(encoding="utf-8")))

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
