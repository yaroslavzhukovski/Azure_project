variable "group_names" {
  description = "List of Entra ID group names to create"
  type        = list(string)
}

variable "role_assignments" {
  description = "Map of group name to list of role assignments"
  type = map(list(object({
    scope        = string
    role_name    = string
  })))
}
