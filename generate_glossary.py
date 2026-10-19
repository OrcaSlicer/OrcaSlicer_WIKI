#!/usr/bin/env python3
"""
Maintain the translation glossary in developer_reference/localization_glossary.md.

The glossary lives in developer_reference/glossary/, one file per language, so a
translator opens only the file for their language:

    terms.tsv       English term + description. Defines which terms exist and their order.
    languages.txt   One language code per line (the folder name under `localization/i18n/`);
                    defines the column order of the table in the Markdown page.
    <lang>.tsv      English term, description and that language's rendering. The first two
                    columns repeat terms.tsv so the file is readable on its own; this script
                    keeps them in step (--sync) and refuses to pass if they drift (--check).

Tab-separated rather than comma-separated so that commas and quotes in a description or a
translation need no escaping: a cell is exactly the text between two tabs. The files open as a
spreadsheet in Excel, LibreOffice and Google Sheets, and GitHub renders them as tables. Leave a
translation empty when the catalog has no established rendering yet (the page shows an em dash).

The table in the Markdown page is generated from these files and is never edited by hand.

Usage:
    python generate_glossary.py              # print the table, report problems and a stale page
    python generate_glossary.py --sync       # copy terms.tsv into every <lang>.tsv (new terms, descriptions, order)
    python generate_glossary.py --sync --prune   # also drop rows whose term is no longer in terms.tsv
    python generate_glossary.py --update     # rewrite the table in the Markdown page
    python generate_glossary.py --check      # exit 1 on a problem or a stale page (for CI)

Add a term: add a row to terms.tsv, run --sync, fill the language files, run --update.
Add a language: add its code to languages.txt, run --sync, fill the new file, run --update.
"""

import argparse
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).parent
DATA_DIR = REPO_ROOT / "developer_reference" / "glossary"
TERMS_PATH = DATA_DIR / "terms.tsv"
LANGUAGES_PATH = DATA_DIR / "languages.txt"
MD_PATH = REPO_ROOT / "developer_reference" / "localization_glossary.md"

# The table is the first block of `|` lines after this heading.
SECTION_HEADING = "## Translation table glossary"

# Empty cell — a language whose catalog has no translation for the term.
MISSING = "—"

BOM = "﻿"
NEWLINE = "\r\n"


def read_rows(path: Path, width: int, problems: list[str]) -> list[list[str]]:
    """Return the data rows of a TSV (header dropped), each padded to `width` cells."""
    lines = [l for l in path.read_text(encoding="utf-8-sig").splitlines() if l.strip()]
    rows = []
    for number, line in enumerate(lines[1:], start=2):
        cells = line.split("\t")
        if len(cells) > width:
            problems.append(f"{path.name} line {number}: {len(cells)} cells, expected {width}")
            cells = cells[:width]
        rows.append(cells + [""] * (width - len(cells)))
    return rows


def write_tsv(path: Path, header: list[str], rows: list[list[str]]) -> None:
    text = NEWLINE.join("\t".join(row) for row in [header] + rows) + NEWLINE
    path.write_bytes((BOM + text).encode("utf-8"))


def read_languages() -> list[str]:
    if not LANGUAGES_PATH.exists():
        sys.exit(f"{LANGUAGES_PATH} not found")
    langs = [l.strip() for l in LANGUAGES_PATH.read_text(encoding="utf-8-sig").splitlines() if l.strip()]
    if len(set(langs)) != len(langs):
        sys.exit(f"{LANGUAGES_PATH.name} lists a language twice")
    return langs


def load(problems: list[str]) -> tuple[list[list[str]], list[str], dict[str, dict[str, list[str]]]]:
    """Return (terms, languages, rows) where rows[lang][english] = [english, description, translation]."""
    languages = read_languages()
    if not TERMS_PATH.exists():
        sys.exit(f"{TERMS_PATH} not found")
    terms = read_rows(TERMS_PATH, 2, problems)
    seen = set()
    for english, _ in terms:
        if not english.strip():
            problems.append(f"{TERMS_PATH.name}: a row has no English term")
        elif english in seen:
            problems.append(f"{TERMS_PATH.name}: duplicate term '{english}'")
        seen.add(english)

    rows: dict[str, dict[str, list[str]]] = {}
    for lang in languages:
        path = DATA_DIR / f"{lang}.tsv"
        if not path.exists():
            problems.append(f"{lang}.tsv is missing (run --sync)")
            continue
        rows[lang] = {}
        for row in read_rows(path, 3, problems):
            if row[0] in rows[lang]:
                problems.append(f"{path.name}: duplicate term '{row[0]}'")
            rows[lang][row[0]] = row
    listed = {f"{l}.tsv" for l in languages} | {TERMS_PATH.name, LANGUAGES_PATH.name}
    for path in sorted(DATA_DIR.glob("*.tsv")):
        if path.name not in listed:
            problems.append(f"{path.name} is not listed in {LANGUAGES_PATH.name}")
    return terms, languages, rows


def check_consistency(terms, languages, rows, problems: list[str]) -> None:
    """Every language file must carry exactly the terms and descriptions of terms.tsv, in order."""
    for lang in languages:
        if lang not in rows:
            continue
        name = f"{lang}.tsv"
        header = (DATA_DIR / name).read_text(encoding="utf-8-sig").splitlines()[0].split("\t")
        if header != ["English", "Description", lang]:
            problems.append(f"{name}: header is {header}, expected ['English', 'Description', '{lang}']")
        wanted = [english for english, _ in terms]
        have = list(rows[lang])
        for english in wanted:
            if english not in rows[lang]:
                problems.append(f"{name}: missing term '{english}' (run --sync)")
        for english in have:
            if english not in wanted:
                problems.append(f"{name}: '{english}' is not in terms.tsv (rename it there, or run --sync --prune)")
        for english, description in terms:
            row = rows[lang].get(english)
            if row and row[1] != description:
                problems.append(f"{name}: description of '{english}' differs from terms.tsv (run --sync)")
        if [e for e in have if e in wanted] != [e for e in wanted if e in rows[lang]]:
            problems.append(f"{name}: rows are not in the order of terms.tsv (run --sync)")


def sync(terms, languages, rows, prune: bool) -> int:
    """Rewrite every <lang>.tsv from terms.tsv, keeping the translations already there."""
    changed = 0
    for lang in languages:
        existing = rows.get(lang, {})
        new_rows = [[english, description, existing.get(english, ["", "", ""])[2]] for english, description in terms]
        extra = [e for e in existing if e not in {t[0] for t in terms}]
        if extra and not prune:
            print(f"{lang}.tsv has {len(extra)} row(s) whose term is not in terms.tsv: " + ", ".join(extra),
                  file=sys.stderr)
            print("  rename them in terms.tsv, or pass --prune to drop them", file=sys.stderr)
            return 1
        path = DATA_DIR / f"{lang}.tsv"
        header = ["English", "Description", lang]
        before = path.read_bytes() if path.exists() else b""
        write_tsv(path, header, new_rows)
        if path.read_bytes() != before:
            changed += 1
            print(f"{path.name}: synced")
    print(f"{changed} file(s) changed")
    return 0


def cell(text: str) -> str:
    """Make a value safe to drop into a Markdown table cell."""
    return " ".join(text.split()).replace("|", r"\|") or MISSING


def build_table(terms, languages, rows) -> list[str]:
    header = ["English", "Description"] + languages
    lines = ["| " + " | ".join(header) + " |"]
    lines.append("| " + " | ".join(["---"] * len(header)) + " |")
    for english, description in terms:
        # The English term is bold; the rest is plain text.
        cells = [f"**{cell(english)}**", cell(description)]
        cells += [cell(rows.get(lang, {}).get(english, ["", "", ""])[2]) for lang in languages]
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
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--sync", action="store_true", help="copy terms.tsv into every language file")
    parser.add_argument("--prune", action="store_true", help="with --sync, drop rows no longer in terms.tsv")
    parser.add_argument("--update", action="store_true", help="rewrite the Markdown page")
    parser.add_argument("--check", action="store_true", help="exit 1 on a problem or a stale page")
    args = parser.parse_args()

    problems: list[str] = []
    terms, languages, rows = load(problems)

    if args.sync:
        if any(p for p in problems if "cells, expected" in p or "duplicate" in p or "no English term" in p):
            print("\n".join(problems), file=sys.stderr)
            return 1
        status = sync(terms, languages, rows, args.prune)
        if status:
            return status
        problems = []
        terms, languages, rows = load(problems)

    check_consistency(terms, languages, rows, problems)
    table = build_table(terms, languages, rows)

    md_lines = MD_PATH.read_text(encoding="utf-8").splitlines()
    new_lines = splice(md_lines, table)
    up_to_date = new_lines == md_lines

    if problems:
        print("\n".join(problems), file=sys.stderr)
        if args.update:
            print("\nFix the problems above (python generate_glossary.py --sync) before --update.", file=sys.stderr)
        if args.update or args.check:
            return 1

    if args.update:
        if up_to_date:
            print(f"{MD_PATH.name} already up to date")
            return 0
        MD_PATH.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
        print(f"{MD_PATH.name} updated: {len(terms)} terms, {len(languages)} languages")
        return 0

    if args.sync and not problems:
        if not up_to_date:
            print(f"Run: python {Path(__file__).name} --update")
        return 0

    if not args.check:
        print("\n".join(table))
    if up_to_date and not problems:
        return 0
    if not up_to_date:
        print(f"\n{MD_PATH.name} is out of date — run: python {Path(__file__).name} --update", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
