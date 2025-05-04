resource "azurerm_log_analytics_workspace" "this" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "vms" {
  for_each = var.vm_ids

  name                       = "diag-${each.key}"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id


  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

