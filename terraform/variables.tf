variable "location" {
  description = "Azure region to deploy resource"
  type        = string
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "RG-functionapps"
}

variable "vnet_address_space" {
  description = "The address space that is used by the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "a name of subnet inside the vNet."
  type        = string
  default     = "subnet1"
}

variable "subnet_address_prefix" {
  description = "the address prefix use for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "key_vault_secret_value" {
  description = "secret value"
  type        = string
  sensitive   = true
}

variable "key_vault_name" {
  description = "az key vault name"
  type        = string
  default     = "kvazproject01"
}

variable "key_vault_soft_delete_retention_days" {
  description = "number of retention days for soft deletion for key vault"
  type        = number
  default     = 7
}

variable "azurerm_service_plan_sku_name" {
    description = "service plan sku name"
    type = string
    default = "Y1"
}

variable "storage_account_replication_type" {
    description = "type of replication for storage"
    type = string
    default = "LRS"
}