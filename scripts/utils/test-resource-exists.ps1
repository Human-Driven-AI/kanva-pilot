function Test-AzureResourceExists {
    param (
        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName,

        [Parameter(Mandatory=$true)]
        [string]$ResourceName,

        [Parameter(Mandatory=$true)]
        [string]$AzCommand
    )

    $result = Invoke-Expression "$AzCommand --name $ResourceName --resource-group $resourceGroupName --query 'name' --output tsv 2>&1"
    
    return ($LASTEXITCODE -eq 0 -and $result -eq $ResourceName)
}

function Test-ContainerAppExists {
    param (
        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName,

        [Parameter(Mandatory=$true)]
        [string]$containerAppName
    )

    return Test-AzureResourceExists -ResourceGroupName $resourceGroupName -ResourceName $containerAppName -AzCommand "az containerapp show"
}

function Test-ContainerAppJobExists {
    param (
        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName,

        [Parameter(Mandatory=$true)]
        [string]$jobName
    )

    return Test-AzureResourceExists -ResourceGroupName $resourceGroupName -ResourceName $jobName -AzCommand "az containerapp job show"
}