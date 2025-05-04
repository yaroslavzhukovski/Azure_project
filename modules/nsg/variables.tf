variable "resource_group_name" {
  description = "Resource group where the NSGs will be deployed"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "nsg_definitions" {
  description = "Map of NSGs and their rules"
  type = map(object({
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}
