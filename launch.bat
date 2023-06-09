@ECHO OFF
IF EXIST PowerShell\pwsh.exe (start "PowerShell (Portable)" PowerShell\pwsh.exe -noexit -file .\PSLoader.ps1) ELSE (start "PowerShell (Local+)" powershell -noexit -file .\PSLoader.ps1)