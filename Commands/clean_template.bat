rmdir /s /q "ProjectSettings"
rmdir /s /q "Packages"
rmdir /s /q ".vscode"

for /r %%f in (*.meta) do (
    del /f /q "%%f"
)

pause