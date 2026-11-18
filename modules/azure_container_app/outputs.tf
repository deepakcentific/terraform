output "container_app_name" {
  description = "Name of the Azure Container App"
  value       = azurerm_container_app.main.name
}

output "container_app_environment_name" {
  description = "Name of the Container Apps environment"
  value       = azurerm_container_app_environment.main.name
}

output "resource_group_name" {
  description = "Name of the resource group containing the Container App"
  value       = azurerm_resource_group.main.name
}

output "fqdn" {
  description = "Public fully qualified domain name of the latest app revision"
  value       = azurerm_container_app.main.latest_revision_fqdn
}

output "url" {
  description = "HTTPS URL for the Flask API"
  value       = "https://${azurerm_container_app.main.latest_revision_fqdn}"
}
