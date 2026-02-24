# Variable Groups Setup Guide

## Overview

This project uses **Azure DevOps Variable Groups** to securely manage secrets for Azure Key Vault. This follows **security best practices** by:

✅ **Not storing secrets in code**
✅ **Not storing secrets in pipeline YAML**
✅ **Not storing secrets in Terraform state files**
✅ **Using Azure DevOps Library for secret management**
✅ **Enabling secret rotation without infrastructure changes**

---

## 🔐 Architecture

```
Azure DevOps Variable Group (keyvault-secrets-dev)
         ↓
    (Provides secret values to pipeline as environment variables)
         ↓
   Azure CLI task sets secrets directly in Key Vault
         ↓
   App Service reads secrets from Key Vault via Managed Identity
```

**Key Change:** Terraform creates the Key Vault infrastructure **only**. Secrets are populated **after** Terraform runs using Azure CLI, keeping secrets out of Terraform state.

---

## 📋 Required Variable Groups

You need to create **3 Variable Groups** in Azure DevOps, one for each environment:

1. `keyvault-secrets-dev`
2. `keyvault-secrets-test`
3. `keyvault-secrets-prod`

---

## 🛠️ Step-by-Step Setup

### Step 1: Navigate to Variable Groups

1. Open your Azure DevOps project
2. Go to **Pipelines** → **Library**
3. Click **+ Variable group**

### Step 2: Create Dev Variable Group

1. **Name:** `keyvault-secrets-dev`
2. **Description:** "Key Vault secrets for Development environment"
3. Click **+ Add** to add variables

### Step 3: Add Required Variables

Add your application secrets as **individual variables**:

| Variable Name | Example Value | Type |
|--------------|---------------|------|
| `DATABASE_CONNECTION_STRING` | `Server=tcp:...` | Secret 🔒 |
| `EXTERNAL_API_KEY` | `dev-api-key-123` | Secret 🔒 |
| `STORAGE_ACCOUNT_KEY` | `abc123...` | Secret 🔒 |
| `APPINSIGHTS_INSTRUMENTATION_KEY` | `guid-here` | Secret 🔒 |

**IMPORTANT:** Click the 🔒 lock icon to mark each variable as **secret**!

### Step 4: Example Secret Values

**Development Example:**

| Variable | Value |
|----------|-------|
| `DATABASE_CONNECTION_STRING` | `Server=tcp:sql-inventory-dev.database.windows.net,1433;Initial Catalog=InventoryDB-Dev;User ID=youruser;Password=YourDevPassword123!;` |
| `EXTERNAL_API_KEY` | `dev-api-key-change-this` |
| `STORAGE_ACCOUNT_KEY` | `dev-storage-key-here` |
| `APPINSIGHTS_INSTRUMENTATION_KEY` | `00000000-0000-0000-0000-000000000000` |

### Step 5: Set Permissions

1. Click on **Pipeline permissions**
2. Grant access to your pipeline: `azure-enterprise-promotion-model`
3. Click **Save**

### Step 6: Repeat for Test Environment

Create variable group: `keyvault-secrets-test`

Use **different** secret values appropriate for test environment.

### Step 7: Repeat for Production Environment

Create variable group: `keyvault-secrets-prod`

⚠️ **IMPORTANT:** Use strong, unique passwords for production!

---

## 🔄 How It Works in the Pipeline

### 1. Pipeline References Variable Groups

```yaml
# azure-pipelines.yml
- stage: Dev_Infrastructure
  variables:
  - group: keyvault-secrets-dev  # ← Loads the variable group
  jobs:
  - job: TerraformApply
    steps:
    # Terraform creates Key Vault (no secrets)
    - template: pipelines/templates/terraform-apply.yml

    # Azure CLI populates secrets
    - template: pipelines/templates/populate-keyvault-secrets.yml
```

### 2. Terraform Creates Infrastructure Only

Terraform creates:
- ✅ Key Vault resource
- ✅ RBAC permissions
- ✅ Network rules
- ❌ **Does NOT create secrets**

### 3. Azure CLI Populates Secrets

After Terraform completes, a bash script runs:

```bash
az keyvault secret set \
    --vault-name "kv-inventory-dev-001" \
    --name "DatabaseConnectionString" \
    --value "$DATABASE_CONNECTION_STRING"
```

This approach ensures:
- Secrets never appear in Terraform state
- Secrets are managed independently from infrastructure
- Better separation of concerns

---

## 🔐 Alternative: Link to Azure Key Vault (Recommended for Production)

For **even better security**, you can link Variable Groups to an **Azure Key Vault**:

### Setup Steps:

1. Create a **separate** Azure Key Vault for DevOps secrets (not the app Key Vault)
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

1. **Check Variable Group:**
   - Go to **Pipelines** → **Library**
   - Click on your variable group
   - Verify all variables exist and are marked as secret (🔒)
   - Check **Pipeline permissions** are set

2. **Run Pipeline:**
   - Watch the "Populate Key Vault Secrets" step
   - Should show: `Setting secret: DatabaseConnectionString`
   - Should complete without errors

3. **Verify in Azure:**
   ```bash
   az keyvault secret list --vault-name kv-inventory-dev-001 --query "[].name"
   ```

---

## 🔐 Customizing Secrets

### Add New Secrets

1. **Update Variable Group:**
   - Add new variable (e.g., `NEW_SECRET_NAME`)
   - Mark as secret 🔒

2. **Update Script:**
   - Edit `infrastructure/scripts/populate-keyvault-secrets.sh`
   - Add new secret block:
   ```bash
   if [ -n "$NEW_SECRET_NAME" ]; then
       echo "Setting secret: NewSecretName"
       az keyvault secret set \
           --vault-name "$KEY_VAULT_NAME" \
           --name "NewSecretName" \
           --value "$NEW_SECRET_NAME" \
           --output none
   fi
   ```

3. **Update Pipeline Template:**
   - Edit `pipelines/templates/populate-keyvault-secrets.yml`
   - Add environment variable mapping:
   ```yaml
   env:
     NEW_SECRET_NAME: $(NEW_SECRET_NAME)
   ```

---

## ⚠️ Security Best Practices

### DO ✅
- Use unique, strong passwords for each environment
- Mark all secret variables with the 🔒 lock icon
- Rotate secrets regularly
- Limit pipeline permissions to specific pipelines
- Use Azure Key Vault-linked Variable Groups for production
- Keep infrastructure (Terraform) separate from secrets (Azure CLI)

### DON'T ❌
- Never commit secrets to git
- Never log secret values in pipeline output
- Don't reuse the same passwords across environments
- Don't grant broad permissions to Variable Groups
- Don't pass secrets to Terraform as variables

---

## 🔄 Rotating Secrets

To rotate a secret:

1. **Update in Variable Group:**
   - Go to **Pipelines** → **Library** → Select variable group
   - Click **Edit** on the variable
   - Update the value
   - Click **Save**

2. **Re-run Pipeline** (or just the populate step):
   - The script will update the Key Vault
   - App Service will automatically use the new secret (via Managed Identity)

3. **Or Update Manually:**
   ```bash
   az keyvault secret set \
       --vault-name kv-inventory-dev-001 \
       --name "DatabaseConnectionString" \
       --value "new-value-here"
   ```

4. **Zero Downtime:**
   - No Terraform changes required
   - No infrastructure redeployment
   - App picks up new secret automatically

---

## 🆘 Troubleshooting

### "Variable group could not be found"

**Solution:**
- Verify the variable group name matches exactly (case-sensitive)
- Check pipeline permissions on the variable group

### "Secret not created in Key Vault"

**Solution:**
- Check if environment variable is set in pipeline template
- Verify variable exists in Variable Group
- Check Azure CLI task logs for errors
- Ensure service principal has Key Vault Secrets Officer role

### "Access denied when setting secret"

**Solution:**
- Service principal needs "Key Vault Secrets Officer" role
- Terraform creates this role for the current user
- Check RBAC assignments on Key Vault

### Variable is empty in script

**Solution:**
- Ensure variable is mapped in `populate-keyvault-secrets.yml`
- Check variable name matches exactly (case-sensitive)
- Variable must be in the Variable Group linked to that stage

---

## 📚 Additional Resources

- [Azure DevOps Variable Groups](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups)
- [Link Variable Group to Azure Key Vault](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml#link-secrets-from-an-azure-key-vault)
- [Azure Key Vault Secret Management](https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets)
- [Terraform Secrets Management Best Practices](https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables)

---

## 🔄 Migration from Old Approach

If you previously used `TF_VAR_KEY_VAULT_SECRETS`:

1. **Rename Variable Groups:**
   - `terraform-secrets-dev` → `keyvault-secrets-dev`

2. **Restructure Variables:**
   - From: Single JSON variable
   - To: Individual secret variables

3. **No Terraform Changes Needed:**
   - Terraform no longer manages secrets
   - Existing secrets in Key Vault are preserved

---

**Last Updated:** 2026-02-23
