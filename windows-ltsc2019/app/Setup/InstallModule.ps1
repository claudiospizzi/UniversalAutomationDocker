<#
    .SNOPSIS
        Install all required PowerShell modules. The specified version is only
        for the UniversalAutomation. Other modules will use the latest version.
#>
param
(
    # Module version for UniversalAutomation.
    [Parameter(Mandatory = $true, Position = 0)]
    [System.String]
    $Version
)

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

# Install NuGet package provider, required to install modules later.
Write-Host 'Install NuGet package provider'
Install-PackageProvider -Name 'NuGet' -MinimumVersion '2.8.5.201' -Force | Out-Null

# Install core modules, required to run Universal Automation
Write-Host 'Install core modules'
Install-Module -Name 'SecurityFever' -Scope 'AllUsers' -Force
Install-Module -Name 'UniversalAutomation' -RequiredVersion $Version -Scope 'AllUsers' -Force
Install-Module -Name 'UniversalAutomation.Dashboard' -RequiredVersion $Version -Scope 'AllUsers' -Force

# Install other modules
# Write-Host 'Install other modules'
