variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-inventory-dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
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
  description = "Secrets to store in Key Vault (provided via pipeline Variable Groups)"
  type        = map(string)
  sensitive   = true
  # NO DEFAULT - Must be provided via pipeline Variable Groups or .tfvars
  # See: docs/variable-groups-setup.md for configuration
}

variable "build_number" {
  description = "Build number from CI/CD pipeline"
  type        = string
  default     = "local"
}
