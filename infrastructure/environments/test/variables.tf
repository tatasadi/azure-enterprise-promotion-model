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

variable "build_number" {
  description = "Build number from CI/CD pipeline"
  type        = string
  default     = "local"
}
