variable "resource_group_name" {
  description = "Nome do resource group"
  type        = string
  default     = "student-rg"
}

variable "location" {
  description = "Localização dos recursos"
  type        = string
  default     = "central US"
}

variable "vm_admin_username" {
  description = "Nome de usuário da VM"
  type        = string
  default     = "azureuser"
}