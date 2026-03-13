# Fix grammar rule identifiers in DefInjected XML (e.g. mistranslated passion/Pain).
# Run from mod root: .\Scripts\fix-grammar-identifiers.ps1
# Pairs are in Scripts\grammar-fix-pairs.csv (wrong,right). Add new lines there when you see new "Bad string pass" errors.

param(
    [string]$Root = (Join-Path $PSScriptRoot "..")
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path $Root).Path
$pairsPath = Join-Path $PSScriptRoot "grammar-fix-pairs.csv"

if (-not (Test-Path $pairsPath)) {
    Write-Error "Missing: $pairsPath"
}

$csv = Get-Content $pairsPath -Encoding UTF8
$pairs = @()
foreach ($line in $csv) {
    if ($line -match "^wrong,") { continue }
    if ($line -notmatch ",") { continue }
    $i = $line.IndexOf(",")
    $wrong = $line.Substring(0, $i)
    $right = $line.Substring($i + 1)
    if ($wrong -and $right) { $pairs += [tuple]::Create($wrong, $right) }
}

$patterns = @("*InteractionDef*.xml", "*RulePackDef*.xml")
$files = @()
foreach ($p in $patterns) {
    Get-ChildItem -Path $Root -Recurse -Filter $p -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match "DefInjected" } |
        ForEach-Object { $files += $_ }
}
$files = $files | Sort-Object -Property FullName -Unique

$totalReplacements = 0
$filesTouched = 0

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $original = $content
    foreach ($pair in $pairs) {
        $wrong = $pair.Item1
        $right = $pair.Item2
        if ($content.Contains($wrong)) {
            $count = ([regex]::Matches($content, [regex]::Escape($wrong))).Count
            $content = $content.Replace($wrong, $right)
            $totalReplacements += $count
            $rel = $f.FullName.Replace($Root, ".")
            Write-Host "  $rel : $wrong -> $right ($count)"
        }
    }
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($f.FullName, $content, (New-Object System.Text.UTF8Encoding $false))
        $filesTouched++
    }
}

Write-Host ""
Write-Host "Done: $filesTouched files, $totalReplacements replacements." -ForegroundColor Green
