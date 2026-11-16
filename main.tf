provider "azurerm" {
    features {}
}

# Create a Azure Resource Group
resource "azurerm_resource_group" "aksdev" {
  name     = "aks-rg2-tf"
  location = "Central US"

# Add Tags
  tags = {
    "environment" = "k8sdev"
  }
}