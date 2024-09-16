param (
    [string]$imageName,
    [string]$containerAppName,
    [string]$containerName,    
    [string]$customConfig
)

. "$PSScriptRoot\..\utils\utils.ps1"
. "$PSScriptRoot\..\config\variables.ps1"
if ($customConfig) {
    . "$PSScriptRoot\..\config\$customConfig"
}

Write-Log "Creating container app $containerAppName from container $containerName and image $imageName"
Write-Log "registryServer ${registryServer}"

az containerapp create `
    --subscription $subscriptionId `
    --resource-group $resourceGroupName `
    --name $containerAppName `
    --container-name $containerName `
    --image ${registryServer}/${imageName} `
    --environment $containerAppEnvName `
    --registry-server $registryServer `
    --registry-username $registryUsername `
    --registry-password $registryPassword  `
    --memory 1Gi `
    --min-replicas 1 `
    --max-replicas 1 `
    --transport auto `
    --revision-suffix "00-initial-deploy" `
    --cpu 0.5 `
    --target-port 80 `
    --ingress external `
    --secrets connectionstringsdefault="$connectionString" `
    --env-vars ConnectionStringsDefault="secretref:connectionstringsdefault" EnableAuthentication=false CorsOrigins=""

Write-Log "Done"