output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}
