. "$PSScriptRoot\..\variables.ps1"

function Get-LatestImageTag {
    param (
        [string]$repository
    )
    
    $tags = az acr repository show-tags --name $registryServer --repository $repository --orderby time_desc --output tsv
    return ($tags -split "\n")[0]
}

# Array of container names
$containerNames = @("kanva-hub", "delphi", "pythoness")
Write-Host "$registryName : $registryName"

# Loop through each container and create the container app
foreach ($containerName in $containerNames) {
    # # Get the latest image tag for this container    
    $latestTag = Get-LatestImageTag -repository $containerName
    Write-Host "Latest tag for $containerName : $latestTag"
    
    # Construct the full image name
    $imageName = "${containerName}:$latestTag"
    
    # Construct the container app name
    $containerAppName = "$containerName-app"

    # Call the create-container-app.ps1 script with the parameters
    & "$PSScriptRoot\create-container-app.ps1" -imageName $imageName -containerAppName $containerAppName -containerName $containerName
}

az containerapp ingress update `
    --resource-group $resourceGroupName `
    --name "kanva-hub-app" `
    --target-port 80