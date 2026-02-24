#!/bin/bash
# ============================================
# POPULATE KEY VAULT SECRETS
# ============================================
# This script populates Azure Key Vault with secrets after Terraform creates the infrastructure.
# Secrets are managed outside of Terraform for security best practices.
#
# Usage:
#   ./populate-keyvault-secrets.sh <environment> <key-vault-name>
#
# Example:
#   ./populate-keyvault-secrets.sh dev kv-inventory-dev-001
#
# Prerequisites:
#   - Azure CLI installed and logged in (az login)
#   - Appropriate permissions to set secrets in Key Vault
#   - Environment variables or Azure DevOps Variable Groups containing secret values

set -e  # Exit on error

# Validate arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <environment> <key-vault-name>"
    echo "Example: $0 dev kv-inventory-dev-001"
    exit 1
fi

ENVIRONMENT=$1
KEY_VAULT_NAME=$2

echo "================================================"
echo "Populating Key Vault: $KEY_VAULT_NAME"
echo "Environment: $ENVIRONMENT"
echo "================================================"

# Check if Key Vault exists
if ! az keyvault show --name "$KEY_VAULT_NAME" &> /dev/null; then
    echo "ERROR: Key Vault '$KEY_VAULT_NAME' not found"
    exit 1
fi

# ============================================
# ADD YOUR SECRETS HERE
# ============================================
# Replace these examples with your actual secrets
# Secrets should come from environment variables set by your CI/CD pipeline

# Example: Database Connection String
if [ -n "$DATABASE_CONNECTION_STRING" ]; then
    echo "Setting secret: DatabaseConnectionString"
    az keyvault secret set \
        --vault-name "$KEY_VAULT_NAME" \
        --name "DatabaseConnectionString" \
        --value "$DATABASE_CONNECTION_STRING" \
        --output none
fi

# Example: API Key
if [ -n "$EXTERNAL_API_KEY" ]; then
    echo "Setting secret: ExternalApiKey"
    az keyvault secret set \
        --vault-name "$KEY_VAULT_NAME" \
        --name "ExternalApiKey" \
        --value "$EXTERNAL_API_KEY" \
        --output none
fi

# Example: Storage Account Key
if [ -n "$STORAGE_ACCOUNT_KEY" ]; then
    echo "Setting secret: StorageAccountKey"
    az keyvault secret set \
        --vault-name "$KEY_VAULT_NAME" \
        --name "StorageAccountKey" \
        --value "$STORAGE_ACCOUNT_KEY" \
        --output none
fi

# Example: Application Insights Instrumentation Key
if [ -n "$APPINSIGHTS_INSTRUMENTATION_KEY" ]; then
    echo "Setting secret: AppInsightsInstrumentationKey"
    az keyvault secret set \
        --vault-name "$KEY_VAULT_NAME" \
        --name "AppInsightsInstrumentationKey" \
        --value "$APPINSIGHTS_INSTRUMENTATION_KEY" \
        --output none
fi

# Add more secrets as needed following the pattern above

echo "================================================"
echo "Key Vault secrets updated successfully!"
echo "================================================"
