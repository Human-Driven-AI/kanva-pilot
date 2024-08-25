. "$PSScriptRoot\..\config\variables.ps1"

Write-Host "Fetching latest container tags for registry $registryName..." -ForegroundColor DarkGreen -BackgroundColor White

function Get-LatestImageTag {
    param (
        [string]$repository
    )
    
    $tags = az acr repository show-tags --name $registryName --repository $repository --orderby time_desc --output tsv
    return ($tags -split "\n")[0]
}

$containerNames = @("kanva-hub", "delphi", "pythoness", "efbundle")
foreach ($containerName in $containerNames) {
    # # Get the latest image tag for this container    
    $latestTag = Get-LatestImageTag -repository $containerName
    Write-Host "- ${containerName}: $latestTag"
}