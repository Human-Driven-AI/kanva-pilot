$ErrorActionPreference = "Stop"

# TODO: Generate URL with SAS token on Azure Portal and replace $Url
# https://portal.azure.com/#@human-driven.ai/resource/subscriptions/d0f83e80-bb64-48b7-b122-bff5dc241649/resourcegroups/HDAI-BuildServer/providers/Microsoft.Storage/storageAccounts/kanvabuildserver/storagebrowser
$Url = "https://kanvadatasets.blob.core.windows.net/poc/kanva.zip"

# Can be overriden
# Generates a path like C:\Users\julian\Downloads\Kanva.zip
$ZipFilePath = Join-Path (New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path "Kanva.zip"

# Can be overriden
# Generates a path like C:\Users\username\AppData\Local\kanva
$ApplicationPath = Join-Path $env:LOCALAPPDATA "kanva"

# Can be overriden
# Generates a path like C:\Users\username\AppData\Local\Microsoft\WindowsApps\python3.10.exe
$PythonPath = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps\python3.10.exe"

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# Downloads the .zip file
Write-Output "Downloading zip file"
Invoke-WebRequest -Uri $Url -Method Get -OutFile $ZipFilePath

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
$DataPath = Join-Path $ApplicationPath "data"
$DelphiPath = Join-Path $ApplicationPath "delphi"
$HubPath = Join-Path $ApplicationPath "hub"
$PythonessPath = Join-Path $ApplicationPath "pythoness"

If (Test-Path $DelphiPath -PathType Container) {
    Write-Output "Removing '$($DelphiPath)'"
    Remove-Item $DelphiPath -Recurse
}

If (Test-Path $PythonessPath -PathType Container) {
    Write-Output "Removing '$($PythonessPath)'"
    Remove-Item $PythonessPath -Recurse
}

If (Test-Path $HubPath -PathType Container) {
    Write-Output "Removing '$($HubPath)'"
    Remove-Item $HubPath -Recurse
}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# Extracts zip file
Write-Output "Extracting zip file to '$($ApplicationPath)'"
Expand-Archive -LiteralPath $ZipFilePath -DestinationPath $ApplicationPath

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# Installs dependencies
Write-Output "Installing Python dependencies"
cd $ApplicationPath
& $PythonPath -m pip install .\delphi
& $PythonPath -m pip install .\pythoness

# Updates Hub's configuration
Write-Output "Updating Hub's configuration"
$HubAppSettingsPath = Join-Path $HubPath "appsettings.json"

$config = Get-Content $HubAppSettingsPath | ConvertFrom-Json -Depth 10
$config.CONNECTIONSTRINGS.DEFAULT = Join-Path $DataPath "hd.db"
$config.FLUTTERDIRECTORY = Join-Path $HubPath "client"
$config.ROOTDATAPATH = $DataPath
$config.WORKINGDIRECTORY = $ApplicationPath
$config | ConvertTo-Json -Depth 10 | Out-File -FilePath $HubAppSettingsPath

Write-Output "Starting Hub"
Start-Process -FilePath "HumanDriven.Server.exe" -WorkingDirectory "$HubPath"
Sleep 10

Write-Output "Starting Delphi"
Start-Process -FilePath $PythonPath -ArgumentList (Join-Path $DelphiPath "src\data_agent_hub_client.py"), "http://localhost:5000/hub-agent", "--root-data-path", "$DataPath", "--no-verify-ssl"

Write-Output "Starting Pythoness"
Start-Process -FilePath $PythonPath -ArgumentList (Join-Path $PythonessPath "src\training_agent_hub_client.py"), "http://localhost:5000/hub-agent", "--root-data-path", "$DataPath", "--no-verify-ssl"

Write-Output "Opening Kanva"
Start-Process "http://localhost:5000"
