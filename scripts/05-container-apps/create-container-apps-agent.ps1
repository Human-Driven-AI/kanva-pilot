param (
    [string]$hubUrl,
    [string]$imageName,
    [string]$containerAppName,
    [string]$containerName
)

. "$PSScriptRoot\..\variables.ps1"

Write-Host "Creating container app $containerAppName from container $containerName and image ${registryServer}/${imageName}"
Write-Host $registryServer, $registryUsername, $registryPassword 
Write-Host $hubUrl
#Write-Host "registryServer ${registryServer} $registryUsername $registryPassword"

az containerapp create `
    --subscription $subscriptionId `
    --resource-group $resourceGroupName `
    --name $containerAppName `
    --container-name $containerName `
    --image ${registryServer}/${imageName} `
    --environment $containerAppEnvName `
    --registry-server $registryServer `
    --registry-username $registryUsername `
    --registry-password $registryPassword `
    --memory 1Gi `
    --min-replicas 1 `
    --max-replicas 1 `
    --transport auto `
    --revision-suffix "00-initial-deploy" `
    --cpu 0.5 `
    --env-vars KANVA_HUB_URL=$hubUrl

#Write-Host "Adding storage to container app $storageAccountName $fileShareName"
# az containerapp storage add `
#     --name $containerAppName `
#     --resource-group $resourceGroupName `
#     --storage-name $storageAccountName `
#     --access-mode ReadWrite `
#     --azure-file-account-name $storageAccountName `
#     --azure-file-account-key $storageAccountKey `
#     --azure-file-share-name $fileShareName `
#     --mount-path /app/data `
#     --mount-options "dir_mode=0777,file_mode=0777,cache=none"
