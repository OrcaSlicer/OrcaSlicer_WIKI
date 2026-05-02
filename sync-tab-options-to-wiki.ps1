param(
    [string]$TabCppPath = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/slic3r/GUI/Tab.cpp",
    [string]$PrintConfigCppPath = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/PrintConfig.cpp",
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

function Get-CppSourceContent {
    param(
        [string]$Source,
        [string]$Description
    )

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
            throw "Failed to download $Description from URL: $Source"
        }
    }

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "$Description not found: $Source"
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

function Get-OptionModesByVariable {
    param([string]$Content)

    $result = @{}
    $lines = $Content -split "`r?`n"
    $currentVariable = $null
    $addPattern = '(?:\b\w+\s*=\s*)*def\s*=\s*this->add(?:_nullable)?\(\s*"(?<variable>[^"]+)"\s*,'
    $modePattern = 'def->mode\s*=\s*(?<mode>comSimple|comAdvanced|comExpert|comDevelop)\s*;'

    foreach ($line in $lines) {
        if ($line -match $addPattern) {
            $capturedVariable = [string]$Matches['variable']
            if ([string]::IsNullOrWhiteSpace($capturedVariable)) {
                $currentVariable = $null
            }
            else {
                $currentVariable = $capturedVariable.Trim()
            }
            continue
        }

        if (-not [string]::IsNullOrWhiteSpace($currentVariable) -and $line -match $modePattern) {
            $result[$currentVariable] = [string]$Matches['mode']
        }
    }

    return $result
}

function Convert-ConfigOptionModeToLabel {
    param([string]$Mode)

    switch ($Mode) {
        'comSimple' { return 'Simple' }
        'comAdvanced' { return 'Advanced' }
        'comExpert' { return 'Expert' }
        'comDevelop' { return 'Develop' }
        default { return $null }
    }
}

$syncProgressActivity = "sync-tab-options-to-wiki.ps1"
$syncStageTotal = 8

function Set-SyncStage {
    param(
        [int]$Step,
        [string]$Status
    )

    $percent = if ($syncStageTotal -gt 0) {
        [Math]::Max(0, [Math]::Min(100, [int](($Step / [double]$syncStageTotal) * 100)))
    }
    else {
        0
    }

    Write-Progress -Id 1 -Activity $syncProgressActivity -Status $Status -PercentComplete $percent
}

function Set-SyncDetail {
    param(
        [string]$Status,
        [int]$Current,
        [int]$Total
    )

    $percent = if ($Total -gt 0) {
        [Math]::Max(0, [Math]::Min(100, [int](($Current / [double]$Total) * 100)))
    }
    else {
        0
    }

    Write-Progress -Id 2 -ParentId 1 -Activity "Processing markdown mappings" -Status $Status -PercentComplete $percent
}

function Complete-SyncProgress {
    Write-Progress -Id 2 -Activity "Processing markdown mappings" -Completed
    Write-Progress -Id 1 -Activity $syncProgressActivity -Completed
}

Set-SyncStage -Step 0 -Status "Validating input paths"

if (-not (Test-Path -LiteralPath $WikiRoot)) {
    Complete-SyncProgress
    throw "Wiki root not found: $WikiRoot"
}

Set-SyncStage -Step 1 -Status "Loading Tab.cpp content"
$tabContent = Get-CppSourceContent -Source $TabCppPath -Description "Tab.cpp"

Set-SyncStage -Step 2 -Status "Parsing option mappings from Tab.cpp"
$patternSingle = 'append_single_option_line\(\s*"(?<variable>[^"]+)"\s*,\s*"(?<ref>[^"]+)"(?:\s*,\s*(?<indexer>[^\)]+))?\s*\)'
$patternOption = 'append_option_line\(\s*[^,]+\s*,\s*"(?<variable>[^"]+)"\s*,\s*"(?<ref>[^"]+)"(?:\s*,\s*(?<indexer>[^\)]+))?\s*\)'
$patternAppendLineBlock = '(?s)(?<obj>\w+)\.label_path\s*=\s*"(?<ref>[^"]+)"\s*;(?<body>.*?)(?:\w+->)?append_line\(\s*\k<obj>\s*\)\s*;'
$patternAppendLineAssignedBlock = '(?s)(?<obj>\w+)\s*=\s*\{.*?\}\s*;(?<body>.*?)(?:\w+->)?append_line\(\s*\k<obj>\s*\)\s*;'
$patternForBlock = '(?s)for\s*\(\s*const\s+std::string\s*&\s*(?<iter>\w+)\s*:\s*(?<collection>\w+)\s*\)\s*\{(?<body>.*?)\}'

$singleMatches = [regex]::Matches($tabContent, $patternSingle)
$optionMatches = [regex]::Matches($tabContent, $patternOption)
$appendLineMatches = [regex]::Matches($tabContent, $patternAppendLineBlock)
$appendLineAssignedMatches = [regex]::Matches($tabContent, $patternAppendLineAssignedBlock)
$forMatches = [regex]::Matches($tabContent, $patternForBlock)
$stringVectors = Get-StringVectors -Content $tabContent

$rawEntries = New-Object System.Collections.Generic.List[object]

foreach ($m in $singleMatches) {
    $variable = $m.Groups['variable'].Value.Trim()
    $indexer = $m.Groups['indexer'].Value.Trim()
    if (-not [string]::IsNullOrWhiteSpace($indexer) -and $indexer -match '^[A-Za-z_]\w*$') {
        $variable = "${variable}[$indexer]"
    }

    $rawEntries.Add([PSCustomObject]@{
        Variable = $variable
        Ref      = $m.Groups['ref'].Value.Trim()
        Index    = [int]$m.Index
    })
}

foreach ($m in $optionMatches) {
    $variable = $m.Groups['variable'].Value.Trim()
    $indexer = $m.Groups['indexer'].Value.Trim()
    if (-not [string]::IsNullOrWhiteSpace($indexer) -and $indexer -match '^[A-Za-z_]\w*$') {
        $variable = "${variable}[$indexer]"
    }

    $rawEntries.Add([PSCustomObject]@{
        Variable = $variable
        Ref      = $m.Groups['ref'].Value.Trim()
        Index    = [int]$m.Index
    })
}

foreach ($m in $appendLineMatches) {
    $obj = $m.Groups['obj'].Value
    $ref = $m.Groups['ref'].Value.Trim()
    $body = $m.Groups['body'].Value
    $optPattern = '(?s)' + [regex]::Escape($obj) + '\.append_option\(\s*.*?get_option\("(?<variable>[^"]+)"(?:\s*,\s*(?<indexer>[^\)]+))?\)\s*\)\s*;'
    $optMatches = [regex]::Matches($body, $optPattern)

    foreach ($om in $optMatches) {
        $variable = $om.Groups['variable'].Value.Trim()
        $indexer = $om.Groups['indexer'].Value.Trim()
        if (-not [string]::IsNullOrWhiteSpace($indexer) -and $indexer -match '^[A-Za-z_]\w*$') {
            $variable = "${variable}[$indexer]"
        }

        $rawEntries.Add([PSCustomObject]@{
            Variable = $variable
            Ref      = $ref
            Index    = [int]($m.Index + $om.Index)
        })
    }
}

foreach ($m in $appendLineAssignedMatches) {
    $obj = $m.Groups['obj'].Value
    $body = $m.Groups['body'].Value

    $labelPattern = [regex]::Escape($obj) + '\.label_path\s*=\s*"(?<ref>[^"]+)"\s*;'
    $labelMatch = [regex]::Match($body, $labelPattern)
    if (-not $labelMatch.Success) {
        continue
    }

    $ref = $labelMatch.Groups['ref'].Value.Trim()
    $optPattern = '(?s)' + [regex]::Escape($obj) + '\.append_option\(\s*.*?get_option\("(?<variable>[^"]+)"(?:\s*,\s*(?<indexer>[^\)]+))?\)\s*\)\s*;'
    $optMatches = [regex]::Matches($body, $optPattern)

    foreach ($om in $optMatches) {
        $variable = $om.Groups['variable'].Value.Trim()
        $indexer = $om.Groups['indexer'].Value.Trim()
        if (-not [string]::IsNullOrWhiteSpace($indexer) -and $indexer -match '^[A-Za-z_]\w*$') {
            $variable = "${variable}[$indexer]"
        }

        $rawEntries.Add([PSCustomObject]@{
            Variable = $variable
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


$parsedMatches = @($rawEntries | Sort-Object -Property Index)

if ($parsedMatches.Count -eq 0) {
    Write-Host "No supported option-to-doc mappings were found." -ForegroundColor Yellow
    Complete-SyncProgress
    exit 0
}

Set-SyncStage -Step 3 -Status "Loading and parsing option modes from PrintConfig.cpp"
$optionModesByVariable = @{}
if (-not [string]::IsNullOrWhiteSpace($PrintConfigCppPath)) {
    try {
        $printConfigContent = Get-CppSourceContent -Source $PrintConfigCppPath -Description "PrintConfig.cpp"
        $optionModesByVariable = Get-OptionModesByVariable -Content $printConfigContent
    }
    catch {
        Write-Host "[WARN] $($_.Exception.Message). Continuing without option mode annotations." -ForegroundColor Yellow
    }
}

Set-SyncStage -Step 4 -Status "Scanning markdown files"
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

Set-SyncStage -Step 5 -Status "Building file and anchor entries"
$entries = New-Object System.Collections.Generic.List[object]
foreach ($m in $parsedMatches) {
    $variable = $m.Variable
    $baseVariable = [regex]::Match($variable, '^[^\[]+').Value
    $mode = $null
    if (-not [string]::IsNullOrWhiteSpace($baseVariable) -and $optionModesByVariable.ContainsKey($baseVariable)) {
        $mode = $optionModesByVariable[$baseVariable]
    }

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
        Mode     = $mode
    })
}

if ($entries.Count -eq 0) {
    Write-Host "No entries with file#anchor format were found." -ForegroundColor Yellow
    Complete-SyncProgress
    exit 0
}

$changes = 0
$missingFiles = 0
$missingHeadings = 0
$alreadyPresent = 0
$normalizedSections = 0
$entriesWithMode = @($entries | Where-Object { -not [string]::IsNullOrWhiteSpace($_.Mode) }).Count

$groupedByFile = $entries | Group-Object -Property FileKey
$totalFileGroups = $groupedByFile.Count
$fileNumber = 0

Set-SyncStage -Step 6 -Status "Applying mappings to markdown files ($totalFileGroups files)"

foreach ($group in $groupedByFile) {
    $fileNumber++
    $fileKey = $group.Name
    Set-SyncDetail -Status "File $fileNumber/$($totalFileGroups): $fileKey" -Current $fileNumber -Total $totalFileGroups

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
    $anchorCount = $groupedByAnchor.Count
    $anchorNumber = 0

    foreach ($anchorGroup in $groupedByAnchor) {
        $anchorNumber++
        Set-SyncDetail -Status "File $fileNumber/$($totalFileGroups): $fileKey | Anchor $anchorNumber/$($anchorCount): $($anchorGroup.Name)" -Current $fileNumber -Total $totalFileGroups
        $anchor = $anchorGroup.Name

        $vars = New-Object System.Collections.Generic.List[string]
        $seenVars = @{}
        $varModes = @{}
        foreach ($entry in $anchorGroup.Group) {
            if (-not $seenVars.ContainsKey($entry.Variable)) {
                $seenVars[$entry.Variable] = $true
                $vars.Add($entry.Variable)
            }

            $modeLabel = Convert-ConfigOptionModeToLabel -Mode $entry.Mode
            if (-not [string]::IsNullOrWhiteSpace($modeLabel) -and -not $varModes.ContainsKey($entry.Variable)) {
                $varModes[$entry.Variable] = $modeLabel
            }
        }

        $formattedVars = $vars | ForEach-Object { "``$_``" }
        $label = if ($vars.Count -eq 1) { "[Variable](built_in_placeholders_variables):" } else { "[Variables](built_in_placeholders_variables):" }

        $modePairs = New-Object System.Collections.Generic.List[string]
        $distinctModes = New-Object System.Collections.Generic.List[string]
        $seenModes = @{}
        foreach ($varName in $vars) {
            if (-not $varModes.ContainsKey($varName)) {
                continue
            }

            $modeName = $varModes[$varName]
            $modePairs.Add("``$varName`` = ``$modeName``")
            if (-not $seenModes.ContainsKey($modeName)) {
                $seenModes[$modeName] = $true
                $distinctModes.Add($modeName)
            }
        }

        $modeSuffix = ""
        if ($modePairs.Count -gt 0) {
            if ($distinctModes.Count -eq 1 -and $modePairs.Count -eq $vars.Count) {
                $modeSuffix = " Mode: ``$($distinctModes[0])``."
            }
            else {
                $modeSuffix = " Modes: " + ($modePairs -join ", ") + "."
            }
        }

        $insertLine = "$label " + ($formattedVars -join ", ") + "."
        if (-not [string]::IsNullOrWhiteSpace($modeSuffix)) {
            $insertLine += $modeSuffix
        }
        $insertLine += "  "  # ending with two spaces so Markdown line break is forced

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
            if ($buffer[$k] -match '^\s*(?:\[(?:Variable|Variables)\]\([^\)]+\)|Variables?)\s*:\s*') {
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

Set-SyncStage -Step 7 -Status "Finalizing summary"
Write-Host "Processed: $($entries.Count) entries"
Write-Host "Entries with option mode: $entriesWithMode"
Write-Host "Inserted:  $changes"
Write-Host "Skipped (already present): $alreadyPresent"
Write-Host "Normalized sections: $normalizedSections"
Write-Host "Missing markdown file matches: $missingFiles"
Write-Host "Missing heading anchors: $missingHeadings"

if ($DryRun) {
    Write-Host "Dry run only. No files were modified." -ForegroundColor Cyan
}

Set-SyncStage -Step 8 -Status "Completed"
Complete-SyncProgress
