# user variables
$newModuleLocation = $pwd.Path+"\Modules"

# function(s)
function Load-Local {
    param (
        [Parameter(Mandatory)]
        [string]$moduleName,
        [string]$moduleVersion
    )

    if($moduleVersion)
    {
        Find-Module -Name "$($moduleName)" -RequiredVersion $moduleVersion | Save-Module -Path $newModuleLocation -Force
    }
    else
    {
        Find-Module -Name "$($moduleName)" | Save-Module -Path $newModuleLocation -Force
    }
}

function Remove-Local {
    param ([Parameter(Mandatory)][string]$moduleName)
    Remove-Item "$($newModuleLocation)\$($moduleName)" -Recurse -Force
}

#working code
$moduleArray = (Get-Content -Path .\modules.txt).Split([System.Environment]::NewLine)
$env:PSModulePath += ";$($newModuleLocation)"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Write-Output "Verifying Requisite Modules..."
foreach($module in $moduleArray)
{
    $splitvar = $module.Split("|")
    if($splitvar[1])
    {
        if(-not (Test-Path -Path "$($newModuleLocation)\$($splitvar[0])"))
        {
            Load-Local -moduleName "$($splitvar[0])" -moduleVersion $splitvar[1]
            # Find-Module -Name "$($splitvar[0])" -RequiredVersion $splitvar[1] | Save-Module -Path $newModuleLocation -Force
            Write-Output "Module $($splitvar[0]) (v$($splitvar[1])) installed"
        }
        else
        {
            Write-Output "Module $($splitvar[0]) (v$($splitvar[1])) already installed"
        }
    }
    else
    {
        if(-not (Test-Path -Path "$($newModuleLocation)\$($module)"))
        {
            Load-Local -moduleName "$($module)"
            # Find-Module -Name "$($module)" | Save-Module -Path $newModuleLocation -Force
            Write-Output "Module $($module) installed"
        }
        else
        {
            Write-Output "Module $($splitvar[0]) already installed"
        }
    }
    
    
}