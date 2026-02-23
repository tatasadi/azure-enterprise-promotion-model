terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 7
  purge_protection_enabled   = var.purge_protection_enabled

  enable_rbac_authorization = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow" # In production, set to "Deny" and configure specific rules
  }

  tags = var.tags
}

# RBAC: Grant Key Vault Secrets Officer to the current user (for Terraform)
resource "azurerm_role_assignment" "terraform_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# RBAC: Grant Key Vault Secrets User to the App Service Managed Identity
resource "azurerm_role_assignment" "app_service_secrets_user" {
  count                = var.app_service_principal_id != "" ? 1 : 0
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app_service_principal_id

  depends_on = [azurerm_key_vault.main]
}

# Create secrets in Key Vault
resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.terraform_secrets_officer]
}
