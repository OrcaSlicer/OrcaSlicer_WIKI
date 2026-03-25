param(
    [string]$TabCppPath = "n:\Repos\OrcaSlicer\src\slic3r\GUI\Tab.cpp",
    [string]$WikiRoot = $PSScriptRoot,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

function ConvertTo-AnchorSlug {
    param([string]$Heading)

    if ([string]::IsNullOrWhiteSpace($Heading)) {
        return ""
    }

    $text = $Heading.Trim().ToLowerInvariant()
    # Keep letters, digits, spaces and hyphens; strip punctuation to mimic markdown anchors.
    $text = [regex]::Replace($text, "[^a-z0-9\s-]", "")
    $text = [regex]::Replace($text, "[\s-]+", "-")
    return $text.Trim('-')
}

function Find-HeadingLineIndex {
    param(
        [string[]]$Lines,
        [string]$Anchor
    )

    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $line = $Lines[$i]
        if ($line -match '^(#{1,6})\s+(.+?)\s*$') {
            $headingText = $Matches[2].Trim()
            $headingText = $headingText -replace '\s+#+$', ''
            $slug = ConvertTo-AnchorSlug -Heading $headingText
            if ($slug -eq $Anchor) {
                return $i
            }
        }
    }

    return -1
}

if (-not (Test-Path -LiteralPath $TabCppPath)) {
    throw "Tab.cpp not found: $TabCppPath"
}

if (-not (Test-Path -LiteralPath $WikiRoot)) {
    throw "Wiki root not found: $WikiRoot"
}

$tabContent = Get-Content -LiteralPath $TabCppPath -Raw

$pattern = 'append_single_option_line\(\s*"(?<variable>[^"]+)"\s*,\s*"(?<ref>[^"]+)"\s*\)'
$matches = [regex]::Matches($tabContent, $pattern)

if ($matches.Count -eq 0) {
    Write-Host "No append_single_option_line(\"var\", \"file#anchor\") entries found." -ForegroundColor Yellow
    exit 0
}

$mdFiles = Get-ChildItem -LiteralPath $WikiRoot -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]wiki[\\/]' }

$mdByName = @{}
foreach ($file in $mdFiles) {
    $key = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    if (-not $mdByName.ContainsKey($key)) {
        $mdByName[$key] = New-Object System.Collections.Generic.List[string]
    }
    $mdByName[$key].Add($file.FullName)
}

$entries = New-Object System.Collections.Generic.List[object]
foreach ($m in $matches) {
    $variable = $m.Groups['variable'].Value.Trim()
    $ref = $m.Groups['ref'].Value.Trim()

    if ($ref -notmatch '#') {
        continue
    }

    $parts = $ref -split '#', 2
    $fileKey = $parts[0].Trim()
    $anchor = $parts[1].Trim().ToLowerInvariant()

    if ([string]::IsNullOrWhiteSpace($fileKey) -or [string]::IsNullOrWhiteSpace($anchor)) {
        continue
    }

    $entries.Add([PSCustomObject]@{
        Variable = $variable
        FileKey  = $fileKey
        Anchor   = $anchor
        Ref      = $ref
    })
}

if ($entries.Count -eq 0) {
    Write-Host "No entries with file#anchor format were found." -ForegroundColor Yellow
    exit 0
}

$changes = 0
$missingFiles = 0
$missingHeadings = 0
$alreadyPresent = 0

$groupedByFile = $entries | Group-Object -Property FileKey

foreach ($group in $groupedByFile) {
    $fileKey = $group.Name

    if (-not $mdByName.ContainsKey($fileKey)) {
        Write-Host "[WARN] Markdown file not found for '$fileKey'" -ForegroundColor Yellow
        $missingFiles++
        continue
    }

    $candidates = $mdByName[$fileKey]
    $targetPath = $candidates[0]
    if ($candidates.Count -gt 1) {
        $targetPath = ($candidates | Sort-Object Length | Select-Object -First 1)
        Write-Host "[WARN] Multiple files matched '$fileKey'. Using: $targetPath" -ForegroundColor Yellow
    }

    $lines = Get-Content -LiteralPath $targetPath
    $buffer = New-Object System.Collections.Generic.List[string]
    $buffer.AddRange([string[]]$lines)
    $fileChanged = $false

    foreach ($entry in $group.Group) {
        $insertLine = "Config option: ``$($entry.Variable)``"

        $idx = Find-HeadingLineIndex -Lines $buffer.ToArray() -Anchor $entry.Anchor
        if ($idx -lt 0) {
            Write-Host "[WARN] Heading anchor '$($entry.Anchor)' not found in $targetPath (from '$($entry.Ref)')" -ForegroundColor Yellow
            $missingHeadings++
            continue
        }

        $nextHeading = -1
        for ($j = $idx + 1; $j -lt $buffer.Count; $j++) {
            if ($buffer[$j] -match '^#{1,6}\s+') {
                $nextHeading = $j
                break
            }
        }

        $sectionEnd = if ($nextHeading -ge 0) { $nextHeading - 1 } else { $buffer.Count - 1 }
        $exists = $false
        for ($k = $idx + 1; $k -le $sectionEnd; $k++) {
            if ($buffer[$k] -eq $insertLine) {
                $exists = $true
                break
            }
        }

        if ($exists) {
            $alreadyPresent++
            continue
        }

        $insertAt = $idx + 1
        while ($insertAt -lt $buffer.Count -and $buffer[$insertAt] -like 'Config option:*') {
            $insertAt++
        }

        $buffer.Insert($insertAt, $insertLine)
        $changes++
        $fileChanged = $true
    }

    if ($fileChanged -and -not $DryRun) {
        Set-Content -LiteralPath $targetPath -Value $buffer -Encoding UTF8
    }
}

Write-Host "Processed: $($entries.Count) entries"
Write-Host "Inserted:  $changes"
Write-Host "Skipped (already present): $alreadyPresent"
Write-Host "Missing markdown file matches: $missingFiles"
Write-Host "Missing heading anchors: $missingHeadings"

if ($DryRun) {
    Write-Host "Dry run only. No files were modified." -ForegroundColor Cyan
}
