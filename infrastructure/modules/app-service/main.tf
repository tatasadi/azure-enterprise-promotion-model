terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = var.tags
}

# App Service
resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = var.always_on

    application_stack {
      dotnet_version = "9.0"
    }

    health_check_path                   = "/health"
    health_check_eviction_time_in_min   = 10
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge(
    {
      "ASPNETCORE_ENVIRONMENT"      = var.environment_name
      "Azure__KeyVault__VaultUri"   = var.key_vault_uri
      "APPINSIGHTS_INSTRUMENTATIONKEY" = var.app_insights_key
    },
    var.additional_app_settings
  )

  https_only = true

  tags = var.tags
}
