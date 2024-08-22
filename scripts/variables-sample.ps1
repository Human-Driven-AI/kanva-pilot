# This is the only mandatory one
$subscriptionId = ""
$location = "norwayeast"
$resourceGroupName = "Kanva-Pilot"

# Storage account
$accessTier = "Hot"
$kind = "StorageV2"
$sku = "Standard_LRS"
$storageAccountName = "kanvapilotstorage"

# Key Vault
$keyVaultName = "kanvapilotkv"
$registryPasswordSecretName = "kanvaRegistryPassword"
$registryPassword = "erVyzwGay8UkHzVEsNqKzi/2ZO4lj2HIBx+rwLMjm8+ACRAwmfvb"

# Database
$autoPauseDelay = 60
$backupStorageRedundancy = "Local"
$capacity = 2
$computeModel = "Serverless"
$databaseName = "kanva-pilot-projects"
$edition = "GeneralPurpose"
$family = "Gen5"
$minCapacity = 0.5
$serverName = "kanva-pilots-db"  # This matches the default value in the template

# Container Apps
$certificateId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.App/managedEnvironments/$environmentName/managedCertificates/kanva.human-driven.ai-managede-240413074901"
$customDomainName = "kanva.human-driven.ai"
$environmentName = "managedEnvironment-KanvaPilot"
$fqdn = "kanva.whiterock-7e873a3c.norwayeast.azurecontainerapps.io"
$registryPasswordSecretRef = "reg-pswd-829f0db6-bbd7"
$registryServer = "kanvaimages.azurecr.io"
$registryUsername = "kanvaimages"
# Valid locations
<#
australiacentral
australiacentral2
australiaeast
australiasoutheast
brazilsouth
canadacentral
canadaeast
centralindia
centralus
eastasia
eastus
eastus2
francecentral
germanywestcentral
israelcentral
italynorth
japaneast
japanwest
jioindiawest
koreacentral
koreasouth
mexicocentral
northcentralus
northeurope
norwayeast
polandcentral
qatarcentral
southafricanorth
southcentralus
southeastasia
southindia
spaincentral
swedencentral
switzerlandnorth
uaenorth
uksouth
ukwest
westcentralus
westeurope
westindia
westus
westus2
westus3
#>
