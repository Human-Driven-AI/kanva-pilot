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