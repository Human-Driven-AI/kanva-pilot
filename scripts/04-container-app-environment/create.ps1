. "$PSScriptRoot\..\variables.ps1"

az containerapp env create `
    --name $containerAppEnvName `
    --resource-group $resourceGroupName `
    --location $location

az containerapp env storage set --name $containerAppEnvName `
    --resource-group $resourceGroupName `
    --storage-name $fileShareName `
    --azure-file-account-name $storageAccountName `
    --azure-file-account-key $storageAccountKey `
    --azure-file-share-name $fileShareName `
    --access-mode ReadWrite
    #--storage-type AzureFile `