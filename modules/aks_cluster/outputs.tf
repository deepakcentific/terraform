output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "cluster_id" {
  description = "Azure resource ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "resource_group_name" {
  description = "Name of the resource group containing the AKS cluster"
  value       = azurerm_resource_group.aks_rg.name
}

output "kubernetes_version" {
  description = "Kubernetes version running on the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}

output "api_server_fqdn" {
  description = "Public FQDN of the AKS API server"
  value       = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

output "ingress_public_ip" {
  description = "Public IP assigned to the NGINX ingress controller service"
  value       = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
}
