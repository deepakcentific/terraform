output "container_app_name" {
  description = "Name of the Azure Container App"
  value       = module.azure_container_app.container_app_name
}

output "container_app_environment_name" {
  description = "Name of the Container Apps environment"
  value       = module.azure_container_app.container_app_environment_name
}

output "resource_group_name" {
  description = "Name of the resource group containing the Container App"
  value       = module.azure_container_app.resource_group_name
}

output "container_app_fqdn" {
  description = "Public fully qualified domain name of the latest app revision"
  value       = module.azure_container_app.fqdn
}

output "container_app_url" {
  description = "HTTPS URL for the Flask API"
  value       = module.azure_container_app.url
}
