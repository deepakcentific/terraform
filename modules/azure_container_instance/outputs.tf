output "container_group_name" {
  description = "Name of the Azure Container Instance container group"
  value       = azurerm_container_group.main.name
}

output "resource_group_name" {
  description = "Name of the resource group containing the container group"
  value       = azurerm_resource_group.main.name
}

output "ip_address" {
  description = "Public IP address assigned to the container group"
  value       = azurerm_container_group.main.ip_address
}

output "url" {
  description = "HTTP URL for the Flask API container"
  value       = "http://${azurerm_container_group.main.ip_address}:${var.container_port}"
}
