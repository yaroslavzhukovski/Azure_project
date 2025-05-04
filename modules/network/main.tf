# Create a Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create Subnets inside the VNet
resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]

}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each = var.subnet_nsg_map

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value
}
