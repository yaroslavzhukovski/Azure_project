resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_configurations
  name                = "${each.value.name}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = each.value.public_ip_required ? azurerm_public_ip.pip[each.key].id : null
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = { for k, v in var.vm_configurations : k => v if v.public_ip_required }
  name                = "${each.value.name}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each            = var.vm_configurations
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group
  size                = "Standard_B1s"
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    name              = "${each.value.name}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
