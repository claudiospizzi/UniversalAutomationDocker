
Write-Host "Start process $PID"


# Part 1
# Load core modules for the universal automation.

Write-Host 'Load UniversalAutomation module'

Import-Module 'UniversalAutomation'
Import-Module 'UniversalAutomation.Dashboard'


# Part 2
# Start the universal automation server, using environment variables.

Write-Host 'Start UniversalAutomation server'

$uaServerSplat = @{
    Port                = 10000
    ConnectionString    = 'C:\App\Database\database.db'
    RepositoryPath      = 'C:\App\Repository'
    GitRemote           = $Env:UA_GIT_REMOTE
    GitRemoteCredential = [System.Management.Automation.PSCredential]::new($Env:UA_GIT_REMOTE_USERNAME, (ConvertTo-SecureString -String $Env:UA_GIT_REMOTE_PASSWORD -AsPlainText -Force))
}
$appToken = Start-UAServer @uaServerSplat


# Part 3
# If the server start did not return an app token, enable the authentication.
# This should only be required for the first run.

if ($null -eq $appToken)
{
    Write-Host 'Enable Authentication on UniversalAutomation server'

    $appToken = (Enable-UAAuthentication -ComputerName 'http://localhost:10000' -Force).Token
}


# Part 4
# Connect to the server to store the connection in this session. This is used
# later for the universal dashbaord.

Write-Host 'Connect to the UniversalAutomation server'

Connect-UAServer -ComputerName 'http://localhost:10000' -AppToken $appToken


# Part 5
# Set license for the Universal Automation and Universal Dashboard.

Write-Host 'Apply UniversalAutomation and UniversalDashboard license'

Set-UALicense -Key $Env:UA_LICENSE
$Env:UDLICENSE = $Env:UD_LICENSE


# Part 6
# Start the Universal Automation Dashboard.

$authMethod = New-UDAuthenticationMethod -Endpoint {
    param ([PSCredential] $Credential)

    Write-Host "[Authentication] Authenticated user $($Credential.Username)"

    # For testing only, should check password...
    New-UDAuthenticationResult -Success -UserName $Credential.Username
}

$AuthPolicy = New-UDAuthorizationPolicy -Name "Policy" -Endpoint {
    param ($ClaimsPrincipal)

    $username = $ClaimsPrincipal.Identity.Name 

    Write-Host "[Authorization] Authorize user $username"

    if (-not $Session:AppToken)
    {
        Write-Host "[Authorization] Identify user $username"

        $identity = Get-UAIdentity -Name $username 

        if ($null -eq $identity)
        {
            Write-Host "[Authorization] Create identify for user $username"

            $role = Get-UARole -Name 'Administrator'
            $identity = New-UAIdentity -Name $username -Role $role
        }

        Write-Host "[Authorization] Grant identity $identity"

        $Session:AppToken = Grant-UAAppToken -Identity $identity
    }

    $true
}

$loginPage = New-UDLoginPage -AuthenticationMethod $authMethod -AuthorizationPolicy $authPolicy

Start-UADashboard -ComputerName "http://localhost:10000" -Port 8080 -LoginPage $loginPage

while ($true) { start-sleep -Second 1 }
