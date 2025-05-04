variable "resource_group_name" {
  description = "Resource group for Log Analytics"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "vm_ids" {
  description = "List of VM IDs to connect to the workspace"
  type        = map(string)
}
