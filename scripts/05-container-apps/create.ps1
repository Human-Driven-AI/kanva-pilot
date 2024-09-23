param(
    [string]$customConfig
)

. "$PSScriptRoot\..\utils\utils.ps1"
. "$PSScriptRoot\..\config\variables.ps1"
if ($customConfig) {
    . "$PSScriptRoot\..\config\$customConfig"
}


if (!(Test-ContainerAppJobExists -resourceGroupName $resourceGroupName -jobName $dbMigrationJobName)) {
    & "$PSScriptRoot\create-db-migration-job.ps1" -customConfig $customConfig
}
else {
    Write-Host "Skipping db migration job creation as it already exists" -ForegroundColor DarkGreen -BackgroundColor White
}

if (!(Test-ContainerAppExists -resourceGroupName $resourceGroupName -containerAppName $hubAppName)) {
    & "$PSScriptRoot\create-container-app-hub.ps1" -imageName "kanva-hub:$hubLatestImage" -containerAppName $hubAppName -containerName "kanva-hub" -customConfig $customConfig
}
else {
    Write-Host "Skipping hub creation as it already exists" -ForegroundColor DarkGreen -BackgroundColor White
}
& "$PSScriptRoot\grant-key-vault-access.ps1" -containerAppName $hubAppName -customConfig $customConfig -secretPermissions @("delete", "get", "list", "set")

$hubUrl = az containerapp show `
    --name $hubAppName `
    --resource-group $resourceGroupName `
    --query "properties.configuration.ingress.fqdn" `
    --output tsv
$hubAgentUrl = "https://$hubUrl/hub-agent"

$configFileToUse = if ($customConfig) { $customConfig } else { "variables.ps1" }
$configPath = "$PSScriptRoot\..\config\$configFileToUse"
Update-ConfigVariable -ConfigFile $configPath -VariableName "hubUrl" -VariableValue $hubUrl

if (!(Test-ContainerAppExists -resourceGroupName $resourceGroupName -containerAppName $delphiAppName)) {
    & "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "delphi:$delphiLatestImage" -containerAppName $delphiAppName -containerName "delphi" -hubUrl $hubAgentUrl -customConfig $customConfig
    & "$PSScriptRoot\mount-storage.ps1" -containerAppName $delphiAppName -customConfig $customConfig
}
else {
    Write-Host "Skipping data agent creation as it already exists" -ForegroundColor DarkGreen -BackgroundColor White
}
& "$PSScriptRoot\grant-key-vault-access.ps1" -containerAppName $delphiAppName -customConfig $customConfig

if (!(Test-ContainerAppExists -resourceGroupName $resourceGroupName -containerAppName $pythonessAppName)) {
    & "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "pythoness:$pythonessLatestImage" -containerAppName $pythonessAppName -containerName "pythoness" -hubUrl $hubAgentUrl -customConfig $customConfig
    & "$PSScriptRoot\mount-storage.ps1" -containerAppName $pythonessAppName -customConfig $customConfig
}
else {
    Write-Host "Skipping training agent creation as it already exists" -ForegroundColor DarkGreen -BackgroundColor White
}
