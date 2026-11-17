# AKS cluster module

This module provisions an Azure resource group and an Azure Kubernetes Service (AKS) cluster. It also assigns the cluster's kubelet identity the `AcrPull` role for the configured Azure Container Registry and installs NGINX Ingress and Argo CD with Helm.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `location` | `string` | `East US` | Azure region |
| `resource_group_name` | `string` | `terraform-aks-resources` | Base name for the resource group |
| `environment` | `string` | `dev` | Environment suffix for the resource group and cluster |
| `vm_size` | `string` | `Standard_D2as_v7` | AKS system node pool VM size |

The calling configuration can pass these values directly to the module; no root `variables.tf` or `.tfvars` file is required when using the defaults.

## Resources and dependencies

- Creates a resource group named `<resource_group_name>-<environment>`.
- Creates an AKS cluster using the latest non-preview Kubernetes version available in the selected region.
- Configures a manually managed system node pool with autoscaling from 1 to 3 nodes.
- Looks up the Azure Container Registry named `deepak` in resource group `acr_rg` and grants it `AcrPull` to the cluster's kubelet identity. That registry must already exist and the deploying identity must have permission to create the role assignment.
- Installs `ingress-nginx` and `argocd` Helm releases after the AKS cluster is created.

The Argo CD Helm configuration sets the server to insecure HTTP mode. Use an appropriate TLS-terminating ingress or change that setting before exposing Argo CD outside a trusted network.

## Output

| Name | Description |
| --- | --- |
| `cluster_name` | Name of the AKS cluster |
| `cluster_id` | Azure resource ID of the AKS cluster |
| `resource_group_name` | Name of the resource group containing the cluster |
| `kubernetes_version` | Kubernetes version running on the cluster |
| `api_server_fqdn` | Public FQDN of the AKS API server |
| `ingress_public_ip` | Public IP assigned to the NGINX ingress controller service |

The QA environment re-exports these values as `aks_cluster_name`, `aks_cluster_id`, `aks_resource_group_name`, `aks_kubernetes_version`, `aks_api_server_fqdn`, and `ingress_public_ip`. For example:

```powershell
terraform output aks_cluster_name
terraform output ingress_public_ip
```

Run Terraform commands from the environment directory (for example, `environments/qa`) that calls this module.
