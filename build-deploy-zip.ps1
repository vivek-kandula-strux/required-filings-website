# build-deploy-zip.ps1
# Packages the site into a cPanel-ready zip.
# Extraction target: public_html/ (contents live at zip root, not in a subfolder).
#
# By default packages dist/ (minified production build from `npm run build`).
# Pass -Raw to package required-filings/ directly (skips minification —
# useful for debugging what shipped vs. what the source looks like).

param(
    [switch]$Raw
)

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot

if ($Raw) {
    $src = Join-Path $root 'required-filings'
    $mode = 'RAW SOURCE'
} else {
    $src = Join-Path $root 'dist'
    $mode = 'MINIFIED (dist)'
    if (-not (Test-Path $src)) {
        Write-Host ''
        Write-Host "  dist/ not found. Run 'npm run build' first, or use -Raw for source-only zip." -ForegroundColor Yellow
        throw "dist/ not found"
    }
}
if (-not (Test-Path $src)) { throw "Source folder not found: $src" }

Write-Host ''
Write-Host "  Source: $src [$mode]" -ForegroundColor Cyan

$stamp = Get-Date -Format 'yyyyMMdd-HHmm'
$stage = Join-Path $env:TEMP "rf-deploy-$stamp"
$suffix = if ($Raw) { '-raw' } else { '' }
$zip   = Join-Path $root "requiredfilings-deploy-$stamp$suffix.zip"

# Fresh staging directory
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Path $stage | Out-Null

# Mirror source into staging, excluding dev-only files/dirs
# /E    - all subdirs incl. empty
# /XD   - exclude directories (scss source, .gstack dev-tool logs, unreferenced template stock)
# /XF   - exclude files (audit script, editor config, source maps, unreferenced favicon variants)
# /NFL /NDL /NJH /NJS /NC /NS /NP - quiet output
#
# These excludes apply to Raw mode. dist/ is already pre-filtered by scripts/build.mjs
# using the same exclusion lists, so most of these are no-ops there.
$excludeDirs = @(
    'scss',
    '.gstack',
    'home-2', 'home-3', 'home-4', 'home-5',   # template stock, unreferenced by production HTML
    'header'                                    # 5 unreferenced .jpg files
)
$excludeFiles = @(
    'audit.sh', '.nojekyll', '*.map',
    'favicon-2.svg', 'favicon-3.svg', 'favicon-4.svg', 'favicon-5.svg'  # unreferenced favicon variants
)
$null = robocopy $src $stage /E /XD @excludeDirs /XF @excludeFiles /NFL /NDL /NJH /NJS /NC /NS /NP
# robocopy exit codes 0-7 = success (8+ = failure)
if ($LASTEXITCODE -ge 8) { throw "robocopy failed with code $LASTEXITCODE" }

# Verify no dev-only files leaked in
if (Test-Path (Join-Path $stage 'assets\scss')) { throw 'scss leaked into staging' }
if (Test-Path (Join-Path $stage 'audit.sh')) { throw 'audit.sh leaked into staging' }
if (Test-Path (Join-Path $stage '.nojekyll')) { throw '.nojekyll leaked into staging' }
foreach ($deadDir in 'assets\img\home-2', 'assets\img\home-3', 'assets\img\home-4', 'assets\img\home-5', 'assets\img\header') {
    if (Test-Path (Join-Path $stage $deadDir)) { throw "$deadDir leaked into staging" }
}

# Sanity check — required files must exist at staging root
foreach ($required in 'index.html', 'robots.txt', 'sitemap.xml', '.htaccess', 'assets\css\main.css', 'assets\img\logo\black-logo.png') {
    if (-not (Test-Path (Join-Path $stage $required))) {
        throw "Missing required file in staging: $required"
    }
}

# Remove any previous zip with the same name
if (Test-Path $zip) { Remove-Item $zip -Force }

# Build the zip manually so entry paths use forward slashes (ZIP spec + cPanel compatible).
# Windows PowerShell's Compress-Archive writes backslashes, which cPanel extractors
# read as literal filename characters instead of directory separators.
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::Open($zip, 'Create')
try {
    Get-ChildItem -Path $stage -Recurse -File -Force | ForEach-Object {
        $relative = $_.FullName.Substring($stage.Length + 1) -replace '\\', '/'
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $archive, $_.FullName, $relative,
            [System.IO.Compression.CompressionLevel]::Optimal
        ) | Out-Null
    }
} finally {
    $archive.Dispose()
}

# Clean up staging
Remove-Item $stage -Recurse -Force
# Reset LASTEXITCODE (robocopy earlier set it to 1 = "files copied", which is success)
$global:LASTEXITCODE = 0

# Report
$sizeMB = [math]::Round((Get-Item $zip).Length / 1MB, 2)
Write-Host ''
Write-Host "  Zip built: $zip" -ForegroundColor Green
Write-Host "  Size:      $sizeMB MB" -ForegroundColor Green
Write-Host "  Mode:      $mode" -ForegroundColor Green
Write-Host ''
Write-Host 'Upload steps:' -ForegroundColor Cyan
Write-Host '  1. In cPanel > File Manager, open public_html/'
Write-Host '  2. Upload the zip above'
Write-Host '  3. Right-click the zip > Extract > confirm destination is public_html/'
Write-Host '  4. Delete the zip file after extraction'
Write-Host '  5. Visit https://requiredfilings.com/ to verify'
Write-Host ''
Write-Host 'Post-deploy verification (from your shell):' -ForegroundColor Cyan
Write-Host '  curl -I https://requiredfilings.com/assets/css/main.css'
Write-Host '    -> expect Content-Encoding: gzip AND Cache-Control: max-age=31536000, immutable'
Write-Host '  curl -I https://requiredfilings.com/'
Write-Host '    -> expect Strict-Transport-Security, X-Content-Type-Options, Cache-Control: max-age=0'
