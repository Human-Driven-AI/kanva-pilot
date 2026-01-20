# Azure Container Apps Deployment (Bash)

Bash scripts to deploy Kanva to Azure Container Apps.

## Requirements

- Bash
- Azure CLI

## Instructions

1. Copy `config/variables-sample.sh` and save it as `config/variables.sh`
2. Edit the subscription ID in `variables.sh`
3. Review the other variables and adjust as required
4. Run `./setup-kanva.sh`

## Custom Configurations

You can create custom config files and place them in `config/variables-IDENTIFIER.sh`. They will be listed by the setup script.
