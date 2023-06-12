# PSS-PortablePowerShell
Somewhat simple script to allow for the use of a "portable" version of powershell. Note that this is really only for one scenario: a developer using corporate machine which *can* install modules using the ```-Scope CurrentUser``` flag, but is sick and tired of issues that arise from OneDrive being enabled and screwing anything PowerShell related in the process

## Features
- Can run a portable version of PowerShell 7+ if required (testing on this solution was done with the zip deployment of version 7.3.4 found [HERE](https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/PowerShell-7.3.4-win-x64.zip), but would likely work with any of the latest releases in the same manner [HERE](https://aka.ms/powershell-release?tag=stable))
- contains 2 functions, listed below:
    - ```Load-Local``` - Downloads and saves modules to the ```$newModuleLocation``` in the PowerShell script (default ```./Modules```)
    - ```Remove-Local``` - Removes the module in the modules directory by way of forcefully removing the folder structure
- has an easy to modify txt file for setting modules to be installed (explained further below)
- simple usage - ```launch.bat``` file allows for double-click launch with a simple shortcut (required way to launch if intending to use a portable version of PowerShell)

## Prerequisites
- pick a location for the repository structure to go
- If you're planning on using a Portable PowerShell 7+ Instance:
    - ensure you download the .zip version of the PowerShell installation, **and unblock the file using the zip file properties** (saves a lot of run dialogs later)
    - extract all files *within* the  PowerShell zip into the ```./PowerShell``` directory. To confirm you have it right, the batch file included should be able to run ```./PowerShell/pwsh.exe``` with no problems
- modify the included ```modules.txt``` file to your liking. By default, the script will install the following modules:
    - Az
    - Microsoft.Graph
    - PnP.PowerShell (v1.12.0)
- run the ```launch.bat``` file, and happy scripting!

## modules.txt structure
The modules.txt file follows a simple, pipe-separated syntax, where the module to be installed is on the left side, and should you wish to install a certain version of a package, a ```|xx.xx.xx``` should be added to the end of the line, where the "x"s are version numbers.

For example, if you just needed the latest ```bongoscript``` module, you would simply add:
```
bongoscript
```
HOWEVER, if you needed ```bongoscript``` at specifically v1.4.20, would would instead need:
```
bongoscript|1.4.20
```

***NOTE: While this solution can technically support whitespace between the module name, pipe-separator and version number, I'm not recommending it***

## Limitations
- Installing modules tends to take significantly longer than what it normally would with a non-portable system. Bad news, this seems to be an issue at PowerShells end, good news it'll only happen if installing new modules (either through modules.txt or through ```Load-Local```)
- no module "installed" comes up in the ```Get-Module``` command, as they're technically not installed properly, I'm simply modifying the ```$env:PSModulePath``` variable for the script session
- the ```Load-Local``` function doesn't conform to [Microsoft's Guidelines](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands). This is intentional as I refused to use something as useless sounding as ```Get-Local``` or ```Add-Local```
- ```Load-Local``` doesn't add or save anything to the ```modules.txt``` file. This is intentional, so that if you manage to break the Modules folder, you can simply nuke, recreate, and run with your chosen default modules
- There is no functionality to update packages. The acceptable solution would be to run ```Remove-Local``` and either restart the script (if the module is in modules.txt) or use the ```Load-Local``` function