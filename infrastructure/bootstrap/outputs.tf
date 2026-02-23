output "storage_account_name" {
  description = "Name of the Terraform state storage account"
  value       = module.tfstate_storage.storage_account_name
}

output "container_name" {
  description = "Name of the Terraform state container"
  value       = module.tfstate_storage.container_name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.tfstate.name
}

output "instructions" {
  description = "Next steps"
  value       = <<-EOT
    Terraform state storage has been created!

    Use these values in your environment backend configurations:
    - resource_group_name  = "${azurerm_resource_group.tfstate.name}"
    - storage_account_name = "${module.tfstate_storage.storage_account_name}"
    - container_name       = "${module.tfstate_storage.container_name}"
  EOT
}
