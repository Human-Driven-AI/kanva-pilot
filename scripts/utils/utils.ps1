. "$PSScriptRoot\test-resource-exists.ps1"
. "$PSScriptRoot\write-config.ps1"
. "$PSScriptRoot\write-log.ps1"


function Get-ActiveAzureSubscription {
    $subscription = az account show --query '{name:name, id:id, tenantId:tenantId}' --output json | ConvertFrom-Json
    
    if ($subscription) {
        return $subscription
    } else {
        Write-Error "No active subscription found. Please log in to Azure or set an active subscription."
        return $null
    }
}