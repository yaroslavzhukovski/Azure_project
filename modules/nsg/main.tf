locals {
  security_rules = {
    for item in flatten([
      for nsg_name, nsg in var.nsg_definitions : [
        for rule in nsg.rules : {
          key      = "${nsg_name}-${rule.name}"
          nsg_name = nsg_name
          rule     = rule
        }
      ]
    ]) : item.key => item
  }
}


resource "azurerm_network_security_group" "this" {
  for_each            = var.nsg_definitions
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "rules" {
  for_each = local.security_rules

  name                        = each.value.rule.name
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[each.value.nsg_name].name

  depends_on = [azurerm_network_security_group.this]
}
