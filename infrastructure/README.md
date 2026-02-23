# Infrastructure as Code - Terraform

This directory contains all Terraform configurations for the Azure Enterprise Promotion Model project.

## 📁 Structure

```
infrastructure/
├── modules/                  # Reusable Terraform modules
│   ├── app-service/          # App Service + App Service Plan
│   ├── key-vault/            # Key Vault with RBAC
│   └── storage-account/      # Storage Account for Terraform state
│
├── environments/             # Environment-specific configurations
│   ├── dev/                  # Development environment
│   ├── test/                 # Test environment
│   └── prod/                 # Production environment
│
└── bootstrap/                # Bootstrap infrastructure
    └── main.tf               # Creates Terraform state storage
```

## 🚀 Getting Started

### 1. Bootstrap (Run Once)

First, create the Azure Storage Account for Terraform state:

```bash
cd bootstrap

# Login to Azure
az login

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Note the outputs - you'll need these for environment configs
terraform output
```

### 2. Deploy an Environment

After bootstrapping, deploy to each environment:

```bash
# Example: Deploy to dev environment
cd environments/dev

# Initialize Terraform (downloads providers and configures backend)
terraform init

# Review what will be created
terraform plan

# Apply the infrastructure
terraform apply

# View outputs
terraform output
```

### 3. Terraform Workflow

```
terraform init    # Initialize (first time or after adding providers)
terraform validate # Validate syntax
terraform plan    # Preview changes
terraform apply   # Apply changes
terraform output  # View outputs
terraform destroy # Destroy all resources (BE CAREFUL!)
```

## 🔐 State Management

### Remote State Backend

All environments use Azure Storage backend for state:

- **Resource Group:** `rg-terraform-state`
- **Storage Account:** `sttfstatedev001`
- **Container:** `tfstate`
- **State Files:**
  - Dev: `inventory-dev.tfstate`
  - Test: `inventory-test.tfstate`
  - Prod: `inventory-prod.tfstate`

### State Locking

State locking is enabled automatically when using Azure Storage backend. This prevents concurrent modifications.

## 🏗️ Modules

### app-service

Creates:
- App Service Plan (Linux)
- App Service (Linux Web App)
- System-assigned Managed Identity
- Health check configuration

**Inputs:**
- `app_service_name` - Name of the App Service
- `app_service_plan_name` - Name of the App Service Plan
- `sku_name` - SKU (B1, S1, P1v2, etc.)
- `environment_name` - Environment (Development, Test, Production)
- `key_vault_uri` - URI of the Key Vault

**Outputs:**
- `app_service_id`
- `app_service_name`
- `app_service_principal_id` - For granting Key Vault access

### key-vault

Creates:
- Azure Key Vault
- RBAC role assignments
- Secrets

**Inputs:**
- `key_vault_name` - Name of the Key Vault (globally unique)
- `app_service_principal_id` - Managed Identity to grant access
- `secrets` - Map of secrets to create

**Outputs:**
- `key_vault_id`
- `key_vault_uri`

### storage-account

Creates:
- Storage Account
- Blob container for Terraform state

**Inputs:**
- `storage_account_name` - Name (globally unique, 3-24 chars)
- `replication_type` - LRS, GRS, etc.

**Outputs:**
- `storage_account_name`
- `container_name`

## 🌍 Environments

### Development (dev)

- **Purpose:** Development and testing
- **SKU:** B1 (cost-effective)
- **Always On:** No (to save costs)
- **Secrets:** Development placeholders

### Test (test)

- **Purpose:** Integration testing and UAT
- **SKU:** B1
- **Always On:** Yes
- **Secrets:** Test environment values

### Production (prod)

- **Purpose:** Production workloads
- **SKU:** P1v2 (production-grade)
- **Always On:** Yes
- **Purge Protection:** Enabled on Key Vault
- **Secrets:** Production values

## 🔧 Customization

### Changing Resource Names

Edit the `variables.tf` in each environment:

```hcl
variable "app_service_name" {
  default = "app-inventory-dev-001"  # Change this
}
```

### Adding Secrets

Edit the `key_vault_secrets` variable:

```hcl
variable "key_vault_secrets" {
  default = {
    "ConnectionStrings--DefaultConnection" = "your-connection-string"
    "ApiKey" = "your-api-key"
    "NewSecret" = "new-secret-value"
  }
  sensitive = true
}
```

### Changing Azure Region

```hcl
variable "location" {
  default = "East US"  # Change to your preferred region
}
```

## 📋 Common Commands

```bash
# Format Terraform files
terraform fmt -recursive

# Validate configuration
terraform validate

# Show current state
terraform show

# List resources in state
terraform state list

# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/my-rg

# Refresh state (sync with Azure)
terraform refresh

# Target specific resource
terraform apply -target=module.app_service
```

## ⚠️ Important Notes

### Before Running Terraform:

1. **Ensure you're logged into Azure:**
   ```bash
   az login
   az account show
   ```

2. **Set the correct subscription:**
   ```bash
   az account set --subscription "your-subscription-id"
   ```

3. **Check you have permissions:**
   - Contributor role on the subscription/resource group
   - Or specific permissions for resources you're creating

### Security Best Practices:

- ✅ **Never commit `.tfstate` files** - They contain secrets!
- ✅ **Use `.tfvars` files for sensitive values** - Already in .gitignore
- ✅ **Use Terraform workspaces or separate backends** - We use separate backends
- ✅ **Enable purge protection in prod** - Already configured
- ✅ **Review plans before applying** - Always run `terraform plan` first

### Cost Management:

- Dev environment uses B1 SKU and disables "Always On"
- Test uses B1 SKU
- Prod uses P1v2 for production workloads
- Consider using B-series for cost savings in non-prod

## 🔄 CI/CD Integration

These Terraform configurations are used by Azure Pipelines:

1. **Pipeline Stage:** `Dev_Infrastructure`, `Test_Infrastructure`, `Prod_Infrastructure`
2. **Templates Used:**
   - `terraform-plan.yml` - Plans changes
   - `terraform-apply.yml` - Applies changes
3. **Service Connections:** Environment-specific Azure service connections
4. **Automated:** Runs on every commit to `main` branch

## 🆘 Troubleshooting

### State Lock Error

```
Error: Error acquiring the state lock
```

**Solution:**
```bash
# Force unlock (use with caution!)
terraform force-unlock <lock-id>
```

### Provider Version Conflicts

```bash
# Delete .terraform directory and re-initialize
rm -rf .terraform
terraform init
```

### Key Vault Purge Protection

If you can't delete a Key Vault in prod:
- It's protected! This is intentional.
- Wait 7-90 days for soft-delete
- Or use Azure Portal to purge

### Resource Already Exists

```bash
# Import the existing resource
terraform import <resource_type>.<name> <azure_resource_id>
```

## 📚 Additional Resources

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Azure Naming Conventions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

---

**Last Updated:** 2026-02-23
