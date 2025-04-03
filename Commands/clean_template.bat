cd ..
rmdir /s /q "ProjectSettings"
rmdir /s /q ".vscode"

for /r %%f in (*.meta) do (
    del /f /q "%%f"
)

del /f /q "Packages/packages-lock.json"
del /f /q "Unity-Package-Template.sln"

echo Done!
pause