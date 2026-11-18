# Azure Container App module

This module creates a resource group, a Consumption-only Container Apps environment, and a public Container App running `deepak.azurecr.io/app1/flask-api:4eb3a3a818278da22060514ec8a76369e5d4bf51`.

The module looks up the existing `deepak` Azure Container Registry in resource group `acr_rg`, creates a user-assigned managed identity, and grants the identity `AcrPull` access to the registry. The app uses that identity to pull the private image. Its public HTTP ingress is served over HTTPS and forwards to port 5000 in the container.

The environment in `environments/azure_container_app` calls this module and keeps its settings directly in `main.tf`. Before deploying, register the required Azure resource providers if they are not registered in your subscription:

```powershell
az provider register --namespace Microsoft.App --wait
az provider register --namespace Microsoft.OperationalInsights --wait
```

From `environments/azure_container_app`, run:

```powershell
az login
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform outputs the public HTTPS URL and FQDN. The app is configured with one replica; Azure charges may apply while it is running. When finished, remove the resources with:

```powershell
terraform destroy
```

The Azure identity running Terraform needs permission to read the existing registry and create role assignments.
