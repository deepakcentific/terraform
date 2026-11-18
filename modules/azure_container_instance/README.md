# Azure Container Instance module

This module creates a resource group and a Linux Azure Container Instance (ACI) container group running the private image `deepak.azurecr.io/app1/flask-api:9fce1827c79fb81f4a6a5f1c22e98a42d35e3475`. It looks up the existing `deepak` Azure Container Registry in resource group `acr_rg`, creates a user-assigned managed identity, and grants that identity the `AcrPull` role on the registry. The container group has a public IP address and exposes TCP port 5000 by default.

ACI runs containers without requiring you to manage virtual machines or a Kubernetes cluster. This example uses one container; container groups can also run multiple closely related containers that share resources and networking.

The environment in `environments/azure_container_instance` calls this module and configures the AzureRM provider. Its settings are specified directly in `main.tf`. From that directory, run:

```powershell
az login
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform outputs the container group's public IP address and URL. Change the module arguments in the environment's `main.tf` to use a different image, port, CPU, or memory. Ensure the port matches the port the application listens on in the container.

The identity used for the ACR pull is separate from the AKS kubelet identity. The Azure account running Terraform needs permission to read the existing registry and create role assignments. If the registry restricts network access, configure its trusted-services access as required by Azure Container Instances.

Azure charges for running resources. When finished learning, remove the resources with:

```powershell
terraform destroy
```
