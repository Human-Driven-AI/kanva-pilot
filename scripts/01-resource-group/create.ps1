. "$PSScriptRoot\..\variables.ps1"
az account set --subscription $subscriptionId
az group create --name $resourceGroupName --location $location
