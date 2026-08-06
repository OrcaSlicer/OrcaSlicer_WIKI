#!/usr/bin/env python3
"""
Auto-generate mkdocs.yml navigation from folder structure.
Fully dynamic - scans all folders and markdown files automatically.

Entries already listed in mkdocs.yml keep the position they have there; only
new files/folders are placed using the sort rules below. Pass --reorder to
ignore the existing nav and sort everything from scratch.

Usage:
    python3 generate_nav.py              # Preview nav structure
    python3 generate_nav.py --update     # Update mkdocs.yml directly
    python3 generate_nav.py --reorder    # Re-sort everything, ignoring current nav
"""

import re
from pathlib import Path
from typing import Optional


# Folders to exclude from navigation (not documentation content)
EXCLUDED_FOLDERS = {
    'images', 'docs', 'wiki', 'html', 'custom_theme',
    '.git', '.github', '__pycache__', 'node_modules',
    'venv', '.venv', 'infill-analysis', 'assets', 'static',
}

# Optional: Override display names for specific folders
# If not specified, names are auto-generated from folder names
# Format: "folder_name": "Display Name"
DISPLAY_NAME_OVERRIDES = {
    # Examples:
    # "print_settings": "Process Settings",
    # "developer_reference": "Developer Section",
}


def folder_to_title(name: str) -> str:
    """Convert a folder name to a readable title."""
    # Replace separators with spaces
    title = name.replace('_', ' ').replace('-', ' ')

    # Title case, preserving certain patterns
    words = title.split()
    result = []
    for word in words:
        lower = word.lower()
        if lower == 'gcode':
            result.append('G-Code')
        elif lower in ['api', 'stl', 'vfa', 'xy', 'semm']:
            result.append(word.upper())
        elif lower in ['and', 'or', 'the', 'in', 'on', 'at', 'to', 'for', 'of']:
            result.append(lower if result else word.title())
        else:
            result.append(word.title())
    return ' '.join(result)


def get_display_name(folder_name: str) -> str:
    """Get display name for a folder."""
    if folder_name in DISPLAY_NAME_OVERRIDES:
        return DISPLAY_NAME_OVERRIDES[folder_name]
    return folder_to_title(folder_name)


def extract_title_from_md(filepath: Path) -> Optional[str]:
    """Extract the first H1 heading from a markdown file."""
    try:
        content = filepath.read_text(encoding='utf-8')
        match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
        if match:
            return match.group(1).strip()
    except (UnicodeDecodeError, IOError, PermissionError):
        # Silently skip files that can't be read
        pass
    return None


def filename_to_title(filename: str) -> str:
    """Convert a filename to a readable title."""
    name = filename

    # Remove common prefixes (settings files often have category prefixes)
    # This regex removes patterns like "printer_basic_information_", "quality_settings_", etc.
    name = re.sub(r'^[a-z]+_(?:[a-z]+_)*(?=\w)', '', name)

    return folder_to_title(name)


def get_file_title(filepath: Path) -> str:
    """Get the display title for a markdown file."""
    # Try to extract from file content first (most accurate)
    extracted = extract_title_from_md(filepath)
    if extracted:
        return extracted
    # Fall back to filename
    return filename_to_title(filepath.stem)


# Release-note files (e.g. release_2_4_0, release_2_4_0_beta) are listed newest
# first: higher version on top, and for the same version stable > rc > beta > alpha.
RELEASE_RE = re.compile(r'release_(\d+)_(\d+)_(\d+)(?:_([a-z]+))?$')
RELEASE_STAGE_ORDER = {None: 0, 'rc': 1, 'beta': 2, 'alpha': 3}  # stable (no suffix) first
PLUGIN_DEVELOPMENT_ORDER = {
    'plugin_system': 0,
    'plugin_development': 1,
    'api_reference': 2,
    'plugin_audit_hook': 3,
}
PLUGIN_API_REFERENCE_ORDER = {
    'registry': 0,
    'host': 1,
    'host_ui': 2,
    'script': 3,
    'gcode': 4,
    'printer_agent': 5,
}
PLUGINS_ORDER = {
    'getting_started': 0,
    'local_plugins': 1,
    'cloud_plugins': 2,
    'plugin_types': 3,
    'managing_plugins': 4,
}
TOP_LEVEL_FOLDER_ORDER = {
    'user_profiles': 10,
    'plugins': 11,
    'developer_reference': 12,
}


def get_sort_key(path: Path) -> tuple:
    """Generate a sort key for ordering files/folders."""
    name = path.name.lower() if path.is_dir() else path.stem.lower()

    if (
        path.parent.name == 'plugin_development'
        and path.parent.parent.name == 'developer_reference'
        and name in PLUGIN_DEVELOPMENT_ORDER
    ):
        return (-1, PLUGIN_DEVELOPMENT_ORDER[name], name)

    if (
        path.is_file()
        and path.parent.name == 'api_reference'
        and path.parent.parent.name == 'plugin_development'
        and path.parent.parent.parent.name == 'developer_reference'
        and name in PLUGIN_API_REFERENCE_ORDER
    ):
        return (-1, PLUGIN_API_REFERENCE_ORDER[name], name)

    if path.is_file() and path.parent.name == 'plugins' and name in PLUGINS_ORDER:
        return (-1, PLUGINS_ORDER[name], name)

    if path.is_dir() and path.parent == Path(__file__).parent and name in TOP_LEVEL_FOLDER_ORDER:
        return (TOP_LEVEL_FOLDER_ORDER[name], name)

    # Release notes get their own priority bucket (distinct from the default 5)
    # so this negative-number key is only ever compared release-to-release.
    release_match = RELEASE_RE.match(name)
    if release_match and path.is_file():
        major, minor, patch = map(int, release_match.group(1, 2, 3))
        stage_order = RELEASE_STAGE_ORDER.get(release_match.group(4), 9)
        return (7, (-major, -minor, -patch, stage_order))

    # Priority ordering: basic/intro first, advanced/misc last
    if any(x in name for x in ['index', 'home', 'intro', 'overview', 'guide']):
        return (0, name)
    if 'basic' in name:
        return (1, name)
    if 'advanced' in name:
        return (8, name)
    if any(x in name for x in ['other', 'misc', 'dependencies']):
        return (9, name)
    # Developer reference goes to the bottom
    if name == 'developer_reference':
        return (10, name)

    return (5, name)  # Default: middle priority, alphabetical


def _collect_nav_paths(value, out: list) -> None:
    """Collect every document path reachable from a nav value."""
    if isinstance(value, str):
        out.append(value)
    elif isinstance(value, list):
        for entry in value:
            _collect_nav_paths(entry, out)
    elif isinstance(value, dict):
        for sub in value.values():
            _collect_nav_paths(sub, out)


def _common_dir(paths: list) -> str:
    """Longest shared directory prefix of a set of document paths."""
    if not paths:
        return ''
    common = paths[0].split('/')[:-1]
    for path in paths[1:]:
        parts = path.split('/')[:-1]
        i = 0
        while i < len(common) and i < len(parts) and common[i] == parts[i]:
            i += 1
        common = common[:i]
    return '/'.join(common)


def _index_nav(entries: list, order: dict) -> None:
    """Record the position of each file/folder within its own nav list.

    Folders are identified by the shared directory prefix of the pages nested
    under a section, so a section keeps its slot even if it was renamed.
    """
    if not isinstance(entries, list):
        return

    for position, entry in enumerate(entries):
        if isinstance(entry, str):
            value = entry
        elif isinstance(entry, dict) and len(entry) == 1:
            value = next(iter(entry.values()))
        else:
            continue

        if isinstance(value, str):
            order.setdefault(value, position)
        elif isinstance(value, list):
            nested: list = []
            _collect_nav_paths(value, nested)
            folder = _common_dir(nested)
            if folder:
                order.setdefault(folder, position)
            _index_nav(value, order)


def read_existing_order(mkdocs_path: Path) -> dict:
    """Map each path currently in mkdocs.yml's nav to its position in its list.

    Returns an empty dict if the nav can't be read, which falls back to a
    fully generated ordering.
    """
    try:
        import yaml
    except ImportError:
        return {}

    try:
        content = mkdocs_path.read_text(encoding='utf-8')
    except (UnicodeDecodeError, IOError, PermissionError):
        return {}

    match = re.search(r'^nav:\s*\n((?:[ \t-].*\n)*)', content, re.MULTILINE)
    if not match:
        return {}

    try:
        nav = yaml.safe_load('nav:\n' + match.group(1))
    except yaml.YAMLError:
        return {}

    order: dict = {}
    _index_nav((nav or {}).get('nav') or [], order)
    return order


def _order_key(path: Path, base_path: Path) -> str:
    return path.relative_to(base_path).as_posix()


def keep_existing_places(sorted_items: list, base_path: Path, existing_order: dict) -> list:
    """Reorder siblings so entries already in mkdocs.yml stay where they are.

    Items known to the existing nav are restored to their recorded order; each
    new item is slotted directly after whichever sibling precedes it in the
    freshly sorted list, so it lands next to its natural neighbour.
    """
    if not existing_order:
        return sorted_items

    known = {}
    for item in sorted_items:
        position = existing_order.get(_order_key(item, base_path))
        if position is not None:
            known[item] = position

    if not known:
        return sorted_items

    result = sorted(known, key=lambda item: known[item])

    for index, item in enumerate(sorted_items):
        if item in known:
            continue
        # Everything before `item` has already been placed in `result`.
        insert_at = 0 if index == 0 else result.index(sorted_items[index - 1]) + 1
        result.insert(insert_at, item)

    return result


def scan_folder(folder: Path, base_path: Path, existing_order: Optional[dict] = None) -> list:
    """Recursively scan a folder and build nav structure."""
    existing_order = existing_order or {}
    nav_items = []

    try:
        items = list(folder.iterdir())
    except PermissionError:
        return nav_items

    if folder.name == 'plugin_development' and folder.parent.name == 'developer_reference':
        ordered_items = keep_existing_places(
            sorted(
                [item for item in items
                 if (item.is_file() and item.suffix == '.md')
                 or (item.is_dir()
                     and not item.name.startswith('.')
                     and item.name.lower() not in EXCLUDED_FOLDERS)],
                key=get_sort_key
            ),
            base_path, existing_order
        )

        for item in ordered_items:
            if item.is_file():
                title = get_file_title(item)
                rel_path = item.relative_to(base_path)
                nav_items.append((title, str(rel_path).replace('\\', '/')))
            else:
                sub_items = scan_folder(item, base_path, existing_order)
                if sub_items:
                    folder_title = get_display_name(item.name)
                    nav_items.append((folder_title, sub_items))

        return nav_items

    # Separate and sort files and folders
    md_files = keep_existing_places(
        sorted(
            [f for f in items if f.is_file() and f.suffix == '.md'],
            key=get_sort_key
        ),
        base_path, existing_order
    )
    subfolders = keep_existing_places(
        sorted(
            [d for d in items if d.is_dir()
             and not d.name.startswith('.')
             and d.name.lower() not in EXCLUDED_FOLDERS],
            key=get_sort_key
        ),
        base_path, existing_order
    )

    # A folder-level index.md becomes the section's index page (Material's
    # navigation.indexes feature): emit it as a bare, first entry with no title
    # (represented as (None, path)) so the section header itself links to it.
    index_file = next((f for f in md_files if f.stem == 'index'), None)
    if index_file:
        md_files = [f for f in md_files if f is not index_file]
        rel_path = str(index_file.relative_to(base_path)).replace('\\', '/')
        nav_items.append((None, rel_path))

    # Process markdown files
    for md_file in md_files:
        title = get_file_title(md_file)
        rel_path = md_file.relative_to(base_path)
        nav_items.append((title, str(rel_path).replace('\\', '/')))

    # Process subfolders recursively
    for subfolder in subfolders:
        sub_items = scan_folder(subfolder, base_path, existing_order)
        if sub_items:
            folder_title = get_display_name(subfolder.name)
            nav_items.append((folder_title, sub_items))

    return nav_items


def generate_nav(base_path: Path, existing_order: Optional[dict] = None) -> list:
    """Generate the complete navigation structure by scanning all folders."""
    existing_order = existing_order or {}
    nav = []

    # Check for home.md -> becomes index.md
    if (base_path / 'home.md').exists():
        nav.append(("Home", "index.md"))

    # Scan all top-level folders that contain markdown files
    top_level_folders = keep_existing_places(
        sorted(
            [d for d in base_path.iterdir()
             if d.is_dir()
             and not d.name.startswith('.')
             and d.name.lower() not in EXCLUDED_FOLDERS
             and any(d.rglob('*.md'))],  # Only include if has .md files
            key=get_sort_key
        ),
        base_path, existing_order
    )

    # Build nav from each folder
    for folder in top_level_folders:
        items = scan_folder(folder, base_path, existing_order)
        if items:
            section_title = get_display_name(folder.name)
            nav.append((section_title, items))

    return nav


def escape_yaml_string(s: str) -> str:
    """Escape special YAML characters in a string."""
    # Characters that need quoting in YAML
    special_chars = set(':{}[],&*#?|-<>=!%@\\')
    if any(c in s for c in special_chars) or ' ' in s or s.startswith('"') or s.startswith("'"):
        # Escape quotes and backslashes, then wrap in double quotes
        escaped = s.replace('\\', '\\\\').replace('"', '\\"')
        return f'"{escaped}"'
    return s


def nav_to_yaml(nav: list, indent: int = 2) -> str:
    """Convert nav structure to YAML string."""
    lines = []
    base_indent = " " * indent

    def format_item(item, level):
        prefix = base_indent * level + "- "
        title, value = item

        # A None title marks a section index page (navigation.indexes): emit the
        # path as a bare list entry, with no "Title:" mapping key.
        if title is None:
            lines.append(f"{prefix}{escape_yaml_string(value)}")
            return

        # Escape title to handle special characters
        escaped_title = escape_yaml_string(title)

        if isinstance(value, list):
            lines.append(f"{prefix}{escaped_title}:")
            for sub_item in value:
                format_item(sub_item, level + 1)
        else:
            # Escape path value
            escaped_value = escape_yaml_string(value)
            lines.append(f"{prefix}{escaped_title}: {escaped_value}")

    for item in nav:
        format_item(item, 0)

    return '\n'.join(lines)


def update_mkdocs_yml(mkdocs_path: Path, nav_yaml: str) -> None:
    """Update the nav section in mkdocs.yml."""
    content = mkdocs_path.read_text(encoding='utf-8')

    # Find and replace the nav section
    # Match nav: followed by lines starting with - or whitespace until next top-level key or EOF
    nav_pattern = re.compile(
        r'^nav:\s*\n((?:[ \t-].*\n)*)',
        re.MULTILINE
    )

    match = nav_pattern.search(content)
    if match:
        new_content = content[:match.start()] + f"nav:\n{nav_yaml}\n" + content[match.end():]
    else:
        new_content = content.rstrip() + f"\n\nnav:\n{nav_yaml}\n"

    # Validate YAML before writing (basic check - try importing yaml if available)
    try:
        import yaml

        # First try strict safe_load; if Python tags are present, fall back to a
        # constrained loader that only permits the mermaid formatter tag.
        try:
            yaml.safe_load(new_content)
        except yaml.constructor.ConstructorError:
            class IgnoreUnknownSafeLoader(yaml.SafeLoader):
                """Safe loader that allows specific custom tags used in mkdocs.yml."""

            def _pymdown_python_name(loader, node):
                # Treat !!python/name:pymdownx.superfences.fence_code_format as its scalar value
                return loader.construct_scalar(node)

            IgnoreUnknownSafeLoader.add_constructor(
                'tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format',
                _pymdown_python_name,
            )

            yaml.load(new_content, Loader=IgnoreUnknownSafeLoader)
    except ImportError:
        # yaml module not available, skip validation
        pass
    except yaml.YAMLError as e:
        raise ValueError(f"Generated YAML is invalid: {e}") from e

    mkdocs_path.write_text(new_content, encoding='utf-8')
    print(f"✅ Updated {mkdocs_path}")


def print_nav_tree(nav: list, indent: int = 0) -> None:
    """Pretty print the navigation structure."""
    for title, value in nav:
        prefix = "  " * indent
        if isinstance(value, list):
            print(f"{prefix}📁 {title}")
            print_nav_tree(value, indent + 1)
        elif title is None:
            print(f"{prefix}📄 (index) {value}")
        else:
            print(f"{prefix}📄 {title}")


def count_items(nav: list) -> int:
    """Count total navigation items."""
    count = 0
    for _, value in nav:
        if isinstance(value, list):
            count += count_items(value)
        else:
            count += 1
    return count


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description='Generate mkdocs.yml navigation from folder structure (fully dynamic)'
    )
    parser.add_argument(
        '--update', '-u', action='store_true',
        help='Update mkdocs.yml directly (default: preview only)'
    )
    parser.add_argument(
        '--reorder', '-r', action='store_true',
        help='Sort everything from scratch instead of keeping the positions already in mkdocs.yml'
    )
    args = parser.parse_args()

    script_dir = Path(__file__).parent
    mkdocs_path = script_dir / 'mkdocs.yml'

    if not mkdocs_path.exists():
        print(f"❌ Error: {mkdocs_path} not found")
        return 1

    print(f"📂 Scanning: {script_dir}\n")
    existing_order = {} if args.reorder else read_existing_order(mkdocs_path)
    if existing_order:
        print(f"📌 Keeping the current position of {len(existing_order)} existing nav entries\n")
    nav = generate_nav(script_dir, existing_order)
    nav_yaml = nav_to_yaml(nav)

    print("📋 Navigation Structure:\n")
    print_nav_tree(nav)
    print(f"\n📊 Total pages: {count_items(nav)}")
    print(f"📁 Total sections: {len(nav) - 1}")  # -1 for home

    if args.update:
        print()
        update_mkdocs_yml(mkdocs_path, nav_yaml)
    else:
        print("\n" + "=" * 60)
        print("Generated YAML (use --update to apply):\n")
        print("nav:")
        print(nav_yaml)
        print("=" * 60)

    return 0


if __name__ == '__main__':
    exit(main())
