variable "location" {
  type        = string
  description = "Azure region for the Container Apps environment"
  default     = "East US"
}

variable "resource_group_name" {
  type        = string
  description = "Base name for the Azure resource group"
  default     = "terraform-aca-resources"
}

variable "environment" {
  type        = string
  description = "Lowercase environment name used in Azure resource names"
  default     = "dev"
}

variable "container_image" {
  type        = string
  description = "Container image to run from the existing Azure Container Registry"
  default     = "deepak.azurecr.io/app1/flask-api:4eb3a3a818278da22060514ec8a76369e5d4bf51"
}

variable "container_port" {
  type        = number
  description = "Port the Flask API listens on inside the container"
  default     = 5000

  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535
    error_message = "container_port must be between 1 and 65535."
  }
}
