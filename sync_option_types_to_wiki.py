#!/usr/bin/env python3
"""
Insert/refresh [Type], [Options] and [CLI Example] tags on the wiki's
print/printer/material settings pages, from the option definitions in
libslic3r/PrintConfig.cpp. The [Type] counterpart to sync-tab-options-to-
wiki.ps1's [Mode]/[Variable] sync — only touches headings that already
carry a [Variable] tag; never places one itself.

Usage:
    python3 sync_option_types_to_wiki.py              # preview only
    python3 sync_option_types_to_wiki.py --update      # write the wiki pages
    python3 sync_option_types_to_wiki.py --check       # exit 1 if stale (CI)
    python3 sync_option_types_to_wiki.py --selftest    # verify extraction, no wiki changes
    python3 sync_option_types_to_wiki.py --coverage    # list keys with no [Variable] tag anywhere

    # Point at a local OrcaSlicer checkout instead of fetching from GitHub:
    python3 sync_option_types_to_wiki.py --source ../OrcaSlicer/src/libslic3r/PrintConfig.cpp --update
"""

import argparse
import glob
import json
import os
import re
import sys
import tempfile
import urllib.request

DEFAULT_SOURCE = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/PrintConfig.cpp"
DEFAULT_OVERRIDES = "option_type_overrides.json"
SETTINGS_DIRS = ["print_settings", "printer_settings", "material_settings"]

# C++ option type -> human label shown in [Type]. Extend here for a new coXxx.
TYPE_MAP = {
    "coBool": "Boolean", "coBools": "Boolean list",
    "coInt": "Integer", "coInts": "Integer list",
    "coFloat": "Float", "coFloats": "Float list",
    "coPercent": "Percentage", "coPercents": "Percentage list",
    "coFloatOrPercent": "Float or Percentage", "coFloatsOrPercents": "Float or Percentage list",
    "coString": "Text", "coStrings": "Text list",
    "coEnum": "Choice", "coEnums": "Choice list",
    "coPoint": "Point", "coPoints": "Point list",
    "coPointsGroups": "Point group list",
}

# option_type.md anchor for each base (non-list) label. "<label> list" always
# points at #list-types regardless of base type.
TYPE_ANCHOR = {
    "Boolean": "boolean",
    "Integer": "integer-float-percentage",
    "Float": "integer-float-percentage",
    "Percentage": "integer-float-percentage",
    "Float or Percentage": "integer-float-percentage",
    "Text": "text",
    "Choice": "choice",
    "Point": "point",
}
LIST_ANCHOR = "list-types"

# Past this many distinct types (or this many keys), a per-key breakdown
# line becomes unreadable — log as "needs manual review" instead.
MAX_MIXED_TYPE_KEYS = 6

# Headings restructured by hand into sub-headings with no [Variable] tag of
# their own, so this script has no association to work from.
MANUAL_HOLDOUTS = {
    "print_settings/quality/quality_settings_seam.md": {"Scarf joint seam"},
    "print_settings/quality/quality_settings_wall_and_surfaces.md": {"Surface flow ratio"},
}

# {1,6} (not {2,6}): a page's own H1 title can carry the tag directly too.
HEADING_RE = re.compile(r'^(#{1,6})\s+(.+?)\s*$')
KEY_IN_BACKTICKS_RE = re.compile(r'`([a-zA-Z0-9_]+)(\[[a-zA-Z_]+\])?`')
ADD_RE = re.compile(r'(?:auto\s+(\w+)\s*=\s*)?def\s*=\s*this->add(?:_nullable)?\("([a-zA-Z0-9_]+)",\s*(co\w+)\)')
ENUM_PUSH_RE = re.compile(r'enum_values\.(?:push_back|emplace_back)\(\s*(?:L\()?"([^"]*)"\)?\)')
ENUM_BRACE_RE = re.compile(r'enum_values\s*=\s*\{([^}]*)\}')
ENUM_REF_RE = re.compile(r'enum_values\s*=\s*(\w+)->enum_values')
QUOTED_STR_RE = re.compile(r'"([^"]*)"')
# coString/coStrings only: a quoted default is unambiguous, unlike a numeric one.
DEFAULT_STR_RE = re.compile(r'set_default_value\(\s*new\s+ConfigOptionString\w*\s*\(\s*"([^"]*)"')
CLI_CUTOFF_MARKER = "CLIActionsConfigDef::CLIActionsConfigDef"


def get_source(source):
    if re.match(r'^https?://', source):
        url = source
        m = re.match(r'^https://github\.com/([^/]+)/([^/]+)/blob/(.+)$', url)
        if m:
            owner, repo, path = m.groups()
            url = f"https://raw.githubusercontent.com/{owner}/{repo}/{path}"
        try:
            with urllib.request.urlopen(url, timeout=20) as resp:
                return resp.read().decode("utf-8")
        except Exception as e:
            raise SystemExit(f"Failed to fetch {url}: {e}\n(pass --source with a local PrintConfig.cpp path to skip the network)")
    with open(source, encoding="utf-8") as f:
        return f.read()


def strip_cpp_comments(text):
    # Without this, a commented-out this->add(...) (e.g. adaptive_layer_height,
    # a disabled feature, not a typo) gets extracted as if live. Tracks
    # string-literal state so a "//" inside a quoted tooltip isn't mistaken
    # for a comment start.
    out = []
    i, n = 0, len(text)
    in_string = False
    while i < n:
        c = text[i]
        if in_string:
            out.append(c)
            if c == "\\" and i + 1 < n:
                out.append(text[i + 1])
                i += 2
                continue
            if c == '"':
                in_string = False
            i += 1
            continue
        if c == '"':
            in_string = True
            out.append(c)
            i += 1
            continue
        if c == "/" and i + 1 < n and text[i + 1] == "/":
            j = text.find("\n", i)
            if j == -1:
                break
            out.append("\n")
            i = j + 1
            continue
        if c == "/" and i + 1 < n and text[i + 1] == "*":
            j = text.find("*/", i + 2)
            if j == -1:
                break
            out.append("\n" * text.count("\n", i, j + 2))
            i = j + 2
            continue
        out.append(c)
        i += 1
    return "".join(out)


def extract_key_metadata(source_text):
    source_text = strip_cpp_comments(source_text)
    cutoff = source_text.find(CLI_CUTOFF_MARKER)
    main = source_text[:cutoff] if cutoff != -1 else source_text

    positions = [(m.start(), m.group(1), m.group(2), m.group(3)) for m in ADD_RE.finditer(main)]
    varname_to_key = {v: k for _, v, k, _ in positions if v}

    data = {}
    pending_refs = {}
    for i, (pos, varname, key, typ) in enumerate(positions):
        end = positions[i + 1][0] if i + 1 < len(positions) else len(main)
        block = main[pos:end]

        enum_values = []
        if typ in ("coEnum", "coEnums"):
            enum_values = ENUM_PUSH_RE.findall(block)
            if not enum_values:
                bm = ENUM_BRACE_RE.search(block)
                if bm:
                    enum_values = QUOTED_STR_RE.findall(bm.group(1))
            if not enum_values:
                rm = ENUM_REF_RE.search(block)
                if rm:
                    pending_refs[key] = rm.group(1)

        default = None
        if typ in ("coString", "coStrings"):
            m = DEFAULT_STR_RE.search(block)
            if m and m.group(1):
                default = m.group(1)

        data[key] = {
            "type": typ,
            "type_label": TYPE_MAP.get(typ, typ),
            "enum_values": enum_values,
            "default": default,
            "nocli": "def->cli = ConfigOptionDef::nocli;" in block,
        }

    for key, varname in pending_refs.items():
        ref_key = varname_to_key.get(varname)
        if ref_key and ref_key in data and data[ref_key]["enum_values"]:
            data[key]["enum_values"] = data[ref_key]["enum_values"]

    return data


def find_empty_enums(keydata):
    # A Choice key with no enum_values means PrintConfig.cpp used an
    # enum-definition style extract_key_metadata() doesn't parse yet —
    # surface it rather than silently falling back to a generic value.
    return sorted(k for k, m in keydata.items() if m["type"] in ("coEnum", "coEnums") and not m["enum_values"])


def find_undocumented_keys(keydata, files):
    documented = set()
    for path in files:
        with open(path, encoding="utf-8") as f:
            content = f.read()
        for line in content.splitlines():
            if "[Variable" in line:
                for m in KEY_IN_BACKTICKS_RE.finditer(line):
                    documented.add(m.group(1))
    return sorted(k for k, m in keydata.items() if not m["nocli"] and k not in documented)


# Known-good extractions, hand-verified against the source.
SELFTEST_CASES = [
    ("seam_position", "enum_values", ["nearest", "aligned", "aligned_back", "back", "random"]),
    ("input_shaping_type", "enum_values_len", 13),
    ("sparse_infill_pattern", "enum_values_len", 26),
    ("retract_lift_enforce", "enum_values_contains", "All Surfaces"),  # space in value -> quoting
    ("nozzle_volume_type", "enum_values_contains", "High Flow"),  # L()-wrapped push_back
    ("brim_type", "enum_values_len", 7),  # plain .emplace_back(), not L()-wrapped
    ("use_relative_e_distances", "type", "coBool"),
    ("bottom_surface_pattern", "enum_values_equals_key", "top_surface_pattern"),  # copied-reference
    ("machine_max_jerk_x", "type", "coFloats"),  # loop-generated, must come from overrides
    ("bbl_use_printhost", "nocli", True),
    ("filament_vendor", "nocli", True),
    ("use_relative_e_distances", "nocli", False),
    ("upward_compatible_machine", "nocli", False),  # no nocli marker in source, despite past assumptions
    ("adaptive_layer_height", "not_extracted", None),  # commented out in source, not a typo
    ("spaghetti_detector", "not_extracted", None),
    ("filament_extruder_id", "not_extracted", None),  # only a same-named key in a different (placeholder-var) namespace
    # nocli is commented out in source with "//BBS: open this option to command line" — deliberately CLI-available
    ("filament_settings_id", "nocli", False),
    ("print_settings_id", "nocli", False),
    ("printer_settings_id", "nocli", False),
]


def run_selftest(keydata):
    failures = []
    for key, check, expected in SELFTEST_CASES:
        if check == "not_extracted":
            if key in keydata:
                failures.append(f"{key}: extracted as a live option, but it's commented out in the source")
            continue
        if key not in keydata:
            failures.append(f"{key}: not found at all")
            continue
        meta = keydata[key]
        if check == "type" and meta["type"] != expected:
            failures.append(f"{key}: type={meta['type']!r}, expected {expected!r}")
        elif check == "enum_values" and meta["enum_values"] != expected:
            failures.append(f"{key}: enum_values={meta['enum_values']!r}, expected {expected!r}")
        elif check == "enum_values_len" and len(meta["enum_values"]) != expected:
            failures.append(f"{key}: {len(meta['enum_values'])} enum values, expected {expected}")
        elif check == "enum_values_contains" and expected not in meta["enum_values"]:
            failures.append(f"{key}: enum_values does not contain {expected!r}")
        elif check == "enum_values_equals_key":
            other = keydata.get(expected)
            if not other or meta["enum_values"] != other["enum_values"]:
                failures.append(f"{key}: enum_values doesn't match {expected}'s (copied-reference resolution broken)")
        elif check == "nocli" and meta["nocli"] != expected:
            failures.append(f"{key}: nocli={meta['nocli']!r}, expected {expected!r}")

    # A nocli key must never end up in a [CLI Example] line.
    if "bbl_use_printhost" in keydata:
        lines = "".join(build_lines_uniform(["bbl_use_printhost"], [keydata["bbl_use_printhost"]]))
        if "[CLI Example]" in lines:
            failures.append("build_lines_uniform: wrote a [CLI Example] for an all-nocli single-key group (bbl_use_printhost)")
        if "Not available via CLI" not in lines:
            failures.append("build_lines_uniform: missing the 'Not available via CLI' note for bbl_use_printhost")
    if "bbl_use_printhost" in keydata and "use_relative_e_distances" in keydata:
        mixed_meta = [keydata["bbl_use_printhost"], keydata["use_relative_e_distances"]]
        lines = "".join(build_lines_mixed(["bbl_use_printhost", "use_relative_e_distances"], mixed_meta))
        if "--bbl-use-printhost=" in lines:
            failures.append("build_lines_mixed: picked a nocli key (bbl_use_printhost) as the [CLI Example] instead of skipping to a usable one")

    # process_file() must recognize its own "Not available via CLI" note as
    # generated content, or a second run duplicates it instead of replacing it.
    if "bbl_use_printhost" in keydata:
        synthetic = (
            "# Test Page\n\n"
            "## Some Heading\n\n"
            "[Mode](option_mode): `Advanced`.  \n"
            "[Variable](built_in_placeholders_variables): `bbl_use_printhost`.  \n"
            "Body text unrelated to the tag.\n"
        )
        with tempfile.TemporaryDirectory() as tmp:
            fake_root = os.path.join(tmp, "print_settings")
            os.makedirs(fake_root)
            fake_path = os.path.join(fake_root, "fake.md")
            with open(fake_path, "w", encoding="utf-8") as f:
                f.write(synthetic)
            fake_keydata = {"bbl_use_printhost": keydata["bbl_use_printhost"]}
            for _ in range(2):
                process_file(fake_path, "print_settings/fake.md", fake_keydata,
                             {"headings_scanned": 0, "no_variable_tag": 0, "unmatched_key": 0,
                              "manual_holdout": 0, "needs_manual_review": 0,
                              "already_current": 0, "refreshed": 0, "inserted": 0},
                             {"unmatched_key": [], "needs_manual_review": []}, do_write=True)
            with open(fake_path, encoding="utf-8") as f:
                result = f.read()
        if result.count("Not available via CLI") != 1:
            failures.append(f"process_file: idempotency broken — 'Not available via CLI' appears "
                             f"{result.count('Not available via CLI')} times after running twice, expected 1")

    return failures


def load_overrides(path):
    if not os.path.exists(path):
        return {}
    with open(path, encoding="utf-8") as f:
        overrides = json.load(f)
    for key, meta in overrides.items():
        meta.setdefault("type_label", TYPE_MAP.get(meta.get("type"), meta.get("type")))
        meta.setdefault("enum_values", [])
        meta.setdefault("default", None)
        meta.setdefault("nocli", False)
    return overrides


def strip_list(type_label):
    return (type_label[:-5], True) if type_label.endswith(" list") else (type_label, False)


def quote_if_needed(value):
    return f'"{value}"' if " " in value else value


def cli_example_value(meta):
    base, _ = strip_list(meta["type_label"])
    if base == "Choice":
        return quote_if_needed(meta["enum_values"][0]) if meta["enum_values"] else "value"
    if base == "Boolean":
        return "1"
    if base == "Integer":
        return "1"
    if base == "Float":
        return "1"
    if base in ("Percentage", "Float or Percentage"):
        return "20%"
    if base == "Text":
        d = meta.get("default")
        if d and " " not in d and '"' not in d and d.strip():
            return d
        return "value"
    if base == "Point":
        return "100,100"
    return "value"


def type_anchor(type_label):
    base, is_list = strip_list(type_label)
    return LIST_ANCHOR if is_list else TYPE_ANCHOR.get(base, "choice")


# Must match process_file()'s block-detector verbatim: unlike every other
# generated line these don't start with a [Tag], so a re-run needs to
# recognize them by exact text to replace rather than duplicate them.
NOCLI_ALL_NOTE = "Not available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  \n"
NOCLI_ALL_NOTE_MIXED = "None of the variables above are available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  \n"


def build_cli_example_lines(keys, metas):
    # nocli is independent of type, so pick a non-nocli key for the example
    # (never claim a nocli key works via CLI); omit the line if none exist.
    non_nocli = [(k, m) for k, m in zip(keys, metas) if not m["nocli"]]
    if not non_nocli:
        return [NOCLI_ALL_NOTE]

    example_key, example_meta = non_nocli[0]
    val = cli_example_value(example_meta)
    flag = f"--{example_key.replace('_', '-')}={val}"
    excluded = [k for k, m in zip(keys, metas) if m["nocli"]]
    if len(keys) == 1:
        suffix = ""
    elif excluded:
        suffix = f" ({', '.join(f'`{k}`' for k in excluded)} {'is' if len(excluded) == 1 else 'are'} not available via CLI; same pattern for the rest)"
    else:
        suffix = " (same pattern for the other variables above)"
    return [f"[CLI Example](cli_mode#setting-overrides): `{flag}`{suffix}.  \n"]


def build_lines_uniform(keys, metas):
    type_label = metas[0]["type_label"]
    base, _ = strip_list(type_label)
    lines = [f"[Type](option_type#{type_anchor(type_label)}): `{type_label}`.  \n"]
    if base == "Choice":
        # Only show [Options] when every key's enum list is identical;
        # otherwise there's no single list that covers the whole group.
        enum_lists = [tuple(m["enum_values"]) for m in metas]
        if all(enum_lists) and len(set(enum_lists)) == 1:
            lines.append(f"[Options](option_type#choice): `{', '.join(metas[0]['enum_values'])}`.  \n")
    lines.extend(build_cli_example_lines(keys, metas))
    return lines


def build_lines_mixed(keys, metas):
    def describe(k, m):
        base, _ = strip_list(m["type_label"])
        suffix = ", not available via CLI" if m["nocli"] else ""
        if base == "Choice" and m["enum_values"]:
            return f"`{k}` ({m['type_label']}: {', '.join(m['enum_values'])}{suffix})"
        return f"`{k}` ({m['type_label']}{suffix})"

    parts = ", ".join(describe(k, m) for k, m in zip(keys, metas))
    lines = [f"[Type](option_type): {parts}.  \n"]

    non_nocli = [(k, m) for k, m in zip(keys, metas) if not m["nocli"]]
    if not non_nocli:
        lines.append(NOCLI_ALL_NOTE_MIXED)
        return lines

    example_key, example_meta = non_nocli[0]
    val = cli_example_value(example_meta)
    flag = f"--{example_key.replace('_', '-')}={val}"
    lines.append(f"[CLI Example](cli_mode#setting-overrides): `{flag}` (`{example_key}` shown; other variables above follow their own type).  \n")
    return lines


def process_file(path, rel_path, keydata, stats, review, do_write):
    with open(path, encoding="utf-8") as f:
        lines = f.readlines()

    heads = [(i, m.group(2).strip()) for i, l in enumerate(lines) if (m := HEADING_RE.match(l))]
    holdouts = MANUAL_HOLDOUTS.get(rel_path, set())

    new_lines = list(lines)
    offset = 0
    changed = False

    for idx, (i, text) in enumerate(heads):
        stats["headings_scanned"] += 1
        end = heads[idx + 1][0] if idx + 1 < len(heads) else len(lines)

        j = i + 1
        if j < end and lines[j].strip() == "":
            j += 1
        block_start = j
        block_end = j
        has_variable_line = False
        generated_start = None  # first pre-existing [Type]/[Options]/[CLI Example] line, if any
        while block_end < end:
            stripped = lines[block_end].strip()
            is_generated_tag_line = stripped.startswith("[Type]") or stripped.startswith("[Options]") or stripped.startswith("[CLI Example]")
            is_generated_nocli_note = lines[block_end] in (NOCLI_ALL_NOTE, NOCLI_ALL_NOTE_MIXED)
            if is_generated_tag_line or is_generated_nocli_note:
                if generated_start is None:
                    generated_start = block_end
                block_end += 1
                continue
            if stripped.startswith("[Mode]") or stripped.startswith("[Modes]") or "[Variable" in stripped:
                if "[Variable" in stripped:
                    has_variable_line = True
                block_end += 1
                continue
            break

        if not has_variable_line:
            stats["no_variable_tag"] += 1
            continue
        if text in holdouts:
            stats["manual_holdout"] += 1
            continue

        keys_in_order = []
        for k in range(block_start, block_end):
            stripped = lines[k].strip()
            if "[Variable" not in stripped:
                continue
            marker = "built_in_placeholders_variables):"
            pos = stripped.find(marker)
            remainder = stripped[pos + len(marker):] if pos != -1 else stripped
            for m in KEY_IN_BACKTICKS_RE.finditer(remainder):
                if m.group(1) not in keys_in_order:
                    keys_in_order.append(m.group(1))

        if not keys_in_order:
            stats["no_variable_tag"] += 1
            continue

        if any(k not in keydata for k in keys_in_order):
            missing = [k for k in keys_in_order if k not in keydata]
            review["unmatched_key"].append((rel_path, text, missing))
            stats["unmatched_key"] += 1
            continue

        metas = [keydata[k] for k in keys_in_order]
        types = set(m["type_label"] for m in metas)

        if len(types) == 1:
            insert_lines = build_lines_uniform(keys_in_order, metas)
        elif len(keys_in_order) <= MAX_MIXED_TYPE_KEYS:
            insert_lines = build_lines_mixed(keys_in_order, metas)
        else:
            review["needs_manual_review"].append((rel_path, text, keys_in_order, sorted(types)))
            stats["needs_manual_review"] += 1
            continue

        existing_gen_start = (generated_start + offset) if generated_start is not None else None
        existing_gen_end = block_end + offset
        insert_at = existing_gen_start if existing_gen_start is not None else (block_end + offset)

        if existing_gen_start is not None:
            old_block = new_lines[existing_gen_start:existing_gen_end]
            if old_block == insert_lines:
                stats["already_current"] += 1
                continue
            new_lines[existing_gen_start:existing_gen_end] = insert_lines
            offset += len(insert_lines) - (existing_gen_end - existing_gen_start)
            stats["refreshed"] += 1
        else:
            new_lines[insert_at:insert_at] = insert_lines
            offset += len(insert_lines)
            stats["inserted"] += 1
        changed = True

    if changed and do_write:
        with open(path, "w", encoding="utf-8") as f:
            f.writelines(new_lines)

    return changed


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--source", default=DEFAULT_SOURCE, help="URL or local path to PrintConfig.cpp")
    parser.add_argument("--overrides", default=DEFAULT_OVERRIDES, help="JSON file of manual key metadata overrides")
    parser.add_argument("--wiki-root", default=os.path.dirname(os.path.abspath(__file__)), help="wiki repo root")
    parser.add_argument("--update", action="store_true", help="write the changes to the wiki pages")
    parser.add_argument("--check", action="store_true", help="exit 1 if any page is stale or references an unknown key (for CI)")
    parser.add_argument("--selftest", action="store_true", help="verify extraction against known-good values, then exit (no wiki changes)")
    parser.add_argument("--coverage", action="store_true", help="also report keys with no [Variable] tag anywhere on the wiki")
    args = parser.parse_args()

    print(f"Reading option definitions from {args.source} ...", file=sys.stderr)
    source_text = get_source(args.source)
    keydata = extract_key_metadata(source_text)

    overrides_path = args.overrides if os.path.isabs(args.overrides) else os.path.join(args.wiki_root, args.overrides)
    overrides = load_overrides(overrides_path)
    keydata.update(overrides)
    print(f"{len(keydata)} option keys known ({len(overrides)} from overrides).", file=sys.stderr)

    if args.selftest:
        failures = run_selftest(keydata)
        if failures:
            print(f"\nSELFTEST FAILED ({len(failures)}):", file=sys.stderr)
            for f in failures:
                print(f"  {f}", file=sys.stderr)
            sys.exit(1)
        print(f"selftest passed ({len(SELFTEST_CASES)} cases).", file=sys.stderr)
        return

    empty_enums = find_empty_enums(keydata)
    if empty_enums:
        print(f"\nWARNING: {len(empty_enums)} Choice-type key(s) resolved to zero enum values — "
              f"PrintConfig.cpp is likely using a new enum-definition style extract_key_metadata() "
              f"doesn't handle yet. These will get a generic 'value' CLI example instead of a real one:",
              file=sys.stderr)
        for k in empty_enums:
            print(f"  {k}", file=sys.stderr)

    files = []
    for d in SETTINGS_DIRS:
        files += glob.glob(os.path.join(args.wiki_root, d, "**", "*.md"), recursive=True)

    if args.coverage:
        undocumented = find_undocumented_keys(keydata, files)
        print(f"\n{len(undocumented)} key(s) have no [Variable] tag anywhere on the wiki:", file=sys.stderr)
        for k in undocumented:
            print(f"  {k}", file=sys.stderr)

    stats = {
        "headings_scanned": 0, "no_variable_tag": 0, "unmatched_key": 0,
        "manual_holdout": 0, "needs_manual_review": 0,
        "already_current": 0, "refreshed": 0, "inserted": 0,
    }
    review = {"unmatched_key": [], "needs_manual_review": []}
    any_changed = False

    for path in sorted(files):
        rel_path = os.path.relpath(path, args.wiki_root)
        changed = process_file(path, rel_path, keydata, stats, review, do_write=args.update)
        any_changed = any_changed or changed

    print(json.dumps(stats, indent=2))

    if review["unmatched_key"]:
        print(f"\n=== keys not found in source or overrides ({len(review['unmatched_key'])}) ===", file=sys.stderr)
        for rel_path, heading, missing in review["unmatched_key"]:
            print(f"  {rel_path} :: {heading} :: {missing}  (add to {args.overrides} if it's loop-generated)", file=sys.stderr)

    if review["needs_manual_review"]:
        print(f"\n=== headings too large/mixed for auto breakdown ({len(review['needs_manual_review'])}) ===", file=sys.stderr)
        for rel_path, heading, keys, types in review["needs_manual_review"]:
            print(f"  {rel_path} :: {heading} :: {len(keys)} keys, types={types}", file=sys.stderr)

    if args.check:
        # needs_manual_review is structural, not staleness, so it doesn't fail CI on its own.
        sys.exit(1 if (stats["refreshed"] or stats["inserted"] or stats["unmatched_key"]) else 0)
    if not args.update and (stats["refreshed"] or stats["inserted"]):
        print(f"\n{stats['inserted']} to insert, {stats['refreshed']} to refresh. Re-run with --update to write.", file=sys.stderr)


if __name__ == "__main__":
    main()
