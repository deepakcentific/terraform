output "container_group_name" {
  description = "Name of the Azure Container Instance container group"
  value       = module.azure_container_instance.container_group_name
}

output "resource_group_name" {
  description = "Name of the resource group containing the container group"
  value       = module.azure_container_instance.resource_group_name
}

output "container_ip_address" {
  description = "Public IP address assigned to the container group"
  value       = module.azure_container_instance.ip_address
}

output "container_url" {
  description = "HTTP URL for the sample container"
  value       = module.azure_container_instance.url
}
