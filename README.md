# Terraform: Azure Linux VM and Load Balancer

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
