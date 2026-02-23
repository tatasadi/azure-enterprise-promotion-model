variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-inventory-dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
  default     = "app-inventory-dev-001"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "plan-inventory-dev-001"
}

variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "B1"
}

variable "app_service_always_on" {
  description = "Should the app be always on"
  type        = bool
  default     = false # Save costs in dev
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "kv-inventory-dev-001"
}

variable "key_vault_secrets" {
  description = "Secrets to store in Key Vault"
  type        = map(string)
  sensitive   = true
  default = {
    "ConnectionStrings--DefaultConnection" = "Server=tcp:sql-inventory-dev.database.windows.net,1433;Initial Catalog=InventoryDB-Dev;Authentication=Active Directory Default;"
    "ApiKey"                               = "dev-api-key-placeholder"
    "ExternalApiSecret"                    = "dev-external-secret-placeholder"
  }
}

variable "build_number" {
  description = "Build number from CI/CD pipeline"
  type        = string
  default     = "local"
}
