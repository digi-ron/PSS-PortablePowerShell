# user variables
$newModuleLocation = $PSScriptRoot+"\Modules"

# function(s)
function Load-Local {
    param (
        [Parameter(Mandatory)]
        [string]$moduleName,
        [string]$moduleVersion
    )

    if($moduleVersion)
    {
        if(Test-Path -Path "$($newModuleLocation)\$($moduleName)")
        {
            Write-Output "$($moduleName) (v$($moduleVersion)) already installed"
        }
        else {
            Find-Module -Name "$($moduleName)" -RequiredVersion $moduleVersion | Save-Module -Path $newModuleLocation -Force
            Write-Output "$($moduleName) (v$($moduleVersion)) installed"
        }
    }
    else
    {
        if(Test-Path -Path "$($newModuleLocation)\$($moduleName)")
        {
            Write-Output "$($moduleName) already installed"
        }
        else {
            Find-Module -Name "$($moduleName)" | Save-Module -Path $newModuleLocation -Force
            Write-Output "$($moduleName) installed"
        }
    }
}

function Remove-Local {
    param ([Parameter(Mandatory)][string]$moduleName)

    $directories = (Get-ChildItem -Path $newModuleLocation -Filter "*$($moduleName)*" -Directory)

    if($directories.Count -le 0) {
        Write-Warning "no modules match input string ""$($moduleName)"""
    }

    foreach($dir in $directories) {
        Remove-Item -Path $dir.FullName -Recurse -Force
        Write-Output "Removed $($dir.Name)..."
    }
}

#working code
Set-Location $PSScriptRoot
$moduleArray = (Get-Content -Path .\modules.txt).Split([System.Environment]::NewLine)
$env:PSModulePath += ";$($newModuleLocation)"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Write-Output "Verifying Requisite Modules..."
foreach($module in $moduleArray)
{
    $splitvar = $module.Split("|")
    if($splitvar[1])
    {
        Load-Local -moduleName "$($splitvar[0].Trim())" -moduleVersion $splitvar[1].Trim()
    }
    else {
        Load-Local -moduleName "$($module)"
    }
    
}

# change directory (if invoked)
if($args[0])
{
    Set-Location "$($args[0])"
}

# clean-up - stops people wondering what all the variables are for
Remove-Variable * -ErrorAction SilentlyContinue