# Infrastructure Scripts

This directory contains scripts for managing Azure infrastructure that is not managed by Terraform.

## Scripts

### `populate-keyvault-secrets.sh`

Populates Azure Key Vault with application secrets after Terraform creates the infrastructure.

**Purpose:** Keep secrets out of Terraform state files for better security.

**Usage:**
```bash
./populate-keyvault-secrets.sh <environment> <key-vault-name>
```

**Example:**
```bash
./populate-keyvault-secrets.sh dev kv-inventory-dev-001
```

**Prerequisites:**
- Azure CLI installed and authenticated (`az login`)
- Key Vault Secrets Officer role on the target Key Vault
- Environment variables containing secret values

**How it works:**
1. Validates inputs and checks Key Vault exists
2. Reads secrets from environment variables
3. Sets each secret in Azure Key Vault using `az keyvault secret set`
4. Used automatically by the pipeline after Terraform Apply

**Pipeline Integration:**

This script is called by `pipelines/templates/populate-keyvault-secrets.yml` which:
- Loads secrets from Azure DevOps Variable Groups
- Maps them to environment variables
- Runs this script via Azure CLI task

**Security Notes:**
- Secrets are never written to disk
- Secrets are never logged to console
- Secrets come from Azure DevOps Variable Groups (encrypted)
- Secrets are transmitted directly to Key Vault via Azure CLI

## Adding New Secrets

To add a new secret:

1. **Add to Variable Group** (Azure DevOps → Pipelines → Library)
   - Add variable in `keyvault-secrets-{env}` group
   - Mark as secret 🔒

2. **Update Pipeline Template** (`pipelines/templates/populate-keyvault-secrets.yml`)
   ```yaml
   env:
     YOUR_NEW_SECRET: $(YOUR_NEW_SECRET)
   ```

3. **Update This Script** (`populate-keyvault-secrets.sh`)
   ```bash
   if [ -n "$YOUR_NEW_SECRET" ]; then
       echo "Setting secret: YourNewSecret"
       az keyvault secret set \
           --vault-name "$KEY_VAULT_NAME" \
           --name "YourNewSecret" \
           --value "$YOUR_NEW_SECRET" \
           --output none
   fi
   ```

## Local Development

For local testing (not recommended for production secrets):

```bash
# Set environment variables
export DATABASE_CONNECTION_STRING="your-dev-connection-string"
export EXTERNAL_API_KEY="your-dev-api-key"

# Run script
./populate-keyvault-secrets.sh dev kv-inventory-dev-001
```

⚠️ **Warning:** Never commit real secrets to git or share them insecurely.
