@ECHO OFF
IF EXIST PowerShell\pwsh.exe (start "PowerShell (Portable) - github.com/digi-ron" PowerShell\pwsh.exe -noexit -file .\PSLoader.ps1) ELSE (start "PowerShell (Local+) - github.com/digi-ron" powershell -noexit -file .\PSLoader.ps1)