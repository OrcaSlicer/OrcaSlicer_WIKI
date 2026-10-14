#!/usr/bin/env python3
"""
Rate the infill patterns of the wiki from OrcaSlicer's own estimates.

Slices infill_calculator.3mf once per pattern with the OrcaSlicer CLI and its --export-statistics output, rates each
pattern's material usage, print time, material per time and layer time variability, and rewrites those ratings in
strength_settings_patterns.md and strength_settings_patterns_quick_reference.md. Strength is not measured: XY-N and Z-N
are set by hand in infill_patterns.csv. The measured values are written to infill_analysis_results.csv.

Usage:
    python infill_analysis.py --orca "C:/Program Files/OrcaSlicer/orca-slicer.exe"
    python infill_analysis.py --orca ./orca-slicer --jobs 4 --out out      # keep the G-code and statistics in out/
    python infill_analysis.py --out out --reuse                            # rate again from the statistics in out/
    python infill_analysis.py --orca ./orca-slicer --dry-run               # print the ratings, write nothing
"""

import argparse
import csv
import json
import re
import statistics
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROJECT = HERE / "infill_calculator.3mf"
PATTERNS_CSV = HERE / "infill_patterns.csv"
RESULTS_CSV = HERE / "infill_analysis_results.csv"
PATTERNS_PAGE = HERE.parent / "strength_settings_patterns.md"
QUICK_REFERENCE_PAGE = HERE.parent / "strength_settings_patterns_quick_reference.md"

# Plate 1 holds a 100 mm cube at 15% sparse infill. Plate 2 holds a 53.13 mm cube at 100%, which fills about the
# same volume, for the patterns that only print solid infill.
TESTS = {"sparse": (1, "--sparse-infill-pattern"), "surface": (2, "--internal-solid-infill-pattern")}

# The filament, in g at the project's 1 g/cm³, that rates as exactly the 15% the density asks for.
EXPECTED_WEIGHT = 997.25 * 0.15

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


def statistics_file(out, pattern, test):
    return out / pattern / f"plate_{TESTS[test][0]}.statistics.json"


def slice_pattern(orca, out, pattern, test):
    plate, option = TESTS[test]
    target = out / pattern
    target.mkdir(parents=True, exist_ok=True)
    # Without walls and shells Lightning leaves the lower half of the cube empty. The first layer must not be, so every
    # pattern gets a bottom shell there and is measured from the second layer; the empty layers above only warn, unless
    # --no-check comes before --slice, as the CLI runs its actions in order.
    command = [orca, "--no-check", "--slice", str(plate), option, pattern, "--bottom-shell-layers", "1",
               "--export-statistics", "--outputdir", str(target), str(PROJECT)]
    # In the output folder, which gets the log the CLI writes to its working directory.
    run = subprocess.run(command, cwd=target, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, errors="replace")
    if run.returncode != 0:
        raise RuntimeError(f"{pattern}: OrcaSlicer exited with {run.returncode}\n{run.stderr.strip()}")
    print(f"sliced {pattern}", flush=True)


def measure(stats):
    # The first layer holds the bottom shell and the start G-code, the last one the end G-code.
    layers = stats["layers"][1:]
    layer_times = [layer["time"] for layer in layers[:-1] if layer["time"] > 0]
    mean = statistics.fmean(layer_times)
    return {
        "time": sum(layer["time"] for layer in layers),
        "weight": sum(feature["weight"] for layer in layers for name, feature in layer["features"].items() if name != "Custom"),
        "layer_time": mean,
        "variability": 2 * statistics.pstdev(layer_times) / mean,
    }


def rate(patterns, measured):
    results = []
    for p in patterns:
        m = measured[p["pattern"]]
        usage = m["weight"] / EXPECTED_WEIGHT
        results.append({**p, **m, "usage": usage, "usage_level": level(usage)})
    # Time and material per time are rated against the patterns of normal material usage.
    normal = [r for r in results if r["usage_level"] == NORMAL]
    mean_time = statistics.fmean(r["time"] for r in normal)
    mean_rate = statistics.fmean(r["weight"] / r["time"] for r in normal)
    for r in results:
        r["time_ratio"] = r["time"] / mean_time
        r["rate_ratio"] = r["weight"] / r["time"] / mean_rate
        r["time_level"] = level(r["time_ratio"])
        r["rate_level"] = level(r["rate_ratio"])
        r["variability_name"], r["variability_level"] = next(
            (name, n) for limit, name, n in VARIABILITY if r["variability"] <= limit)
    return results


def replace_value(lines, label, value):
    pattern = re.compile(r"^(\s*- \*\*" + re.escape(label) + r"\*\* )[^\r\n]*")
    hits = [i for i, line in enumerate(lines) if pattern.match(line)]
    if len(hits) != 1:
        raise ValueError(f"expected one '{label}' line, found {len(hits)}")
    lines[hits[0]] = pattern.sub(lambda m: m.group(1) + value, lines[hits[0]])


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
        name = re.match(r"\s*\[([^\]]+)\]", cells[2]) if len(cells) == 9 else None
        if not name or name.group(1) not in by_name:
            continue
        r = by_name[name.group(1)]
        cells[3] = f" X-Y: {icon('better', r['xy_n'])}<br> Z: {icon('better', r['z_n'])} "
        cells[4] = f" {icon('worse', r['usage_level'])} "
        cells[5] = f" {icon('worse', r['time_level'])} "
        cells[6] = f" {icon('worse', r['variability_level'])} "
        lines[i] = "|".join(cells) + line[len(line.rstrip("\r\n")):]
        seen.add(r["name"])
    missing = set(by_name) - seen
    if missing:
        raise ValueError(f"{QUICK_REFERENCE_PAGE.name} has no row for {', '.join(sorted(missing))}")
    return "".join(lines)


def write_results(results):
    columns = ["pattern", "name", "time_min", "weight_g", "material_usage", "print_time", "material_per_time",
               "layer_time_s", "layer_time_variability", "xy", "z", "material_usage_rating", "print_time_rating",
               "material_per_time_rating", "layer_time_variability_rating"]
    with open(RESULTS_CSV, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(columns)
        for r in results:
            writer.writerow([r["pattern"], r["name"], f"{r['time'] / 60:.2f}", f"{r['weight']:.3f}", f"{r['usage']:.3f}",
                             f"{r['time_ratio']:.3f}", f"{r['rate_ratio']:.3f}", f"{r['layer_time']:.3f}",
                             f"{r['variability']:.3f}", LEVELS[r["xy_n"]][1], LEVELS[r["z_n"]][1],
                             LEVELS[r["usage_level"]][1], LEVELS[r["time_level"]][1], LEVELS[r["rate_level"]][1],
                             r["variability_name"]])


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
    parser.add_argument("--out", type=Path, help="where to keep the G-code and statistics; a temporary folder if not given")
    parser.add_argument("--reuse", action="store_true", help="do not slice a pattern whose statistics are already in --out")
    parser.add_argument("--jobs", type=int, default=2, help="patterns to slice at the same time (default 2)")
    parser.add_argument("--dry-run", action="store_true", help="print the ratings without writing any file")
    args = parser.parse_args()

    with open(PATTERNS_CSV, encoding="utf-8", newline="") as file:
        patterns = [{**row, "xy_n": int(row["xy_n"]), "z_n": int(row["z_n"])} for row in csv.DictReader(file)]

    with tempfile.TemporaryDirectory() as temporary:
        # Absolute, as the CLI runs in the output folder.
        out = (args.out or Path(temporary)).resolve()
        todo = [p for p in patterns if not (args.reuse and statistics_file(out, p["pattern"], p["test"]).exists())]
        if todo:
            if not args.orca:
                sys.exit(f"--orca is needed to slice {len(todo)} pattern(s)")
            orca = str(Path(args.orca).resolve()) if Path(args.orca).exists() else args.orca
            with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
                list(pool.map(lambda p: slice_pattern(orca, out, p["pattern"], p["test"]), todo))
        measured = {}
        for p in patterns:
            with open(statistics_file(out, p["pattern"], p["test"]), encoding="utf-8") as file:
                measured[p["pattern"]] = measure(json.load(file))

    results = rate(patterns, measured)
    for r in results:
        print(f"{r['name']:<20} usage {r['usage']:6.3f} {LEVELS[r['usage_level']][1]:<12} time {r['time_ratio']:6.3f} "
              f"{LEVELS[r['time_level']][1]:<12} g/t {r['rate_ratio']:6.3f} {LEVELS[r['rate_level']][1]:<12} "
              f"layers {r['variability']:6.3f} {r['variability_name']}")
    if args.dry_run:
        return
    write_results(results)
    rewrite(PATTERNS_PAGE, update_patterns_page, results)
    rewrite(QUICK_REFERENCE_PAGE, update_quick_reference, results)


if __name__ == "__main__":
    main()
