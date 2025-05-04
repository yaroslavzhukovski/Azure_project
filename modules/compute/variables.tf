variable "vm_configurations" {
  description = "Map of VMs with their configuration"
  type = map(object({
    name               = string
    resource_group     = string
    location           = string
    subnet_id          = string
    public_ip_required = bool
    admin_username     = string
    admin_password     = string
  }))
}
