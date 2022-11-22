FROM python:3.7-slim

WORKDIR /root

RUN pip install six psutil lxml pyopenssl && \
    apt-get update && apt-get install -y curl libicu-dev gnupg apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list' && \
    apt update && apt install -y powershell && \
    pwsh -c "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted" && \
    pwsh -c "Install-Module -Name PSDesiredStateConfiguration" && \
    pwsh -c "Enable-ExperimentalFeature PSDesiredStateConfiguration.InvokeDscResource" && \
    pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module VMware.PowerCLI" && \
    pwsh -c 'Set-PowerCLIConfiguration -PythonPath "/usr/local/bin/python3.7" -InvalidCertificateAction Ignore -Scope AllUsers -Confirm:$false' && \
    mkdir -p /root/.config/powershell && \
    echo '$ProgressPreference = "SilentlyContinue"' > /root/.config/powershell/Microsoft.PowerShell_profile.ps1

CMD ["/usr/bin/pwsh"]
