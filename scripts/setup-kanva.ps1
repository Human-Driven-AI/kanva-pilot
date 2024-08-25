# setup-kanva.ps1

# Function to load custom configuration
function Load-CustomConfig {
    $configFiles = Get-ChildItem -Path "$PSScriptRoot\config" -Filter "variables-*.ps1"
    if ($configFiles.Count -eq 0) {
        Write-Host "No custom configuration files found in the config folder."
        return $null
    }

    Write-Host "Available custom configurations:"
    for ($i = 0; $i -lt $configFiles.Count; $i++) {
        $configName = $configFiles[$i].BaseName -replace '^variables-', ''
        $configName = (Get-Culture).TextInfo.ToTitleCase($configName.ToLower()) -replace '-', ' '
        Write-Host "$($i + 1). $configName"
    }

    $selection = Read-Host "Enter the number of the configuration to load (or press Enter to cancel)"
    if ([string]::IsNullOrEmpty($selection)) {
        return $null
    }

    $index = [int]$selection - 1
    if ($index -ge 0 -and $index -lt $configFiles.Count) {
        $selectedConfig = $configFiles[$index].Name
        . "$PSScriptRoot\config\variables.ps1"
        . "$PSScriptRoot\config\$selectedConfig"
        Write-Host "Loaded custom configuration: $selectedConfig"
        return $selectedConfig
    }
    else {
        Write-Host "Invalid selection. No configuration loaded."
        return $null
    }
}

# Function to print current configuration
function Print-CurrentConfig {
    Get-Content "$PSScriptRoot\config\variables.ps1"
    if ($script:customConfig) {
        Get-Content "$PSScriptRoot\config\$script:customConfig"
    }
}

# Main menu options
$menuOptions = @(
    "Resource Group",
    "Storage Account",
    "Projects Database",
    "Container App Environment",
    "Container Apps",
    "Utils",
    "Print Current Config",
    "Load Custom Config",
    "Exit"
)

# Initialize custom config variable
$script:customConfig = $null

# Main loop
while ($true) {
    Clear-Host
    Write-Host "=== Kanva Setup Menu ===" -ForegroundColor DarkGreen -BackgroundColor White
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        Write-Host "$($i + 1). $($menuOptions[$i])"
    }

    $selection = Read-Host "Enter your choice"

    switch ($selection) {
        "1" { & "$PSScriptRoot\01-resource-group\create.ps1" $script:customConfig }
        "2" { & "$PSScriptRoot\02-storage-account\create.ps1" $script:customConfig }
        "3" { & "$PSScriptRoot\03-projects-database\create.ps1" $script:customConfig }
        "4" { & "$PSScriptRoot\04-container-app-environment\create.ps1" $script:customConfig }
        "5" {
            Write-Host "Container Apps submenu:"
            Write-Host "1. Create Container App Hub"
            Write-Host "2. Create Container Apps Agent"
            Write-Host "3. Create"
            Write-Host "4. Mount Storage"
            Write-Host "5. Test"
            $subSelection = Read-Host "Enter your choice"
            switch ($subSelection) {
                "1" { & "$PSScriptRoot\05-container-apps\create-container-app-hub.ps1" $script:customConfig }
                "2" { & "$PSScriptRoot\05-container-apps\create-container-apps-agent.ps1" $script:customConfig }
                "3" { & "$PSScriptRoot\05-container-apps\create.ps1" $script:customConfig }
                "4" { & "$PSScriptRoot\05-container-apps\mount_storage.ps1" $script:customConfig }
                "5" { & "$PSScriptRoot\05-container-apps\test.ps1" $script:customConfig }
                default { Write-Host "Invalid selection" }
            }
        }
        "6" {
            Write-Host "Utils submenu:"
            Write-Host "1. Fetch Last Container Tags"
            Write-Host "2. List Files"
            $subSelection = Read-Host "Enter your choice"
            switch ($subSelection) {
                "1" { & "$PSScriptRoot\utils\fetch-last-container-tags.ps1" $script:customConfig }
                "2" { & "$PSScriptRoot\utils\list_files.ps1" $script:customConfig }
                default { Write-Host "Invalid selection" }
            }
        }
        "7" { Print-CurrentConfig }
        "8" { $script:customConfig = Load-CustomConfig }
        "9" { exit }
        default { Write-Host "Invalid selection" }
    }

    Write-Host "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}