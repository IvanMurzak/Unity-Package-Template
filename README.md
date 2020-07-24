# Unity-Package-Template
UPM (Unity Package Manager) ready GitHub repository for Unity
New Unity packages system is very easy to use and make your project much more cleaner.
The repository helps you to create your own Unity package with dependecies.

# How to use
- "Use the template" green button at top right corner of GitHub page
- Clone your new repository
- Add all your stuff to Assets/_PackageRoot directory
- Update Assets/_PackageRoot/package.json to yours
- (on Windows) execute gitSubTreePushToUPM.bat
- (on Mac) execute gitSubTreePushToUPM.makefile
- Create release from UPM branch on GitHub web page.

![alt text](https://neogeek.dev/images/creating-custom-packages-for-unity-2018.3--git-release.png)


# How to import your package to Unity project
You may use one of the variants

## Variant 1
- Select "Add package from git URL"
- Paste URL to your GitHub repository with simple modification:
-- <code>https://github.com/USER/REPO.git#upm</code> Dont forget to replace **USER** and **REPO** to yours

![alt text](https://neogeek.dev/images/creating-custom-packages-for-unity-2018.3--package-manager.png)

## Variant 2
Modify manifest.json file. 
Change "your.own.package" to the name of your package.
Dont forget to replace **USER** and **REPO** to yours.
<pre><code>{
    "dependencies": {
        "your.own.package": "https://github.com/USER/REPO.git#upm"
    }
}
</code></pre>
