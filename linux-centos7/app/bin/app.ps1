Import-Module 'UniversalAutomation'
Import-Module 'UniversalAutomation.Dashboard'

$uaServerSplat = @{
    Port                = 10000
    ConnectionString    = '/app/database/database.db'
    RepositoryPath      = '/app/repository'
    GitRemote           = $Env:UA_GIT_REMOTE
    GitRemoteCredential = [System.Management.Automation.PSCredential]::new($Env:UA_GIT_REMOTE_USERNAME, (ConvertTo-SecureString -String $Env:UA_GIT_REMOTE_PASSWORD -AsPlainText -Force))
    JwtSigningKey       = $Env:UA_JWT_SIGNING_KEY
}
$appToken = Start-UAServer @uaServerSplat

Connect-UAServer -ComputerName 'http://localhost:10000' -AppToken $appToken
Start-UADashboard -ComputerName "http://localhost:10000" -Port 8080
