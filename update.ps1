# Hormuz Monitor - Auto Update Script
# 霍尔木兹监控网站自动更新脚本

param(
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"

Write-Host "========================================"
Write-Host "  Hormuz Monitor - Auto Update"
Write-Host "========================================"
Write-Host ""

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = $PWD }
Set-Location $scriptDir

$sourceFile = "C:\Users\61959\.qclaw\workspace\hormuz_monitor_final.html"
$targetFile = "$scriptDir\index.html"

# Step 1: Copy file
Write-Host "[1/3] Copying file..."
if (-not (Test-Path $sourceFile)) {
    Write-Host "[ERROR] Source file not found: $sourceFile" -ForegroundColor Red
    Write-Host "Please make sure hormuz_monitor_final.html exists" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}
Copy-Item -Path $sourceFile -Destination $targetFile -Force
Write-Host "[OK] File copied successfully" -ForegroundColor Green

# Step 2: Git commit
Write-Host ""
Write-Host "[2/3] Committing changes..."
$commitMsg = if ($Message) { $Message } else {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "Update: $timestamp"
}
git add .
git commit -m $commitMsg
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Git commit failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "[OK] Commit successful" -ForegroundColor Green

# Step 3: Git push
Write-Host ""
Write-Host "[3/3] Pushing to GitHub..."
git push
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Push failed!" -ForegroundColor Red
    Write-Host "Possible reasons:" -ForegroundColor Yellow
    Write-Host "  - Network issue"
    Write-Host "  - Not logged in to GitHub"
    Write-Host ""
    Write-Host "Try running in Git Bash:" -ForegroundColor Cyan
    Write-Host '  git push' -ForegroundColor Cyan
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "[OK] Push successful!" -ForegroundColor Green

Write-Host ""
Write-Host "========================================"
Write-Host "  Update Complete!" -ForegroundColor Green
Write-Host "  Website: https://riven9955-max.github.io/hormuz-monitor/"
Write-Host "  (Takes ~1-2 min to go live)"
Write-Host "========================================"
Read-Host "Press Enter to exit"
