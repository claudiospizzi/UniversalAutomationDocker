FROM mcr.microsoft.com/windows/servercore:ltsc2019

ARG ua_version=1.3.1

# Prepare the profile: handle errors and suppress progress bar
RUN powershell -Command "New-Item -Path 'C:\\Users\\ContainerAdministrator\\Documents\\WindowsPowerShell' -ItemType 'Directory' | Out-Null"
RUN powershell -Command "Add-Content -Path 'C:\\Users\\ContainerAdministrator\\Documents\\WindowsPowerShell\\profile.ps1' -Value '\$ProgressPreference = ''SilentlyContinue'''"
RUN powershell -Command "Add-Content -Path 'C:\\Users\\ContainerAdministrator\\Documents\\WindowsPowerShell\\profile.ps1' -Value '\$ErrorActionPreference = ''Stop'''"

# Install the Universal Automation modules
RUN powershell -Command "Install-Module -Name 'UniversalAutomation' -RequiredVersion '${ua_version}' -Force"
RUN powershell -Command "Install-Module -Name 'UniversalAutomation.Dashboard' -RequiredVersion '${ua_version}' -Force"

COPY bin/app.ps1 C:\App\run.ps1

EXPOSE 8080 10000

VOLUME [ "C:\\App\\Database" ]

ENTRYPOINT [ "powershell", "-File", "C:\\App\\run.ps1" ]
