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
$hubUrl = az containerapp show `
    --name "kanva-hub-app" `
    --resource-group $resourceGroupName `
    --query "properties.configuration.ingress.fqdn" `
    --output tsv
$hubUrl =  "https://$hubUrl/hub-agent"

$args = 'KANVA_HUB_URL="{0}" KANVA_ROOT_DATA_PATH="/app/data"' -f $hubUrl
& "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "delphi:20240825-0156" -containerAppName "delphi-app" -containerName "delphi" -hubUrl $hubUrl
& "$PSScriptRoot\create-container-apps-agent.ps1" -imageName "pythoness:20240825-0234" -containerAppName "pythoness-app" -containerName "pythoness" -hubUrl $hubUrl

Write-Host "Please mount the file share in the agent container apps" -ForegroundColor DarkGreen -BackgroundColor White