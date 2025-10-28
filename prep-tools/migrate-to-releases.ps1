# Migrate to GitHub Releases
# This script helps migrate your downloads from local storage to GitHub Releases

param(
    [Parameter(Mandatory=$true)]
    [string]$GameOrTool,
    
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet('game', 'tool')]
    [string]$Type = 'game'
)

# Determine path based on type
$basePath = if ($Type -eq 'game') {
    "content/games/published/$GameOrTool"
} else {
    "content/tools/$GameOrTool"
}

$downloadsPath = Join-Path $basePath "downloads"

if (-not (Test-Path $downloadsPath)) {
    Write-Error "Downloads path not found: $downloadsPath"
    exit 1
}

# Get download files
$files = Get-ChildItem $downloadsPath -File

if ($files.Count -eq 0) {
    Write-Error "No files found in $downloadsPath"
    exit 1
}

Write-Host "`n=== Migrating to GitHub Releases ===" -ForegroundColor Cyan
Write-Host "Item: $GameOrTool"
Write-Host "Version: $Version"
Write-Host "Type: $Type"
Write-Host ""

# Create tag
$tag = "$GameOrTool-v$Version"
Write-Host "Step 1: Creating Git Tag" -ForegroundColor Yellow
Write-Host "Tag name: $tag"
Write-Host ""

$confirmation = Read-Host "Create and push tag? (y/n)"
if ($confirmation -eq 'y') {
    git tag -a $tag -m "$GameOrTool v$Version Release"
    git push origin $tag
    Write-Host "✓ Tag created and pushed" -ForegroundColor Green
} else {
    Write-Host "⚠ Skipped - you can create it manually later:" -ForegroundColor Yellow
    Write-Host "  git tag -a $tag -m '$GameOrTool v$Version Release'" -ForegroundColor Gray
    Write-Host "  git push origin $tag" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 2: Files to Upload to GitHub Release" -ForegroundColor Yellow
Write-Host ""

$downloadEntries = @()

foreach ($file in $files) {
    $sizeMB = [math]::Round($file.Length / 1MB, 2)
    Write-Host "  📦 $($file.Name) - $sizeMB MB"
    
    # Generate manifest entry
    $platform = "Windows"
    if ($file.Extension -eq ".zip") {
        $platform = "Cross-platform"
    } elseif ($file.Name -match "mac|osx") {
        $platform = "macOS"
    } elseif ($file.Name -match "linux") {
        $platform = "Linux"
    }
    
    $downloadEntries += @{
        filename = $file.Name
        platform = $platform
        version = $Version
        size = $file.Length
        sizeFormatted = "$sizeMB MB"
        url = "https://github.com/PedlarGames/pedlargames-content/releases/download/$tag/$($file.Name)"
    }
}

Write-Host ""
Write-Host "Step 3: Create GitHub Release & Upload Files" -ForegroundColor Yellow
$releaseUrl = "https://github.com/PedlarGames/pedlargames-content/releases/new?tag=$tag"
Write-Host "1. Open this URL:"
Write-Host "   $releaseUrl" -ForegroundColor Cyan
Write-Host "2. Fill in the release notes"
Write-Host "3. Drag and drop the files listed above"
Write-Host "4. Publish the release"
Write-Host ""

Write-Host "Step 4: Update Manifest" -ForegroundColor Yellow
Write-Host "Add this to your manifest.json downloads array:"
Write-Host ""

$manifestJson = $downloadEntries | ConvertTo-Json -Depth 5
Write-Host $manifestJson -ForegroundColor Green

Write-Host ""
$openBrowser = Read-Host "Open GitHub release page in browser? (y/n)"
if ($openBrowser -eq 'y') {
    Start-Process $releaseUrl
}

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Upload files to the GitHub release"
Write-Host "2. Update manifest.json with the URLs shown above"
Write-Host "3. Large files can stay on your local machine (they're in .gitignore)"
Write-Host ""
