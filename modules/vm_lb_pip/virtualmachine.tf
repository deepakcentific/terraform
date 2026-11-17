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

resource "azurerm_virtual_network" "main" {
  name                = "${local.resource_group_name}-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "main" {
  name                 = "web"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "${local.resource_group_name}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_network_security_rule" "http" {
  name                        = "Allow-HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "Allow-SSH-Restricted"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.ssh_source_address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_public_ip" "load_balancer" {
  name                = "${local.resource_group_name}-lb-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_lb" "main" {
  name                = "${local.resource_group_name}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  tags                = local.common_tags

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.load_balancer.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name            = "web-backend"
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "http" {
  name            = "http-health-probe"
  loadbalancer_id = azurerm_lb.main.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

resource "azurerm_lb_rule" "http" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "public"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.http.id
  disable_outbound_snat          = true
}

resource "azurerm_lb_rule" "ssh" {
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "public"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  disable_outbound_snat          = true
}

resource "azurerm_lb_outbound_rule" "main" {
  name                     = "vm-internet-egress"
  loadbalancer_id          = azurerm_lb.main.id
  protocol                 = "All"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.main.id
  allocated_outbound_ports = 1024
  tcp_reset_enabled        = true
  idle_timeout_in_minutes  = 4

  depends_on = [
    azurerm_lb_rule.http,
    azurerm_lb_rule.ssh,
  ]

  frontend_ip_configuration {
    name = "public"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${local.resource_group_name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.main,
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  network_interface_id    = azurerm_network_interface.main.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${local.resource_group_name}-vm"
  computer_name                   = "${var.environment}-web"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.main.id]
  custom_data                     = filebase64("${path.module}\\cloud-init.yaml")
  tags                            = local.common_tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface_backend_address_pool_association.main,
  ]
}

output "load_balancer_public_ip" {
  description = "Public IPv4 address for the HTTP endpoint and restricted SSH access"
  value       = azurerm_public_ip.load_balancer.ip_address
}

output "web_url" {
  description = "HTTP URL served by the Linux VM through the load balancer"
  value       = "http://${azurerm_public_ip.load_balancer.ip_address}"
}

output "ssh_command" {
  description = "SSH command; connect only from the configured allowed CIDR"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.load_balancer.ip_address}"
}

output "vm_private_ip" {
  description = "Private IP address of the Linux VM"
  value       = azurerm_network_interface.main.private_ip_address
}
