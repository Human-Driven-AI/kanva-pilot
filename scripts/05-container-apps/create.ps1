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

$hubUrl = az containerapp show `
    --name $hubAppName `
    --resource-group $resourceGroupName `
    --query "properties.configuration.ingress.fqdn" `
    --output tsv
$hubUrl =  "https://$hubUrl/hub-agent"
$args = 'KANVA_HUB_URL="{0}" KANVA_ROOT_DATA_PATH="/app/data"' -f $hubUrl

if (!(Test-ContainerAppExists -resourceGroupName $resourceGroupName -containerAppName $delphiAppName)) {
    & "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "delphi:$delphiLatestImage" -containerAppName $delphiAppName -containerName "delphi" -hubUrl $hubUrl -customConfig $customConfig
    & "$PSScriptRoot\mount-storage.ps1" -containerAppName $delphiAppName -customConfig $customConfig
}
else {
    Write-Host "Skipping data agent creation as it already exists" -ForegroundColor DarkGreen -BackgroundColor White
}

if (!(Test-ContainerAppExists -resourceGroupName $resourceGroupName -containerAppName $pythonessAppName)) {
    & "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "pythoness:$pythonessLatestImage" -containerAppName $pythonessAppName -containerName "pythoness" -hubUrl $hubUrl -customConfig $customConfig
    & "$PSScriptRoot\mount-storage.ps1" -containerAppName $pythonessAppName -customConfig $customConfig
}
else {
    Write-Host "Skipping training agent creation as it already exists" -ForegroundColor DarkGreen -BackgroundColor White
}
