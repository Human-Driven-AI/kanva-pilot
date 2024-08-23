. "$PSScriptRoot\..\variables.ps1"
az sql server create `
    --name $serverName `
    --resource-group $resourceGroupName `
    --location $location `
    --admin-user $adminUser `
    --admin-password $adminPassword

az sql db create `
    --resource-group $resourceGroupName `
    --server $serverName `
    --name $databaseName `
    --edition GeneralPurpose `
    --family Gen5 `
    --capacity $capacity `
    --zone-redundant false `
    --collation "SQL_Latin1_General_CP1_CI_AS" `
    --max-size 2GB `
    --read-replicas 0 `
    --auto-pause-delay -1 `
    --min-capacity 0.5 `
    --backup-storage-redundancy Local `
    --compute-model $computeModel
