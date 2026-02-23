# ============================================
# BOOTSTRAP - Terraform State Storage Setup
# ============================================
# Run this ONCE to create the storage account for Terraform state
# After running, configure backend in environment configs

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group for Terraform State
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Purpose   = "Terraform State Storage"
    ManagedBy = "Terraform"
  }
}

# Storage Account Module for Terraform State
module "tfstate_storage" {
  source = "../modules/storage-account"

  storage_account_name = var.storage_account_name
  resource_group_name  = azurerm_resource_group.tfstate.name
  location             = azurerm_resource_group.tfstate.location
  replication_type     = var.replication_type

  tags = {
    Purpose   = "Terraform State Storage"
    ManagedBy = "Terraform"
  }
}
