
module "virtual_machine_loadbalancer" {
  source = "../../modules/vm_lb_pip"

  location                  = var.location
  resource_group_name       = var.resource_group_name
  environment               = var.environment
  vm_size                   = var.vm_size
  admin_username            = var.admin_username
  ssh_public_key            = var.ssh_public_key
  ssh_source_address_prefix = var.ssh_source_address_prefix
}