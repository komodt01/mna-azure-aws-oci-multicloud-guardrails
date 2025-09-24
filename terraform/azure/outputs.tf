output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "log_analytics_workspace_id" { value = azurerm_log_analytics_workspace.law.id }
output "key_vault_uri" { value = azurerm_key_vault.kv.vault_uri }
