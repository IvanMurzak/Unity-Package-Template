#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Opens all Unity projects in the repository using Unity Editor.

.DESCRIPTION
    Launches Unity Editor for each project by reading the required version
    from ProjectSettings/ProjectVersion.txt:
    - Installer
    - Unity-Package
    - Unity-Tests/2022.3.62f3
    - Unity-Tests/2023.2.22f1
    - Unity-Tests/6000.3.1f1

.PARAMETER EditorsPath
    Optional. Path to the Unity Hub editors folder.
    Defaults to "C:\Program Files\Unity\Hub\Editor".

.EXAMPLE
    .\open-all-projects.ps1

.EXAMPLE
    .\open-all-projects.ps1 -EditorsPath "D:\Unity\Hub\Editor"
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$EditorsPath
)

$ErrorActionPreference = "Stop"

# Root directory (parent of commands)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

# Auto-detect editors path if not provided
if (-not $EditorsPath) {
    # Try to read from Unity Hub config file
    $HubConfigPath = Join-Path $env:APPDATA "UnityHub\secondaryInstallPath.json"
    if (Test-Path $HubConfigPath) {
        $ConfigContent = Get-Content $HubConfigPath -Raw | ConvertFrom-Json
        if ($ConfigContent) {
            $EditorsPath = $ConfigContent
        }
    }

    # Fallback: check common locations
    if (-not $EditorsPath -or -not (Test-Path $EditorsPath)) {
        $CommonPaths = @(
            "C:\Program Files\Unity\Hub\Editor",
            "D:\Program Files\Unity\Hub\Editor",
            "D:\Unity\Hub\Editor",
            "C:\Unity\Hub\Editor"
        )
        foreach ($Path in $CommonPaths) {
            if (Test-Path $Path) {
                $EditorsPath = $Path
                break
            }
        }
    }
}

# Verify editors path exists
if (-not $EditorsPath -or -not (Test-Path $EditorsPath)) {
    Write-Error "Unity editors folder not found.`nPlease specify the correct path using -EditorsPath parameter.`nExample: .\open-all-projects.ps1 -EditorsPath 'D:\Unity\Editor'"
    exit 1
}

# Define projects to open
$Projects = @(
    "Installer",
    "Unity-Package",
    "Unity-Tests/2022.3.62f3",
    "Unity-Tests/2023.2.22f1",
    "Unity-Tests/6000.3.1f1"
)

Write-Host "Opening Unity projects..." -ForegroundColor Cyan
Write-Host "Editors path: $EditorsPath" -ForegroundColor Gray
Write-Host ""

foreach ($Project in $Projects) {
    $ProjectPath = Join-Path $RepoRoot $Project

    if (-not (Test-Path $ProjectPath)) {
        Write-Warning "Project not found: $ProjectPath"
        continue
    }

    # Read the project version from ProjectSettings/ProjectVersion.txt
    $VersionFile = Join-Path $ProjectPath "ProjectSettings/ProjectVersion.txt"
    if (-not (Test-Path $VersionFile)) {
        Write-Warning "ProjectVersion.txt not found for: $Project"
        continue
    }

    # Parse the version (format: "m_EditorVersion: 2022.3.62f1")
    $VersionContent = Get-Content $VersionFile -Raw
    if ($VersionContent -match "m_EditorVersion:\s*(.+)") {
        $UnityVersion = $Matches[1].Trim()
    }
    else {
        Write-Warning "Could not parse Unity version for: $Project"
        continue
    }

    # Find the Unity Editor executable
    $UnityExe = Join-Path $EditorsPath "$UnityVersion\Editor\Unity.exe"
    if (-not (Test-Path $UnityExe)) {
        Write-Warning "Unity $UnityVersion not installed. Skipping: $Project"
        continue
    }

    Write-Host "Opening: $Project (Unity $UnityVersion)" -ForegroundColor Yellow

    # Launch Unity Editor with the project path
    Start-Process -FilePath $UnityExe -ArgumentList "-projectPath `"$ProjectPath`""

    # Delay between launches to avoid overwhelming the system
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "Done! All projects are being opened." -ForegroundColor Green
