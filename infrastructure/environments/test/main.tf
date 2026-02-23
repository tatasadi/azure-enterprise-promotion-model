terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstateazpromota"
    container_name       = "tfstate"
    key                  = "inventory-test.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = local.tags
}

# Key Vault Module
module "key_vault" {
  source = "../../modules/key-vault"

  key_vault_name           = var.key_vault_name
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  app_service_principal_id = module.app_service.app_service_principal_id

  secrets = var.key_vault_secrets

  tags = local.tags
}

# App Service Module
module "app_service" {
  source = "../../modules/app-service"

  app_service_name      = var.app_service_name
  app_service_plan_name = var.app_service_plan_name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  sku_name              = var.app_service_sku
  always_on             = var.app_service_always_on
  environment_name      = "Test"
  key_vault_uri         = module.key_vault.key_vault_uri

  additional_app_settings = {
    "Build__Date"   = timestamp()
    "Build__Number" = var.build_number
  }

  tags = local.tags

  depends_on = [module.key_vault]
}

locals {
  tags = {
    Environment = "Test"
    Project     = "InventoryApi"
    ManagedBy   = "Terraform"
    CostCenter  = "Engineering"
  }
}
