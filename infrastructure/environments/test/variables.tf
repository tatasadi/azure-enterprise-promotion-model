variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-inventory-test"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
  default     = "app-inventory-test-001"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "plan-inventory-test-001"
}

variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "B1"
}

variable "app_service_always_on" {
  description = "Should the app be always on"
  type        = bool
  default     = true
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "kv-inventory-test-001"
}

variable "key_vault_secrets" {
  description = "Secrets to store in Key Vault"
  type        = map(string)
  sensitive   = true
  default = {
    "ConnectionStrings--DefaultConnection" = "Server=tcp:sql-inventory-test.database.windows.net,1433;Initial Catalog=InventoryDB-Test;Authentication=Active Directory Default;"
    "ApiKey"                               = "test-api-key-placeholder"
    "ExternalApiSecret"                    = "test-external-secret-placeholder"
  }
}

variable "build_number" {
  description = "Build number from CI/CD pipeline"
  type        = string
  default     = "local"
}
