output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_cluster.cluster_name
}

output "aks_cluster_id" {
  description = "Azure resource ID of the AKS cluster"
  value       = module.aks_cluster.cluster_id
}

output "aks_resource_group_name" {
  description = "Name of the resource group containing the AKS cluster"
  value       = module.aks_cluster.resource_group_name
}

output "aks_kubernetes_version" {
  description = "Kubernetes version running on the AKS cluster"
  value       = module.aks_cluster.kubernetes_version
}

output "aks_api_server_fqdn" {
  description = "Public FQDN of the AKS API server"
  value       = module.aks_cluster.api_server_fqdn
}

output "ingress_public_ip" {
  description = "Public IP assigned to the NGINX ingress controller service"
  value       = module.aks_cluster.ingress_public_ip
}
