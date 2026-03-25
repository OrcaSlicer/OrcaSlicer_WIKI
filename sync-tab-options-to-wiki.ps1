param(
    [string]$TabCppPath = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/slic3r/GUI/Tab.cpp",
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

function Get-TabCppContent {
    param([string]$Source)

    if ($Source -match '^https?://') {
        $url = $Source
        # Convert GitHub blob URL to a raw URL so the script receives C++ source text.
        if ($url -match '^https://github\.com/([^/]+)/([^/]+)/blob/(.+)$') {
            $owner = $Matches[1]
            $repo = $Matches[2]
            $path = $Matches[3]
            $url = "https://raw.githubusercontent.com/$owner/$repo/$path"
        }

        try {
            return (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
        }
        catch {
            throw "Failed to download Tab.cpp from URL: $Source"
        }
    }

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Tab.cpp not found: $Source"
    }

    return Get-Content -LiteralPath $Source -Raw
}

function Get-StringVectors {
    param([string]$Content)

    $result = @{}
    $vectorPattern = '(?s)const\s+std::vector\s*<\s*std::string\s*>\s*(?<name>\w+)\s*\{(?<vals>.*?)\}\s*;'
    $vectorMatches = [regex]::Matches($Content, $vectorPattern)

    foreach ($vm in $vectorMatches) {
        $name = $vm.Groups['name'].Value
        $valsRaw = $vm.Groups['vals'].Value
        $vals = [regex]::Matches($valsRaw, '"(?<v>[^"]+)"') | ForEach-Object { $_.Groups['v'].Value }
        if ($vals.Count -gt 0) {
            $result[$name] = @($vals)
        }
    }

    return $result
}

if (-not (Test-Path -LiteralPath $WikiRoot)) {
    throw "Wiki root not found: $WikiRoot"
}

$tabContent = Get-TabCppContent -Source $TabCppPath

$patternSingle = 'append_single_option_line\(\s*"(?<variable>[^"]+)"\s*,\s*"(?<ref>[^"]+)"\s*\)'
$patternOption = 'append_option_line\(\s*[^,]+\s*,\s*"(?<variable>[^"]+)"\s*,\s*"(?<ref>[^"]+)"\s*\)'
$patternAppendLineBlock = '(?s)(?<obj>\w+)\.label_path\s*=\s*"(?<ref>[^"]+)"\s*;(?<body>.*?)(?:\w+->)?append_line\(\s*\k<obj>\s*\)\s*;'
$patternForBlock = '(?s)for\s*\(\s*const\s+std::string\s*&\s*(?<iter>\w+)\s*:\s*(?<collection>\w+)\s*\)\s*\{(?<body>.*?)\}'

$singleMatches = [regex]::Matches($tabContent, $patternSingle)
$optionMatches = [regex]::Matches($tabContent, $patternOption)
$appendLineMatches = [regex]::Matches($tabContent, $patternAppendLineBlock)
$forMatches = [regex]::Matches($tabContent, $patternForBlock)
$stringVectors = Get-StringVectors -Content $tabContent

$rawEntries = New-Object System.Collections.Generic.List[object]

foreach ($m in $singleMatches) {
    $rawEntries.Add([PSCustomObject]@{
        Variable = $m.Groups['variable'].Value.Trim()
        Ref      = $m.Groups['ref'].Value.Trim()
        Index    = [int]$m.Index
    })
}

foreach ($m in $optionMatches) {
    $rawEntries.Add([PSCustomObject]@{
        Variable = $m.Groups['variable'].Value.Trim()
        Ref      = $m.Groups['ref'].Value.Trim()
        Index    = [int]$m.Index
    })
}

foreach ($m in $appendLineMatches) {
    $obj = $m.Groups['obj'].Value
    $ref = $m.Groups['ref'].Value.Trim()
    $body = $m.Groups['body'].Value
    $optPattern = [regex]::Escape($obj) + '\.append_option\(\s*optgroup->get_option\("(?<variable>[^"]+)"\)\s*\)\s*;'
    $optMatches = [regex]::Matches($body, $optPattern)

    foreach ($om in $optMatches) {
        $rawEntries.Add([PSCustomObject]@{
            Variable = $om.Groups['variable'].Value.Trim()
            Ref      = $ref
            Index    = [int]($m.Index + $om.Index)
        })
    }
}

foreach ($fm in $forMatches) {
    $iter = $fm.Groups['iter'].Value
    $collection = $fm.Groups['collection'].Value
    $body = $fm.Groups['body'].Value

    if (-not $stringVectors.ContainsKey($collection)) {
        continue
    }

    $values = $stringVectors[$collection]
    $prefixPattern = 'append_option_line\(\s*[^,]+\s*,\s*"(?<prefix>[^"]*)"\s*\+\s*' + [regex]::Escape($iter) + '\s*,\s*"(?<ref>[^"]+)"\s*\)'
    $suffixPattern = 'append_option_line\(\s*[^,]+\s*,\s*' + [regex]::Escape($iter) + '\s*\+\s*"(?<suffix>[^"]*)"\s*,\s*"(?<ref>[^"]+)"\s*\)'

    $prefixMatches = [regex]::Matches($body, $prefixPattern)
    foreach ($pm in $prefixMatches) {
        $prefix = $pm.Groups['prefix'].Value
        $ref = $pm.Groups['ref'].Value.Trim()

        foreach ($v in $values) {
            $rawEntries.Add([PSCustomObject]@{
                Variable = "$prefix$v"
                Ref      = $ref
                Index    = [int]($fm.Index + $pm.Index)
            })
        }
    }

    $suffixMatches = [regex]::Matches($body, $suffixPattern)
    foreach ($sm in $suffixMatches) {
        $suffix = $sm.Groups['suffix'].Value
        $ref = $sm.Groups['ref'].Value.Trim()

        foreach ($v in $values) {
            $rawEntries.Add([PSCustomObject]@{
                Variable = "$v$suffix"
                Ref      = $ref
                Index    = [int]($fm.Index + $sm.Index)
            })
        }
    }
}

$matches = @($rawEntries | Sort-Object -Property Index)

if ($matches.Count -eq 0) {
    Write-Host "No supported option-to-doc mappings were found." -ForegroundColor Yellow
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
    $variable = $m.Variable
    $ref = $m.Ref

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
$normalizedSections = 0

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

    $groupedByAnchor = $group.Group | Group-Object -Property Anchor

    foreach ($anchorGroup in $groupedByAnchor) {
        $anchor = $anchorGroup.Name

        $vars = New-Object System.Collections.Generic.List[string]
        $seenVars = @{}
        foreach ($entry in $anchorGroup.Group) {
            if (-not $seenVars.ContainsKey($entry.Variable)) {
                $seenVars[$entry.Variable] = $true
                $vars.Add($entry.Variable)
            }
        }

        $formattedVars = $vars | ForEach-Object { "``$_``" }
        $label = if ($vars.Count -eq 1) { "[Variable](Built-in-placeholders-variables):" } else { "[Variables](Built-in-placeholders-variables):" }
        $insertLine = "$label " + ($formattedVars -join ", ") + ".  "  # ending with two spaces so Markdown line break is forced

        $idx = Find-HeadingLineIndex -Lines $buffer.ToArray() -Anchor $anchor
        if ($idx -lt 0) {
            $sourceRef = $anchorGroup.Group[0].Ref
            Write-Host "[WARN] Heading anchor '$anchor' not found in $targetPath (from '$sourceRef')" -ForegroundColor Yellow
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
        $metadataLineIndexes = New-Object System.Collections.Generic.List[int]
        $hasCanonicalLine = $false

        for ($k = $idx + 1; $k -le $sectionEnd; $k++) {
            if ($buffer[$k] -match '^\s*Variables?:\s*') {
                $metadataLineIndexes.Add($k)
                if ($buffer[$k] -eq $insertLine) {
                    $hasCanonicalLine = $true
                }
            }
        }

        $hasBlankBetween = ($idx + 1) -lt $buffer.Count -and [string]::IsNullOrWhiteSpace($buffer[$idx + 1])
        $varLineIndex = $idx + 2
        $hasHeadingRightAfterVariable = ($varLineIndex + 1) -lt $buffer.Count -and $buffer[$varLineIndex + 1] -match '^#{1,6}\s+'
        $alreadyCanonical = $metadataLineIndexes.Count -eq 1 -and $hasCanonicalLine -and $metadataLineIndexes[0] -eq $varLineIndex -and $hasBlankBetween -and (-not $hasHeadingRightAfterVariable)
        if ($alreadyCanonical) {
            $alreadyPresent++
            continue
        }

        if ($metadataLineIndexes.Count -gt 0) {
            for ($r = $metadataLineIndexes.Count - 1; $r -ge 0; $r--) {
                $buffer.RemoveAt($metadataLineIndexes[$r])
            }
            $normalizedSections++
            $fileChanged = $true
        }

        if ((($idx + 2) -lt $buffer.Count) -and [string]::IsNullOrWhiteSpace($buffer[$idx + 1]) -and $buffer[$idx + 2] -eq $insertLine -and (-not (($idx + 3) -lt $buffer.Count -and $buffer[$idx + 3] -match '^#{1,6}\s+'))) {
            $alreadyPresent++
            continue
        }

        if (-not (($idx + 1) -lt $buffer.Count -and [string]::IsNullOrWhiteSpace($buffer[$idx + 1]))) {
            $buffer.Insert($idx + 1, "")
            $fileChanged = $true
        }

        $buffer.Insert($idx + 2, $insertLine)
        if (($idx + 3) -lt $buffer.Count -and $buffer[$idx + 3] -match '^#{1,6}\s+') {
            $buffer.Insert($idx + 3, "")
            $fileChanged = $true
        }
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
Write-Host "Normalized sections: $normalizedSections"
Write-Host "Missing markdown file matches: $missingFiles"
Write-Host "Missing heading anchors: $missingHeadings"

if ($DryRun) {
    Write-Host "Dry run only. No files were modified." -ForegroundColor Cyan
}
