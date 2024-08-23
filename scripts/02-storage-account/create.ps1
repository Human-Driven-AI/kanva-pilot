. "$PSScriptRoot\..\variables.ps1"
az storage account create `
    --name $storageAccountName `
    --resource-group $resourceGroupName `
    --location $location `
    --sku $sku `
    --kind $kind `
    --access-tier $accessTier `
    --enable-hierarchical-namespace true `
    --allow-blob-public-access true `
    --allow-cross-tenant-replication false `
    --min-tls-version TLS1_2 `
    --public-network-access Enabled

# Get the storage account key
$storageAccountKey = (az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' -o tsv)

# Create file share
az storage share create `
    --name $fileShareName `
    --account-name $storageAccountName `
    --account-key $storageAccountKey `
    --quota $fileShareQuota

# Display the storage account key
Write-Host "Storage Account Key: $storageAccountKey"
Write-Host "Please update variables.ps1 with the storage account key" -ForegroundColor DarkGreen -BackgroundColor White