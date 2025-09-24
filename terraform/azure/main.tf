data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg-security"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}

resource "azurerm_key_vault" "kv" {
  name                          = "${var.prefix}kv${substr(replace(azurerm_resource_group.rg.location, "-", ""), 0, 6)}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.kv_sku_name
  purge_protection_enabled      = false
  soft_delete_retention_days    = 7
  public_network_access_enabled = true
  tags                          = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "kv_to_law" {
  name                       = "${var.prefix}-kv-diag"
  target_resource_id         = azurerm_key_vault.kv.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # Logs
  enabled_log {
    category = "AuditEvent"
  }

  # Metrics (new style; replaces deprecated `metric { ... }`)
  enabled_metric {
    category = "AllMetrics"
  }
}
