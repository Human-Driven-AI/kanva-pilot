param (
    [string]$imageName,
    [string]$containerAppName,
    [string]$containerName
)

. "$PSScriptRoot\..\variables.ps1"

Write-Host "Creating container app $containerAppName from container $containerName and image $imageName"
Write-Host "registryServer ${registryServer}"

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
    --cpu 0.5
    #--custom-domain $customDomainName `
    # --ingress external `
    # --target-port 80 `
    #--location $location `
    #--enable-sticky-sessions `
    #--env-vars WEBSITES_PORT=80 `