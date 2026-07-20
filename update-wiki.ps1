<#
.SYNOPSIS
    Runs the wiki maintenance scripts in order, in one pass.

.DESCRIPTION
    Convenience wrapper that chains the four repository maintenance steps:

      1. fix-image-links.ps1        - normalize Markdown image references for validate_images.yml
      2. sync-tab-options-to-wiki.ps1 - import/refresh the [Mode]/[Variable] option metadata from Tab.cpp
      3. generate_nav.py --update   - regenerate the nav section of mkdocs.yml (the mkdocs.yml part of build.ps1)
      4. generate_glossary.py --update - regenerate the translation table in guides/localization_glossary.md from its CSV

    Step 3 only updates mkdocs.yml; it does NOT run the full mkdocs site build. Use build.ps1 for that.

.PARAMETER WikiRoot
    Root of the wiki checkout. Defaults to the script's own directory.

.PARAMETER TabCppPath
    Passed through to sync-tab-options-to-wiki.ps1 (Tab.cpp URL or local path). Uses that script's default when omitted.

.PARAMETER PrintConfigCppPath
    Passed through to sync-tab-options-to-wiki.ps1 (PrintConfig.cpp URL or local path). Uses that script's default when omitted.

.PARAMETER DryRun
    Preview mode: image fixer and option sync run with -DryRun, and mkdocs.yml / the glossary table are previewed (not written).

.EXAMPLE
    pwsh ./update-wiki.ps1
.EXAMPLE
    pwsh ./update-wiki.ps1 -DryRun
.EXAMPLE
    pwsh ./update-wiki.ps1 -TabCppPath "N:/Repos/OrcaSlicer/src/slic3r/GUI/Tab.cpp" -PrintConfigCppPath "N:/Repos/OrcaSlicer/src/libslic3r/PrintConfig.cpp"
#>
param(
    [string]$WikiRoot = $PSScriptRoot,
    [string]$TabCppPath,
    [string]$PrintConfigCppPath,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $WikiRoot)) {
    throw "Wiki root not found: $WikiRoot"
}

$fixScript = Join-Path $WikiRoot 'fix-image-links.ps1'
$syncScript = Join-Path $WikiRoot 'sync-tab-options-to-wiki.ps1'
$navScript = Join-Path $WikiRoot 'generate_nav.py'
$glossaryScript = Join-Path $WikiRoot 'generate_glossary.py'

foreach ($required in @($fixScript, $syncScript, $navScript, $glossaryScript)) {
    if (-not (Test-Path -LiteralPath $required)) {
        throw "Required script not found: $required"
    }
}

function Write-Stage {
    param([int]$Number, [string]$Title)
    Write-Host ""
    Write-Host "==== [$Number/4] $Title ====" -ForegroundColor Cyan
}

# --- Step 1: image fixer -------------------------------------------------------
Write-Stage -Number 1 -Title 'Fixing image links (fix-image-links.ps1)'
$fixArgs = @{ WikiRoot = $WikiRoot }
if ($DryRun) { $fixArgs.DryRun = $true }
& $fixScript @fixArgs

# --- Step 2: sync tab options --------------------------------------------------
Write-Stage -Number 2 -Title 'Syncing Tab.cpp option metadata (sync-tab-options-to-wiki.ps1)'
$syncArgs = @{ WikiRoot = $WikiRoot }
if ($DryRun) { $syncArgs.DryRun = $true }
if (-not [string]::IsNullOrWhiteSpace($TabCppPath)) { $syncArgs.TabCppPath = $TabCppPath }
if (-not [string]::IsNullOrWhiteSpace($PrintConfigCppPath)) { $syncArgs.PrintConfigCppPath = $PrintConfigCppPath }
& $syncScript @syncArgs

# --- Step 3: update mkdocs.yml nav (build.ps1's mkdocs.yml step) ---------------
Write-Stage -Number 3 -Title 'Updating mkdocs.yml navigation (generate_nav.py)'
$python = (Get-Command python -ErrorAction SilentlyContinue) ?? (Get-Command python3 -ErrorAction SilentlyContinue)
if (-not $python) {
    throw "python (or python3) is required for steps 3-4 but was not found on PATH."
}

# generate_nav.py prints Unicode (e.g. an emoji); force UTF-8 so it doesn't crash on a
# non-UTF-8 Windows console codepage (cp1252).
$env:PYTHONUTF8 = '1'
$env:PYTHONIOENCODING = 'utf-8'

if ($DryRun) {
    Write-Host "[DryRun] Previewing generated nav (mkdocs.yml not modified)." -ForegroundColor Cyan
    & $python.Source $navScript
}
else {
    & $python.Source $navScript --update
}
if ($LASTEXITCODE -ne 0) {
    throw "generate_nav.py exited with code $LASTEXITCODE."
}

# --- Step 4: regenerate the localization glossary table ------------------------
Write-Stage -Number 4 -Title 'Regenerating localization glossary (generate_glossary.py)'
if ($DryRun) {
    Write-Host "[DryRun] Previewing generated glossary table (localization_glossary.md not modified)." -ForegroundColor Cyan
    # Without --update the script exits 1 when the page is stale; that's the report, not a failure.
    & $python.Source $glossaryScript
}
else {
    & $python.Source $glossaryScript --update
    if ($LASTEXITCODE -ne 0) {
        throw "generate_glossary.py exited with code $LASTEXITCODE."
    }
}

Write-Host ""
Write-Host "All wiki maintenance steps completed." -ForegroundColor Green
if ($DryRun) {
    Write-Host "Dry run only. No files were modified." -ForegroundColor Cyan
}
