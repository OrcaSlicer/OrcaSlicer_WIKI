<#
.SYNOPSIS
    Normalizes Markdown image references so they pass .github/workflows/validate_images.yml.

.DESCRIPTION
    Scans every Markdown file under the wiki (excluding the generated wiki/ build output)
    and repairs OrcaSlicer image references, both `![alt](url)` and inline <img> tags:

      * Relative/root-absolute paths that point at a file in this repo
        (e.g. "](/images/...", "](../images/...", "](../../images/...") are rewritten to the
        canonical raw GitHub URL:
            https://github.com/OrcaSlicer/OrcaSlicer_WIKI/blob/main/<path>?raw=true
      * github.com blob/raw URLs for an OrcaSlicer repo get "?raw=true" appended when missing.
      * The alt text / alt attribute is set to the image filename without its extension
        (exactly what the validator expects).
      * For <img> tags, the alt attribute is moved before src.

    References inside fenced code blocks, external (non-OrcaSlicer) URLs, and local paths that
    do not resolve to an existing file are left untouched (the latter are reported as warnings).

.PARAMETER WikiRoot
    Root of the wiki checkout. Defaults to the script's own directory.

.PARAMETER Repo
    Repository name used when building canonical URLs from local paths. Default: OrcaSlicer_WIKI.

.PARAMETER Branch
    Branch used when building canonical URLs from local paths. Default: main.

.PARAMETER DryRun
    Report what would change without writing any files.
#>
param(
    [string]$WikiRoot = $PSScriptRoot,
    [string]$Repo = 'OrcaSlicer_WIKI',
    [string]$Branch = 'main',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$RepoOwner = 'OrcaSlicer'
$CanonicalPrefix = "https://github.com/$RepoOwner/$Repo/blob/$Branch/"
$ImageExtensions = @('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.bmp', '.apng', '.avif', '.ico')

if (-not (Test-Path -LiteralPath $WikiRoot)) {
    throw "Wiki root not found: $WikiRoot"
}
$RootFull = [System.IO.Path]::GetFullPath($WikiRoot)
if (-not $RootFull.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
    $RootFull += [System.IO.Path]::DirectorySeparatorChar
}

# Fenced code block ranges (so we never rewrite examples). Mirrors the validator's stripping.
function Get-CodeBlockRanges {
    param([string]$Text)

    $fence = ([char]0x60).ToString() * 3   # ```
    $pattern = '(?m)^[ \t]*' + $fence + '+[\s\S]*?^[ \t]*' + $fence + '+[ \t]*$'
    $ranges = New-Object System.Collections.Generic.List[object]
    foreach ($m in [regex]::Matches($Text, $pattern)) {
        $ranges.Add([PSCustomObject]@{ Start = $m.Index; End = $m.Index + $m.Length })
    }
    return $ranges
}

function Test-IndexInRanges {
    param([System.Collections.Generic.List[object]]$Ranges, [int]$Index)

    foreach ($r in $Ranges) {
        if ($Index -ge $r.Start -and $Index -lt $r.End) {
            return $true
        }
    }
    return $false
}

function Get-StemFromPath {
    param([string]$PathOrUrl)

    $noQuery = ($PathOrUrl -split '\?', 2)[0]
    $noFragment = ($noQuery -split '#', 2)[0]
    $leaf = ($noFragment -replace '\\', '/').TrimEnd('/').Split('/')[-1]
    return [System.IO.Path]::GetFileNameWithoutExtension($leaf)
}

# Map a local (non-URL) image link to a repo-relative path if it lands inside the wiki root.
function Get-RepoRelativePath {
    param([string]$LinkPath, [string]$MarkdownDir)

    $clean = $LinkPath.Trim()
    $clean = ($clean -split '[?#]', 2)[0]        # drop any query/fragment
    $clean = $clean -replace '^\./', ''
    if ([string]::IsNullOrWhiteSpace($clean)) {
        return $null
    }

    if ($clean.StartsWith('/')) {
        $candidate = Join-Path $WikiRoot ($clean.TrimStart('/'))
    }
    else {
        $candidate = Join-Path $MarkdownDir $clean
    }

    try {
        $full = [System.IO.Path]::GetFullPath($candidate)
    }
    catch {
        return $null
    }

    if (-not $full.StartsWith($RootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }

    $rel = $full.Substring($RootFull.Length) -replace '\\', '/'
    return $rel
}

# Ensure an OrcaSlicer github.com blob/raw URL carries ?raw=true.
function Repair-OrcaGithubUrl {
    param([string]$Url)

    if ($Url -notmatch '^https://github\.com/OrcaSlicer/[^/]+/(blob|raw)/') {
        return $Url    # raw.githubusercontent.com needs no query; leave as-is
    }

    $parts = $Url -split '\?', 2
    $base = $parts[0]
    if ($parts.Count -eq 1) {
        return "$base`?raw=true"
    }

    $query = $parts[1]
    $keep = @($query -split '&' | Where-Object { $_ -and ($_ -notmatch '^raw=') })
    $keep += 'raw=true'
    return "$base`?" + ($keep -join '&')
}

# Decide the fixed (url, alt) for an image link, or $null when it should be left alone.
function Resolve-ImageFix {
    param([string]$Url, [string]$MarkdownDir)

    $trimmed = $Url.Trim()

    $isUrl = $trimmed -match '^[a-zA-Z][a-zA-Z0-9+.-]*://'
    if (-not $isUrl -and $trimmed -notmatch '^(mailto:|data:|#)') {
        # Local path candidate.
        $rel = Get-RepoRelativePath -LinkPath $trimmed -MarkdownDir $MarkdownDir
        if ($null -eq $rel) {
            return $null
        }
        $ext = [System.IO.Path]::GetExtension($rel).ToLowerInvariant()
        if ($ImageExtensions -notcontains $ext) {
            return $null
        }
        $abs = Join-Path $WikiRoot $rel
        $exists = Test-Path -LiteralPath $abs -PathType Leaf
        return [PSCustomObject]@{
            Url    = "$CanonicalPrefix$rel`?raw=true"
            Alt    = [System.IO.Path]::GetFileNameWithoutExtension($rel)
            Kind   = 'local'
            Exists = $exists
            RelPath = $rel
        }
    }

    # Only blob/raw asset URLs are what the validator inspects. This deliberately excludes
    # badge/shield URLs such as .../actions/workflows/<wf>.yml/badge.svg, which are not assets.
    $isOrcaAsset = ($trimmed -match '^https://github\.com/OrcaSlicer/[^/]+/(blob|raw)/') -or
                   ($trimmed -match '^https://raw\.githubusercontent\.com/OrcaSlicer/')
    if ($isOrcaAsset) {
        return [PSCustomObject]@{
            Url    = Repair-OrcaGithubUrl -Url $trimmed
            Alt    = Get-StemFromPath -PathOrUrl $trimmed
            Kind   = 'orca-url'
            Exists = $true
            RelPath = $null
        }
    }

    return $null   # external / unrelated URL (badges, shields, user-attachments, etc.)
}

# Parse <img ...> attributes preserving order; supports quoted and unquoted values.
function Get-ImgAttributes {
    param([string]$Tag)

    $attrs = New-Object System.Collections.Generic.List[object]
    $attrPattern = '([a-zA-Z_:][\w:.-]*)(?:\s*=\s*("([^"]*)"|''([^'']*)''|([^\s>/]+)))?'
    foreach ($m in [regex]::Matches($Tag, $attrPattern)) {
        $name = $m.Groups[1].Value
        if ($name -match '^(img)$') { continue }   # skip the tag name itself
        $value = $null
        if ($m.Groups[3].Success) { $value = $m.Groups[3].Value }
        elseif ($m.Groups[4].Success) { $value = $m.Groups[4].Value }
        elseif ($m.Groups[5].Success) { $value = $m.Groups[5].Value }
        $attrs.Add([PSCustomObject]@{ Name = $name; Value = $value })
    }
    return $attrs
}

$mdImagePattern = '!\[(?<alt>[^\]]*)\]\(\s*(?<url>[^)\s]+)(?:\s+"(?<title>[^"]*)")?\s*\)'
$htmlImagePattern = '<img\b[^>]*?/?>'

# Skip the generated wiki/ build output and releases/ (which validate_images.yml also excludes).
$mdFiles = Get-ChildItem -LiteralPath $WikiRoot -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]wiki[\\/]' -and $_.FullName -notmatch '[\\/]releases[\\/]' }

$filesChanged = 0
$linksConverted = 0
$urlsRawFixed = 0
$altFixed = 0
$imgReordered = 0
$missingLocal = 0

foreach ($file in $mdFiles) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    if ($null -eq $text) { continue }

    $markdownDir = Split-Path -Parent $file.FullName
    $codeRanges = Get-CodeBlockRanges -Text $text

    # Collect edits as {Start, Length, Replacement}; apply right-to-left so indexes stay valid.
    $edits = New-Object System.Collections.Generic.List[object]

    foreach ($m in [regex]::Matches($text, $mdImagePattern)) {
        if (Test-IndexInRanges -Ranges $codeRanges -Index $m.Index) { continue }

        $url = $m.Groups['url'].Value
        $alt = $m.Groups['alt'].Value
        $title = $m.Groups['title'].Value

        $fix = Resolve-ImageFix -Url $url -MarkdownDir $markdownDir
        if ($null -eq $fix) { continue }

        if ($fix.Kind -eq 'local' -and -not $fix.Exists) {
            Write-Host "[WARN] $($file.Name) line $(($text.Substring(0,$m.Index) -split "`n").Count): image not found for '$url' (expected $($fix.RelPath))" -ForegroundColor Yellow
            $missingLocal++
            continue
        }

        $titleSuffix = if ([string]::IsNullOrEmpty($title)) { '' } else { " `"$title`"" }
        $replacement = "![$($fix.Alt)]($($fix.Url)$titleSuffix)"
        if ($replacement -ne $m.Value) {
            if ($fix.Kind -eq 'local') { $linksConverted++ }
            else {
                if ($fix.Url -ne $url) { $urlsRawFixed++ }
                if ($fix.Alt -ne $alt) { $altFixed++ }
            }
            $edits.Add([PSCustomObject]@{ Start = $m.Index; Length = $m.Length; Replacement = $replacement })
        }
    }

    foreach ($m in [regex]::Matches($text, $htmlImagePattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
        if (Test-IndexInRanges -Ranges $codeRanges -Index $m.Index) { continue }

        $tag = $m.Value
        $attrs = Get-ImgAttributes -Tag $tag
        $srcAttr = $attrs | Where-Object { $_.Name.ToLowerInvariant() -eq 'src' } | Select-Object -First 1
        if ($null -eq $srcAttr -or [string]::IsNullOrWhiteSpace($srcAttr.Value)) { continue }

        $fix = Resolve-ImageFix -Url $srcAttr.Value -MarkdownDir $markdownDir
        if ($null -eq $fix) { continue }

        if ($fix.Kind -eq 'local' -and -not $fix.Exists) {
            Write-Host "[WARN] $($file.Name) line $(($text.Substring(0,$m.Index) -split "`n").Count): <img> not found for '$($srcAttr.Value)' (expected $($fix.RelPath))" -ForegroundColor Yellow
            $missingLocal++
            continue
        }

        # Rebuild with alt first, then src, then remaining attributes in their original order.
        $otherAttrs = $attrs | Where-Object { $_.Name.ToLowerInvariant() -ne 'alt' -and $_.Name.ToLowerInvariant() -ne 'src' }
        $rebuilt = "<img alt=`"$($fix.Alt)`" src=`"$($fix.Url)`""
        foreach ($a in $otherAttrs) {
            if ($null -eq $a.Value) { $rebuilt += " $($a.Name)" }
            else { $rebuilt += " $($a.Name)=`"$($a.Value)`"" }
        }
        $rebuilt += if ($tag -match '/>\s*$') { ' />' } else { '>' }

        if ($rebuilt -ne $tag) {
            $imgReordered++
            $edits.Add([PSCustomObject]@{ Start = $m.Index; Length = $m.Length; Replacement = $rebuilt })
        }
    }

    if ($edits.Count -eq 0) { continue }

    $sorted = $edits | Sort-Object -Property Start -Descending
    $newText = $text
    foreach ($e in $sorted) {
        $newText = $newText.Substring(0, $e.Start) + $e.Replacement + $newText.Substring($e.Start + $e.Length)
    }

    $relFile = $file.FullName.Substring($RootFull.Length) -replace '\\', '/'
    Write-Host "[FIX] $relFile ($($edits.Count) reference(s))" -ForegroundColor Cyan
    $filesChanged++

    if (-not $DryRun) {
        # Preserve UTF-8 without BOM, matching the repo's existing files.
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($file.FullName, $newText, $utf8NoBom)
    }
}

Write-Host ""
Write-Host "Files changed:            $filesChanged"
Write-Host "Local paths converted:    $linksConverted"
Write-Host "URLs given ?raw=true:     $urlsRawFixed"
Write-Host "Alt text corrected:       $altFixed"
Write-Host "<img> tags normalized:    $imgReordered"
Write-Host "Local images not found:   $missingLocal"
if ($DryRun) {
    Write-Host "Dry run only. No files were modified." -ForegroundColor Cyan
}
