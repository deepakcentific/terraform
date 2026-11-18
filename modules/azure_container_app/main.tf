terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

locals {
  resource_group_name = "${var.resource_group_name}-${var.environment}"
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

data "azurerm_container_registry" "acr" {
  name                = "deepak"
  resource_group_name = "acr_rg"
}

resource "azurerm_user_assigned_identity" "acr_pull" {
  name                = "aca-acr-pull-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_pull.principal_id
}

resource "azurerm_container_app_environment" "main" {
  name                = "aca-env-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_container_app" "main" {
  name                         = "flask-api-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = local.common_tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acr_pull.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.acr_pull.id
  }

  ingress {
    external_enabled = true
    target_port      = var.container_port
    transport        = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "flask-api"
      image  = var.container_image
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  depends_on = [
    azurerm_role_assignment.acr_pull,
  ]
}
