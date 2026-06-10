# sync-progress.ps1
# Reads production-checklist.md, computes progress, and writes a snapshot
# into CLAUDE.md between the <!-- PROGRESS:START --> / <!-- PROGRESS:END --> markers.
# Run after marking any checklist item complete.

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$checklistPath = Join-Path $root 'production-checklist.md'
$claudePath    = Join-Path $root 'CLAUDE.md'

if (-not (Test-Path $checklistPath)) { throw "Not found: $checklistPath" }
if (-not (Test-Path $claudePath))    { throw "Not found: $claudePath" }

$lines = Get-Content $checklistPath -Encoding UTF8

$checked   = ($lines | Where-Object { $_ -match '^\s*-\s*\[x\]' }).Count
$unchecked = ($lines | Where-Object { $_ -match '^\s*-\s*\[\s\]' }).Count
$total     = $checked + $unchecked
$pct       = if ($total -gt 0) { [math]::Round(($checked / $total) * 100, 1) } else { 0 }

# Per-section breakdown (## headings)
$sections = @()
$currentSection = $null
$currentChecked = 0
$currentTotal = 0
foreach ($line in $lines) {
    if ($line -match '^##\s+(.+)$') {
        if ($null -ne $currentSection) {
            $sections += [pscustomobject]@{ Name = $currentSection; Done = $currentChecked; Total = $currentTotal }
        }
        $currentSection = $Matches[1].Trim()
        $currentChecked = 0
        $currentTotal = 0
    } elseif ($line -match '^\s*-\s*\[x\]') {
        $currentChecked++
        $currentTotal++
    } elseif ($line -match '^\s*-\s*\[\s\]') {
        $currentTotal++
    }
}
if ($null -ne $currentSection) {
    $sections += [pscustomobject]@{ Name = $currentSection; Done = $currentChecked; Total = $currentTotal }
}

$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm'

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('## Progress Snapshot')
[void]$sb.AppendLine("**$checked / $total items complete ($pct%)** - last synced $timestamp")
[void]$sb.AppendLine('')
[void]$sb.AppendLine('### By section')
foreach ($s in $sections) {
    if ($s.Total -eq 0) { continue }
    $secPct = [math]::Round(($s.Done / $s.Total) * 100, 0)
    [void]$sb.AppendLine("- **$($s.Name)** - $($s.Done) / $($s.Total) ($secPct%)")
}
[void]$sb.AppendLine('')
[void]$sb.AppendLine('### Full checklist (mirror)')
[void]$sb.AppendLine('')
foreach ($line in $lines) {
    [void]$sb.AppendLine($line)
}

$snapshot = $sb.ToString().TrimEnd()

$claude = Get-Content $claudePath -Raw -Encoding UTF8
$pattern = '(?s)(<!-- PROGRESS:START -->).*?(<!-- PROGRESS:END -->)'
$replacement = "`$1`r`n$snapshot`r`n`$2"

if ($claude -notmatch '<!-- PROGRESS:START -->') {
    throw 'CLAUDE.md is missing the <!-- PROGRESS:START --> marker.'
}
if ($claude -notmatch '<!-- PROGRESS:END -->') {
    throw 'CLAUDE.md is missing the <!-- PROGRESS:END --> marker.'
}

$updated = [regex]::Replace($claude, $pattern, $replacement)
Set-Content -Path $claudePath -Value $updated -Encoding UTF8 -NoNewline

Write-Host ("Synced: {0}/{1} ({2}%) at {3}" -f $checked, $total, $pct, $timestamp) -ForegroundColor Green
