cd ..
cd "Assets/root"

@echo off

REM Check if the correct number of arguments is provided
if "%~2"=="" (
    echo Usage: package_rename.bat <username> <packageName>
    exit /b 1
)

set "username=%~1"
set "packageName=%~2"
set "lowerPackageName=%packageName%"
set "lowerUsername=%username%"
setlocal enabledelayedexpansion
for %%A in (%lowerPackageName%) do set "lowerPackageName=%%A"
for %%A in (%lowerUsername%) do set "lowerUsername=%%A"

REM Recursively replace "package" and "Package" in file content, ignoring .md files
for /r %%F in (*) do (
    if /i not "%%~xF"==".md" (
        powershell -Command "(Get-Content -Raw -Path '%%F') -replace 'package', '!lowerPackageName!' -replace 'Package', '%packageName%' -replace 'Your_Name', '%username%' -replace 'your_name', '!lowerUsername!' | Set-Content -Path '%%F'"
    )
)

REM Recursively rename files with "package" and "Package" in their names, ignoring .md files
for /r %%F in (*) do (
    if /i not "%%~xF"==".md" (
        set "newName=%%~nxF"
        set "newName=!newName:package=!lowerPackageName!"
        set "newName=!newName:Package=%packageName%!"
        if not "%%~nxF"=="!newName!" (
            ren "%%F" "!newName!"
        )
    )
)

echo Done!
pause