variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "East US"
}

variable "resource_group_name" {
  type        = string
  description = "Base name for the Azure resource group"
  default     = "terraform-resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"
}

variable "vm_size" {
  type        = string
  description = "Azure VM size for the Linux web server"
  default     = "Standard_B1ms" #Standard_D2as_v7
}

variable "admin_username" {
  type        = string
  description = "Linux administrator username"
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "OpenSSH public key used to access the VM through the load balancer"
}

variable "ssh_source_address_prefix" {
  type        = string
  description = "Public IPv4 CIDR allowed to connect to SSH (for example, your.ip.address/32)"

  validation {
    condition     = can(cidrhost(var.ssh_source_address_prefix, 0)) && var.ssh_source_address_prefix != "0.0.0.0/0"
    error_message = "Provide a valid IPv4 CIDR other than 0.0.0.0/0 to restrict SSH access."
  }
}

