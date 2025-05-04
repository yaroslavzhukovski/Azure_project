output "nsg_ids" {
  description = "Map of NSG names to their IDs"
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}
