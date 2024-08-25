. "$PSScriptRoot\..\utils\utils.ps1"
. "$PSScriptRoot\..\config\variables.ps1"

Write-Host "Fetching latest container tags for registry $registryName..." -ForegroundColor DarkGreen -BackgroundColor White

az account set --subscription $hdaiSubscriptionId

function Get-LatestImageTag {
    param (
        [string]$repository
    )
    
    $tags = az acr repository show-tags --name $registryName --repository $repository --orderby time_desc --output tsv
    return ($tags -split "\n")[0]
}

$configPath = "$PSScriptRoot\..\config\variables.ps1"

$latestTag = Get-LatestImageTag -repository "efbundle"
if ($latestTag -ne $dbMigrationLatestImage) {
    Update-ConfigVariable -ConfigFile $configPath -VariableName "dbMigrationLatestImage" -VariableValue $latestTag
}

$latestTag = Get-LatestImageTag -repository "kanva-hub"
if ($latestTag -ne $hubLatestImage) {
    Update-ConfigVariable -ConfigFile $configPath -VariableName "hubLatestImage" -VariableValue $latestTag
}

$latestTag = Get-LatestImageTag -repository "delphi"
if ($latestTag -ne $delphiLatestImage) {
    Update-ConfigVariable -ConfigFile $configPath -VariableName "delphiLatestImage" -VariableValue $latestTag
}

$latestTag = Get-LatestImageTag -repository "pythoness"
if ($latestTag -ne $pythonessLatestImage) {
    Update-ConfigVariable -ConfigFile $configPath -VariableName "pythonessLatestImage" -VariableValue $latestTag
}