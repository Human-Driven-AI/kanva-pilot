param(
    [string]$customConfig
)

. "$PSScriptRoot\..\utils\utils.ps1"
. "$PSScriptRoot\..\config\variables.ps1"
if ($customConfig) {
    . "$PSScriptRoot\..\config\$customConfig"
}

Write-Log "Creating Key Vault $keyVaultName"

$publicNetworkAccess = "Disabled"
if ($createPublicKeyVault) {
    $publicNetworkAccess = "Enabled"
}

# Create the Key Vault
az keyvault create `
    --name $keyVaultName `
    --resource-group $resourceGroupName `
    --location $location `
    --sku Standard `
    --enable-rbac-authorization false `
    --public-network-access $publicNetworkAccess `
    --enabled-for-deployment false `
    --enabled-for-disk-encryption false `
    --enabled-for-template-deployment false `
    --retention-days 90

Write-Log "Done"