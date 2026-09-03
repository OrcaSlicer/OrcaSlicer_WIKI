#!/usr/bin/env python3
"""
Regenerate cli/cli_actions.md, cli/cli_transform.md, and cli/cli_misc.md from
the CLIActionsConfigDef / CLITransformConfigDef / CLIMiscConfigDef option
definitions in libslic3r/PrintConfig.cpp. The script only ever derives the
flag NAME mechanically; every option's group/input/description/notes prose
comes from cli_option_overrides.json (which also holds page-level scaffolding
under "_pages" — title, intro, groups). A key with no overrides entry is
reported as a gap, not silently skipped.

Usage:
    python3 sync_cli_options_to_wiki.py              # preview only
    python3 sync_cli_options_to_wiki.py --update      # write the wiki pages
    python3 sync_cli_options_to_wiki.py --check       # exit 1 if any page is stale, or an option has no overrides entry (CI)

    # Point at a local OrcaSlicer checkout instead of fetching from GitHub:
    python3 sync_cli_options_to_wiki.py --source ../OrcaSlicer/src/libslic3r/PrintConfig.cpp --update
"""

import argparse
import json
import os
import re
import sys
import urllib.request

DEFAULT_SOURCE = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/PrintConfig.cpp"
DEFAULT_OVERRIDES = "cli_option_overrides.json"

CLASS_MARKERS = [
    ("CLIActionsConfigDef::CLIActionsConfigDef", "CLITransformConfigDef::CLITransformConfigDef", "cli_actions"),
    ("CLITransformConfigDef::CLITransformConfigDef", "CLIMiscConfigDef::CLIMiscConfigDef", "cli_transform"),
    # CLIMiscConfigDef is last, so an unbounded search would swallow the
    # unrelated placeholder-variable defs after it — including a `scale`
    # that collides with CLITransformConfigDef's real `scale` option.
    ("CLIMiscConfigDef::CLIMiscConfigDef", "const CLIActionsConfigDef", "cli_misc"),
]

ADD_RE = re.compile(r'this->add(?:_nullable)?\("([a-zA-Z0-9_]+)",\s*(co\w+)\)')
CLI_ALIAS_RE = re.compile(r'def->cli\s*=\s*"([^"]*)"')


def strip_cpp_comments(text):
    # Duplicated from sync_option_types_to_wiki.py so each script stays
    # independently runnable. Without it, commented-out actions would be
    # extracted as if live.
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


def dash(key):
    return key.replace("_", "-")


def flag_names(key, cli_alias):
    if not cli_alias:
        return [f"--{dash(key)}"]
    names = []
    for part in cli_alias.split("|"):
        names.append(f"-{part}" if len(part) == 1 else f"--{part}")
    return names


def format_flag(names):
    return " / ".join(f"`{n}`" for n in names)


def extract_options(source_text):
    stripped = strip_cpp_comments(source_text)
    results = {}
    for start_marker, end_marker, page in CLASS_MARKERS:
        start = stripped.find(start_marker)
        if start == -1:
            continue
        end = stripped.find(end_marker) if end_marker else len(stripped)
        body = stripped[start:end]
        positions = [(m.start(), m.group(1), m.group(2)) for m in ADD_RE.finditer(body)]
        for i, (pos, key, typ) in enumerate(positions):
            block_end = positions[i + 1][0] if i + 1 < len(positions) else len(body)
            block = body[pos:block_end]
            alias_m = CLI_ALIAS_RE.search(block)
            alias = alias_m.group(1) if alias_m else None
            results[key] = {
                "type": typ,
                "cli_flag": format_flag(flag_names(key, alias)),
                "page": page,
            }
    return results


def load_overrides(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


# Known-good extractions, hand-verified against the source.
SELFTEST_CASES = [
    ("help", "cli_flag", "`--help` / `-h`"),   # explicit multi-alias
    ("slice", "cli_flag", "`--slice`"),         # explicit alias, no dash-conversion needed
    ("export_3mf", "cli_flag", "`--export-3mf`"),  # default dash-conversion
    ("export_3mf", "page", "cli_actions"),
    ("scale", "page", "cli_transform"),  # the actual bug this caught
    ("arrange", "page", "cli_transform"),
    ("datadir", "page", "cli_misc"),
    ("total_count", "not_extracted", None),  # sanity: a real placeholder-variable key must NOT leak in
]


def run_selftest(source_options):
    failures = []
    for key, check, expected in SELFTEST_CASES:
        if check == "not_extracted":
            if key in source_options:
                failures.append(f"{key}: extracted as a CLI-only option, but it isn't one")
            continue
        if key not in source_options:
            failures.append(f"{key}: not found at all")
            continue
        actual = source_options[key][check]
        if actual != expected:
            failures.append(f"{key}.{check} = {actual!r}, expected {expected!r}")
    if len(source_options) != 53:
        failures.append(f"expected exactly 53 CLI-only options, found {len(source_options)}")
    return failures


def build_page(page_key, overrides, source_options):
    page_cfg = overrides["_pages"][page_key]
    keys_for_page = [k for k, v in source_options.items() if v["page"] == page_key]

    by_group = {g: [] for g in page_cfg["groups"]}
    ungrouped = []
    for key in keys_for_page:
        opt = overrides["options"].get(key)
        if not opt:
            continue  # reported separately as a gap; never silently rendered
        group = opt["group"]
        if group not in by_group:
            ungrouped.append((key, group))
            continue
        by_group[group].append(key)

    lines = [f"# {page_cfg['title']}\n\n", f"{page_cfg['intro']}\n\n"]
    if page_cfg.get("admonition"):
        lines.append(f"{page_cfg['admonition']}\n\n")
    for g in page_cfg["groups"]:
        anchor = re.sub(r'[^a-z0-9\s-]', '', g.lower())
        anchor = re.sub(r'[\s-]+', '-', anchor).strip('-')
        lines.append(f"- [{g}](#{anchor})\n")
    lines.append("\n")

    for g in page_cfg["groups"]:
        keys = by_group[g]
        if not keys:
            continue
        lines.append(f"## {g}\n\n")
        if page_cfg.get("group_intro", {}).get(g):
            lines.append(f"{page_cfg['group_intro'][g]}\n\n")
        lines.append("| Flag | Input | Description | Notes |\n")
        lines.append("| --- | --- | --- | --- |\n")
        for key in keys:
            opt = overrides["options"][key]
            flag = source_options[key]["cli_flag"]
            notes_cell = f" {opt['notes']}" if opt["notes"] else ""
            lines.append(f"| {flag} | {opt['input']} | {opt['description']} |{notes_cell} |\n")
        lines.append("\n")

    return "".join(lines).rstrip("\n") + "\n", ungrouped


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--source", default=DEFAULT_SOURCE, help="URL or local path to PrintConfig.cpp")
    parser.add_argument("--overrides", default=DEFAULT_OVERRIDES, help="JSON file of page scaffolding + per-option prose")
    parser.add_argument("--wiki-root", default=os.path.dirname(os.path.abspath(__file__)), help="wiki repo root")
    parser.add_argument("--update", action="store_true", help="write the changes to the wiki pages")
    parser.add_argument("--check", action="store_true", help="exit 1 if any page is stale or an option is missing an overrides entry (for CI)")
    parser.add_argument("--selftest", action="store_true", help="verify extraction against known-good values, then exit (no wiki changes)")
    args = parser.parse_args()

    print(f"Reading CLI option definitions from {args.source} ...", file=sys.stderr)
    source_text = get_source(args.source)
    source_options = extract_options(source_text)
    print(f"{len(source_options)} CLI-only options found in source.", file=sys.stderr)

    if args.selftest:
        failures = run_selftest(source_options)
        if failures:
            print(f"\nSELFTEST FAILED ({len(failures)}):", file=sys.stderr)
            for f in failures:
                print(f"  {f}", file=sys.stderr)
            sys.exit(1)
        print(f"selftest passed ({len(SELFTEST_CASES)} cases).", file=sys.stderr)
        return

    overrides_path = args.overrides if os.path.isabs(args.overrides) else os.path.join(args.wiki_root, args.overrides)
    overrides = load_overrides(overrides_path)

    missing_overrides = [k for k in source_options if k not in overrides["options"]]
    stale_overrides = [k for k in overrides["options"] if k not in source_options]

    stats = {"pages_current": 0, "pages_stale": 0}
    for page_key in overrides["_pages"]:
        content, ungrouped = build_page(page_key, overrides, source_options)
        if ungrouped:
            print(f"WARNING: {page_key}: option(s) with an unrecognized group, skipped: {ungrouped}", file=sys.stderr)
        path = os.path.join(args.wiki_root, "cli", f"{page_key}.md")
        current = ""
        if os.path.exists(path):
            with open(path, encoding="utf-8") as f:
                current = f.read()
        if current == content:
            stats["pages_current"] += 1
        else:
            stats["pages_stale"] += 1
            if args.update:
                with open(path, "w", encoding="utf-8") as f:
                    f.write(content)

    print(json.dumps(stats, indent=2))

    if missing_overrides:
        print(f"\n=== options in source with no overrides entry ({len(missing_overrides)}) ===", file=sys.stderr)
        for k in missing_overrides:
            print(f"  {k} ({source_options[k]['type']}, {source_options[k]['cli_flag']}) — add to {args.overrides}", file=sys.stderr)
    if stale_overrides:
        print(f"\n=== overrides entries with no matching option in source ({len(stale_overrides)}) ===", file=sys.stderr)
        for k in stale_overrides:
            print(f"  {k} — removed/renamed upstream? remove from {args.overrides} or update the key", file=sys.stderr)

    if args.check:
        sys.exit(1 if (stats["pages_stale"] or missing_overrides or stale_overrides) else 0)
    if not args.update and stats["pages_stale"]:
        print(f"\n{stats['pages_stale']} page(s) stale. Re-run with --update to write.", file=sys.stderr)


if __name__ == "__main__":
    main()
