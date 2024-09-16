param(
    [string]$containerAppName,
    [string]$customConfig,
    [string[]]$secretPermissions = @("get", "list")
)

. "$PSScriptRoot\..\utils\utils.ps1"
. "$PSScriptRoot\..\config\variables.ps1"
if ($customConfig) {
    . "$PSScriptRoot\..\config\$customConfig"
}

$identityName = "${containerAppName}-identity"

# Check if the identity already exists
Write-Log "Checking if managed identity $identityName exists"
$existingIdentity = $(az identity show --name $identityName --resource-group $resourceGroupName --query id --output tsv 2>$null)

if ($existingIdentity) {
    Write-Log "Managed identity $identityName already exists"
    $principalId = $(az identity show --name $identityName --resource-group $resourceGroupName --query principalId --output tsv)
} else {
    Write-Log "Creating container app managed identity $identityName"
    az identity create --name $identityName --resource-group $resourceGroupName
    $principalId = $(az identity show --name $identityName --resource-group $resourceGroupName --query principalId --output tsv)
}

Write-Log "Checking if Key Vault policy exists for $principalId"
$existingPolicy = $(az keyvault show --name $keyVaultName --query "properties.accessPolicies[?objectId=='$principalId']" -o tsv)

if ($existingPolicy) {
    Write-Log "Policy already exists for $principalId. Skipping policy creation."
} else {
    Write-Log "Granting Key Vault permissions: $secretPermissions"
    az keyvault set-policy --name $keyVaultName --object-id $principalId --secret-permissions $secretPermissions
}

Write-Log "Done"