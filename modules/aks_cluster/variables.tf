variable "location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "East US"
}

variable "resource_group_name" {
  type        = string
  description = "Base name for the Azure resource group"
  default     = "terraform-aks-resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"
}

variable "vm_size" {
  type        = string
  description = "Azure VM size for the Linux web server"
  default     = "Standard_D2as_v7"
}

