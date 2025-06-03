# Install Kanva on an Azure VM

The first steps of this install procedure required rebooting the VM.

1. Enable Hypervisor
```bash
bcdedit /set hypervisorlaunchtype auto
Restart-Computer
```

2. Install Hyper-V:
```bash
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
```

2. Install Containers
```bash
Install-WindowsFeature -Name Containers -Restart
```

3. Allow web traffic
```bash
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow -Profile Any
```

4. Download and Install Docker
```bash
# Invoke-WebRequest is super slow to donwload the file
# Invoke-WebRequest -Uri "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -OutFile "DockerDesktopInstaller.exe"
# It's better to download the installer through the browser
Start-Process "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
```

5. Log into the repository. The password will be provided by Human-Driven AI:
```bash
docker login kanvaimages.azurecr.io -u KanvaPilot
```

6. Create folder for Kanva:
```bash
cd c:\
mkdir kanva
cd kanva
```
7. Get configuration files.

    1. Either download these individually:
    - [Docker Compose file](https://raw.githubusercontent.com/Human-Driven-AI/kanva-pilot/refs/heads/main/windows/docker-compose.yml)
    - [Enviromental variables](https://github.com/Human-Driven-AI/kanva-pilot/blob/main/windows/pilot.env)
    2. Or clone the repository:
    ```bash
    git clone git@github.com:Human-Driven-AI/kanva-pilot.git
    ```
    3. Or download the repository as a zip file:
    - https://github.com/Human-Driven-AI/kanva-pilot/archive/refs/heads/main.zip


Whatever method is used, docker-compose.yml and pilot.env should be placed in C:\kanva.

8. Start Kanva
```bash
docker-compose up -d
```

9. Stop Kanva
```bash
docker-compose down
```
