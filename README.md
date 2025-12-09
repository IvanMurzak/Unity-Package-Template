# [Unity Package Template](https://github.com/IvanMurzak/Unity-Package-Template)

<img width="100%" alt="Stats" src="https://user-images.githubusercontent.com/9135028/198754538-4dd93fc6-7eb2-42ae-8ac6-d7361c39e6ef.gif"/>

Unity Editor supports NPM packages. It is way more flexible solution in comparison with classic Plugin that Unity is using for years. NPM package supports versioning and dependencies. You may update / downgrade any package very easily. Also, Unity Editor has UPM (Unity Package Manager) that makes the process even simpler.

This template repository is designed to be easily updated into a real Unity package. Please follow the instruction bellow, it will help you to go through the entire process of package creation, distribution and installing.

# Steps to make your package

#### 1️⃣ Click the button to create new repository on GitHub using this template.

[![create new repository](https://user-images.githubusercontent.com/9135028/198753285-3d3c9601-0711-43c7-a8f2-d40ec42393a2.png)](https://github.com/IvanMurzak/Unity-Package-Template/generate)

#### 2️⃣ Clone your new repository and open it in Unity Editor

#### 3️⃣ Initialize Project

Use the initialization script to rename the package and replace all placeholders.

```powershell
.\commands\init.ps1 -PackageId "com.company.package" -PackageName "My Package"
```

This script will:
- Rename directories and files.
- Replace `YOUR_PACKAGE_ID`, `YOUR_PACKAGE_NAME`, etc. in all files.

#### 4️⃣ Manual Configuration

1. **Update `package.json`**
   Open `Unity-Package/Assets/root/package.json` and update:
   - `description`
   - `author`
   - `keywords`
   - `unity` (minimum supported Unity version)

2. **Generate Meta Files**
   To ensure all Unity meta files are correctly generated:
   - Open Unity Hub.
   - Add the `Installer` folder as a project.
   - Add the `Unity-Package` folder as a project.
   - Open both projects in Unity Editor. This will generate the necessary `.meta` files.

#### 5️⃣ Version Management

To update the package version across all files (package.json, Installer.cs, etc.), use the bump version script:

```powershell
.\commands\bump-version.ps1 -NewVersion "1.0.1"
```

#### 6️⃣ Setup CI/CD

To enable automatic testing and deployment:

1.  **Configure GitHub Secrets**
    Go to `Settings` > `Secrets and variables` > `Actions` > `New repository secret` and add:
    -   `UNITY_EMAIL`: Your Unity account email.
    -   `UNITY_PASSWORD`: Your Unity account password.
    -   `UNITY_LICENSE`: Content of your `Unity_lic.ulf` file.
        -   Windows: `C:/ProgramData/Unity/Unity_lic.ulf`
        -   Mac: `/Library/Application Support/Unity/Unity_lic.ulf`
        -   Linux: `~/.local/share/unity3d/Unity/Unity_lic.ulf`

2.  **Enable Workflows**
    Rename the sample workflow files to enable them:
    -   `.github/workflows/release.yml-sample` ➡️ `.github/workflows/release.yml`
    -   `.github/workflows/test_pull_request.yml-sample` ➡️ `.github/workflows/test_pull_request.yml`

3.  **Update Unity Version**
    Open both `.yml` files and update the `UNITY_VERSION` (or similar variable) to match your project's Unity Editor version.

4.  **Automatic Deployment**
    The release workflow triggers automatically when you push to the `main` branch with an incremented version in `package.json`.

#### 7️⃣ Add files into `Assets/root` folder

[Unity guidelines](https://docs.unity3d.com/Manual/cus-layout.html) about organizing files into the package root directory

```text
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

##### Final polishing

- Update the `README.md` file (this file) with information about your package.
- Copy the updated `README.md` to `Assets/root` as well.

> ⚠️ Everything outside of the `root` folder won't be added to your package. But still could be used for testing or showcasing your package at your repository.

#### 8️⃣ Deploy to any registry you like

- [Deploy to OpenUPM](https://github.com/IvanMurzak/Unity-Package-Template/blob/main/Docs/Deploy-OpenUPM.md) (recommended)
- [Deploy using GitHub](https://github.com/IvanMurzak/Unity-Package-Template/blob/main/Docs/Deploy-GitHub.md)
- [Deploy to npmjs.com](https://github.com/IvanMurzak/Unity-Package-Template/blob/main/Docs/Deploy-npmjs.md)

#### 9️⃣ Install your package into Unity Project

When your package is distributed, you can install it into any Unity project.

> Don't install into the same Unity project, please use another one.

- [Install OpenUPM-CLI](https://github.com/openupm/openupm-cli#installation)
- Open a command line at the root of Unity project (the folder which contains `Assets`)
- Execute the command (for `OpenUPM` hosted package)

  ```bash
  openupm add YOUR_PACKAGE_NAME
  ```

# Final view in Unity Package Manager

![image](https://user-images.githubusercontent.com/9135028/198777922-fdb71949-aee7-49c8-800f-7db885de9453.png)
