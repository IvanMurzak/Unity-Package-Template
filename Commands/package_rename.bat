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

echo Debugging: Converting to lowercase
for /f "usebackq delims=" %%A in (`powershell -Command "$env:packageName.ToLower()"`) do set "lowerPackageName=%%A"
for /f "usebackq delims=" %%A in (`powershell -Command "$env:username.ToLower()"`) do set "lowerUsername=%%A"

echo Debugging: SetLocal
setlocal enabledelayedexpansion

REM Debugging: Print variables
echo Username: %username%
echo PackageName: %packageName%
echo Lowercase PackageName: !lowerPackageName!
echo Lowercase Username: !lowerUsername!

REM Recursively replace "package" and "Package" in file content, ignoring .md and .meta files
for /r %%F in (*) do (
    REM Check if the file ends with .md or .meta
    if /i "%%~xF"==".asmdef" (
        REM Process the file
        echo Processing file: %%F
        powershell -Command "(Get-Content -Raw -Path '%%F') -replace 'Package', '%packageName%' -replace 'package', '!lowerPackageName!' -replace 'Your_Name', '%username%' -replace 'your_name', '!lowerUsername!' | Set-Content -Path '%%F'" || (
            echo Failed to process file %%F
        )
    )
    if /i "%%~nxF"=="package.json" (
        REM Process the file
        echo Processing file: %%F
        powershell -Command "(Get-Content -Raw -Path '%%F') -replace 'Package', '%packageName%' -replace 'package', '!lowerPackageName!' -replace 'Your_Name', '%username%' -replace 'your_name', '!lowerUsername!' | Set-Content -Path '%%F'" || (
            echo Failed to process file %%F
        )
    )
)

REM Recursively rename files with "package" and "Package" in their names, ignoring .md files
for /r %%F in (*) do (
    if /i "%%~xF"==".asmdef" (
        set "newName=%%~nxF"
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