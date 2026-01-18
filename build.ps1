# Build script for OrcaSlicer WIKI using mkdocs
# Outputs HTML to the wiki/ folder

# Automatically runs from the script's own directory
Set-Location -Path $PSScriptRoot
Write-Host "Running build script from: $(Get-Location)`n" -ForegroundColor Cyan

$ErrorActionPreference = 'Stop'

# Parse command-line arguments
$DownloadSvg = $false
foreach ($arg in $args) {
    switch ($arg) {
        '--download-svg' { $DownloadSvg = $true }
        '-d' { $DownloadSvg = $true }
        default { }
    }
}

# Dependency checks (unchanged from previous version)
if (-not (Get-Command mkdocs -ErrorAction SilentlyContinue)) {
    Write-Error "Error: mkdocs is required but not installed."
    exit 1
}
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Error: python is required but not installed."
    exit 1
}

# Check and install mkdocs-material (the theme)
Write-Host "Checking for mkdocs-material..."
try {
    python -m pip show mkdocs-material > $null 2>&1
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "mkdocs-material is already installed."
}
catch {
    Write-Host "mkdocs-material not found. Installing..."
    python -m pip install mkdocs-material
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install mkdocs-material."
        exit 1
    }
    Write-Host "mkdocs-material installed successfully."
}

Write-Host "Checking for mkdocs-github-admonitions-plugin..."
try {
    python -m pip show mkdocs-github-admonitions-plugin > $null 2>&1
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "mkdocs-github-admonitions-plugin is already installed."
}
catch {
    Write-Host "mkdocs-github-admonitions-plugin not found. Installing..."
    python -m pip install mkdocs-github-admonitions-plugin
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install mkdocs-github-admonitions-plugin."
        exit 1
    }
    Write-Host "mkdocs-github-admonitions-plugin installed successfully."
}

python generate_nav.py --update

Write-Host "Building documentation with mkdocs..."

Remove-Item -Recurse -Force wiki -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path docs | Out-Null

Write-Host "Preparing documentation structure..."

$dirsToCopy = @('images', 'calibration', 'developer-reference', 'general-settings',
                'material_settings', 'print_prepare', 'print_settings', 'printer_settings')

foreach ($dir in $dirsToCopy) {
    if (Test-Path $dir) {
        Copy-Item -Recurse $dir docs\ -Force
    }
}

Get-ChildItem -Path . -Filter *.md -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -ne 'README.md' -and $_.Name -ne 'Home.md'
} | Copy-Item -Destination docs\ -Force

if (Test-Path Home.md) {
    Copy-Item Home.md docs\index.md
}

# Make sure MkDocs can see custom CSS/JS during the build
New-Item -ItemType Directory -Force -Path "docs/assets/stylesheets" | Out-Null
New-Item -ItemType Directory -Force -Path "docs/assets/javascripts" | Out-Null

if (Test-Path "web_extras\extra.css") {
    Copy-Item "web_extras\extra.css" "docs/assets/stylesheets/extra.css" -Force
}

if (Test-Path "web_extras\icon-theme.js") {
    Copy-Item "web_extras\icon-theme.js" "docs/assets/javascripts/icon-theme.js" -Force
}

if (Test-Path "web_extras\katex.js") {
    Copy-Item "web_extras\katex.js" "docs/assets/javascripts/katex.js" -Force
}

Write-Host "Converting GitHub image URLs to local paths..."

if ($DownloadSvg) {
    New-Item -ItemType Directory -Force -Path docs\images\orcaslicer-icons | Out-Null
    Write-Host "Downloading SVG icons from OrcaSlicer main repo..."

    $iconUrls = Select-String -Path docs\*.md -Pattern 'https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/[^?)"]*' -AllMatches |
                ForEach-Object { $_.Matches.Value } | Sort-Object -Unique

    foreach ($url in $iconUrls) {
        $filename = [System.IO.Path]::GetFileName($url)
        $localPath = "docs\images\orcaslicer-icons\$filename"
        if (-not (Test-Path $localPath)) {
            $rawUrl = $url -replace 'github.com/OrcaSlicer/OrcaSlicer/blob/main', 'raw.githubusercontent.com/OrcaSlicer/OrcaSlicer/main'
            Write-Host "Downloading: $filename"
            Invoke-WebRequest -Uri $rawUrl -OutFile $localPath -UseBasicParsing
        }

        # If a *_dark.svg is referenced, also download the non-dark variant for light mode
        if ($filename -match '_dark(\.svg.*)$') {
            $lightFile = $filename -replace '_dark(\.svg.*)$', '$1'
            $lightLocalPath = "docs\images\orcaslicer-icons\$lightFile"

            if (-not (Test-Path $lightLocalPath)) {
                $lightUrl = $url -replace '_dark(\.svg.*)$', '$1'
                $lightRawUrl = $lightUrl -replace 'github.com/OrcaSlicer/OrcaSlicer/blob/main', 'raw.githubusercontent.com/OrcaSlicer/OrcaSlicer/main'
                Write-Host "Downloading: $lightFile"
                Invoke-WebRequest -Uri $lightRawUrl -OutFile $lightLocalPath -UseBasicParsing
            }
        }
    }
} else {
    Write-Host "Skipping SVG icon download (use --download-svg or -d to enable)"
}

Get-ChildItem -Path docs -Filter *.md -Recurse | ForEach-Object {
    $mdFile = $_.FullName

    # Get full path of docs folder
    $docsFull = (Get-Item -Path docs -Force).FullName

    # Calculate relative path from docs to current file (as string)
    $relPathFromDocs = $mdFile.Substring($docsFull.Length).TrimStart('\','/')

    # Count how many directory levels deep we are (number of \ or /)
    $depth = ($relPathFromDocs -split '[\\/]').Count - 1   # -1 because file itself doesn't count as level

    $prefix = '../' * $depth

    $content = Get-Content -Path $mdFile -Raw

    # Replace GitHub wiki image URLs
    $content = $content -replace 'https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/images/([^?)"]*)\?raw=true',
                                 "${prefix}images/`$1"

    # Replace OrcaSlicer repo icon URLs
    $content = $content -replace 'https://github.com/OrcaSlicer/OrcaSlicer/blob/main/resources/images/([^?)"]*)\?raw=true',
                                 "${prefix}images/orcaslicer-icons/`$1"

    Set-Content -Path $mdFile -Value $content -NoNewline
}

mkdocs build --site-dir wiki

Write-Host "Creating redirect directories for wiki-style URLs..."
Get-ChildItem -Path wiki -Filter *.html -Recurse | Where-Object { $_.Name -ne 'index.html' } | ForEach-Object {
    $htmlFile = $_.FullName

    # Get full path of wiki folder
    $wikiFull = (Get-Item -Path wiki -Force).FullName

    # Calculate relative path from wiki/ to the current HTML file
    $relPath = $htmlFile.Substring($wikiFull.Length).TrimStart('\','/')

    # Normalize path separators to forward slashes for URLs
    $relPath = $relPath -replace '\\', '/'

    $filename = [System.IO.Path]::GetFileNameWithoutExtension($htmlFile)

    # Skip if the file is already at the root of wiki/
    if ($_.Directory.FullName -eq $wikiFull) {
        return
    }

    $redirectDir = Join-Path wiki $filename

    # Skip if a real directory already exists with this name
    if (Test-Path $redirectDir -PathType Container) {
        return
    }

    New-Item -ItemType Directory -Path $redirectDir -Force | Out-Null
    $redirectFile = Join-Path $redirectDir 'index.html'

    # Relative URL: go up one level then down to the original file
    $relativeUrl = '../' + $relPath

    # URL-encode spaces but keep forward slashes
    $encodedUrl = $relativeUrl -replace ' ', '%20'

    $redirectHtml = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=$encodedUrl">
  <link rel="canonical" href="$encodedUrl">
  <script>window.location.replace("$encodedUrl");</script>
</head>
<body>
  <p>Redirecting to <a href="$encodedUrl">$filename</a>...</p>
</body>
</html>
"@

    Set-Content -Path $redirectFile -Value $redirectHtml
}

Remove-Item -Recurse -Force docs -ErrorAction SilentlyContinue

# === COPY EXTRA WEB ASSETS TO WIKI ===
Write-Host "Copying extra web assets to wiki folder..."

# Ensure target directories exist
New-Item -ItemType Directory -Path "wiki\assets\stylesheets" -Force | Out-Null
New-Item -ItemType Directory -Path "wiki\assets\images" -Force | Out-Null
New-Item -ItemType Directory -Path "wiki\assets\javascripts" -Force | Out-Null

# Copy extra.css
if (Test-Path "web_extras\extra.css") {
    Copy-Item "web_extras\extra.css" "wiki\assets\stylesheets\extra.css" -Force
    Write-Host "Copied extra.css"
} else {
    Write-Host "Warning: web_extras\extra.css not found - skipping" -ForegroundColor Yellow
}

# Copy favicon and logo
if (Test-Path "web_extras\OrcaSlicer.ico") {
    Copy-Item "web_extras\OrcaSlicer.ico" "wiki\assets\images\OrcaSlicer.ico" -Force
    Write-Host "Copied OrcaSlicer.ico"
} else {
    Write-Host "Warning: web_extras\OrcaSlicer.ico not found - skipping" -ForegroundColor Yellow
}

if (Test-Path "web_extras\OrcaSlicer.png") {
    Copy-Item "web_extras\OrcaSlicer.png" "wiki\assets\images\OrcaSlicer.png" -Force
    Write-Host "Copied OrcaSlicer.png"
} else {
    Write-Host "Warning: web_extras\OrcaSlicer.png not found - skipping" -ForegroundColor Yellow
}

if (Test-Path "web_extras\icon-theme.js") {
    Copy-Item "web_extras\icon-theme.js" "wiki\assets\javascripts\icon-theme.js" -Force
    Write-Host "Copied icon-theme.js"
} else {
    Write-Host "Warning: web_extras\icon-theme.js not found - skipping" -ForegroundColor Yellow
}

if (Test-Path "web_extras\katex.js") {
    Copy-Item "web_extras\katex.js" "wiki\assets\javascripts\katex.js" -Force
    Write-Host "Copied katex.js"
} else {
    Write-Host "Warning: web_extras\katex.js not found - skipping" -ForegroundColor Yellow
}

if (Test-Path "web_extras") {
    New-Item -ItemType Directory -Path "wiki\web_extras" -Force | Out-Null
    Copy-Item -Path "web_extras\*" -Destination "wiki\web_extras" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Copied web_extras directory"
} else {
    Write-Host "Warning: web_extras directory not found - skipping" -ForegroundColor Yellow
}

Write-Host "`nBuild complete! HTML files are in the wiki/ folder." -ForegroundColor Green

# === PREVENT WINDOW FROM CLOSING IMMEDIATELY WHEN DOUBLE-CLICKED ===
# This only triggers in normal console windows (not in VS Code, ISE, etc.)
if ($host.Name -match 'ConsoleHost|Windows PowerShell ISE') {
    Write-Host "`nPress Enter to close this window..." -ForegroundColor Yellow
    Read-Host | Out-Null
}
