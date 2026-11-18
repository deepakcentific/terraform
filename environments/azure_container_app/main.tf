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

module "azure_container_app" {
  source = "../../modules/azure_container_app"

  location            = "East US"
  resource_group_name = "terraform-aca-resources"
  environment         = "dev"
  container_image     = "deepak.azurecr.io/app1/flask-api:4eb3a3a818278da22060514ec8a76369e5d4bf51"
  container_port      = 5000
}
