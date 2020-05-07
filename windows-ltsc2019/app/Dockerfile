# Docker Image for Universal Automation

# Use the WS2019 PowerShell image, with this we have Windows PowerShell 5.1 and
# the latest PowerShell 7.0 available.
FROM mcr.microsoft.com/powershell:lts-windowsservercore-1809

# Copy setup files to the conatiner. The Setup folder contains all scripts to
# prepare the image for Universal Automation.
COPY [ "Setup", "C:/Setup/" ]

# Install git.
RUN powershell -Command "C:\Setup\InstallGit.ps1" "2.26.1"

# Install PowerShell modules.
RUN powershell -Command "C:\Setup\InstallModule.ps1" "1.3.1"

# Define docker ports, for ua dashbaord and automation.
EXPOSE 8080 10000

VOLUME [ "C:/App/Database/" ]

# Finally, copy the app scripts
COPY [ "App", "C:/App/" ]

# And run the app
ENTRYPOINT [ "powershell", "-File", "C:\\App\\App.ps1" ]
