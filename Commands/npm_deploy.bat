xcopy ..\README.md ..\Assets\root\README.md* /Y
xcopy ..\README.md ..\Assets\root\Documentation~\README.md* /Y
cd ..\Assets\root
npm publish
pause