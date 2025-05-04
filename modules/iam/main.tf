resource "azuread_group" "groups" {
  for_each         = toset(var.group_names)
  display_name     = each.value
  security_enabled = true
}

locals {
  flattened_role_assignments = {
    for item in flatten([
      for group_name, roles in var.role_assignments : [
        for idx, role in roles : {
          key        = "${group_name}-${idx}"
          group_name = group_name
          role       = role
        }
      ]
    ]) : item.key => item
  }
}


resource "azurerm_role_assignment" "assignments" {
  for_each = local.flattened_role_assignments

  principal_id         = azuread_group.groups[each.value.group_name].object_id
  role_definition_name = each.value.role.role_name
  scope                = each.value.role.scope
}
