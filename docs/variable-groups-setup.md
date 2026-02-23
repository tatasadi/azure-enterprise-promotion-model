# Variable Groups Setup Guide

## Overview

This project uses **Azure DevOps Variable Groups** to securely manage Terraform variables, especially secrets that will be stored in Azure Key Vault. This follows security best practices by:

✅ **Not storing secrets in code**
✅ **Not storing secrets in pipeline YAML**
✅ **Using Azure DevOps Library for secret management**
✅ **Enabling secret rotation without code changes**

---

## 🔐 Architecture

```
Azure DevOps Variable Group (terraform-secrets-dev)
         ↓
    (Provides TF_VAR_KEY_VAULT_SECRETS to pipeline)
         ↓
   Terraform receives secrets as variable
         ↓
    Creates/updates secrets in Azure Key Vault
         ↓
   App Service reads secrets from Key Vault via Managed Identity
```

---

## 📋 Required Variable Groups

You need to create **3 Variable Groups** in Azure DevOps, one for each environment:

1. `terraform-secrets-dev`
2. `terraform-secrets-test`
3. `terraform-secrets-prod`

---

## 🛠️ Step-by-Step Setup

### Step 1: Navigate to Variable Groups

1. Open your Azure DevOps project
2. Go to **Pipelines** → **Library**
3. Click **+ Variable group**

### Step 2: Create Dev Variable Group

1. **Name:** `terraform-secrets-dev`
2. **Description:** "Terraform secrets for Development environment"
3. Click **+ Add** to add variables

### Step 3: Add Required Variables

Add the following variable:

| Variable Name | Value | Type |
|--------------|-------|------|
| `TF_VAR_KEY_VAULT_SECRETS` | See format below | Secret |

**IMPORTANT:** Click the 🔒 lock icon to mark it as **secret**!

### Step 4: Variable Value Format

The value must be a **JSON object** (as a string) with your secrets:

```json
{"ConnectionStrings--DefaultConnection":"Server=tcp:sql-inventory-dev.database.windows.net,1433;Initial Catalog=InventoryDB-Dev;User ID=youruser;Password=YourDevPassword123!;Encrypt=True;","ApiKey":"dev-api-key-change-this","ExternalApiSecret":"dev-external-secret-change-this"}
```

**Note:** This is a single-line JSON string. Azure DevOps will store it securely.

#### Pretty Format (for reference):
```json
{
  "ConnectionStrings--DefaultConnection": "Server=tcp:sql-inventory-dev.database.windows.net,1433;Initial Catalog=InventoryDB-Dev;User ID=youruser;Password=YourDevPassword123!;Encrypt=True;",
  "ApiKey": "dev-api-key-change-this",
  "ExternalApiSecret": "dev-external-secret-change-this"
}
```

### Step 5: Set Permissions

1. Click on **Pipeline permissions**
2. Grant access to your pipeline: `azure-enterprise-promotion-model` (or your pipeline name)
3. Click **Save**

### Step 6: Repeat for Test Environment

Create variable group: `terraform-secrets-test`

```json
{"ConnectionStrings--DefaultConnection":"Server=tcp:sql-inventory-test.database.windows.net,1433;Initial Catalog=InventoryDB-Test;User ID=youruser;Password=YourTestPassword123!;Encrypt=True;","ApiKey":"test-api-key-change-this","ExternalApiSecret":"test-external-secret-change-this"}
```

### Step 7: Repeat for Production Environment

Create variable group: `terraform-secrets-prod`

```json
{"ConnectionStrings--DefaultConnection":"Server=tcp:sql-inventory-prod.database.windows.net,1433;Initial Catalog=InventoryDB-Prod;User ID=youruser;Password=YourProdPassword123!;Encrypt=True;","ApiKey":"prod-api-key-change-this","ExternalApiSecret":"prod-external-secret-change-this"}
```

⚠️ **IMPORTANT:** Use strong, unique passwords for production!

---

## 🔄 How It Works in the Pipeline

The pipeline references these Variable Groups:

```yaml
# azure-pipelines.yml
- stage: Dev_Infrastructure
  variables:
  - group: terraform-secrets-dev  # ← Loads the variable group
  jobs:
  - job: TerraformPlan
    steps:
    - template: pipelines/templates/terraform-plan.yml
```

The Terraform template uses the variable:

```yaml
# pipelines/templates/terraform-plan.yml
- task: TerraformTaskV4@4
  displayName: 'Terraform Plan'
  inputs:
    commandOptions: '-var="key_vault_secrets=$(TF_VAR_KEY_VAULT_SECRETS)"'
  env:
    TF_VAR_KEY_VAULT_SECRETS: $(TF_VAR_KEY_VAULT_SECRETS)
```

Terraform receives it as a variable:

```hcl
# infrastructure/environments/dev/variables.tf
variable "key_vault_secrets" {
  description = "Secrets to store in Key Vault"
  type        = map(string)
  sensitive   = true
}
```

---

## 🔐 Alternative: Link to Azure Key Vault

For **even better security**, you can link Variable Groups to an **Azure Key Vault**:

### Setup Steps:

1. Create an Azure Key Vault (separate from app Key Vaults)
2. Store your secrets in this Key Vault
3. In Azure DevOps Library:
   - Toggle **Link secrets from an Azure key vault as variables**
   - Select your Azure subscription
   - Select your Key Vault
   - Authorize
   - Select which secrets to map

This way:
- ✅ Secrets are managed in Azure, not Azure DevOps
- ✅ Automatic sync when secrets change
- ✅ Better audit trail
- ✅ Centralized secret management

---

## 🧪 Testing Variable Groups

To verify your setup:

1. Go to **Pipelines** → **Library**
2. Click on your variable group
3. Verify the variable exists and is marked as secret (🔒)
4. Check **Pipeline permissions** are set

Run your pipeline and check the Terraform Plan output. You should see:

```
Terraform will perform the following actions:

  # module.key_vault.azurerm_key_vault_secret.secrets["ApiKey"] will be created
  + resource "azurerm_key_vault_secret" "secrets" {
      + name         = "ApiKey"
      + value        = (sensitive value)
      ...
    }
```

The `(sensitive value)` indicates Terraform received the secret correctly!

---

## ⚠️ Security Best Practices

### DO ✅
- Use unique, strong passwords for each environment
- Mark all secret variables with the 🔒 lock icon
- Rotate secrets regularly
- Limit pipeline permissions to specific pipelines
- Use Azure Key Vault-linked Variable Groups for production

### DON'T ❌
- Never commit secrets to git (`.tfvars` files are in `.gitignore`)
- Never log secret values in pipeline output
- Don't reuse the same passwords across environments
- Don't grant broad permissions to Variable Groups

---

## 🔄 Rotating Secrets

To rotate a secret:

1. **Update in Variable Group:**
   - Go to **Pipelines** → **Library** → Select variable group
   - Click **Edit** on the variable
   - Update the value
   - Click **Save**

2. **Re-run Pipeline:**
   - The next pipeline run will update the Key Vault
   - App Service will automatically use the new secret (via Managed Identity)

3. **Zero Downtime:**
   - No code changes required
   - No redeployment required (if only changing the secret value)

---

## 🆘 Troubleshooting

### "Variable group could not be found"

**Solution:**
- Verify the variable group name matches exactly (case-sensitive)
- Check pipeline permissions on the variable group

### "Error parsing key_vault_secrets variable"

**Solution:**
- Ensure the JSON is valid (use a JSON validator)
- Ensure it's a single-line string
- Check for escaped quotes if needed

### "No value provided for variable 'key_vault_secrets'"

**Solution:**
- Variable group not linked to the stage
- Variable name doesn't match (`TF_VAR_KEY_VAULT_SECRETS`)
- Pipeline permissions not granted

### Secrets Not Created in Key Vault

**Solution:**
- Check Terraform Apply logs for errors
- Verify JSON format in variable group
- Ensure service principal has Key Vault permissions

---

## 📚 Additional Resources

- [Azure DevOps Variable Groups](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups)
- [Link Variable Group to Azure Key Vault](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml#link-secrets-from-an-azure-key-vault)
- [Terraform Sensitive Variables](https://developer.hashicorp.com/terraform/language/values/variables#suppressing-values-in-cli-output)

---

**Last Updated:** 2026-02-23
