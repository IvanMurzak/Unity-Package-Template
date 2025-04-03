cd ..
rmdir /s /q ".vscode"

for /r %%f in (*.meta) do (
    del /f /q "%%f"
)


del /f /q "Unity-Package-Template.sln"

del /f /q "Packages\packages-lock.json"

del /f /q "ProjectSettings\ProjectSettings.asset"
del /f /q "ProjectSettings\AudioManager.asset"
del /f /q "ProjectSettings\ClusterInputManager.asset"
del /f /q "ProjectSettings\DynamicsManager.asset"
del /f /q "ProjectSettings\EditorBuildSettings.asset"
del /f /q "ProjectSettings\EditorSettings.asset"
del /f /q "ProjectSettings\GraphicsSettings.asset"
del /f /q "ProjectSettings\InputManager.asset"
del /f /q "ProjectSettings\NavMeshAreas.asset"
del /f /q "ProjectSettings\PackageManagerSettings.asset"
del /f /q "ProjectSettings\Physics2DSettings.asset"
del /f /q "ProjectSettings\PresetManager.asset"
del /f /q "ProjectSettings\QualitySettings.asset"
del /f /q "ProjectSettings\TagManager.asset"
del /f /q "ProjectSettings\TimeManager.asset"
del /f /q "ProjectSettings\UnityConnectSettings.asset"
del /f /q "ProjectSettings\VFXManager.asset"
del /f /q "ProjectSettings\XRSettings.asset"


echo Done!
pause