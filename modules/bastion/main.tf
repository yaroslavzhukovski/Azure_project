resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.bastion_subnet_prefix]
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "this" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_name = null

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}
