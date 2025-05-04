
variable "project_name" {
  description = "Project name"
  default     = "medilync"
}

variable "resource_group_names" {
  description = "Resource group list"
  type        = list(string)
  default     = ["Medilync-ProdRG", "Medilync-DevRG", "Medilync-InfraRG"]
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "admin_username" {
  description = "Administrator username for all virtual machines"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for all virtual machines"
  type        = string
  sensitive   = true
}

variable "admin_object_id" {
  description = "Azure AD object ID of the main administrator (used for Key Vault access)"
  type        = string
}

