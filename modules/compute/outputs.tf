output "vm_private_ips" {
  description = "Map of VM names to their private IP addresses"
  value = {
    for k, nic in azurerm_network_interface.nic : k => nic.private_ip_address
  }
}

output "vm_ids" {
  description = "Map of VM names to their resource IDs"
  value = {
    for name, vm in azurerm_windows_virtual_machine.vm :
    name => vm.id
  }
}
