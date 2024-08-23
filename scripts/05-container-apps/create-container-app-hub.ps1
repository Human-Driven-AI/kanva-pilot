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
    --cpu 0.5 `
    --target-port 80 `
    --ingress external `
    --env-vars ConnectionStringsDefault="Server=tcp:$databaseName.database.windows.net,1433;Initial Catalog=$databaseName;Persist Security Info=False;User ID=$adminUser;Password=$adminPassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=120;"
    #--custom-domain $customDomainName `
    #--location $location `
    #--enable-sticky-sessions `
    #--env-vars WEBSITES_PORT=80 `