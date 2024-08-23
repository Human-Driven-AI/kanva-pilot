. "$PSScriptRoot\..\variables.ps1"

az containerapp env create `
    --name $containerAppEnvName `
    --resource-group $resourceGroupName `
    --location $location