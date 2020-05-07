<#
    .SNOPSIS
        Download the git installer and invoke it in silent mode.
#>
param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [System.String]
    $Version
)

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

# Download installer
Write-Host "Download Git-$Version-64-bit.exe ..."
Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v$Version.windows.1/Git-$Version-64-bit.exe" -OutFile "C:\Setup\Git-$Version-64-bit.exe"

# Invoke installation
Write-Host "Run Git-$Version-64-bit.exe /SILENT"
& "C:\Setup\Git-$Version-64-bit.exe" /SILENT

# The setup will exit without waiting for compleation, so wait here
Write-Host "Wait for Setup ..."
do
{
    Start-Sleep -Seconds 5
}
while ($null -ne (Get-Process -Name "C:\Setup\Git-$Version-64-bit" -ErrorAction 'SilentlyContinue'))

# Finally, update the path variable
[System.Environment]::SetEnvironmentVariable("Path", "$Env:Path;C:\Program Files\Git\cmd", [System.EnvironmentVariableTarget]::Machine)
