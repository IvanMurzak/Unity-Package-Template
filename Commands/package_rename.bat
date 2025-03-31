@echo off
echo Started package rename process.

echo Change to the target directory
cd ..\Assets\root || (
    echo Failed to change directory to ..\Assets\root
    exit /b 1
)

echo Username: %~1
echo Package Name: %~2

echo Check if the correct number of arguments is provided
if "%~2"=="" (
    echo Usage: package_rename.bat {username} {packageName}
    exit /b 1
)

echo Debugging: Reading arguments
set "username=%~1"
set "packageName=%~2"
set "lowerPackageName=%packageName%"
set "lowerUsername=%username%"
echo Debugging: SetLocal
setlocal enabledelayedexpansion
echo Debugging: for1
for %%A in (%lowerPackageName%) do set "lowerPackageName=%%A"
for %%A in (%lowerUsername%) do set "lowerUsername=%%A"

echo Debugging: Print variables
echo Username: %username%
echo PackageName: %packageName%
echo Lowercase PackageName: !lowerPackageName!
echo Lowercase Username: !lowerUsername!

REM Recursively replace "package" and "Package" in file content, ignoring .md files
for /r %%F in (*) do (
    if /i not "%%~xF"==".md" (
        powershell -Command "(Get-Content -Raw -Path '%%F') -replace 'package', '!lowerPackageName!' -replace 'Package', '%packageName%' -replace 'Your_Name', '%username%' -replace 'your_name', '!lowerUsername!' | Set-Content -Path '%%F'" || (
            echo Failed to process file %%F
        )
    )
)

REM Recursively rename files with "package" and "Package" in their names, ignoring .md files
for /r %%F in (*) do (
    if /i not "%%~xF"==".md" (
        set "newName=%%~nxF"
        set "newName=!newName:package=!lowerPackageName!"
        set "newName=!newName:Package=%packageName%!"
        if not "%%~nxF"=="!newName!" (
            ren "%%F" "!newName!" || (
                echo Failed to rename file %%F
            )
        )
    )
)

echo Done!
pause