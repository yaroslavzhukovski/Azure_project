variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Key Vault will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_object_id" {
  description = "Azure AD object ID of the admin group or user"
  type        = string
}
