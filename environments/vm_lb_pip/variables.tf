variable "location" {
  type        = string
  description = "Azure region for the dev environment"
}

variable "resource_group_name" {
  type        = string
  description = "Base name for the Azure resource group"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vm_size" {
  type        = string
  description = "Azure VM size for the Linux web server"
}

variable "admin_username" {
  type        = string
  description = "Linux administrator username"
}

variable "ssh_public_key" {
  type        = string
  description = "OpenSSH public key used to access the VM"
}

variable "ssh_source_address_prefix" {
  type        = string
  description = "Public IPv4 CIDR allowed to connect to SSH"
}
