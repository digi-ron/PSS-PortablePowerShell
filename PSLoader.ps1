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