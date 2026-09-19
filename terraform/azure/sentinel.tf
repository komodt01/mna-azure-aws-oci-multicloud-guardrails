# ----------------------------------------
# Microsoft Sentinel
# ----------------------------------------

# Enable Microsoft Sentinel on the existing Log Analytics workspace.
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law.id
}

# ----------------------------------------
# Detection 1: Storage configuration activity
# ----------------------------------------
#
# Identifies successful Azure Storage configuration changes that may
# affect public exposure. The event itself does not prove that a
# storage resource is publicly accessible; it creates an investigation
# signal for security review.
resource "azurerm_sentinel_alert_rule_scheduled" "public_storage" {
  name                       = "${var.prefix}-storage-config-change"
  display_name               = "Storage configuration change requiring review"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  severity                   = "Medium"
  enabled                    = true
  query_frequency            = "PT1H"
  query_period               = "PT1H"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0

  query = <<KQL
AzureActivity
| where ActivityStatusValue == "Success"
| where OperationNameValue has_any (
    "Microsoft.Storage/storageAccounts",
    "SetBlobServiceProperties",
    "SetFileServiceProperties",
    "SetPublicNetworkAccess"
)
| project
    TimeGenerated,
    Caller,
    OperationNameValue,
    ResourceGroup,
    Resource,
    SubscriptionId
KQL

  depends_on = [
    azurerm_sentinel_log_analytics_workspace_onboarding.sentinel
  ]
}

# ----------------------------------------
# Detection 2: Encryption-related storage activity
# ----------------------------------------
#
# Identifies successful Azure Storage account configuration activity
# that requires validation against the organization's encryption and
# key-management requirements.
#
# AzureActivity is used as an investigation signal. The event itself
# does not prove that the storage account lacks a customer-managed key.
resource "azurerm_sentinel_alert_rule_scheduled" "no_cmek" {
  name                       = "${var.prefix}-encryption-review"
  display_name               = "Storage configuration requiring encryption review"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  severity                   = "Medium"
  enabled                    = true
  query_frequency            = "PT1H"
  query_period               = "PT1H"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0

  query = <<KQL
AzureActivity
| where ActivityStatusValue == "Success"
| where OperationNameValue == "Microsoft.Storage/storageAccounts/write"
| project
    TimeGenerated,
    Caller,
    OperationNameValue,
    ResourceGroup,
    Resource,
    SubscriptionId
KQL

  depends_on = [
    azurerm_sentinel_log_analytics_workspace_onboarding.sentinel
  ]
}
