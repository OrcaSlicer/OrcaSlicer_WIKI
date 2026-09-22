param(
    [string]$TabCppPath = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/slic3r/GUI/Tab.cpp",
    [string]$PrintConfigCppPath = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/PrintConfig.cpp",
    [string]$PublishSettingsCppPath,
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

function Find-FirstHeadingLineIndex {
    param([string[]]$Lines)

    for ($i = 0; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i] -match '^(#{1,6})\s+(.+?)\s*$') {
            return $i
        }
    }

    return -1
}

function ConvertTo-DocFileKey {
    param([string]$RefFile)

    if ([string]::IsNullOrWhiteSpace($RefFile)) {
        return ""
    }

    $normalizedRef = $RefFile.Trim() -replace '\\', '/'
    $leaf = ($normalizedRef -split '/')[(-1)]
    if ([string]::IsNullOrWhiteSpace($leaf)) {
        return ""
    }

    if ([System.IO.Path]::GetExtension($leaf).ToLowerInvariant() -eq '.md') {
        return [System.IO.Path]::GetFileNameWithoutExtension($leaf)
    }

    return $leaf
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

function Resolve-PublishSettingsPath {
    param(
        [string]$Explicit,
        [string]$PrintConfigPath
    )

    if (-not [string]::IsNullOrWhiteSpace($Explicit)) {
        return $Explicit
    }

    # PublishSettings.cpp sits next to PrintConfig.cpp in libslic3r, so follow whatever
    # checkout or URL the caller already pointed PrintConfig.cpp at.
    if ([string]::IsNullOrWhiteSpace($PrintConfigPath) -or $PrintConfigPath -notmatch '(?i)PrintConfig\.cpp$') {
        return ""
    }

    return ($PrintConfigPath -replace '(?i)PrintConfig\.cpp$', 'PublishSettings.cpp')
}

function Get-PublishablePrinterOptionTables {
    param([string]$Content)

    $result = @{}
    # const std::vector<PublishablePrinterOption>& publishable_printer_retraction_options()
    # {
    #     static const std::vector<PublishablePrinterOption> options = {
    #         { "retraction_length", "printer_extruder_retraction#length" },
    # Bound the body span: an unbounded '.*?' backtracks badly over a whole translation unit.
    # The lazy match stops at the first column-0 '}', i.e. the function's own closing brace.
    $tablePattern = '(?s)std::vector\s*<\s*PublishablePrinterOption\s*>\s*&?\s*(?<name>\w+)\s*\(\s*\)\s*\{(?<body>.{0,8000}?)\r?\n\}'

    foreach ($tm in [regex]::Matches($Content, $tablePattern)) {
        $name = $tm.Groups['name'].Value
        $body = $tm.Groups['body'].Value

        $options = New-Object System.Collections.Generic.List[object]
        foreach ($om in [regex]::Matches($body, '\{\s*"(?<key>[^"]+)"\s*,\s*"(?<ref>[^"]+)"\s*\}')) {
            $options.Add([PSCustomObject]@{
                Key = $om.Groups['key'].Value.Trim()
                Ref = $om.Groups['ref'].Value.Trim()
            })
        }

        if ($options.Count -gt 0) {
            # .ToArray(): wrapping a List[object] in @() and assigning it through the hashtable
            # indexer fails with "Argument types do not match" on PowerShell 7.6.
            $result[$name] = $options.ToArray()
        }
    }

    return $result
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

function Get-AppendLineBlockEntries {
    param(
        [string]$Obj,
        [string]$Ref,
        [string]$Body,
        [int]$BaseIndex
    )

    $entries = New-Object System.Collections.Generic.List[object]

    # 1) Direct form: obj.append_option( ... get_option("var"[, idx]) ... );
    $directPattern = '(?s)' + [regex]::Escape($Obj) + '\.append_option\(\s*.*?get_option\("(?<variable>[^"]+)"(?:\s*,\s*(?<indexer>[^\)]+))?\)\s*\)\s*;'
    foreach ($om in [regex]::Matches($Body, $directPattern)) {
        $variable = $om.Groups['variable'].Value.Trim()
        $indexer = $om.Groups['indexer'].Value.Trim()
        if (-not [string]::IsNullOrWhiteSpace($indexer) -and $indexer -match '^[A-Za-z_]\w*$') {
            $variable = "${variable}[$indexer]"
        }

        $entries.Add([PSCustomObject]@{
            Variable = $variable
            Ref      = $Ref
            Index    = [int]($BaseIndex + $om.Index)
        })
    }

    # 2) Indirect form: Option <name> = ...get_option("var"[, idx]); ... obj.append_option(<name>);
    $optionVarMap = @{}
    $declPattern = '(?:Option|ConfigOptionDef|auto)\s+(?<name>\w+)\s*=\s*[^;]*?get_option\(\s*"(?<variable>[^"]+)"(?:\s*,\s*(?<indexer>[^\),]+))?\s*\)\s*;'
    foreach ($dm in [regex]::Matches($Body, $declPattern)) {
        $name = $dm.Groups['name'].Value
        $variable = $dm.Groups['variable'].Value.Trim()
        $indexer = $dm.Groups['indexer'].Value.Trim()
        if (-not [string]::IsNullOrWhiteSpace($indexer) -and $indexer -match '^[A-Za-z_]\w*$') {
            $variable = "${variable}[$indexer]"
        }

        $optionVarMap[$name] = $variable
    }

    if ($optionVarMap.Count -gt 0) {
        $appendVarPattern = [regex]::Escape($Obj) + '\.append_option\(\s*(?<name>\w+)\s*\)\s*;'
        foreach ($am in [regex]::Matches($Body, $appendVarPattern)) {
            $name = $am.Groups['name'].Value
            if (-not $optionVarMap.ContainsKey($name)) {
                continue
            }

            $entries.Add([PSCustomObject]@{
                Variable = $optionVarMap[$name]
                Ref      = $Ref
                Index    = [int]($BaseIndex + $am.Index)
            })
        }
    }

    return $entries
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
        'comDevelop' { return 'Developer' }
        default { return $null }
    }
}

function Remove-StaleSectionMetadata {
    param(
        [System.Collections.Generic.List[string]]$Buffer,
        [hashtable]$ExpectedAnchors,
        [string]$MetadataLinePattern
    )

    $sectionsPruned = 0
    $headings = New-Object System.Collections.Generic.List[object]

    for ($i = 0; $i -lt $Buffer.Count; $i++) {
        $line = $Buffer[$i]
        if ($line -match '^(#{1,6})\s+(.+?)\s*$') {
            $headingText = $Matches[2].Trim()
            $headingText = $headingText -replace '\s+#+$', ''
            $slug = ConvertTo-AnchorSlug -Heading $headingText
            if (-not [string]::IsNullOrWhiteSpace($slug)) {
                $headings.Add([PSCustomObject]@{
                    Index  = $i
                    Anchor = $slug
                })
            }
        }
    }

    if ($headings.Count -eq 0) {
        return 0
    }

    for ($h = $headings.Count - 1; $h -ge 0; $h--) {
        $sectionStart = $headings[$h].Index
        $sectionAnchor = $headings[$h].Anchor

        if ($ExpectedAnchors.ContainsKey($sectionAnchor)) {
            continue
        }

        $sectionEnd = if ($h -lt ($headings.Count - 1)) { $headings[$h + 1].Index - 1 } else { $Buffer.Count - 1 }
        if ($sectionEnd -le $sectionStart) {
            continue
        }

        $metadataIndexes = New-Object System.Collections.Generic.List[int]
        for ($k = $sectionStart + 1; $k -le $sectionEnd; $k++) {
            if ($Buffer[$k] -match $MetadataLinePattern) {
                $metadataIndexes.Add($k)
            }
        }

        if ($metadataIndexes.Count -eq 0) {
            continue
        }

        for ($r = $metadataIndexes.Count - 1; $r -ge 0; $r--) {
            $Buffer.RemoveAt($metadataIndexes[$r])
        }

        $sectionsPruned++
    }

    return $sectionsPruned
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
# Bound the brace block and the body span: unbounded '.*?' here backtracks catastrophically
# over Tab.cpp (~160s). Real bodies are under 500 chars, so 8000 is generous headroom.
$patternAppendLineAssignedBlock = '(?s)(?<obj>\w+)\s*=\s*\{[^{}]*?\}\s*;(?<body>.{0,8000}?)(?:\w+->)?append_line\(\s*\k<obj>\s*\)\s*;'
$patternForBlock = '(?s)for\s*\(\s*const\s+std::string\s*&\s*(?<iter>\w+)\s*:\s*(?<collection>\w+)\s*\)\s*\{(?<body>.*?)\}'
# for (const PublishablePrinterOption& opt : publishable_printer_retraction_options())
#     optgroup->append_single_option_line(opt.key, opt.icon, extruder_idx);
# Either a braced block or the single statement up to its ';'.
$patternPublishableForBlock = '(?s)for\s*\(\s*const\s+PublishablePrinterOption\s*&\s*(?<iter>\w+)\s*:\s*(?<table>\w+)\s*\(\s*\)\s*\)\s*(?<body>\{[^{}]{0,2000}\}|[^{}]{0,2000}?;)'

$singleMatches = [regex]::Matches($tabContent, $patternSingle)
$optionMatches = [regex]::Matches($tabContent, $patternOption)
$appendLineMatches = [regex]::Matches($tabContent, $patternAppendLineBlock)
$appendLineAssignedMatches = [regex]::Matches($tabContent, $patternAppendLineAssignedBlock)
$forMatches = [regex]::Matches($tabContent, $patternForBlock)
$publishableForMatches = [regex]::Matches($tabContent, $patternPublishableForBlock)
$stringVectors = Get-StringVectors -Content $tabContent

# The printer tab's Retraction/Z-Hop optgroups are built by looping over the option tables in
# libslic3r/PublishSettings.cpp, so their config key / doc ref pairs live there rather than at
# the Tab.cpp call site. Without them those sections parse as unmapped and Remove-StaleSectionMetadata
# strips their [Mode]/[Variable] lines.
$publishableOptionTables = @{}
if ($publishableForMatches.Count -gt 0) {
    $publishSettingsSource = Resolve-PublishSettingsPath -Explicit $PublishSettingsCppPath -PrintConfigPath $PrintConfigCppPath
    if ([string]::IsNullOrWhiteSpace($publishSettingsSource)) {
        Write-Host "[WARN] Cannot locate PublishSettings.cpp from '$PrintConfigCppPath'. Pass -PublishSettingsCppPath." -ForegroundColor Yellow
    }
    else {
        try {
            $publishSettingsContent = Get-CppSourceContent -Source $publishSettingsSource -Description "PublishSettings.cpp"
            $publishableOptionTables = Get-PublishablePrinterOptionTables -Content $publishSettingsContent
        }
        catch {
            Write-Host "[WARN] Could not read PublishSettings.cpp ($publishSettingsSource): $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

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

    foreach ($entry in (Get-AppendLineBlockEntries -Obj $obj -Ref $ref -Body $body -BaseIndex ([int]$m.Index))) {
        $rawEntries.Add($entry)
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

    foreach ($entry in (Get-AppendLineBlockEntries -Obj $obj -Ref $ref -Body $body -BaseIndex ([int]$m.Index))) {
        $rawEntries.Add($entry)
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

        $valueOrder = 0
        foreach ($v in $values) {
            $rawEntries.Add([PSCustomObject]@{
                Variable = "$prefix$v"
                Ref      = $ref
                Index    = [int]($fm.Index + $pm.Index)
                Order    = $valueOrder
            })
            $valueOrder++
        }
    }

    $suffixMatches = [regex]::Matches($body, $suffixPattern)
    foreach ($sm in $suffixMatches) {
        $suffix = $sm.Groups['suffix'].Value
        $ref = $sm.Groups['ref'].Value.Trim()

        $valueOrder = 0
        foreach ($v in $values) {
            $rawEntries.Add([PSCustomObject]@{
                Variable = "$v$suffix"
                Ref      = $ref
                Index    = [int]($fm.Index + $sm.Index)
                Order    = $valueOrder
            })
            $valueOrder++
        }
    }
}


foreach ($fm in $publishableForMatches) {
    $iter = $fm.Groups['iter'].Value
    $tableName = $fm.Groups['table'].Value
    $body = $fm.Groups['body'].Value

    if (-not $publishableOptionTables.ContainsKey($tableName)) {
        Write-Host "[WARN] No option table '$tableName' found in PublishSettings.cpp; its optgroup will be skipped." -ForegroundColor Yellow
        continue
    }

    $options = $publishableOptionTables[$tableName]
    $escapedIter = [regex]::Escape($iter)
    # append_single_option_line(opt.key, opt.icon[, idx]) and the append_option_line(optgroup, ...) form.
    # The struct's two fields are (key, doc ref), matching the call's own argument order.
    $singleFieldPattern = 'append_single_option_line\(\s*' + $escapedIter + '\.\w+\s*,\s*' + $escapedIter + '\.\w+(?:\s*,\s*(?<indexer>[^\),]+))?\s*\)'
    $optionFieldPattern = 'append_option_line\(\s*[^,]+\s*,\s*' + $escapedIter + '\.\w+\s*,\s*' + $escapedIter + '\.\w+(?:\s*,\s*(?<indexer>[^\),]+))?\s*\)'

    foreach ($pattern in @($singleFieldPattern, $optionFieldPattern)) {
        foreach ($am in [regex]::Matches($body, $pattern)) {
            $indexer = $am.Groups['indexer'].Value.Trim()
            $optionOrder = 0

            foreach ($option in $options) {
                $variable = $option.Key
                if (-not [string]::IsNullOrWhiteSpace($indexer) -and $indexer -match '^[A-Za-z_]\w*$') {
                    $variable = "${variable}[$indexer]"
                }

                $rawEntries.Add([PSCustomObject]@{
                    Variable = $variable
                    Ref      = $option.Ref
                    Index    = [int]($fm.Index + $am.Index)
                    Order    = $optionOrder
                })
                $optionOrder++
            }
        }
    }
}

# Sort-Object is unstable: values expanded from one source loop share an Index, so
# without -Stable and the Order tiebreak their order is decided arbitrarily and
# reshuffles whenever Tab.cpp shifts (e.g. machine_max_jerk_x/y/z/e).
$parsedMatches = @($rawEntries | Sort-Object -Property Index, Order -Stable)

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
$firstHeadingAnchorToken = '__first_heading__'
foreach ($m in $parsedMatches) {
    $variable = $m.Variable
    $baseVariable = [regex]::Match($variable, '^[^\[]+').Value
    $mode = $null
    if (-not [string]::IsNullOrWhiteSpace($baseVariable) -and $optionModesByVariable.ContainsKey($baseVariable)) {
        $mode = $optionModesByVariable[$baseVariable]
    }

    $ref = $m.Ref

    $rawFileKey = $null
    $anchor = $null
    if ($ref -match '#') {
        $parts = $ref -split '#', 2
        $rawFileKey = $parts[0].Trim()
        $anchorPart = $parts[1].Trim().ToLowerInvariant()
        if ([string]::IsNullOrWhiteSpace($anchorPart)) {
            $anchor = $firstHeadingAnchorToken
        }
        else {
            $anchor = $anchorPart
        }
    }
    else {
        $rawFileKey = $ref.Trim()
        $anchor = $firstHeadingAnchorToken
    }

    $fileKey = ConvertTo-DocFileKey -RefFile $rawFileKey

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
    Write-Host "No entries with markdown file references were found." -ForegroundColor Yellow
    Complete-SyncProgress
    exit 0
}

$changes = 0
$missingFiles = 0
$missingHeadings = 0
$alreadyPresent = 0
$normalizedSections = 0
$entriesWithMode = @($entries | Where-Object { -not [string]::IsNullOrWhiteSpace($_.Mode) }).Count
$metadataLinePattern = '^\s*(?:\[(?:Variable|Variables|Mode|Modes)\]\([^\)]+\)|`[^`]+`\s+\[(?:Variable|Variables)\]\([^\)]+\)|Variables?|Modes?)\s*:\s*'

$managedTargetPaths = @{}
foreach ($fileKey in $mdByName.Keys) {
    $candidates = $mdByName[$fileKey]
    $managedPath = $candidates[0]
    if ($candidates.Count -gt 1) {
        $managedPath = ($candidates | Sort-Object Length | Select-Object -First 1)
    }

    $managedTargetPaths[$managedPath] = $true
}

$expectedAnchorsByPath = @{}
$processedTargetPaths = @{}

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

    $processedTargetPaths[$targetPath] = $true
    if (-not $expectedAnchorsByPath.ContainsKey($targetPath)) {
        $expectedAnchorsByPath[$targetPath] = @{}
    }

    $lines = Get-Content -LiteralPath $targetPath
    $buffer = New-Object System.Collections.Generic.List[string]
    $buffer.AddRange([string[]]$lines)
    $firstHeadingIndex = Find-FirstHeadingLineIndex -Lines $buffer.ToArray()
    $firstHeadingAnchor = $null
    if ($firstHeadingIndex -ge 0 -and $buffer[$firstHeadingIndex] -match '^(#{1,6})\s+(.+?)\s*$') {
        $headingText = $Matches[2].Trim()
        $headingText = $headingText -replace '\s+#+$', ''
        $firstHeadingAnchor = ConvertTo-AnchorSlug -Heading $headingText
    }
    $fileChanged = $false

    $groupedByAnchor = $group.Group | Group-Object -Property Anchor
    $anchorCount = $groupedByAnchor.Count
    $anchorNumber = 0

    foreach ($anchorGroup in $groupedByAnchor) {
        $anchorNumber++
        Set-SyncDetail -Status "File $fileNumber/$($totalFileGroups): $fileKey | Anchor $anchorNumber/$($anchorCount): $($anchorGroup.Name)" -Current $fileNumber -Total $totalFileGroups
        $anchor = $anchorGroup.Name
        $resolvedAnchor = $anchor

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
        $variableLabel = if ($vars.Count -eq 1) { "[Variable](built_in_placeholders_variables):" } else { "[Variables](built_in_placeholders_variables):" }
        $insertVariableLine = "$variableLabel " + ($formattedVars -join ", ") + ".  "  # ending with two spaces so Markdown line break is forced

        $distinctModes = New-Object System.Collections.Generic.List[string]
        $seenModes = @{}
        $modeToVars = @{}
        $varsWithoutMode = New-Object System.Collections.Generic.List[string]

        foreach ($varName in $vars) {
            $formattedVarName = "``$varName``"
            if (-not $varModes.ContainsKey($varName)) {
                $varsWithoutMode.Add($formattedVarName)
                continue
            }

            $modeName = $varModes[$varName]
            if (-not $seenModes.ContainsKey($modeName)) {
                $seenModes[$modeName] = $true
                $distinctModes.Add($modeName)
                $modeToVars[$modeName] = New-Object System.Collections.Generic.List[string]
            }

            $modeToVars[$modeName].Add($formattedVarName)
        }

        $canonicalLines = New-Object System.Collections.Generic.List[string]

        if ($distinctModes.Count -gt 1) {
            $canonicalLines.Add("[Modes](option_mode):  ")
            foreach ($modeName in $distinctModes) {
                $modeVars = [System.Collections.Generic.List[string]]$modeToVars[$modeName]
                $groupVariableLabel = if ($modeVars.Count -eq 1) { "[Variable](built_in_placeholders_variables):" } else { "[Variables](built_in_placeholders_variables):" }
                $canonicalLines.Add("``$modeName`` $groupVariableLabel " + ($modeVars -join ", ") + ".  ")
            }

            if ($varsWithoutMode.Count -gt 0) {
                $leftoverVariableLabel = if ($varsWithoutMode.Count -eq 1) { "[Variable](built_in_placeholders_variables):" } else { "[Variables](built_in_placeholders_variables):" }
                $canonicalLines.Add("$leftoverVariableLabel " + ($varsWithoutMode -join ", ") + ".  ")
            }
        }
        else {
            $insertModeLine = $null
            if ($distinctModes.Count -gt 0) {
                $formattedModes = $distinctModes | ForEach-Object { "``$_``" }
                $modeLabel = if ($distinctModes.Count -eq 1) { "[Mode](option_mode):" } else { "[Modes](option_mode):" }
                $insertModeLine = "$modeLabel " + ($formattedModes -join ", ") + ".  "  # ending with two spaces so Markdown line break is forced
            }

            if (-not [string]::IsNullOrWhiteSpace($insertModeLine)) {
                $canonicalLines.Add($insertModeLine)
            }
            $canonicalLines.Add($insertVariableLine)
        }

        $idx = -1
        if ($anchor -eq $firstHeadingAnchorToken) {
            if ($firstHeadingIndex -lt 0 -or [string]::IsNullOrWhiteSpace($firstHeadingAnchor)) {
                $sourceRef = $anchorGroup.Group[0].Ref
                Write-Host "[WARN] First heading not found in $targetPath (from '$sourceRef')" -ForegroundColor Yellow
                $missingHeadings++
                continue
            }

            $idx = $firstHeadingIndex
            $resolvedAnchor = $firstHeadingAnchor
        }
        else {
            $idx = Find-HeadingLineIndex -Lines $buffer.ToArray() -Anchor $anchor
        }

        if ($idx -lt 0) {
            $sourceRef = $anchorGroup.Group[0].Ref
            Write-Host "[WARN] Heading anchor '$anchor' not found in $targetPath (from '$sourceRef')" -ForegroundColor Yellow
            $missingHeadings++
            continue
        }

        if (-not [string]::IsNullOrWhiteSpace($resolvedAnchor)) {
            $expectedAnchorsByPath[$targetPath][$resolvedAnchor] = $true
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

        for ($k = $idx + 1; $k -le $sectionEnd; $k++) {
            if ($buffer[$k] -match $metadataLinePattern) {
                $metadataLineIndexes.Add($k)
            }
        }

        $hasBlankBetween = ($idx + 1) -lt $buffer.Count -and [string]::IsNullOrWhiteSpace($buffer[$idx + 1])
        $metadataStart = $idx + 2
        $lastMetadataIndex = $metadataStart + $canonicalLines.Count - 1
        $hasHeadingRightAfterMetadata = ($lastMetadataIndex + 1) -lt $buffer.Count -and $buffer[$lastMetadataIndex + 1] -match '^#{1,6}\s+'
        $isCanonicalLayout = $hasBlankBetween -and $metadataLineIndexes.Count -eq $canonicalLines.Count
        if ($isCanonicalLayout) {
            for ($ci = 0; $ci -lt $canonicalLines.Count; $ci++) {
                $expectedIndex = $metadataStart + $ci
                if ($expectedIndex -ge $buffer.Count -or $metadataLineIndexes[$ci] -ne $expectedIndex -or $buffer[$expectedIndex] -ne $canonicalLines[$ci]) {
                    $isCanonicalLayout = $false
                    break
                }
            }
        }

        $alreadyCanonical = $isCanonicalLayout -and (-not $hasHeadingRightAfterMetadata)
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

        if (-not (($idx + 1) -lt $buffer.Count -and [string]::IsNullOrWhiteSpace($buffer[$idx + 1]))) {
            $buffer.Insert($idx + 1, "")
            $fileChanged = $true
        }

        $insertIndex = $idx + 2
        foreach ($metadataLine in $canonicalLines) {
            $buffer.Insert($insertIndex, $metadataLine)
            $insertIndex++
        }

        if ($insertIndex -lt $buffer.Count -and $buffer[$insertIndex] -match '^#{1,6}\s+') {
            $buffer.Insert($insertIndex, "")
            $fileChanged = $true
        }

        $changes++
        $fileChanged = $true
    }

    $staleSectionsPruned = Remove-StaleSectionMetadata -Buffer $buffer -ExpectedAnchors $expectedAnchorsByPath[$targetPath] -MetadataLinePattern $metadataLinePattern
    if ($staleSectionsPruned -gt 0) {
        $normalizedSections += $staleSectionsPruned
        $fileChanged = $true
    }

    if ($fileChanged -and -not $DryRun) {
        Set-Content -LiteralPath $targetPath -Value $buffer -Encoding UTF8
    }
}

foreach ($managedTargetPath in $managedTargetPaths.Keys) {
    if ($processedTargetPaths.ContainsKey($managedTargetPath)) {
        continue
    }

    $lines = Get-Content -LiteralPath $managedTargetPath
    $buffer = New-Object System.Collections.Generic.List[string]
    $buffer.AddRange([string[]]$lines)

    $expectedAnchors = @{}
    if ($expectedAnchorsByPath.ContainsKey($managedTargetPath)) {
        $expectedAnchors = $expectedAnchorsByPath[$managedTargetPath]
    }

    $staleSectionsPruned = Remove-StaleSectionMetadata -Buffer $buffer -ExpectedAnchors $expectedAnchors -MetadataLinePattern $metadataLinePattern
    if ($staleSectionsPruned -le 0) {
        continue
    }

    $normalizedSections += $staleSectionsPruned
    if (-not $DryRun) {
        Set-Content -LiteralPath $managedTargetPath -Value $buffer -Encoding UTF8
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
