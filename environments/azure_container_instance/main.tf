terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "azure_container_instance" {
  source = "../../modules/azure_container_instance"

  location            = "East US"
  resource_group_name = "terraform-aci-resources"
  environment         = "dev"
  container_image     = "deepak.azurecr.io/app1/flask-api:4eb3a3a818278da22060514ec8a76369e5d4bf51"
  container_port      = 5000
  container_cpu       = 1
  container_memory    = 1.5
}
