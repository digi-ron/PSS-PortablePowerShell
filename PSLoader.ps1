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
        if(-not (Test-Path -Path "$($newModuleLocation)\$($splitvar[0].Trim())"))
        {
            Load-Local -moduleName "$($splitvar[0].Trim())" -moduleVersion $splitvar[1].Trim()
            Write-Output "Module $($splitvar[0].Trim()) (v$($splitvar[1].Trim())) installed"
        }
        else
        {
            Write-Output "Module $($splitvar[0].Trim()) (v$($splitvar[1].Trim())) already installed"
        }
    }
    else
    {
        if(-not (Test-Path -Path "$($newModuleLocation)\$($module)"))
        {
            Load-Local -moduleName "$($module)"
            Write-Output "Module $($module) installed"
        }
        else
        {
            Write-Output "Module $($module) already installed"
        }
    }
    
    
}