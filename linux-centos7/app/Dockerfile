FROM mcr.microsoft.com/powershell:7.0.0-centos-7

ARG ua_version=1.3.1

# Prepare the profile: handle errors and suppress progress bar
RUN pwsh -Command "New-Item -Path '/root/.config/powershell' -ItemType 'Directory' | Out-Null"
RUN pwsh -Command "Add-Content -Path '/root/.config/powershell/profile.ps1' -Value '\$ProgressPreference = ''SilentlyContinue'''"
RUN pwsh -Command "Add-Content -Path '/root/.config/powershell/profile.ps1' -Value '\$ErrorActionPreference = ''Stop'''"

# Install the Universal Automation modules
RUN pwsh -Command "Install-Module -Name 'UniversalAutomation' -RequiredVersion '${ua_version}' -Force"
RUN pwsh -Command "Install-Module -Name 'UniversalAutomation.Dashboard' -RequiredVersion '${ua_version}' -Force"

COPY bin/app.ps1 /app/run.ps1

EXPOSE 8080 10000

VOLUME [ "/app/database" ]

ENTRYPOINT [ "pwsh", "-File", "/app/run.ps1" ]
