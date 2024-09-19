# What is this?
- This is a config file to install `Microsoft 365 Apps for enterprise` on a Windows machine
- This installs the following
  - Word
  - Excel
  - PowerPoint
- Auto updates are enabled

# Links
- [Office Deployment Tool](https://go.microsoft.com/fwlink/p/?LinkID=626065)

# Steps
- Download above file and extract `setup.exe`
- Move `config.xml` to the same folder
- Open PowerShell as admin then cd to the folder where `setup.exe` is and run
```
.\setup.exe /configure config.xml
```
- Then activate with MAS