#!/bin/bash

# Build script for OrcaSlicer WIKI using mkdocs
# Outputs HTML to the wiki/ folder

set -e  # Exit on error

# Parse command-line arguments
DOWNLOAD_SVG=false
for arg in "$@"; do
  case $arg in
    --download-svg|-d)
      DOWNLOAD_SVG=true
      shift
      ;;
    *)
      # Unknown option
      ;;
  esac
done

# Check for required dependencies
command -v mkdocs >/dev/null 2>&1 || { echo "Error: mkdocs is required but not installed."; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "Error: python3 is required but not installed."; exit 1; }

python3 generate_nav.py --update

echo "Building documentation with mkdocs..."

# Clean previous build and prepare docs directory
rm -rf wiki
mkdir -p docs

# Copy all markdown files and directories to docs, excluding wiki and docs itself
# This creates a structure mkdocs can work with
echo "Preparing documentation structure..."

# Copy all directories and markdown files, excluding wiki, docs, and .git
rsync -av \
  --exclude='wiki' \
  --exclude='docs' \
  --exclude='.git' \
  --exclude='*.sh' \
  --exclude='*.py' \
  --exclude='*.yml' \
  --exclude='*.yaml' \
  --exclude='README.md' \
  --exclude='Home.md' \
  --exclude='.gitignore' \
  --exclude='infill-analysis' \
  . docs/ 2>/dev/null || {
  # Fallback: manually copy directories and markdown files
  echo "Using fallback copy method..."
  # Copy root level markdown files, excluding Home.md and README.md
  find . -maxdepth 1 -name "*.md" ! -name "README.md" ! -name "Home.md" -exec cp {} docs/ \;
  # Copy all directories with markdown files
  [ -d "images" ] && cp -r images docs/ 2>/dev/null || true
  [ -d "calibration" ] && cp -r calibration docs/ 2>/dev/null || true
  [ -d "developer-reference" ] && cp -r developer-reference docs/ 2>/dev/null || true
  [ -d "general-settings" ] && cp -r general-settings docs/ 2>/dev/null || true
  [ -d "material_settings" ] && cp -r material_settings docs/ 2>/dev/null || true
  [ -d "print_prepare" ] && cp -r print_prepare docs/ 2>/dev/null || true
  [ -d "print_settings" ] && cp -r print_settings docs/ 2>/dev/null || true
  [ -d "printer_settings" ] && cp -r printer_settings docs/ 2>/dev/null || true
}

# Copy Home.md as index.md so mkdocs generates index.html at root level
# (Home.md was excluded from rsync, so copy it directly from source)
if [ -f "Home.md" ]; then
  cp Home.md docs/index.md
fi

# Convert GitHub image URLs to relative local paths in all markdown files
echo "Converting GitHub image URLs to local paths..."

# Download SVG icons if option is enabled
if [ "$DOWNLOAD_SVG" = true ]; then
  # Create directory for OrcaSlicer main repo icons
  mkdir -p docs/images/orcaslicer-icons

  # Extract and download unique SVG icons from OrcaSlicer main repo
  echo "Downloading SVG icons from OrcaSlicer main repo..."
  grep -roh "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/[^?)]*" docs/ 2>/dev/null | \
    sort -u | while read url; do
    # Extract filename from URL
    filename=$(basename "$url")
    local_path="docs/images/orcaslicer-icons/$filename"

    # Download if not already cached
    if [ ! -f "$local_path" ]; then
      # Convert blob URL to raw URL
      raw_url=$(echo "$url" | sed 's|github.com/OrcaSlicer/OrcaSlicer/blob/main|raw.githubusercontent.com/OrcaSlicer/OrcaSlicer/main|')
      echo "  Downloading: $filename"
      curl -sL "$raw_url" -o "$local_path" 2>/dev/null || true
    fi

    # If this is a *_dark.svg icon, also fetch the light variant so theme swapping works offline
    if echo "$filename" | grep -q "_dark\\.svg"; then
      light_filename=$(echo "$filename" | sed 's/_dark\\(\\.svg.*\\)/\\1/')
      light_local_path="docs/images/orcaslicer-icons/$light_filename"

      if [ ! -f "$light_local_path" ]; then
        light_url=$(echo "$url" | sed 's/_dark\\(\\.svg.*\\)/\\1/')
        light_raw_url=$(echo "$light_url" | sed 's|github.com/OrcaSlicer/OrcaSlicer/blob/main|raw.githubusercontent.com/OrcaSlicer/OrcaSlicer/main|')
        echo "  Downloading: $light_filename"
        curl -sL "$light_raw_url" -o "$light_local_path" 2>/dev/null || true
      fi
    fi
  done
else
  echo "Skipping SVG icon download (use --download-svg or -d to enable)"
fi

find docs -name "*.md" -type f | while read md_file; do
  # Calculate relative path to images based on file depth
  depth=$(echo "$md_file" | tr -cd '/' | wc -c)
  depth=$((depth - 1))  # Subtract 1 for "docs/"

  prefix=""
  for ((i=0; i<depth; i++)); do
    prefix="../$prefix"
  done

  # Replace OrcaSlicer_WIKI GitHub URLs with relative paths
  sed -i '' "s|https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/\([^?]*\)?raw=true|${prefix}images/\1|g" "$md_file" 2>/dev/null || \
  sed -i "s|https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/\([^?]*\)?raw=true|${prefix}images/\1|g" "$md_file"

  # Replace OrcaSlicer main repo icon URLs with local paths
  sed -i '' "s|https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/\([^?]*\)?raw=true|${prefix}images/orcaslicer-icons/\1|g" "$md_file" 2>/dev/null || \
  sed -i "s|https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/\([^?]*\)?raw=true|${prefix}images/orcaslicer-icons/\1|g" "$md_file"
done

# Ensure MkDocs can find custom assets during the build
mkdir -p docs/assets/stylesheets docs/assets/javascripts
[ -f "web_extras/extra.css" ] && cp "web_extras/extra.css" docs/assets/stylesheets/extra.css
[ -f "web_extras/icon-theme.js" ] && cp "web_extras/icon-theme.js" docs/assets/javascripts/icon-theme.js
[ -f "web_extras/katex.js" ] && cp "web_extras/katex.js" docs/assets/javascripts/katex.js

# Build mkdocs and output to wiki folder
mkdocs build --site-dir wiki

# Create redirect directories for GitHub wiki-style URLs (e.g., /wiki/quality_settings_layer_height)
echo "Creating redirect directories for wiki-style URLs..."
create_redirects() {
  # Find all HTML files (except index.html) and create root-level redirects
  find wiki -name "*.html" -type f ! -name "index.html" | while read html_file; do
    # Get the relative path from wiki/
    rel_path="${html_file#wiki/}"

    # Extract the filename without .html extension
    filename=$(basename "$rel_path" .html)

    # Skip files already at root level
    dir_of_file=$(dirname "$rel_path")
    if [ "$dir_of_file" = "." ]; then
      continue
    fi

    # Create redirect directory at root level (for clean URLs without .html)
    redirect_dir="wiki/${filename}"

    # Skip if directory already exists (could be a real content directory)
    if [ -d "$redirect_dir" ]; then
      continue
    fi

    mkdir -p "$redirect_dir"
    redirect_file="${redirect_dir}/index.html"

    # Calculate relative path from redirect directory to target
    # Redirect is at wiki/filename/, target is at wiki/rel_path
    # So we need to go up one level (../) then to rel_path
    relative_url="../${rel_path}"

    # URL encode spaces in the path
    encoded_url=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "${relative_url}" 2>/dev/null || echo "${relative_url}" | sed 's/ /%20/g')

    # Create redirect HTML content
    cat > "$redirect_file" <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=${encoded_url}">
  <link rel="canonical" href="${encoded_url}">
  <script>
    (function() {
      var hash = window.location.hash || "";
      var target = "${encoded_url}" + hash;
      window.location.replace(target);
    })();
  </script>
</head>
<body>
  <p>Redirecting to <a href="${encoded_url}">${filename}</a>...</p>
</body>
</html>
EOF
  done
}

create_redirects

# Clean up docs directory after build
rm -rf docs

echo "Copying extra web assets to wiki folder..."
mkdir -p wiki/assets/stylesheets
mkdir -p wiki/assets/images
mkdir -p wiki/assets/javascripts

# Copy shared assets that complement MkDocs' static site output
if [ -f "web_extras/extra.css" ]; then
  cp "web_extras/extra.css" wiki/assets/stylesheets/extra.css
else
  echo "Warning: web_extras/extra.css not found - skipping"
fi

if [ -f "web_extras/OrcaSlicer.ico" ]; then
  cp "web_extras/OrcaSlicer.ico" wiki/assets/images/OrcaSlicer.ico
else
  echo "Warning: web_extras/OrcaSlicer.ico not found - skipping"
fi

if [ -f "web_extras/OrcaSlicer.png" ]; then
  cp "web_extras/OrcaSlicer.png" wiki/assets/images/OrcaSlicer.png
else
  echo "Warning: web_extras/OrcaSlicer.png not found - skipping"
fi

if [ -f "web_extras/icon-theme.js" ]; then
  cp "web_extras/icon-theme.js" wiki/assets/javascripts/icon-theme.js
else
  echo "Warning: web_extras/icon-theme.js not found - skipping"
fi

if [ -f "web_extras/katex.js" ]; then
  cp "web_extras/katex.js" wiki/assets/javascripts/katex.js
else
  echo "Warning: web_extras/katex.js not found - skipping"
fi

if [ -d "web_extras" ]; then
  mkdir -p wiki/web_extras
  cp -r web_extras/* wiki/web_extras/ 2>/dev/null || true
else
  echo "Warning: web_extras directory not found - skipping"
fi

echo "Build complete! HTML files are in the wiki/ folder."
