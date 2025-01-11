# Windows Cleanup and Optimization Script
# Author: [Your Name]
# GitHub: [Your GitHub Profile]

# Run as administrator check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    exit
}

Write-Host "`nStarting Windows Cleanup and Optimization..." -ForegroundColor Green

# Function to delete temp files
function Clear-TempFiles {
    Write-Host "`nCleaning Temporary Files..." -ForegroundColor Yellow
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Function to clear Prefetch files
function Clear-Prefetch {
    Write-Host "`nClearing Prefetch Files..." -ForegroundColor Yellow
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Function to empty Recycle Bin
function Empty-RecycleBin {
    Write-Host "`nEmptying Recycle Bin..." -ForegroundColor Yellow
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
}

# Function to clear Windows Update cache
function Clear-WindowsUpdateCache {
    Write-Host "`nClearing Windows Update Cache..." -ForegroundColor Yellow
    Stop-Service -Name wuauserv -Force
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv
}

# Function to flush DNS cache
function Flush-DNS {
    Write-Host "`nFlushing DNS Cache..." -ForegroundColor Yellow
    ipconfig /flushdns
}

# Execute all functions
Clear-TempFiles
Clear-Prefetch
Empty-RecycleBin
Clear-WindowsUpdateCache
Flush-DNS

Write-Host "`nSystem Cleanup Completed Successfully!" -ForegroundColor Green

# Ask user if they want to restart Explorer
$restartExplorer = Read-Host "Do you want to restart Windows Explorer? (y/n)"
if ($restartExplorer -eq 'y') {
    Write-Host "`nRestarting Explorer..." -ForegroundColor Cyan
    Stop-Process -Name explorer -Force
    Start-Process explorer.exe
}

Write-Host "`nAll tasks completed. Your system is now optimized!" -ForegroundColor Green
