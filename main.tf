provider "azurerm" {  
  features {}
}


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"


  node_provisioning_profile {
    mode = "Manual"
  }

  default_node_pool {
    name                 = "systempool"
    vm_size              = var.vm_size
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    #availability_zones   = [1, 2, 3]
    # Added June2023
    #zones = [1,2,3]
    #enable_auto_scaling  = true # COMMENTED OCT2024
    auto_scaling_enabled = true  # ADDED OCT2024
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
      "app"              = "system-apps" 
    } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "dev"
      "nodepoolos"       = "linux"
      "app"              = "system-apps" 
   } 
  }

# Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }



# Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "dev"
  }
}