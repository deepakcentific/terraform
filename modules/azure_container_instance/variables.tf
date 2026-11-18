variable "location" {
  type        = string
  description = "Azure region for the container group and resource group"
  default     = "East US"
}

variable "resource_group_name" {
  type        = string
  description = "Base name for the Azure resource group"
  default     = "terraform-aci-resources"
}

variable "environment" {
  type        = string
  description = "Lowercase environment name used in Azure resource names"
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,57}[a-z0-9])?$", var.environment))
    error_message = "Use 1-59 lowercase letters, numbers, or hyphens for the environment; it must not start or end with a hyphen."
  }
}

variable "container_image" {
  type        = string
  description = "Container image to run"
  default     = "deepak.azurecr.io/app1/flask-api:9fce1827c79fb81f4a6a5f1c22e98a42d35e3475"
}

variable "container_port" {
  type        = number
  description = "Public TCP port exposed by the container"
  default     = 5000

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "container_port must be between 1 and 65535."
  }
}

variable "container_cpu" {
  type        = number
  description = "CPU cores allocated to the container"
  default     = 1
}

variable "container_memory" {
  type        = number
  description = "Memory in GB allocated to the container"
  default     = 1.5
}
