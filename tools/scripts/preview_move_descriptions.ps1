param(
    [string]$Move,
    [Nullable[int]]$Index,
    [switch]$CheckOverflow,
    [switch]$OnlyOverflow,
    [switch]$FitReport,
    [switch]$OnlyProblems,
    [switch]$OnlyRisky,
    [switch]$IncludeTight
)

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$moveNamesPath = Join-Path $repoRoot "res\\text\\move_names.json"
$moveDescsPath = Join-Path $repoRoot "res\\text\\move_descriptions.json"
$charmapPath = Join-Path $repoRoot "tools\\msgenc\\charmap.txt"
$systemFontPath = Join-Path $repoRoot "build\\res\\fonts\\pl_font.narc.p\\font_system.NFGR"
$subscreenFontPath = Join-Path $repoRoot "build\\res\\fonts\\pl_font.narc.p\\font_subscreen.NFGR"

$battleButtonHardWidthPx = 128
$battleButtonWarningWidthPx = 120
$battleSummaryNameWidthPx = 88
$battleSummaryTolerancePx = 4
$battleDescriptionWidthPx = 120
$battleDescriptionHeightPx = 80
$battleDescriptionTolerancePx = 12
$fontLineHeightPx = 16

function Get-FontMetrics {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Missing font file: $Path"
    }

    [byte[]]$bytes = [System.IO.File]::ReadAllBytes($Path)

    if ($bytes.Length -lt 16) {
        throw "Font file is too small to parse: $Path"
    }

    $widthTableOffset = [BitConverter]::ToUInt32($bytes, 4)
    $numGlyphs = [BitConverter]::ToUInt32($bytes, 8)

    if (($widthTableOffset + $numGlyphs) -gt $bytes.Length) {
        throw "Font width table is out of bounds in $Path"
    }

    [byte[]]$widths = $bytes[$widthTableOffset..($widthTableOffset + $numGlyphs - 1)]

    return [PSCustomObject]@{
        Path = $Path
        NumGlyphs = [int]$numGlyphs
        Widths = $widths
    }
}

function Get-Charmap {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Missing charmap: $Path"
    }

    $map = @{}

    foreach ($line in Get-Content $Path -Encoding UTF8) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($line.TrimStart().StartsWith("//")) {
            continue
        }

        if ($line -notmatch '^([0-9A-Fa-f]{4})=(.*)$') {
            continue
        }

        $code = [Convert]::ToInt32($matches[1], 16)
        $value = $matches[2]

        if ($value.StartsWith("{") -and $value.EndsWith("}")) {
            continue
        }

        if ($value -eq '\x0000') {
            continue
        }

        if (-not $map.ContainsKey($value)) {
            $map[$value] = $code
        }
    }

    return $map
}

function Get-TextElements {
    param([string]$Text)

    $elements = New-Object 'System.Collections.Generic.List[string]'
    $enumerator = [System.Globalization.StringInfo]::GetTextElementEnumerator($Text)

    while ($enumerator.MoveNext()) {
        $elements.Add([string]$enumerator.GetTextElement())
    }

    return $elements
}

function Measure-TextWidthPx {
    param(
        [string]$Text,
        [hashtable]$Charmap,
        [PSCustomObject]$FontMetrics,
        [int]$FallbackCode
    )

    $width = 0
    $invalidChars = New-Object 'System.Collections.Generic.List[string]'

    foreach ($element in Get-TextElements $Text) {
        if ($element -eq "`r" -or $element -eq "`n") {
            continue
        }

        if ($Charmap.ContainsKey($element)) {
            $code = [int]$Charmap[$element]
        } else {
            $code = $FallbackCode

            if (-not $invalidChars.Contains($element)) {
                $invalidChars.Add($element)
            }
        }

        if ($code -lt 1 -or $code -gt $FontMetrics.NumGlyphs) {
            $code = $FallbackCode
        }

        $width += [int]$FontMetrics.Widths[$code - 1]
    }

    return [PSCustomObject]@{
        Width = $width
        InvalidChars = @($invalidChars)
    }
}

function Get-BattleButtonStatus {
    param([int]$WidthPx)

    if ($WidthPx -gt $battleButtonHardWidthPx) {
        return "OVERFLOW"
    }

    if ($WidthPx -gt $battleButtonWarningWidthPx) {
        return "TIGHT"
    }

    return "FIT"
}

function Test-IsMeaningfulSeverity {
    param(
        [string]$Severity,
        [bool]$IncludeTightSeverity
    )

    if ($Severity -eq "BAD" -or $Severity -eq "RISKY") {
        return $true
    }

    if ($IncludeTightSeverity -and $Severity -eq "TIGHT") {
        return $true
    }

    return $false
}

function Get-OverflowSeverity {
    param([int]$OverflowPx)

    if ($OverflowPx -le 0) {
        return "FIT"
    }

    if ($OverflowPx -le 4) {
        return "TIGHT"
    }

    if ($OverflowPx -le 12) {
        return "RISKY"
    }

    return "BAD"
}

function Get-WidthStatus {
    param(
        [int]$WidthPx,
        [int]$LimitPx,
        [int]$TolerancePx = 0
    )

    $overflowPx = [Math]::Max(0, $WidthPx - $LimitPx)
    $effectiveOverflowPx = [Math]::Max(0, $overflowPx - $TolerancePx)
    $severity = Get-OverflowSeverity $effectiveOverflowPx
    $fitsVisually = ($effectiveOverflowPx -eq 0)

    return [PSCustomObject]@{
        Fits = ($overflowPx -eq 0)
        FitsVisually = $fitsVisually
        OverflowPx = $overflowPx
        EffectiveOverflowPx = $effectiveOverflowPx
        TolerancePx = $TolerancePx
        Severity = $severity
        HasMeaningfulOverflow = (Test-IsMeaningfulSeverity $severity $IncludeTight)
        Label = if ($overflowPx -eq 0) {
            "FIT"
        } elseif ($effectiveOverflowPx -eq 0) {
            "OVERFLOW by ${overflowPx}px (within ${TolerancePx}px vanilla tolerance)"
        } else {
            "OVERFLOW by ${overflowPx}px ($severity after ${TolerancePx}px tolerance)"
        }
    }
}

function Get-SummaryStatus {
    param(
        [int]$WidthPx,
        [int]$LimitPx
    )

    return Get-WidthStatus $WidthPx $LimitPx $battleSummaryTolerancePx
}

function Get-DescriptionReport {
    param(
        [object[]]$LineMeasures,
        [string[]]$Lines
    )

    $lineCount = $Lines.Count
    $maxVisibleLines = [int]($battleDescriptionHeightPx / $fontLineHeightPx)
    $maxLineWidthPx = if ($LineMeasures.Count -gt 0) { ($LineMeasures | Measure-Object -Property Width -Maximum).Maximum } else { 0 }
    $widthOverflowPx = [Math]::Max(0, $maxLineWidthPx - $battleDescriptionWidthPx)
    $effectiveWidthOverflowPx = [Math]::Max(0, $widthOverflowPx - $battleDescriptionTolerancePx)
    $heightOverflowLines = [Math]::Max(0, $lineCount - $maxVisibleLines)
    $widthSeverity = Get-OverflowSeverity $effectiveWidthOverflowPx
    $overflowingLines = New-Object 'System.Collections.Generic.List[object]'

    for ($lineIndex = 0; $lineIndex -lt $Lines.Count; $lineIndex++) {
        $lineWidth = [int]$LineMeasures[$lineIndex].Width
        $lineOverflowPx = [Math]::Max(0, $lineWidth - $battleDescriptionWidthPx)

        if ($lineOverflowPx -gt 0) {
            $effectiveLineOverflowPx = [Math]::Max(0, $lineOverflowPx - $battleDescriptionTolerancePx)
            $overflowingLines.Add([PSCustomObject]@{
                LineNumber = $lineIndex + 1
                WidthPx = $lineWidth
                OverflowPx = $lineOverflowPx
                EffectiveOverflowPx = $effectiveLineOverflowPx
                Severity = Get-OverflowSeverity $effectiveLineOverflowPx
                Text = $Lines[$lineIndex]
            })
        }
    }

    $parts = New-Object 'System.Collections.Generic.List[string]'

    if ($widthOverflowPx -gt 0) {
        $worstLine = $overflowingLines | Sort-Object EffectiveOverflowPx, OverflowPx -Descending | Select-Object -First 1

        if ($effectiveWidthOverflowPx -eq 0) {
            $parts.Add("WIDE by $widthOverflowPx" + "px (within ${battleDescriptionTolerancePx}px vanilla tolerance)")
        } else {
            $parts.Add("WIDE by $widthOverflowPx" + "px ($widthSeverity after ${battleDescriptionTolerancePx}px tolerance, line " + $worstLine.LineNumber + ")")
        }
    }

    if ($heightOverflowLines -gt 0) {
        if ($heightOverflowLines -eq 1) {
            $parts.Add("TALL by 1 line")
        } else {
            $parts.Add("TALL by $heightOverflowLines lines")
        }
    }

    $fits = ($widthOverflowPx -eq 0) -and ($heightOverflowLines -eq 0)
    $fitsVisually = ($effectiveWidthOverflowPx -eq 0) -and ($heightOverflowLines -eq 0)
    $label = if ($parts.Count -eq 0) { "FIT" } else { $parts -join " + " }

    return [PSCustomObject]@{
        Fits = $fits
        FitsVisually = $fitsVisually
        MaxLineWidthPx = [int]$maxLineWidthPx
        LineCount = [int]$lineCount
        WidthOverflowPx = [int]$widthOverflowPx
        EffectiveWidthOverflowPx = [int]$effectiveWidthOverflowPx
        HeightOverflowLines = [int]$heightOverflowLines
        TolerancePx = [int]$battleDescriptionTolerancePx
        WidthSeverity = $widthSeverity
        HasMeaningfulWidthOverflow = (Test-IsMeaningfulSeverity $widthSeverity $IncludeTight)
        HasMeaningfulHeightOverflow = ($heightOverflowLines -gt 0)
        OverflowingLines = $overflowingLines.ToArray()
        Label = $label
    }
}

function Get-MessageText {
    param($Value)

    if ($Value -is [System.Array]) {
        return (($Value -join "") -replace "\n$", "")
    }

    return [string]$Value
}

$moveNames = (Get-Content $moveNamesPath -Raw -Encoding UTF8 | ConvertFrom-Json).messages
$moveDescs = (Get-Content $moveDescsPath -Raw -Encoding UTF8 | ConvertFrom-Json).messages
$charmap = Get-Charmap $charmapPath
$systemFont = Get-FontMetrics $systemFontPath
$subscreenFont = Get-FontMetrics $subscreenFontPath
$fallbackCode = if ($charmap.ContainsKey("?")) { [int]$charmap["?"] } else { throw "Charmap is missing '?' fallback." }

if ($moveNames.Count -ne $moveDescs.Count) {
    throw "move_names.json has $($moveNames.Count) entries but move_descriptions.json has $($moveDescs.Count) entries."
}

$query = if ($Move) { $Move.ToLowerInvariant() } else { $null }
$found = 0
$showMetrics = $FitReport -or $CheckOverflow -or ($null -ne $Index) -or [bool]$Move

for ($i = 0; $i -lt $moveNames.Count; $i++) {
    if ($null -ne $Index -and $i -ne $Index) {
        continue
    }

    $moveName = [string]$moveNames[$i].en_US

    if ($null -ne $query -and -not $moveName.ToLowerInvariant().Contains($query)) {
        continue
    }

    $moveNameMeasureBattle = Measure-TextWidthPx $moveName $charmap $subscreenFont $fallbackCode
    $moveNameMeasureSummary = Measure-TextWidthPx $moveName $charmap $systemFont $fallbackCode
    $buttonStatus = Get-BattleButtonStatus $moveNameMeasureBattle.Width
    $summaryNameStatus = Get-SummaryStatus $moveNameMeasureSummary.Width $battleSummaryNameWidthPx

    $descText = Get-MessageText $moveDescs[$i].en_US
    $descLines = @($descText -split "`n")
    $lineMeasures = foreach ($line in $descLines) {
        Measure-TextWidthPx $line $charmap $systemFont $fallbackCode
    }
    $descriptionReport = Get-DescriptionReport $lineMeasures $descLines
    $descriptionOverflow = -not $descriptionReport.Fits
    $hasProblem = ($buttonStatus -ne "FIT") -or (-not $summaryNameStatus.Fits) -or $descriptionOverflow
    $hasMeaningfulProblem = ($buttonStatus -eq "OVERFLOW") -or $summaryNameStatus.HasMeaningfulOverflow -or $descriptionReport.HasMeaningfulWidthOverflow -or $descriptionReport.HasMeaningfulHeightOverflow

    if ($OnlyOverflow -and -not $descriptionOverflow) {
        continue
    }

    if ($OnlyProblems -and -not $hasMeaningfulProblem) {
        continue
    }

    if ($OnlyRisky -and -not $hasMeaningfulProblem) {
        continue
    }

    $found++
    $suffixParts = New-Object 'System.Collections.Generic.List[string]'

    if ($buttonStatus -ne "FIT") {
        $suffixParts.Add("battle button: $buttonStatus")
    }

    if (-not $summaryNameStatus.FitsVisually) {
        $suffixParts.Add("summary name: $($summaryNameStatus.Label)")
    }

    if (-not $descriptionReport.FitsVisually) {
        $suffixParts.Add("description: $($descriptionReport.Label)")
    }

    $suffix = if ($suffixParts.Count -gt 0) { "  [" + ($suffixParts -join "; ") + "]" } else { "" }
    Write-Output ("[{0:d3}] {1}{2}" -f $i, $moveName, $suffix)

    if ($showMetrics) {
        Write-Output ("Battle Button: {0}px / {1}px [{2}]" -f $moveNameMeasureBattle.Width, $battleButtonHardWidthPx, $buttonStatus)
        Write-Output ("Battle Summary Name: {0}px / {1}px [{2}]" -f $moveNameMeasureSummary.Width, $battleSummaryNameWidthPx, $summaryNameStatus.Label)
        Write-Output ("Description: max line {0}px / {1}px, {2} lines / {3} lines ({4}px) [{5}]" -f $descriptionReport.MaxLineWidthPx, $battleDescriptionWidthPx, $descriptionReport.LineCount, ($battleDescriptionHeightPx / $fontLineHeightPx), $battleDescriptionHeightPx, $descriptionReport.Label)
    } elseif ($CheckOverflow) {
        Write-Output ("Description: max line {0}px / {1}px, {2} lines / {3} lines ({4}px) [{5}]" -f $descriptionReport.MaxLineWidthPx, $battleDescriptionWidthPx, $descriptionReport.LineCount, ($battleDescriptionHeightPx / $fontLineHeightPx), $battleDescriptionHeightPx, $descriptionReport.Label)
    }

    if ($showMetrics -and $descriptionReport.OverflowingLines.Count -gt 0) {
        foreach ($overflowLine in $descriptionReport.OverflowingLines) {
            if ($overflowLine.EffectiveOverflowPx -eq 0) {
                Write-Output ("Description line {0}: {1}px (+{2}px, within {3}px tolerance) {4}" -f $overflowLine.LineNumber, $overflowLine.WidthPx, $overflowLine.OverflowPx, $battleDescriptionTolerancePx, $overflowLine.Text)
            } else {
                Write-Output ("Description line {0}: {1}px (+{2}px, {3} after {4}px tolerance) {5}" -f $overflowLine.LineNumber, $overflowLine.WidthPx, $overflowLine.OverflowPx, $overflowLine.Severity, $battleDescriptionTolerancePx, $overflowLine.Text)
            }
        }
    }

    if ($moveNameMeasureBattle.InvalidChars.Count -gt 0) {
        Write-Output ("Unmapped battle-name chars: {0}" -f (($moveNameMeasureBattle.InvalidChars | Sort-Object -Unique) -join ", "))
    }

    if ($moveNameMeasureSummary.InvalidChars.Count -gt 0) {
        Write-Output ("Unmapped summary-name chars: {0}" -f (($moveNameMeasureSummary.InvalidChars | Sort-Object -Unique) -join ", "))
    }

    $descInvalidChars = $lineMeasures | ForEach-Object { $_.InvalidChars } | Sort-Object -Unique

    if ($descInvalidChars.Count -gt 0) {
        Write-Output ("Unmapped description chars: {0}" -f ($descInvalidChars -join ", "))
    }

    $descText

    Write-Output ""
}

if ($found -eq 0) {
    if ($OnlyRisky) {
        throw "No matching moves with risky or bad battle-text fit issues found."
    }

    if ($OnlyProblems) {
        throw "No matching moves with battle-text fit problems found."
    }

    if ($OnlyOverflow) {
        throw "No matching moves with overflowing descriptions found."
    }

    throw "No matching moves found."
}
