param(
    [string]$customConfig
)

. "$PSScriptRoot\..\utils\utils.ps1"
. "$PSScriptRoot\..\config\variables.ps1"
if ($customConfig) {
    . "$PSScriptRoot\..\config\$customConfig"
}

$envExists = Test-ContainerAppEnvironmentExists -containerAppEnvName $containerAppEnvName -resourceGroupName $resourceGroupName -customConfig $customConfig

if ($envExists -eq $containerAppEnvName) {
    Write-Log "Container App Environment '$containerAppEnvName' already exists."
}
else {
    Write-Log "Creating container app environment $containerAppEnvName"
    az containerapp env create `
        --name $containerAppEnvName `
        --resource-group $resourceGroupName `
        --location $location

    Write-Log "Linking storage account $storageAccountName to container app environment"
    az containerapp env storage set --name $containerAppEnvName `
        --resource-group $resourceGroupName `
        --storage-name $fileShareName `
        --azure-file-account-name $storageAccountName `
        --azure-file-account-key $storageAccountKey `
        --azure-file-share-name $fileShareName `
        --access-mode ReadWrite
}

& "$PSScriptRoot\create-key-vault.ps1" -customConfig $customConfig

Write-Log "Done"