# PSS-PortablePowerShell
Somewhat simple script to allow for the use of a "portable" version of powershell. Note that this is really only for one scenario: a corporate machine which *can* install modules using the ```-Scope CurrentUser``` flag, but is sick and tired of issues that arise from OneDrive being enabled and screwing anything PowerShell related in the process

## Features
- Can run a portable version of PowerShell 7+ if required (testing on this solution was done with the zip deployment of version 7.3.4 found [HERE](https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/PowerShell-7.3.4-win-x64.zip), but would likely work with any of the latest releases in the same manner [HERE](https://aka.ms/powershell-release?tag=stable))
- contains 2 functions, listed below:
    - ```Load-Local``` - Downloads and saves modules to the ```$newModuleLocation``` in the PowerShell script (default ```./Modules```)
    - ```Remove-Local``` - Removes the module in the modules directory by way of forcefully removing the folder structure
- has an easy to modify txt file for setting modules to be installed (explained further below)
- simple usage - ```launch.bat``` file allows for double-click launch with a simple shortcut (required way to launch if intending to use a portable version of PowerShell)

## Prerequisites
- pick a location for the repository structure to go
- (if using a portable powershell version) ensure you download the .zip version of the PowerShell installation, and extract all files *within* the zip into the ```./PowerShell``` directory. To confirm you have it right, the batch file included should be able to run ```./PowerShell/pwsh.exe``` with no problems
- modify the included ```modules.txt``` file to your liking. By default, the script will install the following modules:
    - Az
    - Microsoft.Graph
    - PnP.PowerShell (v1.12.0)
- run the ```launch.bat``` file, and happy scripting!

## modules.txt structure
The modules.txt file follows a simple, pipe-separated syntax, where the module to be installed is on the left side, and should you wish to install a certain version of a package, a ```|xx.xx.xx``` should be added to the end of the line.

For example, if you just needed the latest ```bongoscript``` module, you would simply add:
```
bongoscript
```
HOWEVER, if you needed ```bongoscript``` at specifically v1.4.20, would would instead need:
```
bongoscript|1.4.20
```

***NOTE: due to how I did this code, there is currently no trim for the split variable, meaning that there needs to be NO WHITESPACE between the package name, pip-separator, and version number!!!***