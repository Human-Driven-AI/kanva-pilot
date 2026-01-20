# Azure Container Apps Deployment (PowerShell)

PowerShell scripts to deploy Kanva to Azure Container Apps.

## Requirements

- PowerShell
- Azure CLI

## Instructions

1. Copy `config/variables-sample.ps1` and save it as `config/variables.ps1`
2. Edit the subscription ID in `variables.ps1`
3. Review the other variables and adjust as required
4. Run `setup-kanva.ps1`

## Custom Configurations

You can create custom config files and place them in `config/variables-IDENTIFIER.ps1`. They will be listed by the setup script.
