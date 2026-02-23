variable "resource_group_name" {
  description = "Name of the resource group for Terraform state"
  type        = string
  default     = "rg-terraform-state"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
  default     = "sttfstatecommon001"
}

variable "replication_type" {
  description = "Storage replication type"
  type        = string
  default     = "LRS"
}
