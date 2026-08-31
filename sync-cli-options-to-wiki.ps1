<#
.SYNOPSIS
    Regenerate cli/cli_actions.md, cli/cli_transform.md, and cli/cli_misc.md
    from the CLIActionsConfigDef / CLITransformConfigDef / CLIMiscConfigDef
    option definitions in libslic3r/PrintConfig.cpp.

.DESCRIPTION
    Each of the three C++ classes maps 1:1 to one wiki page (fixed by
    $ClassMarkers). The script only ever derives the flag NAME mechanically;
    every option's group/input/description/notes prose comes from
    cli_option_overrides.json (which also holds page-level scaffolding under
    "_pages"). A key with no overrides entry is reported as a gap.

    PowerShell port of sync_cli_options_to_wiki.py, which remains the
    reference implementation.

.PARAMETER PrintConfigCppPath
    URL or local path to PrintConfig.cpp.

.PARAMETER OverridesPath
    JSON file of page scaffolding + per-option prose. Relative paths are
    resolved against -WikiRoot.

.PARAMETER WikiRoot
    Wiki repo root. Defaults to the script's own directory.

.PARAMETER DryRun
    Preview only -- do not write changes to disk.

.PARAMETER Check
    Exit 1 if any page is stale, or an option has no overrides entry (or an
    overrides entry has no matching option in source). For CI. Implies
    -DryRun.

.PARAMETER SelfTest
    Verify extraction against known-good values, then exit. No wiki changes.

.EXAMPLE
    pwsh ./sync-cli-options-to-wiki.ps1 -DryRun
    pwsh ./sync-cli-options-to-wiki.ps1
    pwsh ./sync-cli-options-to-wiki.ps1 -Check
    pwsh ./sync-cli-options-to-wiki.ps1 -PrintConfigCppPath ../OrcaSlicer/src/libslic3r/PrintConfig.cpp
#>
param(
    [string]$PrintConfigCppPath = "https://github.com/OrcaSlicer/OrcaSlicer/blob/main/src/libslic3r/PrintConfig.cpp",
    [string]$OverridesPath = "cli_option_overrides.json",
    [string]$WikiRoot = $PSScriptRoot,
    [switch]$DryRun,
    [switch]$Check,
    [switch]$SelfTest
)

$ErrorActionPreference = 'Stop'

if ($Check) { $DryRun = $true }

$ClassMarkers = @(
    [PSCustomObject]@{ Start = 'CLIActionsConfigDef::CLIActionsConfigDef'; End = 'CLITransformConfigDef::CLITransformConfigDef'; Page = 'cli_actions' }
    [PSCustomObject]@{ Start = 'CLITransformConfigDef::CLITransformConfigDef'; End = 'CLIMiscConfigDef::CLIMiscConfigDef'; Page = 'cli_transform' }
    # CLIMiscConfigDef is last, so an unbounded search would swallow the
    # unrelated placeholder-variable defs after it -- including a `scale`
    # that collides with CLITransformConfigDef's real `scale` option.
    [PSCustomObject]@{ Start = 'CLIMiscConfigDef::CLIMiscConfigDef'; End = 'const CLIActionsConfigDef'; Page = 'cli_misc' }
)

$AddPattern = 'this->add(?:_nullable)?\("(?<key>[a-zA-Z0-9_]+)",\s*(?<typ>co\w+)\)'
$CliAliasPattern = 'def->cli\s*=\s*"(?<alias>[^"]*)"'

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
    # Duplicated from sync-option-types-to-wiki.ps1 so each script stays
    # independently runnable. Without it, commented-out actions would be
    # extracted as if live.
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

function ConvertTo-DashedKey {
    param([string]$Key)
    return $Key.Replace('_', '-')
}

function Get-FlagNames {
    param(
        [string]$Key,
        [string]$CliAlias
    )

    if ([string]::IsNullOrEmpty($CliAlias)) {
        return @("--$(ConvertTo-DashedKey -Key $Key)")
    }
    $names = New-Object System.Collections.Generic.List[string]
    foreach ($part in ($CliAlias -split '\|')) {
        if ($part.Length -eq 1) { $names.Add("-$part") } else { $names.Add("--$part") }
    }
    return @($names)
}

function Format-Flag {
    param([string[]]$Names)
    return (($Names | ForEach-Object { "``$_``" }) -join ' / ')
}

function Get-CliOptions {
    param([string]$SourceText)

    $stripped = Remove-CppComments -Text $SourceText
    # Ordered so rows within a group preserve PrintConfig.cpp source order --
    # a plain @{} hashtable's .Keys enumeration order is unspecified.
    $results = [ordered]@{}

    foreach ($marker in $ClassMarkers) {
        $start = $stripped.IndexOf($marker.Start)
        if ($start -eq -1) { continue }
        $end = if ($marker.End) { $stripped.IndexOf($marker.End) } else { $stripped.Length }
        if ($end -eq -1) { $end = $stripped.Length }
        $body = $stripped.Substring($start, $end - $start)

        $positions = New-Object System.Collections.Generic.List[object]
        foreach ($m in [regex]::Matches($body, $AddPattern)) {
            $positions.Add([PSCustomObject]@{ Index = $m.Index; Key = $m.Groups['key'].Value; Typ = $m.Groups['typ'].Value })
        }

        for ($i = 0; $i -lt $positions.Count; $i++) {
            $p = $positions[$i]
            $blockEndIdx = if (($i + 1) -lt $positions.Count) { $positions[$i + 1].Index } else { $body.Length }
            $block = $body.Substring($p.Index, $blockEndIdx - $p.Index)

            $aliasMatch = [regex]::Match($block, $CliAliasPattern)
            $alias = if ($aliasMatch.Success) { $aliasMatch.Groups['alias'].Value } else { $null }

            $results[$p.Key] = [PSCustomObject]@{
                Type    = $p.Typ
                CliFlag = Format-Flag -Names (Get-FlagNames -Key $p.Key -CliAlias $alias)
                Page    = $marker.Page
            }
        }
    }

    return $results
}

function Import-CliOverrides {
    param([string]$Path)
    return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Invoke-SelfTest {
    param($SourceOptions)

    $failures = New-Object System.Collections.Generic.List[string]

    $cases = @(
        [PSCustomObject]@{ Key = 'help'; Check = 'CliFlag'; Expected = '`--help` / `-h`' }
        [PSCustomObject]@{ Key = 'slice'; Check = 'CliFlag'; Expected = '`--slice`' }
        [PSCustomObject]@{ Key = 'export_3mf'; Check = 'CliFlag'; Expected = '`--export-3mf`' }
        [PSCustomObject]@{ Key = 'export_3mf'; Check = 'Page'; Expected = 'cli_actions' }
        [PSCustomObject]@{ Key = 'scale'; Check = 'Page'; Expected = 'cli_transform' }
        [PSCustomObject]@{ Key = 'arrange'; Check = 'Page'; Expected = 'cli_transform' }
        [PSCustomObject]@{ Key = 'datadir'; Check = 'Page'; Expected = 'cli_misc' }
        [PSCustomObject]@{ Key = 'total_count'; Check = 'not_extracted'; Expected = $null }
    )

    foreach ($case in $cases) {
        $key = $case.Key; $check = $case.Check; $expected = $case.Expected
        if ($check -eq 'not_extracted') {
            if ($SourceOptions.Contains($key)) {
                $failures.Add("$key`: extracted as a CLI-only option, but it isn't one")
            }
            continue
        }
        if (-not $SourceOptions.Contains($key)) {
            $failures.Add("$key`: not found at all")
            continue
        }
        $actual = $SourceOptions[$key].$check
        if ($actual -cne $expected) {
            $failures.Add("$key.$check = '$actual', expected '$expected'")
        }
    }

    if ($SourceOptions.Count -ne 53) {
        $failures.Add("expected exactly 53 CLI-only options, found $($SourceOptions.Count)")
    }

    return @($failures)
}

function ConvertTo-AnchorSlug {
    param([string]$Heading)
    $text = $Heading.Trim().ToLowerInvariant()
    $text = [regex]::Replace($text, '[^a-z0-9\s-]', '')
    $text = [regex]::Replace($text, '[\s-]+', '-')
    return $text.Trim('-')
}

function Build-CliPage {
    param(
        [string]$PageKey,
        $Overrides,
        $SourceOptions
    )

    $pageCfg = $Overrides._pages.$PageKey
    $keysForPage = @($SourceOptions.Keys | Where-Object { $SourceOptions[$_].Page -eq $PageKey })

    $groups = @($pageCfg.groups)
    $byGroup = @{}
    foreach ($g in $groups) { $byGroup[$g] = New-Object System.Collections.Generic.List[string] }
    $ungrouped = New-Object System.Collections.Generic.List[object]

    foreach ($key in $keysForPage) {
        $opt = $Overrides.options.$key
        if (-not $opt) { continue }  # reported separately as a gap; never silently rendered
        $group = $opt.group
        if (-not $byGroup.ContainsKey($group)) {
            $ungrouped.Add(@($key, $group))
            continue
        }
        $byGroup[$group].Add($key)
    }

    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append("# $($pageCfg.title)`n`n")
    [void]$sb.Append("$($pageCfg.intro)`n`n")
    if ($pageCfg.admonition) {
        [void]$sb.Append("$($pageCfg.admonition)`n`n")
    }
    foreach ($g in $groups) {
        $anchor = ConvertTo-AnchorSlug -Heading $g
        [void]$sb.Append("- [$g](#$anchor)`n")
    }
    [void]$sb.Append("`n")

    foreach ($g in $groups) {
        $keys = $byGroup[$g]
        if ($keys.Count -eq 0) { continue }
        [void]$sb.Append("## $g`n`n")
        $groupIntro = $null
        if ($pageCfg.group_intro -and ($pageCfg.group_intro.PSObject.Properties.Match($g).Count -gt 0)) {
            $groupIntro = $pageCfg.group_intro.$g
        }
        if ($groupIntro) {
            [void]$sb.Append("$groupIntro`n`n")
        }
        [void]$sb.Append("| Flag | Input | Description | Notes |`n")
        [void]$sb.Append("| --- | --- | --- | --- |`n")
        foreach ($key in $keys) {
            $opt = $Overrides.options.$key
            $flag = $SourceOptions[$key].CliFlag
            $notesCell = if ($opt.notes) { " $($opt.notes)" } else { '' }
            [void]$sb.Append("| $flag | $($opt.input) | $($opt.description) |$notesCell |`n")
        }
        [void]$sb.Append("`n")
    }

    $content = $sb.ToString().TrimEnd("`n") + "`n"
    return [PSCustomObject]@{ Content = $content; Ungrouped = $ungrouped.ToArray() }
}

if (-not (Test-Path -LiteralPath $WikiRoot)) {
    throw "Wiki root not found: $WikiRoot"
}

Write-Host "Reading CLI option definitions from $PrintConfigCppPath ..." -ForegroundColor Cyan
$sourceText = Get-CppSourceText -Source $PrintConfigCppPath -Description 'PrintConfig.cpp'
$sourceOptions = Get-CliOptions -SourceText $sourceText
Write-Host "$($sourceOptions.Count) CLI-only options found in source." -ForegroundColor Cyan

if ($SelfTest) {
    $failures = Invoke-SelfTest -SourceOptions $sourceOptions
    if ($failures.Count -gt 0) {
        Write-Host "`nSELFTEST FAILED ($($failures.Count)):" -ForegroundColor Red
        foreach ($f in $failures) { Write-Host "  $f" -ForegroundColor Red }
        exit 1
    }
    Write-Host "selftest passed (8 cases)." -ForegroundColor Green
    exit 0
}

$resolvedOverridesPath = if ([System.IO.Path]::IsPathRooted($OverridesPath)) { $OverridesPath } else { Join-Path $WikiRoot $OverridesPath }
$overrides = Import-CliOverrides -Path $resolvedOverridesPath

$overrideKeys = New-Object System.Collections.Generic.HashSet[string]
foreach ($p in $overrides.options.PSObject.Properties) { [void]$overrideKeys.Add($p.Name) }

$missingOverrides = @($sourceOptions.Keys | Where-Object { -not $overrideKeys.Contains($_) })
$staleOverrides = @($overrideKeys | Where-Object { -not $sourceOptions.Contains($_) })

$stats = [ordered]@{ pages_current = 0; pages_stale = 0 }

foreach ($pageProp in $overrides._pages.PSObject.Properties) {
    $pageKey = $pageProp.Name
    $result = Build-CliPage -PageKey $pageKey -Overrides $overrides -SourceOptions $sourceOptions
    $content = $result.Content
    $ungrouped = $result.Ungrouped
    if ($ungrouped.Count -gt 0) {
        $ungroupedDesc = ($ungrouped | ForEach-Object { "('$($_[0])', '$($_[1])')" }) -join ', '
        Write-Host "WARNING: $pageKey`: option(s) with an unrecognized group, skipped: $ungroupedDesc" -ForegroundColor Yellow
    }

    $path = Join-Path $WikiRoot "cli" "$pageKey.md"
    $current = if (Test-Path -LiteralPath $path) { Get-Content -LiteralPath $path -Raw } else { '' }

    if ([string]::Equals($current, $content, [System.StringComparison]::Ordinal)) {
        $stats.pages_current++
    }
    else {
        $stats.pages_stale++
        if (-not $DryRun) {
            [System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))
        }
    }
}

$stats | ConvertTo-Json | Write-Host

if ($missingOverrides.Count -gt 0) {
    Write-Host "`n=== options in source with no overrides entry ($($missingOverrides.Count)) ===" -ForegroundColor Yellow
    foreach ($k in $missingOverrides) {
        Write-Host "  $k ($($sourceOptions[$k].Type), $($sourceOptions[$k].CliFlag)) — add to $OverridesPath" -ForegroundColor Yellow
    }
}
if ($staleOverrides.Count -gt 0) {
    Write-Host "`n=== overrides entries with no matching option in source ($($staleOverrides.Count)) ===" -ForegroundColor Yellow
    foreach ($k in $staleOverrides) {
        Write-Host "  $k — removed/renamed upstream? remove from $OverridesPath or update the key" -ForegroundColor Yellow
    }
}

if ($DryRun) {
    Write-Host "`nDry run only. No files were modified." -ForegroundColor Cyan
}

if ($Check) {
    if ($stats.pages_stale -or $missingOverrides.Count -or $staleOverrides.Count) {
        exit 1
    }
    exit 0
}

if ($DryRun -and $stats.pages_stale) {
    Write-Host "`n$($stats.pages_stale) page(s) stale. Re-run without -DryRun to write." -ForegroundColor Cyan
}
