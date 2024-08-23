# This is the only mandatory one
$subscriptionId = ""
# This one needs to be unique globally, so add a suffix
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only
$storageAccountName = "kanvapilotstorage"
#                   = "123456789012345678901234"
# This one needs to be unique globally, so add a suffix
$databaseName = "kanva-pilot-projects-jhi"

$location = "norwayeast" # See valid locations below
$resourceGroupName = "Kanva-Pilot"

# Storage account
$accessTier = "Hot"
$kind = "StorageV2"
$sku = "Standard_LRS"

# Key Vault
$keyVaultName = "kanvapilotkv"

# Database
$adminPassword = ""
$adminUser = "sqladmin"
$backupStorageRedundancy = "Local"
$capacity = 2
$computeModel = "Serverless"
$edition = "GeneralPurpose"
$family = "Gen5"
$minCapacity = 0.5

# Container Apps
$customDomainName = "kanva.human-driven.ai"
$containerAppEnvName = "managedEnvironment-KanvaPilot2"
$registryName = "kanvaimages"
$registryServer = "kanvaimages.azurecr.io"
$registryUsername = "KanvaPilotCustomer"
$registryPassword = ""

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
