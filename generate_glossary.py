#!/usr/bin/env python3
"""
Regenerate the translation table in guides/localization_glossary.md from
guides/localization_glossary.csv.

The CSV is the source of truth: the first column is the English term, the second
is its description, and every remaining column is a language catalog (`de`, `es`,
... — the column name is the folder name under `localization/i18n/`). Add a
language by adding a column, add a term by adding a row.

Usage:
    python generate_glossary.py              # print the table, report if the page is stale
    python generate_glossary.py --update     # rewrite the table in the Markdown page
    python generate_glossary.py --check      # exit 1 if the page is stale (for CI)
"""

import argparse
import csv
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).parent
CSV_PATH = REPO_ROOT / "guides" / "localization_glossary.csv"
MD_PATH = REPO_ROOT / "guides" / "localization_glossary.md"

# The table is the first block of `|` lines after this heading.
SECTION_HEADING = "## Translation table glossary"

# Empty cell — a language whose catalog has no translation for the term.
MISSING = "—"


def read_csv() -> tuple[list[str], list[list[str]]]:
    """Return (header, rows) with every row padded to the header width."""
    with CSV_PATH.open(encoding="utf-8-sig", newline="") as f:
        rows = [r for r in csv.reader(f) if any(c.strip() for c in r)]
    if not rows:
        sys.exit(f"{CSV_PATH.name} is empty")
    header, body = rows[0], rows[1:]
    for i, row in enumerate(body, start=2):
        if len(row) > len(header):
            sys.exit(f"{CSV_PATH.name} line {i}: {len(row)} cells, header has {len(header)}")
        row += [""] * (len(header) - len(row))
    return header, body


def cell(text: str) -> str:
    """Make a value safe to drop into a Markdown table cell."""
    return " ".join(text.split()).replace("|", r"\|") or MISSING


def build_table(header: list[str], rows: list[list[str]]) -> list[str]:
    lines = ["| " + " | ".join(header) + " |"]
    lines.append("| " + " | ".join(["---"] * len(header)) + " |")
    for row in rows:
        # The English term is bold; the rest is plain text.
        cells = [f"**{cell(row[0])}**"] + [cell(c) for c in row[1:]]
        lines.append("| " + " | ".join(cells) + " |")
    return lines


def splice(md_lines: list[str], table: list[str]) -> list[str]:
    """Replace the table under SECTION_HEADING with the generated one."""
    try:
        start = md_lines.index(SECTION_HEADING)
    except ValueError:
        sys.exit(f"{MD_PATH.name}: heading '{SECTION_HEADING}' not found")
    first = next((i for i in range(start, len(md_lines)) if md_lines[i].startswith("|")), None)
    if first is None:
        sys.exit(f"{MD_PATH.name}: no table found under '{SECTION_HEADING}'")
    last = first
    while last + 1 < len(md_lines) and md_lines[last + 1].startswith("|"):
        last += 1
    return md_lines[:first] + table + md_lines[last + 1:]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--update", action="store_true", help="rewrite the Markdown page")
    parser.add_argument("--check", action="store_true", help="exit 1 if the page is stale")
    args = parser.parse_args()

    header, rows = read_csv()
    table = build_table(header, rows)

    md_lines = MD_PATH.read_text(encoding="utf-8").splitlines()
    new_lines = splice(md_lines, table)
    up_to_date = new_lines == md_lines

    if args.update:
        if up_to_date:
            print(f"{MD_PATH.name} already up to date")
            return 0
        MD_PATH.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
        print(f"{MD_PATH.name} updated: {len(rows)} terms, {len(header) - 2} languages")
        return 0

    if not args.check:
        print("\n".join(table))
    if up_to_date:
        return 0
    print(f"\n{MD_PATH.name} is out of date — run: python {Path(__file__).name} --update",
          file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
