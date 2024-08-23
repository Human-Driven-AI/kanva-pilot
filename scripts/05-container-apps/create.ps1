. "$PSScriptRoot\..\variables.ps1"

# function Get-LatestImageTag {
#     param (
#         [string]$repository
#     )
    
#     $tags = az acr repository show-tags --name $registryName --repository $repository --orderby time_desc --output tsv
#     return ($tags -split "\n")[0]
# }

# # Array of container names
# $containerNames = @("kanva-hub", "delphi", "pythoness")
# Write-Host "$registryName : $registryName"

# # Loop through each container and create the container app
# foreach ($containerName in $containerNames) {
#     # # Get the latest image tag for this container    
#     $latestTag = Get-LatestImageTag -repository $containerName
#     Write-Host "Latest tag for $containerName : $latestTag"
# }

& "$PSScriptRoot\create-container-app-hub.ps1"    -imageName "kanva-hub:20240514-1816" -containerAppName "kanva-hub-app" -containerName "kanva-hub"
$containerAppUrl = az containerapp show `
    --name "kanva-hub-app" `
    --resource-group $resourceGroupName `
    --query "properties.configuration.ingress.fqdn" `
    --output tsv

$args = "/app/src/data_agent_hub_client.py $containerAppUrl --root-data-path /app/data"
& "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "delphi:20240514-1434" -containerAppName "delphi-app" -containerName "delphi"
$args = "/app/src/training_agent_hub_client.py $containerAppUrl --root-data-path /app/data"
& "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "pythoness:20240506-1143" -containerAppName "pythoness-app" -containerName "pythoness"