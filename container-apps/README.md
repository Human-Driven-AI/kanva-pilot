# Azure Container Apps Deployment

Scripts to deploy Kanva to Azure Container Apps using the reference architecture.

## Options

- **[windows/](windows/)** - PowerShell scripts (requires PowerShell and Azure CLI)
- **[linux/](linux/)** - Bash scripts (requires Bash and Azure CLI)

Both options create the same Azure infrastructure:
- Resource Group
- Storage Account (for data files)
- Azure SQL Database (for project metadata)
- Key Vault (for secrets)
- Container App Environment with Kanva containers (Hub, Delphi, Pythoness)

## Requirements

- Azure subscription
- Azure CLI installed and logged in
- Container registry credentials from Human-Driven AI
