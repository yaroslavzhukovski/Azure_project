resource "azurerm_key_vault" "this" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.admin_object_id

    key_permissions    = ["Get", "List", "Create", "Delete"]
    secret_permissions = ["Get", "List", "Set", "Delete"]
  }
}

data "azurerm_client_config" "current" {}
