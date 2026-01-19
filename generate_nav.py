#!/usr/bin/env python3
"""
Auto-generate mkdocs.yml navigation from folder structure.
Fully dynamic - scans all folders and markdown files automatically.

Usage:
    python3 generate_nav.py              # Preview nav structure
    python3 generate_nav.py --update     # Update mkdocs.yml directly
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
    # "developer-reference": "Developer Section",
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


def get_sort_key(path: Path) -> tuple:
    """Generate a sort key for ordering files/folders."""
    name = path.name.lower() if path.is_dir() else path.stem.lower()

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
    if name == 'developer-reference':
        return (10, name)

    return (5, name)  # Default: middle priority, alphabetical


def scan_folder(folder: Path, base_path: Path) -> list:
    """Recursively scan a folder and build nav structure."""
    nav_items = []
    
    try:
        items = list(folder.iterdir())
    except PermissionError:
        return nav_items
    
    # Separate and sort files and folders
    md_files = sorted(
        [f for f in items if f.is_file() and f.suffix == '.md'],
        key=get_sort_key
    )
    subfolders = sorted(
        [d for d in items if d.is_dir() 
         and not d.name.startswith('.') 
         and d.name.lower() not in EXCLUDED_FOLDERS],
        key=get_sort_key
    )
    
    # Process markdown files
    for md_file in md_files:
        title = get_file_title(md_file)
        rel_path = md_file.relative_to(base_path)
        nav_items.append((title, str(rel_path).replace('\\', '/')))
    
    # Process subfolders recursively
    for subfolder in subfolders:
        sub_items = scan_folder(subfolder, base_path)
        if sub_items:
            folder_title = get_display_name(subfolder.name)
            nav_items.append((folder_title, sub_items))
    
    return nav_items


def generate_nav(base_path: Path) -> list:
    """Generate the complete navigation structure by scanning all folders."""
    nav = []
    
    # Check for Home.md -> becomes index.md
    if (base_path / 'Home.md').exists():
        nav.append(("Home", "index.md"))
    
    # Scan all top-level folders that contain markdown files
    top_level_folders = sorted(
        [d for d in base_path.iterdir() 
         if d.is_dir() 
         and not d.name.startswith('.')
         and d.name.lower() not in EXCLUDED_FOLDERS
         and any(d.rglob('*.md'))],  # Only include if has .md files
        key=get_sort_key
    )
    
    # Build nav from each folder
    for folder in top_level_folders:
        items = scan_folder(folder, base_path)
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

        class _MkDocsSafeLoader(yaml.SafeLoader):
            """SafeLoader that tolerates mkdocs Python tags."""

        # Allow !!python/name:... tags used by MkDocs/pymdownx without executing code
        _MkDocsSafeLoader.add_constructor(
            'tag:yaml.org,2002:python/name',
            lambda loader, node: loader.construct_scalar(node)
        )

        yaml.load(new_content, Loader=_MkDocsSafeLoader)
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
    args = parser.parse_args()
    
    script_dir = Path(__file__).parent
    mkdocs_path = script_dir / 'mkdocs.yml'
    
    if not mkdocs_path.exists():
        print(f"❌ Error: {mkdocs_path} not found")
        return 1
    
    print(f"📂 Scanning: {script_dir}\n")
    nav = generate_nav(script_dir)
    nav_yaml = nav_to_yaml(nav)
    
    print("📋 Navigation Structure:\n")
    print_nav_tree(nav)
    print(f"\n📊 Total pages: {count_items(nav)}")
    print(f"📁 Total sections: {len(nav) - 1}")  # -1 for Home
    
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
