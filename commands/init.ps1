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

.PARAMETER InstallerExtraPath
    Optional. An extra path segment between Assets/ and the Installer folder.
    For example, "Editor" places the installer at Assets/Editor/{Package} Installer.
    If not provided, you will be prompted (press Enter to skip).

.EXAMPLE
    .\init.ps1 -PackageId "com.mycompany.coolpackage" -PackageName "Cool Package"

.EXAMPLE
    .\init.ps1 -PackageId "com.mycompany.coolpackage" -PackageName "Cool Package" -InstallerExtraPath "Editor"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$PackageId,

    [Parameter(Mandatory = $true)]
    [string]$PackageName,

    [Parameter(Mandatory = $false)]
    [string]$InstallerExtraPath
)

$ErrorActionPreference = "Stop"

# Prompt for InstallerExtraPath if not provided
if (-not $PSBoundParameters.ContainsKey('InstallerExtraPath')) {
    Write-Host "Optional: Enter an extra path for the Installer (e.g., 'Editor')." -ForegroundColor Cyan
    Write-Host "Press Enter to skip." -ForegroundColor Gray
    $InstallerExtraPath = Read-Host "Installer Extra Path"
}

# Normalize InstallerExtraPath
if (-not [string]::IsNullOrWhiteSpace($InstallerExtraPath)) {
    $InstallerExtraPath = ($InstallerExtraPath.Trim() -replace '\\', '/').TrimStart('/').TrimEnd('/')
}

# Derived variables
$PackageIdLowercase = $PackageId.ToLower()

# Compute base installer name and file name first
$PackageNameInstallerBase = "$PackageName Installer"
$PackageNameInstallerFile = $PackageNameInstallerBase -replace ' ', '-'  # Stays unchanged (no path prefix)

# Prepend extra path to installer name if provided
if ([string]::IsNullOrWhiteSpace($InstallerExtraPath)) {
    $PackageNameInstaller = $PackageNameInstallerBase
} else {
    $PackageNameInstaller = "$InstallerExtraPath/$PackageNameInstallerBase"
}

# Replacements map for file content (includes extra path in installer name)
$Replacements = @{
    "YOUR_PACKAGE_ID"                  = $PackageId
    "YOUR_PACKAGE_ID_LOWERCASE"        = $PackageIdLowercase
    "YOUR_PACKAGE_NAME"                = $PackageName
    "YOUR_PACKAGE_NAME_INSTALLER_FILE" = $PackageNameInstallerFile
    "YOUR_PACKAGE_NAME_INSTALLER"      = $PackageNameInstaller
}

# Replacements map for file/folder renaming (uses base names without extra path)
$ReplacementsForRenaming = @{
    "YOUR_PACKAGE_ID"                  = $PackageId
    "YOUR_PACKAGE_ID_LOWERCASE"        = $PackageIdLowercase
    "YOUR_PACKAGE_NAME"                = $PackageName
    "YOUR_PACKAGE_NAME_INSTALLER_FILE" = $PackageNameInstallerFile
    "YOUR_PACKAGE_NAME_INSTALLER"      = $PackageNameInstallerBase
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
if (-not [string]::IsNullOrWhiteSpace($InstallerExtraPath)) {
    Write-Host "  Installer Extra Path: $InstallerExtraPath"
}
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

# 1.5. Create extra path folders and move installer (if extra path provided)
if (-not [string]::IsNullOrWhiteSpace($InstallerExtraPath)) {
    Write-Host "Creating extra path and moving installer folder..." -ForegroundColor Yellow
    $InstallerAssetsDir = Join-Path $RepoRoot "Installer/Assets"
    $SourceFolder = Join-Path $InstallerAssetsDir "YOUR_PACKAGE_NAME_INSTALLER"
    $ExtraPathDir = Join-Path $InstallerAssetsDir $InstallerExtraPath

    # Create extra path directories
    if (-not (Test-Path $ExtraPathDir)) {
        New-Item -Path $ExtraPathDir -ItemType Directory -Force | Out-Null
        Write-Host "  Created: $ExtraPathDir" -ForegroundColor Gray
    }

    # Move installer folder
    if (Test-Path $SourceFolder) {
        $DestFolder = Join-Path $ExtraPathDir "YOUR_PACKAGE_NAME_INSTALLER"
        Move-Item -Path $SourceFolder -Destination $DestFolder -Force
        Write-Host "  Moved installer to: $InstallerExtraPath/" -ForegroundColor Gray
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
            $NewName = $NewName -replace $Key, $ReplacementsForRenaming[$Key]
        }
    }

    if ($NewName -ne $Item.Name) {
        Rename-Item -Path $Item.FullName -NewName $NewName
        Write-Host "  Renamed: $($Item.Name) -> $NewName" -ForegroundColor Gray
    }
}

Write-Host "Done!" -ForegroundColor Green
