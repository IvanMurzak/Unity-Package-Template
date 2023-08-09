# Unity Package Template

<img width="100%" alt="Stats" src="https://user-images.githubusercontent.com/9135028/198754538-4dd93fc6-7eb2-42ae-8ac6-d7361c39e6ef.gif"/>

UPM (Unity Package Manager) ready GitHub repository for Unity. Unity package system is very easy to use and to make your project much cleaner. The repository helps you to create your own Unity package with dependencies.

This is a template repository for fast package creation for Unity which can be imported to Unity project through `Package Manager` in Unity Editor. The repository is universal for `Package Creation` and `Publishing` cycles.

### Supported
  - ✔️ [NPMJS](https://www.npmjs.com/)
  - ✔️ [OpenUPM](https://openupm.com/)
  - ✔️ [GitHub Packages](https://github.com/features/packages)
  - ✔️ [UPM (Unity Package Manager)](https://docs.unity3d.com/Manual/upm-ui.html)


# Unity Package Creation 
[![image](https://user-images.githubusercontent.com/9135028/198753285-3d3c9601-0711-43c7-a8f2-d40ec42393a2.png)](https://github.com/IvanMurzak/Unity-Package-Template/generate)
- Create your own repository on GitHub using this repository as a template. Press the green button one line above.
- Clone freshly created repository and open in Unity
- Put files that should be packed into the package under `Assets/_PackageRoot` folder. Everything outside the folder could be used for testing or demonstrating your plugin 
<details>
  <summary>>> Detailed data structure in package root folder</summary>
  
  [Unity guidlines](https://docs.unity3d.com/Manual/cus-layout.html) about organizing files into the package root directory
  
```
  <root>
  ├── package.json
  ├── README.md
  ├── CHANGELOG.md
  ├── LICENSE.md
  ├── Third Party Notices.md
  ├── Editor
  │   ├── [company-name].[package-name].Editor.asmdef
  │   └── EditorExample.cs
  ├── Runtime
  │   ├── [company-name].[package-name].asmdef
  │   └── RuntimeExample.cs
  ├── Tests
  │   ├── Editor
  │   │   ├── [company-name].[package-name].Editor.Tests.asmdef
  │   │   └── EditorExampleTest.cs
  │   └── Runtime
  │        ├── [company-name].[package-name].Tests.asmdef
  │        └── RuntimeExampleTest.cs
  ├── Samples~
  │        ├── SampleFolder1
  │        ├── SampleFolder2
  │        └── ...
  └── Documentation~
       └── [package-name].md
```

</details>

### Edit `Assets/_packageRoot/package.json` 

#### Required steps
- change `name` in format `my.packge.name.hello.world`
- change `displayName`, `version`, `description` to any
- change `unity` to setup minimum supported Unity version

#### Optional steps
- add yourself as an author in format `"author": { "name": "Ivan Murzak", "url": "https://github.com/IvanMurzak" },`
- advanced editing and format `package.json` - read more about NPM package format [here](https://docs.npmjs.com/cli/v8/configuring-npm/package-json)
- don't forget to update `LICENSE` file


# Publishing
There are many platforms to publish your Package. You can read more about all alternative variants and their pros and cons [here](https://github.com/IvanMurzak/Unity-Package-Template/blob/master/AlternativeDestributionOptions.md) (OPTIONAL). This tutorial is targeted on NPMJS deployment.

### Preparation (just once)
- Install [NPM](https://nodejs.org/en/download/)
- Create [NPMJS](https://npmjs.com) account
- Execute script in Unity project `npmAddUser.bat` and sign-in to your account
<details>
  <summary>>> npmAddUser.bat script content</summary>
  
  It executes `npm adduser` command in the package root folder
  
  ```
cd Assets/_PackageRoot
npm adduser
  ```
  
</details>

### Deploy
Make sure you finished editing `package.json` and files in `Assets/_PackageRoot` folder. Because it is going to be public with no ability to discard it
- Don't forget to increment `version` in `package.json` file. Versions lower than `1.0.0` gonna be shown in Unity as "preview"
- Execute the script in Unity project `npmPublish.bat` to publish your package to the public

<details>
  <summary>>> npmPublish.bat script content</summary>
  
  The first line in the script copies the `README.md` file to the package root. Because the README should be in a package also, that is a part of the package format.
  It executes `npm publish` command in the package root folder. The command publishes your package to the NPMJS platform automatically
  
  ```
xcopy .\README.md .\Assets\_PackageRoot\README.md /y
cd Assets\_PackageRoot
npm publish
pause
  ```
  
</details>


# Installation 
When your package is distributed, you can install it into any Unity project. 

- [Install OpenUPM-CLI](https://github.com/openupm/openupm-cli#installation)
- Open the command line in the Unity project folder
- `openupm --registry https://registry.npmjs.org add YOUR_PACKAGE_NAME`


# Final view in Package Manager

![image](https://user-images.githubusercontent.com/9135028/198777922-fdb71949-aee7-49c8-800f-7db885de9453.png)
