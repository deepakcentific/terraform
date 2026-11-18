# Terraform: Azure Infrastructure Examples

This repository contains separate Terraform examples for an Azure Linux VM and load balancer, an AKS cluster, Azure Container Instances (ACI), and Azure Container Apps. Apply each example from its own directory so its Terraform state is kept separate.

## Azure Container App learning example

The [`azure_container_app` environment](./environments/azure_container_app) calls a reusable module in [`modules/azure_container_app`](./modules/azure_container_app). It looks up the existing `deepak` ACR in resource group `acr_rg`, creates a user-assigned managed identity with `AcrPull` access, and runs the Flask API image on a public Container App. The app exposes HTTPS ingress and forwards traffic to container port 5000.

Register the required Azure resource providers if needed, then from `environments/azure_container_app` run:

```powershell
az login
az provider register --namespace Microsoft.App --wait
az provider register --namespace Microsoft.OperationalInsights --wait
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform outputs the app URL and FQDN. Clean up when finished to avoid ongoing Azure charges:

```powershell
terraform destroy
```

## Azure Container Instance learning example

The [`azure_container_instance` environment](./environments/azure_container_instance) calls a reusable module in [`modules/azure_container_instance`](./modules/azure_container_instance). It looks up the existing `deepak` ACR in resource group `acr_rg`, creates a user-assigned managed identity with `AcrPull` access, and runs the private Flask API image on a public Linux container group. The example exposes TCP port 5000. ACI is useful for running containers without managing VMs or Kubernetes.

From `environments/azure_container_instance`, authenticate to Azure and run:

```powershell
az login
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform outputs the container group's URL and IP address. Adjust values directly in the environment's `main.tf`. Clean up when finished to avoid ongoing Azure charges:

```powershell
terraform destroy
```

The module README describes the example and its configurable inputs.

## Azure Linux VM and Load Balancer

This configuration creates an Azure resource group, virtual network and subnet, one small Ubuntu 22.04 VM, and a Standard public load balancer. The VM has no public IP. HTTP traffic is forwarded to Nginx on the VM, SSH is forwarded through the load balancer and restricted to a caller-supplied CIDR, and a load-balancer outbound rule provides VM internet egress for cloud-init package installation.

The load balancer currently has one VM backend. It provides a stable public endpoint, but a single VM is not highly available.

Refer to this repo as well: https://github.com/dsahoo165/Terraform/tree/main
## Prerequisites

- Terraform 1.5 or later
- Azure CLI authenticated to the subscription to use (`az login`)
- An SSH key pair

Generate a key pair in PowerShell if needed:

```powershell
ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\terraform-azure"
```

Create `terraform.tfvars` in this directory. Replace the sample values with your public key contents and your public IPv4 address in CIDR notation:

```hcl
location                 = "East US"
resource_group_name       = "terraform-resources"
environment               = "dev"
vm_size                   = "Standard_B1ms"
admin_username            = "azureuser"
ssh_public_key            = "ssh-ed25519 REPLACE_WITH_CONTENTS_OF_YOUR_PUBLIC_KEY"
ssh_source_address_prefix = "REPLACE_WITH_YOUR_PUBLIC_IPV4/32"
```

For example, display the generated public key with:

```powershell
Get-Content "$env:USERPROFILE\.ssh\terraform-azure.pub"
```

Do not commit `terraform.tfvars` or private SSH keys.

## Deploy

Run these commands from this directory:

```powershell
terraform init
terraform validate
terraform plan
terraform apply
```

After applying, Terraform prints the load balancer public IP, web URL, SSH command, and VM private IP. Visit the web URL to reach Nginx. Connect using the matching private key, for example:

```powershell
ssh -i "$env:USERPROFILE\.ssh\terraform-azure" azureuser@<load-balancer-public-ip>
```

The SSH source CIDR must include the public IP of the computer initiating the connection. Change `ssh_source_address_prefix` in `terraform.tfvars` if that IP changes.

## Clean up

When finished, remove the resources created by this configuration:

```powershell
terraform destroy
```
