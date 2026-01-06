#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Initializes the Unity Package project by replacing placeholders.

.DESCRIPTION
    Replaces placeholders in file content, filenames, and directory names.
    Placeholders:
    - YOUR_PACKAGE_ID
    - YOUR_PACKAGE_ID_LOWERCASE
    - YOUR_PACKAGE_NAME
    - YOUR_PACKAGE_NAME_INSTALLER
    - YOUR_PACKAGE_NAME_INSTALLER_FILE

.PARAMETER PackageId
    The package ID (e.g., "com.company.package").

.PARAMETER PackageName
    The package name (e.g., "My Package").

.EXAMPLE
    .\init.ps1 -PackageId "com.mycompany.coolpackage" -PackageName "Cool Package"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$PackageId,

    [Parameter(Mandatory = $true)]
    [string]$PackageName
)

$ErrorActionPreference = "Stop"

# Derived variables
$PackageIdLowercase = $PackageId.ToLower()
$PackageNameInstaller = "$PackageName Installer"
$PackageNameInstallerFile = $PackageNameInstaller -replace ' ', '-'

# Replacements map
$Replacements = @{
    "YOUR_PACKAGE_ID"                  = $PackageId
    "YOUR_PACKAGE_ID_LOWERCASE"        = $PackageIdLowercase
    "YOUR_PACKAGE_NAME"                = $PackageName
    "YOUR_PACKAGE_NAME_INSTALLER_FILE" = $PackageNameInstallerFile
    "YOUR_PACKAGE_NAME_INSTALLER"      = $PackageNameInstaller
}

# Sort keys by length descending to avoid partial replacements
$SortedKeys = $Replacements.Keys | Sort-Object { $_.Length } -Descending

# Root directory (parent of commands)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

Write-Host "Initializing package with:" -ForegroundColor Cyan
Write-Host "  ID: $PackageId"
Write-Host "  Name: $PackageName"
Write-Host "  Installer: $PackageNameInstaller"
Write-Host "  Installer File: $PackageNameInstallerFile"
Write-Host ""

# Define target paths
$TargetPaths = @("commands/bump-version.ps1", "Installer", "Unity-Package", "Unity-Tests", "README.md", ".github")

# 1. Replace content in files
Write-Host "Replacing content in files..." -ForegroundColor Yellow
$Files = @()
foreach ($Path in $TargetPaths) {
    $FullPath = Join-Path $RepoRoot $Path
    if (Test-Path $FullPath) {
        if ((Get-Item $FullPath).PSIsContainer) {
            $Files += Get-ChildItem -Path $FullPath -Recurse -File
        }
        else {
            $Files += Get-Item $FullPath
        }
    }
    else {
        Write-Warning "Path not found: $FullPath"
    }
}

foreach ($File in $Files) {
    $Content = Get-Content -Path $File.FullName -Raw
    $NewContent = $Content
    $Modified = $false

    foreach ($Key in $SortedKeys) {
        if ($NewContent -match $Key) {
            $NewContent = $NewContent -replace $Key, $Replacements[$Key]
            $Modified = $true
        }
    }

    if ($Modified) {
        Set-Content -Path $File.FullName -Value $NewContent -NoNewline
        Write-Host "  Updated: $($File.FullName)" -ForegroundColor Gray
    }
}

# 2. Rename files and directories
# We need to do this depth-first (bottom-up) so we don't rename a parent directory before its children
Write-Host "Renaming files and directories..." -ForegroundColor Yellow
$Items = @()
foreach ($Path in $TargetPaths) {
    $FullPath = Join-Path $RepoRoot $Path
    if (Test-Path $FullPath) {
        if ((Get-Item $FullPath).PSIsContainer) {
            $Items += Get-ChildItem -Path $FullPath -Recurse
        }
        else {
            $Items += Get-Item $FullPath
        }
    }
}

# Sort depth-first (longest path first) to handle nested renames correctly
$Items = $Items | Sort-Object -Property FullName -Descending | Select-Object -Unique

foreach ($Item in $Items) {
    $NewName = $Item.Name
    foreach ($Key in $SortedKeys) {
        if ($NewName -match $Key) {
            $NewName = $NewName -replace $Key, $Replacements[$Key]
        }
    }

    if ($NewName -ne $Item.Name) {
        Rename-Item -Path $Item.FullName -NewName $NewName
        Write-Host "  Renamed: $($Item.Name) -> $NewName" -ForegroundColor Gray
    }
}

Write-Host "Done!" -ForegroundColor Green
