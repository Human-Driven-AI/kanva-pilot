# PowerShell to Bash Scripts Migration

## Overview

This document describes the migration of Azure deployment scripts from PowerShell (`.ps1`) to Bash (`.sh`) for Linux/macOS compatibility. The original scripts in `scripts/` use PowerShell and have been converted to portable Bash scripts in `scripts/nix/`.

## What Was Done

### Migration Date
December 2, 2025

### Source and Destination
- **Source:** `scripts/*.ps1` (PowerShell scripts for Windows)
- **Destination:** `scripts/nix/*.sh` (Bash scripts for Linux/macOS)

### Scripts Created

| Original PowerShell | Bash Equivalent | Purpose |
|---------------------|-----------------|---------|
| `setup-kanva.ps1` | `setup-kanva.sh` | Interactive menu for running deployment steps |
| `config/common.ps1` | `config/common.sh` | Shared configuration constants |
| `config/variables-sample.ps1` | `config/variables-sample.sh` | Template for user-specific variables |
| `utils/utils.ps1` | `utils/utils.sh` | Main utility functions loader |
| `utils/write-log.ps1` | `utils/write-log.sh` | Logging with timestamps and colors |
| `utils/write-config.ps1` | `utils/write-config.sh` | Update variables in config files |
| `utils/test-resource-exists.ps1` | `utils/test-resource-exists.sh` | Check if Azure resources exist |
| `utils/fetch-last-container-tags.ps1` | `utils/fetch-last-container-tags.sh` | Fetch latest container image tags |
| `01-resource-group/create.ps1` | `01-resource-group/create.sh` | Create Azure resource group |
| `02-storage-account/create.ps1` | `02-storage-account/create.sh` | Create storage account and file share |
| `03-projects-database/create.ps1` | `03-projects-database/create.sh` | Create SQL Server and database |
| `04-container-app-environment/create.ps1` | `04-container-app-environment/create.sh` | Create Container App Environment |
| `04-container-app-environment/create-key-vault.ps1` | `04-container-app-environment/create-key-vault.sh` | Create Azure Key Vault |
| `05-container-apps/create.ps1` | `05-container-apps/create.sh` | Orchestrate container app creation |
| `05-container-apps/create-container-app-hub.ps1` | `05-container-apps/create-container-app-hub.sh` | Create hub container app |
| `05-container-apps/create-container-apps-agent.ps1` | `05-container-apps/create-container-apps-agent.sh` | Create agent container apps |
| `05-container-apps/create-db-migration-job.ps1` | `05-container-apps/create-db-migration-job.sh` | Create database migration job |
| `05-container-apps/grant-key-vault-access.ps1` | `05-container-apps/grant-key-vault-access.sh` | Create managed identity and grant Key Vault access |
| `05-container-apps/mount-storage.ps1` | `05-container-apps/mount-storage.sh` | Mount Azure File Share to container apps |
| `07-maintenance/start.ps1` | `07-maintenance/start.sh` | Activate container app revisions |
| `07-maintenance/stop.ps1` | `07-maintenance/stop.sh` | Deactivate container app revisions |
| `07-maintenance/update.ps1` | `07-maintenance/update.sh` | Update apps to latest revision |
| `07-maintenance/create-revision.ps1` | `07-maintenance/create-revision.sh` | Create new container app revision |

### Not Migrated
- `06-app-registration/create.ps1` - Not present in original scripts folder

## Directory Structure

```
scripts/nix/
├── setup-kanva.sh                          # Main interactive menu
├── config/
│   ├── available-locations.txt             # Valid Azure locations
│   ├── common.sh                           # Shared constants
│   └── variables-sample.sh                 # Template (copy to variables.sh)
├── utils/
│   ├── utils.sh                            # Loads all utility functions
│   ├── write-log.sh                        # Logging function
│   ├── write-config.sh                     # Config update function
│   ├── test-resource-exists.sh             # Resource existence checks
│   └── fetch-last-container-tags.sh        # Fetch latest image tags
├── 01-resource-group/
│   └── create.sh
├── 02-storage-account/
│   └── create.sh
├── 03-projects-database/
│   └── create.sh
├── 04-container-app-environment/
│   ├── create.sh
│   └── create-key-vault.sh
├── 05-container-apps/
│   ├── create.sh
│   ├── create-container-app-hub.sh
│   ├── create-container-apps-agent.sh
│   ├── create-db-migration-job.sh
│   ├── grant-key-vault-access.sh
│   └── mount-storage.sh
└── 07-maintenance/
    ├── start.sh
    ├── stop.sh
    ├── update.sh
    └── create-revision.sh
```

## How to Use

### Prerequisites
- Azure CLI (`az`) installed and logged in
- Bash shell (Linux/macOS terminal)
- Optional: `yq` for YAML manipulation (falls back to Python if not available)

### Setup

1. **Copy the sample variables file:**
   ```bash
   cd scripts/nix/config
   cp variables-sample.sh variables.sh
   ```

2. **Edit variables.sh with your Azure details:**
   ```bash
   # Required settings:
   subscriptionId="your-subscription-id"
   adminPassword="your-sql-admin-password"
   registryPassword="your-container-registry-password"
   # ... other settings as needed
   ```

3. **Run the interactive setup:**
   ```bash
   cd scripts/nix
   ./setup-kanva.sh
   ```

### Running Individual Scripts

Each script can be run independently:

```bash
# Create resource group
./01-resource-group/create.sh

# Create storage account
./02-storage-account/create.sh

# With custom config file
./01-resource-group/create.sh variables-production.sh
```

### Custom Configurations

To use multiple environments (dev, staging, production):

1. Create additional config files: `config/variables-production.sh`, `config/variables-staging.sh`
2. These will appear in the "Load Config" menu option
3. Or pass them as the first argument to individual scripts

## Key Differences from PowerShell Version

| Aspect | PowerShell | Bash |
|--------|------------|------|
| Variable syntax | `$variableName` | `$variableName` (same) |
| Function return | `return @{...}` | Echo key=value pairs |
| Multi-line commands | Backtick (`) | Backslash (\) |
| String replacement | `-replace` | `${var/find/replace}` |
| YAML handling | `powershell-yaml` module | `yq` or Python fallback |
| Path separator | Backslash (\) | Forward slash (/) |
| sed in-place | N/A | `-i ''` (macOS) vs `-i` (Linux) |

## Review Checklist

When reviewing these scripts, verify:

- [ ] All Azure CLI commands match the PowerShell originals
- [ ] Variable names are consistent across scripts
- [ ] Error handling (`set -e`) is appropriate
- [ ] Path resolution works from any directory
- [ ] Custom config loading works correctly
- [ ] The `mount-storage.sh` YAML manipulation works (test with both `yq` and Python fallback)
- [ ] Scripts are executable (`chmod +x`)

## Testing

To test without making Azure changes:

1. Add `--dry-run` or `echo` before `az` commands
2. Test config loading: `source config/variables.sh && echo $subscriptionId`
3. Test utility functions: `source utils/utils.sh && write_log "test"`

## Potential Improvements

1. Add `--dry-run` flag to all scripts
2. Add input validation for required variables
3. Add `--help` option to each script
4. Consider using `shellcheck` for linting
5. Add integration tests with Azure sandbox
