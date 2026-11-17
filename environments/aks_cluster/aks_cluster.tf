module "aks_cluster" {
  source = "../../modules/aks_cluster"

  #if no values are provided then default values will be assigned
  
  location                  = "East US"
  #resource_group_name      = "terraform-aks-resources"
  environment               = "dev2"
  vm_size                   = "Standard_D2as_v7"

}