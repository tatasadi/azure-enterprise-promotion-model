variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU for App Service Plan (e.g., B1, S1, P1v2)"
  type        = string
  default     = "B1"
}

variable "always_on" {
  description = "Should the app be always on"
  type        = bool
  default     = true
}

variable "environment_name" {
  description = "Environment name (Development, Test, Production)"
  type        = string
}

variable "key_vault_uri" {
  description = "URI of the Key Vault"
  type        = string
}

variable "app_insights_key" {
  description = "Application Insights instrumentation key"
  type        = string
  default     = ""
}

variable "additional_app_settings" {
  description = "Additional app settings"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
