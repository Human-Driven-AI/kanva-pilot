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
    @{Name="Resource Group"; Script="01-resource-group\create.ps1"; Used=$false},
    @{Name="Storage Account"; Script="02-storage-account\create.ps1"; Used=$false},
    @{Name="Projects Database"; Script="03-projects-database\create.ps1"; Used=$false},
    @{Name="Container App Environment"; Script="04-container-app-environment\create.ps1"; Used=$false},
    @{Name="Container Apps"; Script="05-container-apps\create.ps1"; Used=$false},
    @{Name="Utils"; Script="utils\list_files.ps1"; Used=$false},
    @{Name="Print Current Config"; Script=$null; Used=$false},
    @{Name="Load Custom Config"; Script=$null; Used=$false},
    @{Name="Exit"; Script=$null; Used=$false}
)

# Initialize custom config variable
$script:customConfig = $null

# Function to display the menu
function Show-Menu {
    $currentConfig = if ($script:customConfig) { 
        ($script:customConfig -replace '^variables-', '' -replace '\.ps1$', '') -replace '-', ' '
    } else { 
        "Base" 
    }
    
    $menuWidth = 50
    $configDisplay = "Config: $currentConfig".PadLeft($menuWidth)
    
    Clear-Host
    Write-Host $configDisplay
    Write-Host (" " * $menuWidth) -BackgroundColor White
    Write-Host " Kanva Setup Menu".PadRight($menuWidth) -ForegroundColor DarkGreen -BackgroundColor White
    Write-Host (" " * $menuWidth) -BackgroundColor White
    Write-Host ("")
    
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        $checkMark = if ($menuOptions[$i].Used) { "[✅] " } else { "[ ]" }
        Write-Host ("{0}{1}. {2}" -f $checkMark, ($i + 1), $menuOptions[$i].Name)
    }
    Write-Host ("=" * $menuWidth)
}

# Function to run a script and mark it as used
function Invoke-MenuOption {
    param (
        [int]$Index
    )
    
    if ($Index -ge 0 -and $Index -lt $menuOptions.Count) {
        $option = $menuOptions[$Index]
        if ($option.Script) {
            & "$PSScriptRoot\$($option.Script)" $script:customConfig
            $option.Used = $true
        }
        elseif ($option.Name -eq "Print Current Config") {
            Print-CurrentConfig
        }
        elseif ($option.Name -eq "Load Custom Config") {
            $script:customConfig = Load-CustomConfig
        }
        elseif ($option.Name -eq "Exit") {
            return $false
        }
    }
    else {
        Write-Host "Invalid selection"
    }
    return $true
}

# Main loop
$continue = $true
while ($continue) {
    Show-Menu
    $selection = Read-Host "Enter your choice"
    
    if ($selection -eq "5") {
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
        $menuOptions[4].Used = $true
    }
    elseif ($selection -eq "6") {
        Write-Host "Utils submenu:"
        Write-Host "1. Fetch Last Container Tags"
        Write-Host "2. List Files"
        $subSelection = Read-Host "Enter your choice"
        switch ($subSelection) {
            "1" { & "$PSScriptRoot\utils\fetch-last-container-tags.ps1" $script:customConfig }
            "2" { & "$PSScriptRoot\utils\list_files.ps1" $script:customConfig }
            default { Write-Host "Invalid selection" }
        }
        $menuOptions[5].Used = $true
    }
    else {
        $continue = Invoke-MenuOption ([int]$selection - 1)
    }

    if ($continue) {
        Write-Host "Press any key to continue..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}