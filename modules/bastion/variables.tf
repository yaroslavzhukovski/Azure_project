variable "resource_group_name" {
  description = "Resource group for Bastion"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  type = string
}
variable "vnet_resource_group_name" {
  type = string
}


variable "bastion_subnet_prefix" {
  description = "CIDR block for AzureBastionSubnet"
  type        = string
}

variable "public_ip_name" {
  description = "Name for the public IP used by Bastion"
  type        = string
}

variable "bastion_name" {
  description = "Name for the Bastion resource"
  type        = string
}
