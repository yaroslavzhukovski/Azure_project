variable "resource_group_name" {
  description = "Name of the Resource Group to deploy the network"
  type        = string
}

variable "location" {
  description = "Azure Region for the network resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets to create inside the VNet"
  type = map(object({
    address_prefix = string
  }))
}

variable "subnet_nsg_map" {
  description = "Optional map of subnet names to NSG IDs"
  type        = map(string)
  default     = {}
}
