# Enable Sentinel on the existing Log Analytics workspace
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law.id
}

# Rule 1: Public storage changes (AzureActivity)
resource "azurerm_sentinel_alert_rule_scheduled" "public_storage" {
  name                       = "${var.prefix}-public-storage"
  display_name               = "Public storage change (AzureActivity)"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  severity                   = "Medium"
  enabled                    = true
  query_frequency            = "PT1H"
  query_period               = "PT1H"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0

  query = <<KQL
AzureActivity
| where OperationNameValue has_any ("SetBlobServiceProperties", "SetFileServiceProperties", "SetPublicNetworkAccess")
| where ActivityStatusValue == "Success"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, Resource, SubscriptionId
KQL

  depends_on = [azurerm_sentinel_log_analytics_workspace_onboarding.sentinel]
}

# Rule 2: Resource created without CMK hints (AzureActivity heuristic)
resource "azurerm_sentinel_alert_rule_scheduled" "no_cmek" {
  name                       = "${var.prefix}-no-cmek"
  display_name               = "Resource created without CMK hint (AzureActivity)"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  severity                   = "Medium"
  enabled                    = true
  query_frequency            = "PT1H"
  query_period               = "PT1H"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0

  query = <<KQL
AzureActivity
| where OperationNameValue has_any ("Microsoft.Storage/storageAccounts/write", "Microsoft.DBfor")
| where ActivityStatusValue == "Success"
| where Properties !has "encryption" or Properties !has "keyVaultProperties"
| project TimeGenerated, Caller, OperationNameValue, ResourceGroup, Resource, SubscriptionId
KQL

  depends_on = [azurerm_sentinel_log_analytics_workspace_onboarding.sentinel]
}
