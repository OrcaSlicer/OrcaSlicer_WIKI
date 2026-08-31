<#
.SYNOPSIS
    Insert/refresh [Type], [Options] and [CLI Example] tags on the wiki's
    print/printer/material settings pages, from the option definitions in
    libslic3r/PrintConfig.cpp.

.DESCRIPTION
    The [Type] counterpart to sync-tab-options-to-wiki.ps1's [Mode]/[Variable]
    sync — only touches headings that already carry a [Variable] tag; never
    places one itself. PowerShell port of sync_option_types_to_wiki.py, which
    remains the reference implementation.

.PARAMETER PrintConfigCppPath
    URL or local path to PrintConfig.cpp.

.PARAMETER OverridesPath
    JSON file of manual key metadata overrides (for loop-generated keys with
    no literal this->add(...) call, e.g. machine_max_jerk_x). Relative paths
    are resolved against -WikiRoot.

.PARAMETER WikiRoot
    Wiki repo root. Defaults to the script's own directory.

.PARAMETER DryRun
    Preview only -- do not write changes to disk.

.PARAMETER Check
    Exit 1 if any page is stale, or references a key not found in the
    source/overrides. For CI. Implies -DryRun.

.PARAMETER Coverage
    Also report keys with no [Variable] tag anywhere on the wiki.

.PARAMETER SelfTest
    Verify extraction against a subset of known-good values, then exit.

.EXAMPLE
    pwsh ./sync-option-types-to-wiki.ps1 -DryRun
    pwsh ./sync-option-types-to-wiki.ps1
    pwsh ./sync-option-types-to-wiki.ps1 -Check
    pwsh ./sync-option-types-to-wiki.ps1 -PrintConfigCppPath ../OrcaSlicer/src/libslic3r/PrintConfig.cpp
#>
param(
    [string]$PrintConfigCppPath = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/PrintConfig.cpp",
    [string]$OverridesPath = "option_type_overrides.json",
    [string]$WikiRoot = $PSScriptRoot,
    [switch]$DryRun,
    [switch]$Check,
    [switch]$Coverage,
    [switch]$SelfTest
)

$ErrorActionPreference = 'Stop'

if ($Check) { $DryRun = $true }

$TypeMap = @{
    'coBool' = 'Boolean'; 'coBools' = 'Boolean list'
    'coInt' = 'Integer'; 'coInts' = 'Integer list'
    'coFloat' = 'Float'; 'coFloats' = 'Float list'
    'coPercent' = 'Percentage'; 'coPercents' = 'Percentage list'
    'coFloatOrPercent' = 'Float or Percentage'; 'coFloatsOrPercents' = 'Float or Percentage list'
    'coString' = 'Text'; 'coStrings' = 'Text list'
    'coEnum' = 'Choice'; 'coEnums' = 'Choice list'
    'coPoint' = 'Point'; 'coPoints' = 'Point list'
    'coPointsGroups' = 'Point group list'
}

$TypeAnchor = @{
    'Boolean' = 'boolean'
    'Integer' = 'integer-float-percentage'
    'Float' = 'integer-float-percentage'
    'Percentage' = 'integer-float-percentage'
    'Float or Percentage' = 'integer-float-percentage'
    'Text' = 'text'
    'Choice' = 'choice'
    'Point' = 'point'
}
$ListAnchor = 'list-types'

# Past this many distinct types (or keys), log "needs manual review" instead
# of an auto-generated per-key breakdown.
$MaxMixedTypeKeys = 6

# Headings restructured by hand into sub-headings with no [Variable] tag of
# their own, so this script has no association to work from.
$ManualHoldouts = @{
    'print_settings/quality/quality_settings_seam.md' = @('Scarf joint seam')
    'print_settings/quality/quality_settings_wall_and_surfaces.md' = @('Surface flow ratio')
}

$SettingsDirs = @('print_settings', 'printer_settings', 'material_settings')

$HeadingPattern = '^(#{1,6})\s+(.+?)\s*$'
$KeyInBackticksPattern = '`(?<key>[a-zA-Z0-9_]+)(\[[a-zA-Z_]+\])?`'
$AddPattern = '(?:auto\s+(?<varname>\w+)\s*=\s*)?def\s*=\s*this->add(?:_nullable)?\("(?<key>[a-zA-Z0-9_]+)",\s*(?<typ>co\w+)\)'
$EnumPushPattern = 'enum_values\.(?:push_back|emplace_back)\(\s*(?:L\()?"(?<v>[^"]*)"\)?\)'
$EnumBracePattern = 'enum_values\s*=\s*\{(?<vals>[^}]*)\}'
$EnumRefPattern = 'enum_values\s*=\s*(?<ref>\w+)->enum_values'
$QuotedStrPattern = '"(?<v>[^"]*)"'
$DefaultStrPattern = 'set_default_value\(\s*new\s+ConfigOptionString\w*\s*\(\s*"(?<v>[^"]*)"'
$CliCutoffMarker = 'CLIActionsConfigDef::CLIActionsConfigDef'

# Must match Update-WikiFile's block-detector verbatim: unlike every other
# generated line these don't start with a [Tag], so a re-run needs to
# recognize them by exact text to replace rather than duplicate them.
$NocliAllNote = 'Not available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  '
$NocliAllNoteMixed = 'None of the variables above are available via CLI — see [Setting Overrides](cli_mode#setting-overrides) for the full list of excluded keys.  '

function Get-CppSourceText {
    param(
        [string]$Source,
        [string]$Description
    )

    if ($Source -match '^https?://') {
        $url = $Source
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

function Remove-CppComments {
    # Without this, a commented-out this->add(...) (e.g. adaptive_layer_height,
    # a disabled feature, not a typo) gets extracted as if live. Tracks
    # string-literal state so a "//" inside a quoted tooltip isn't mistaken
    # for a comment start.
    param([string]$Text)

    $sb = [System.Text.StringBuilder]::new($Text.Length)
    $n = $Text.Length
    $i = 0
    $inString = $false

    while ($i -lt $n) {
        $c = $Text[$i]

        if ($inString) {
            [void]$sb.Append($c)
            if ($c -eq '\' -and ($i + 1) -lt $n) {
                [void]$sb.Append($Text[$i + 1])
                $i += 2
                continue
            }
            if ($c -eq '"') { $inString = $false }
            $i++
            continue
        }

        if ($c -eq '"') {
            $inString = $true
            [void]$sb.Append($c)
            $i++
            continue
        }

        if ($c -eq '/' -and ($i + 1) -lt $n -and $Text[$i + 1] -eq '/') {
            $j = $Text.IndexOf("`n", $i)
            if ($j -eq -1) { break }
            [void]$sb.Append("`n")
            $i = $j + 1
            continue
        }

        if ($c -eq '/' -and ($i + 1) -lt $n -and $Text[$i + 1] -eq '*') {
            $j = $Text.IndexOf('*/', $i + 2)
            if ($j -eq -1) { break }
            $newlineCount = ($Text.Substring($i, ($j + 2) - $i) -split "`n").Count - 1
            [void]$sb.Append("`n" * $newlineCount)
            $i = $j + 2
            continue
        }

        [void]$sb.Append($c)
        $i++
    }

    return $sb.ToString()
}

# ---------------------------------------------------------------------------
# Key metadata extraction
# ---------------------------------------------------------------------------

function Get-KeyMetadata {
    param([string]$SourceText)

    $clean = Remove-CppComments -Text $SourceText
    $cutoff = $clean.IndexOf($CliCutoffMarker)
    $main = if ($cutoff -ne -1) { $clean.Substring(0, $cutoff) } else { $clean }

    $addMatches = [regex]::Matches($main, $AddPattern)
    if ($addMatches.Count -eq 0) {
        return @{}
    }

    $positions = New-Object System.Collections.Generic.List[object]
    foreach ($m in $addMatches) {
        $positions.Add([PSCustomObject]@{
            Index   = $m.Index
            VarName = $m.Groups['varname'].Value
            Key     = $m.Groups['key'].Value
            Typ     = $m.Groups['typ'].Value
        })
    }

    $varnameToKey = @{}
    foreach ($p in $positions) {
        if (-not [string]::IsNullOrEmpty($p.VarName)) {
            $varnameToKey[$p.VarName] = $p.Key
        }
    }

    $data = @{}
    $pendingRefs = @{}

    for ($i = 0; $i -lt $positions.Count; $i++) {
        $p = $positions[$i]
        $blockEndIdx = if (($i + 1) -lt $positions.Count) { $positions[$i + 1].Index } else { $main.Length }
        $block = $main.Substring($p.Index, $blockEndIdx - $p.Index)

        $enumValues = New-Object System.Collections.Generic.List[string]
        if ($p.Typ -eq 'coEnum' -or $p.Typ -eq 'coEnums') {
            foreach ($em in [regex]::Matches($block, $EnumPushPattern)) {
                $enumValues.Add($em.Groups['v'].Value)
            }
            if ($enumValues.Count -eq 0) {
                $bm = [regex]::Match($block, $EnumBracePattern)
                if ($bm.Success) {
                    foreach ($qm in [regex]::Matches($bm.Groups['vals'].Value, $QuotedStrPattern)) {
                        $enumValues.Add($qm.Groups['v'].Value)
                    }
                }
            }
            if ($enumValues.Count -eq 0) {
                $rm = [regex]::Match($block, $EnumRefPattern)
                if ($rm.Success) {
                    $pendingRefs[$p.Key] = $rm.Groups['ref'].Value
                }
            }
        }

        $default = $null
        if ($p.Typ -eq 'coString' -or $p.Typ -eq 'coStrings') {
            $dm = [regex]::Match($block, $DefaultStrPattern)
            if ($dm.Success -and $dm.Groups['v'].Value) {
                $default = $dm.Groups['v'].Value
            }
        }

        $typeLabel = if ($TypeMap.ContainsKey($p.Typ)) { $TypeMap[$p.Typ] } else { $p.Typ }

        $data[$p.Key] = [PSCustomObject]@{
            Type       = $p.Typ
            TypeLabel  = $typeLabel
            EnumValues = @($enumValues)
            Default    = $default
            NoCli      = $block.Contains('def->cli = ConfigOptionDef::nocli;')
        }
    }

    foreach ($key in @($pendingRefs.Keys)) {
        $varname = $pendingRefs[$key]
        if ($varnameToKey.ContainsKey($varname)) {
            $refKey = $varnameToKey[$varname]
            if ($data.ContainsKey($refKey) -and $data[$refKey].EnumValues.Count -gt 0) {
                $data[$key].EnumValues = $data[$refKey].EnumValues
            }
        }
    }

    return $data
}

function Find-EmptyEnumKeys {
    param([hashtable]$KeyData)

    $result = New-Object System.Collections.Generic.List[string]
    foreach ($key in $KeyData.Keys) {
        $meta = $KeyData[$key]
        if (($meta.Type -eq 'coEnum' -or $meta.Type -eq 'coEnums') -and $meta.EnumValues.Count -eq 0) {
            $result.Add($key)
        }
    }
    return @($result | Sort-Object)
}

function Find-UndocumentedKeys {
    param(
        [hashtable]$KeyData,
        [string[]]$Files
    )

    $documented = New-Object System.Collections.Generic.HashSet[string]
    foreach ($path in $Files) {
        $content = Get-Content -LiteralPath $path -Raw
        foreach ($line in ($content -split "`r?`n")) {
            if ($line -notmatch '\[Variable') { continue }
            foreach ($m in [regex]::Matches($line, $KeyInBackticksPattern)) {
                [void]$documented.Add($m.Groups['key'].Value)
            }
        }
    }

    $result = New-Object System.Collections.Generic.List[string]
    foreach ($key in $KeyData.Keys) {
        if (-not $KeyData[$key].NoCli -and -not $documented.Contains($key)) {
            $result.Add($key)
        }
    }
    return @($result | Sort-Object)
}

# ---------------------------------------------------------------------------
# Overrides
# ---------------------------------------------------------------------------

function Import-Overrides {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return @{}
    }

    $json = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    $result = @{}
    foreach ($prop in $json.PSObject.Properties) {
        $key = $prop.Name
        $entry = $prop.Value
        $typ = if ($entry.PSObject.Properties.Match('type').Count -gt 0) { $entry.type } else { $null }
        $typeLabel = if ($entry.PSObject.Properties.Match('type_label').Count -gt 0) {
            $entry.type_label
        }
        elseif ($typ -and $TypeMap.ContainsKey($typ)) {
            $TypeMap[$typ]
        }
        else {
            $typ
        }
        $enumValues = if ($entry.PSObject.Properties.Match('enum_values').Count -gt 0) { @($entry.enum_values) } else { @() }
        $default = if ($entry.PSObject.Properties.Match('default').Count -gt 0) { $entry.default } else { $null }
        $nocli = if ($entry.PSObject.Properties.Match('nocli').Count -gt 0) { [bool]$entry.nocli } else { $false }

        $result[$key] = [PSCustomObject]@{
            Type       = $typ
            TypeLabel  = $typeLabel
            EnumValues = $enumValues
            Default    = $default
            NoCli      = $nocli
        }
    }
    return $result
}

# ---------------------------------------------------------------------------
# Line builders
# ---------------------------------------------------------------------------

function Get-TypeBaseAndIsList {
    param([string]$TypeLabel)

    if ($TypeLabel.EndsWith(' list')) {
        return @($TypeLabel.Substring(0, $TypeLabel.Length - 5), $true)
    }
    return @($TypeLabel, $false)
}

function ConvertTo-QuotedIfNeeded {
    param([string]$Value)
    if ($Value -match '\s') { return "`"$Value`"" }
    return $Value
}

function Get-CliExampleValue {
    param($Meta)

    $baseIsList = Get-TypeBaseAndIsList -TypeLabel $Meta.TypeLabel
    $base = $baseIsList[0]

    switch ($base) {
        'Choice' {
            if ($Meta.EnumValues.Count -gt 0) { return (ConvertTo-QuotedIfNeeded -Value $Meta.EnumValues[0]) }
            return 'value'
        }
        'Boolean' { return '1' }
        'Integer' { return '1' }
        'Float' { return '1' }
        'Percentage' { return '20%' }
        'Float or Percentage' { return '20%' }
        'Text' {
            $d = $Meta.Default
            if ($d -and $d -notmatch '\s' -and $d -notmatch '"' -and $d.Trim()) { return $d }
            return 'value'
        }
        'Point' { return '100,100' }
        default { return 'value' }
    }
}

function Get-TypeAnchor {
    param([string]$TypeLabel)

    $baseIsList = Get-TypeBaseAndIsList -TypeLabel $TypeLabel
    $base = $baseIsList[0]
    $isList = $baseIsList[1]
    if ($isList) { return $ListAnchor }
    if ($TypeAnchor.ContainsKey($base)) { return $TypeAnchor[$base] }
    return 'choice'
}

function Build-CliExampleLines {
    param(
        [string[]]$Keys,
        [object[]]$Metas
    )

    $nonNocli = New-Object System.Collections.Generic.List[object]
    for ($i = 0; $i -lt $Keys.Count; $i++) {
        if (-not $Metas[$i].NoCli) { $nonNocli.Add(@($Keys[$i], $Metas[$i])) }
    }

    if ($nonNocli.Count -eq 0) {
        return @($NocliAllNote)
    }

    $exampleKey = $nonNocli[0][0]
    $exampleMeta = $nonNocli[0][1]
    $val = Get-CliExampleValue -Meta $exampleMeta
    $flag = "--$($exampleKey.Replace('_', '-'))=$val"

    $excluded = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $Keys.Count; $i++) {
        if ($Metas[$i].NoCli) { $excluded.Add($Keys[$i]) }
    }

    $suffix = ''
    if ($Keys.Count -eq 1) {
        $suffix = ''
    }
    elseif ($excluded.Count -gt 0) {
        $verb = if ($excluded.Count -eq 1) { 'is' } else { 'are' }
        $excludedList = ($excluded | ForEach-Object { "``$_``" }) -join ', '
        $suffix = " ($excludedList $verb not available via CLI; same pattern for the rest)"
    }
    else {
        $suffix = ' (same pattern for the other variables above)'
    }

    return @("[CLI Example](cli_mode#setting-overrides): ``$flag``$suffix.  ")
}

function Build-LinesUniform {
    param(
        [string[]]$Keys,
        [object[]]$Metas
    )

    $typeLabel = $Metas[0].TypeLabel
    $baseIsList = Get-TypeBaseAndIsList -TypeLabel $typeLabel
    $base = $baseIsList[0]

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("[Type](option_type#$(Get-TypeAnchor -TypeLabel $typeLabel)): ``$typeLabel``.  ")

    if ($base -eq 'Choice') {
        $enumLists = $Metas | ForEach-Object { ($_.EnumValues -join "`u{1}") }
        $allNonEmpty = -not ($Metas | Where-Object { $_.EnumValues.Count -eq 0 })
        $distinct = @($enumLists | Select-Object -Unique)
        if ($allNonEmpty -and $distinct.Count -eq 1) {
            $lines.Add("[Options](option_type#choice): ``$($Metas[0].EnumValues -join ', ')``.  ")
        }
    }

    foreach ($l in (Build-CliExampleLines -Keys $Keys -Metas $Metas)) {
        $lines.Add($l)
    }

    return @($lines)
}

function Build-LinesMixed {
    param(
        [string[]]$Keys,
        [object[]]$Metas
    )

    $parts = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $Keys.Count; $i++) {
        $k = $Keys[$i]
        $m = $Metas[$i]
        $baseIsList = Get-TypeBaseAndIsList -TypeLabel $m.TypeLabel
        $base = $baseIsList[0]
        $suffix = if ($m.NoCli) { ', not available via CLI' } else { '' }
        if ($base -eq 'Choice' -and $m.EnumValues.Count -gt 0) {
            $parts.Add("``$k`` ($($m.TypeLabel): $($m.EnumValues -join ', ')$suffix)")
        }
        else {
            $parts.Add("``$k`` ($($m.TypeLabel)$suffix)")
        }
    }

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("[Type](option_type): $($parts -join ', ').  ")

    $nonNocli = New-Object System.Collections.Generic.List[object]
    for ($i = 0; $i -lt $Keys.Count; $i++) {
        if (-not $Metas[$i].NoCli) { $nonNocli.Add(@($Keys[$i], $Metas[$i])) }
    }

    if ($nonNocli.Count -eq 0) {
        $lines.Add($NocliAllNoteMixed)
        return @($lines)
    }

    $exampleKey = $nonNocli[0][0]
    $exampleMeta = $nonNocli[0][1]
    $val = Get-CliExampleValue -Meta $exampleMeta
    $flag = "--$($exampleKey.Replace('_', '-'))=$val"
    $lines.Add("[CLI Example](cli_mode#setting-overrides): ``$flag`` (``$exampleKey`` shown; other variables above follow their own type).  ")

    return @($lines)
}

# ---------------------------------------------------------------------------
# Per-file processing
# ---------------------------------------------------------------------------

function Test-LinesEqual {
    param([string[]]$A, [string[]]$B)
    if ($A.Count -ne $B.Count) { return $false }
    for ($i = 0; $i -lt $A.Count; $i++) {
        if (-not [string]::Equals($A[$i], $B[$i], [System.StringComparison]::Ordinal)) { return $false }
    }
    return $true
}

function Update-WikiFile {
    param(
        [string]$Path,
        [string]$RelPath,
        [hashtable]$KeyData,
        $Stats,
        [System.Collections.Generic.List[object]]$UnmatchedReview,
        [System.Collections.Generic.List[object]]$ManualReview,
        [bool]$DoWrite
    )

    $originalLines = @(Get-Content -LiteralPath $Path)

    $heads = New-Object System.Collections.Generic.List[object]
    for ($i = 0; $i -lt $originalLines.Count; $i++) {
        if ($originalLines[$i] -match $HeadingPattern) {
            $heads.Add([PSCustomObject]@{ Index = $i; Text = $Matches[2].Trim() })
        }
    }

    $holdouts = if ($ManualHoldouts.ContainsKey($RelPath)) { $ManualHoldouts[$RelPath] } else { @() }

    $buffer = New-Object System.Collections.Generic.List[string]
    $buffer.AddRange([string[]]$originalLines)
    $offset = 0
    $changed = $false

    for ($idx = 0; $idx -lt $heads.Count; $idx++) {
        $i = $heads[$idx].Index
        $text = $heads[$idx].Text
        $Stats.headings_scanned++
        $end = if (($idx + 1) -lt $heads.Count) { $heads[$idx + 1].Index } else { $originalLines.Count }

        $j = $i + 1
        if ($j -lt $end -and $originalLines[$j].Trim() -eq '') { $j++ }
        $blockStart = $j
        $blockEnd = $j
        $hasVariableLine = $false
        $generatedStart = $null

        while ($blockEnd -lt $end) {
            $stripped = $originalLines[$blockEnd].Trim()
            $isGeneratedTagLine = $stripped.StartsWith('[Type]') -or $stripped.StartsWith('[Options]') -or $stripped.StartsWith('[CLI Example]')
            $isGeneratedNocliNote = ($originalLines[$blockEnd] -ceq $NocliAllNote) -or ($originalLines[$blockEnd] -ceq $NocliAllNoteMixed)

            if ($isGeneratedTagLine -or $isGeneratedNocliNote) {
                if ($null -eq $generatedStart) { $generatedStart = $blockEnd }
                $blockEnd++
                continue
            }
            if ($stripped.StartsWith('[Mode]') -or $stripped.StartsWith('[Modes]') -or $stripped.Contains('[Variable')) {
                if ($stripped.Contains('[Variable')) { $hasVariableLine = $true }
                $blockEnd++
                continue
            }
            break
        }

        if (-not $hasVariableLine) {
            $Stats.no_variable_tag++
            continue
        }
        if ($holdouts -contains $text) {
            $Stats.manual_holdout++
            continue
        }

        $keysInOrder = New-Object System.Collections.Generic.List[string]
        for ($k = $blockStart; $k -lt $blockEnd; $k++) {
            $stripped = $originalLines[$k].Trim()
            if (-not $stripped.Contains('[Variable')) { continue }
            $marker = 'built_in_placeholders_variables):'
            $pos = $stripped.IndexOf($marker)
            $remainder = if ($pos -ge 0) { $stripped.Substring($pos + $marker.Length) } else { $stripped }
            foreach ($m in [regex]::Matches($remainder, $KeyInBackticksPattern)) {
                $k2 = $m.Groups['key'].Value
                if (-not $keysInOrder.Contains($k2)) { $keysInOrder.Add($k2) }
            }
        }

        if ($keysInOrder.Count -eq 0) {
            $Stats.no_variable_tag++
            continue
        }

        $missing = @($keysInOrder | Where-Object { -not $KeyData.ContainsKey($_) })
        if ($missing.Count -gt 0) {
            $UnmatchedReview.Add([PSCustomObject]@{ RelPath = $RelPath; Heading = $text; Missing = $missing })
            $Stats.unmatched_key++
            continue
        }

        $metas = @($keysInOrder | ForEach-Object { $KeyData[$_] })
        $types = @($metas | ForEach-Object { $_.TypeLabel } | Select-Object -Unique)

        $insertLines = $null
        if ($types.Count -eq 1) {
            $insertLines = Build-LinesUniform -Keys @($keysInOrder) -Metas $metas
        }
        elseif ($keysInOrder.Count -le $MaxMixedTypeKeys) {
            $insertLines = Build-LinesMixed -Keys @($keysInOrder) -Metas $metas
        }
        else {
            $ManualReview.Add([PSCustomObject]@{ RelPath = $RelPath; Heading = $text; Keys = @($keysInOrder); Types = @($types | Sort-Object) })
            $Stats.needs_manual_review++
            continue
        }

        $existingGenStart = if ($null -ne $generatedStart) { $generatedStart + $offset } else { $null }
        $existingGenEnd = $blockEnd + $offset
        $insertAt = if ($null -ne $existingGenStart) { $existingGenStart } else { $blockEnd + $offset }

        if ($null -ne $existingGenStart) {
            $oldBlock = @($buffer.GetRange($existingGenStart, $existingGenEnd - $existingGenStart))
            if (Test-LinesEqual -A $oldBlock -B $insertLines) {
                $Stats.already_current++
                continue
            }
            $buffer.RemoveRange($existingGenStart, $existingGenEnd - $existingGenStart)
            $buffer.InsertRange($existingGenStart, [string[]]$insertLines)
            $offset += $insertLines.Count - ($existingGenEnd - $existingGenStart)
            $Stats.refreshed++
        }
        else {
            $buffer.InsertRange($insertAt, [string[]]$insertLines)
            $offset += $insertLines.Count
            $Stats.inserted++
        }
        $changed = $true
    }

    if ($changed -and $DoWrite) {
        Set-Content -LiteralPath $Path -Value $buffer -Encoding UTF8
    }

    return $changed
}

# ---------------------------------------------------------------------------
# Self-test (subset of the Python script's SELFTEST_CASES)
# ---------------------------------------------------------------------------

function Invoke-SelfTest {
    param([hashtable]$KeyData)

    $failures = New-Object System.Collections.Generic.List[string]

    function Test-Case {
        param([string]$Key, [string]$Check, $Expected)

        if ($Check -eq 'not_extracted') {
            if ($KeyData.ContainsKey($Key)) {
                $failures.Add("$Key`: extracted as a live option, but it's commented out in the source")
            }
            return
        }
        if (-not $KeyData.ContainsKey($Key)) {
            $failures.Add("$Key`: not found at all")
            return
        }
        $meta = $KeyData[$Key]
        switch ($Check) {
            'type' {
                if ($meta.Type -ne $Expected) { $failures.Add("$Key`: type=$($meta.Type), expected $Expected") }
            }
            'enum_values_len' {
                if ($meta.EnumValues.Count -ne $Expected) { $failures.Add("$Key`: $($meta.EnumValues.Count) enum values, expected $Expected") }
            }
            'enum_values_contains' {
                if ($meta.EnumValues -notcontains $Expected) { $failures.Add("$Key`: enum_values does not contain '$Expected'") }
            }
            'enum_values_equals_key' {
                $other = $KeyData[$Expected]
                if (-not $other -or -not (Test-LinesEqual -A @($meta.EnumValues) -B @($other.EnumValues))) {
                    $failures.Add("$Key`: enum_values doesn't match $Expected's (copied-reference resolution broken)")
                }
            }
            'nocli' {
                if ($meta.NoCli -ne $Expected) { $failures.Add("$Key`: nocli=$($meta.NoCli), expected $Expected") }
            }
        }
    }

    Test-Case -Key 'seam_position' -Check 'type' -Expected 'coEnum'
    Test-Case -Key 'input_shaping_type' -Check 'enum_values_len' -Expected 13
    Test-Case -Key 'sparse_infill_pattern' -Check 'enum_values_len' -Expected 26
    Test-Case -Key 'retract_lift_enforce' -Check 'enum_values_contains' -Expected 'All Surfaces'
    Test-Case -Key 'nozzle_volume_type' -Check 'enum_values_contains' -Expected 'High Flow'
    Test-Case -Key 'brim_type' -Check 'enum_values_len' -Expected 7
    Test-Case -Key 'use_relative_e_distances' -Check 'type' -Expected 'coBool'
    Test-Case -Key 'bottom_surface_pattern' -Check 'enum_values_equals_key' -Expected 'top_surface_pattern'
    Test-Case -Key 'machine_max_jerk_x' -Check 'type' -Expected 'coFloats'
    Test-Case -Key 'bbl_use_printhost' -Check 'nocli' -Expected $true
    Test-Case -Key 'filament_vendor' -Check 'nocli' -Expected $true
    Test-Case -Key 'use_relative_e_distances' -Check 'nocli' -Expected $false
    Test-Case -Key 'upward_compatible_machine' -Check 'nocli' -Expected $false
    Test-Case -Key 'adaptive_layer_height' -Check 'not_extracted' -Expected $null
    Test-Case -Key 'spaghetti_detector' -Check 'not_extracted' -Expected $null
    Test-Case -Key 'filament_extruder_id' -Check 'not_extracted' -Expected $null
    Test-Case -Key 'filament_settings_id' -Check 'nocli' -Expected $false
    Test-Case -Key 'print_settings_id' -Check 'nocli' -Expected $false
    Test-Case -Key 'printer_settings_id' -Check 'nocli' -Expected $false

    if ($KeyData.ContainsKey('bbl_use_printhost')) {
        $lines = Build-LinesUniform -Keys @('bbl_use_printhost') -Metas @($KeyData['bbl_use_printhost'])
        $joined = $lines -join "`n"
        if ($joined -match '\[CLI Example\]') {
            $failures.Add('Build-LinesUniform: wrote a [CLI Example] for an all-nocli single-key group (bbl_use_printhost)')
        }
        if ($joined -notmatch 'Not available via CLI') {
            $failures.Add("Build-LinesUniform: missing the 'Not available via CLI' note for bbl_use_printhost")
        }
    }
    if ($KeyData.ContainsKey('bbl_use_printhost') -and $KeyData.ContainsKey('use_relative_e_distances')) {
        $lines = Build-LinesMixed -Keys @('bbl_use_printhost', 'use_relative_e_distances') -Metas @($KeyData['bbl_use_printhost'], $KeyData['use_relative_e_distances'])
        $joined = $lines -join "`n"
        if ($joined -match '--bbl-use-printhost=') {
            $failures.Add('Build-LinesMixed: picked a nocli key (bbl_use_printhost) as the [CLI Example] instead of skipping to a usable one')
        }
    }

    return @($failures)
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

if (-not (Test-Path -LiteralPath $WikiRoot)) {
    throw "Wiki root not found: $WikiRoot"
}

Write-Host "Reading option definitions from $PrintConfigCppPath ..." -ForegroundColor Cyan
$sourceText = Get-CppSourceText -Source $PrintConfigCppPath -Description 'PrintConfig.cpp'
$keyData = Get-KeyMetadata -SourceText $sourceText

$resolvedOverridesPath = if ([System.IO.Path]::IsPathRooted($OverridesPath)) { $OverridesPath } else { Join-Path $WikiRoot $OverridesPath }
$overrides = Import-Overrides -Path $resolvedOverridesPath
foreach ($k in $overrides.Keys) { $keyData[$k] = $overrides[$k] }
Write-Host "$($keyData.Count) option keys known ($($overrides.Count) from overrides)." -ForegroundColor Cyan

if ($SelfTest) {
    $failures = Invoke-SelfTest -KeyData $keyData
    if ($failures.Count -gt 0) {
        Write-Host "`nSELFTEST FAILED ($($failures.Count)):" -ForegroundColor Red
        foreach ($f in $failures) { Write-Host "  $f" -ForegroundColor Red }
        exit 1
    }
    Write-Host "selftest passed." -ForegroundColor Green
    exit 0
}

$emptyEnums = Find-EmptyEnumKeys -KeyData $keyData
if ($emptyEnums.Count -gt 0) {
    Write-Host "`nWARNING: $($emptyEnums.Count) Choice-type key(s) resolved to zero enum values -- PrintConfig.cpp is likely using a new enum-definition style Get-KeyMetadata doesn't handle yet:" -ForegroundColor Yellow
    foreach ($k in $emptyEnums) { Write-Host "  $k" -ForegroundColor Yellow }
}

$files = New-Object System.Collections.Generic.List[string]
foreach ($d in $SettingsDirs) {
    $dirPath = Join-Path $WikiRoot $d
    if (Test-Path -LiteralPath $dirPath) {
        Get-ChildItem -LiteralPath $dirPath -Recurse -File -Filter '*.md' | ForEach-Object { $files.Add($_.FullName) }
    }
}

if ($Coverage) {
    $undocumented = Find-UndocumentedKeys -KeyData $keyData -Files @($files)
    Write-Host "`n$($undocumented.Count) key(s) have no [Variable] tag anywhere on the wiki:" -ForegroundColor Cyan
    foreach ($k in $undocumented) { Write-Host "  $k" -ForegroundColor Cyan }
}

$stats = [ordered]@{
    headings_scanned = 0; no_variable_tag = 0; unmatched_key = 0
    manual_holdout = 0; needs_manual_review = 0
    already_current = 0; refreshed = 0; inserted = 0
}
$unmatchedReview = New-Object System.Collections.Generic.List[object]
$manualReview = New-Object System.Collections.Generic.List[object]

$sortedFiles = @($files | Sort-Object)
$fileNumber = 0
foreach ($path in $sortedFiles) {
    $fileNumber++
    Write-Progress -Activity 'sync-option-types-to-wiki.ps1' -Status "File $fileNumber/$($sortedFiles.Count)" -PercentComplete ([int](($fileNumber / [double]$sortedFiles.Count) * 100))
    $relPath = [System.IO.Path]::GetRelativePath($WikiRoot, $path) -replace '\\', '/'
    [void](Update-WikiFile -Path $path -RelPath $relPath -KeyData $keyData -Stats $stats -UnmatchedReview $unmatchedReview -ManualReview $manualReview -DoWrite (-not $DryRun))
}
Write-Progress -Activity 'sync-option-types-to-wiki.ps1' -Completed

$stats | ConvertTo-Json | Write-Host

if ($unmatchedReview.Count -gt 0) {
    Write-Host "`n=== keys not found in source or overrides ($($unmatchedReview.Count)) ===" -ForegroundColor Yellow
    foreach ($r in $unmatchedReview) {
        Write-Host "  $($r.RelPath) :: $($r.Heading) :: $($r.Missing -join ', ')  (add to $OverridesPath if it's loop-generated)" -ForegroundColor Yellow
    }
}

if ($manualReview.Count -gt 0) {
    Write-Host "`n=== headings too large/mixed for auto breakdown ($($manualReview.Count)) ===" -ForegroundColor Yellow
    foreach ($r in $manualReview) {
        Write-Host "  $($r.RelPath) :: $($r.Heading) :: $($r.Keys.Count) keys, types=$($r.Types -join ', ')" -ForegroundColor Yellow
    }
}

if ($DryRun) {
    Write-Host "`nDry run only. No files were modified." -ForegroundColor Cyan
}

if ($Check) {
    if ($stats.refreshed -or $stats.inserted -or $stats.unmatched_key) {
        exit 1
    }
    exit 0
}

if ($DryRun -and ($stats.refreshed -or $stats.inserted)) {
    Write-Host "`n$($stats.inserted) to insert, $($stats.refreshed) to refresh. Re-run without -DryRun to write." -ForegroundColor Cyan
}
