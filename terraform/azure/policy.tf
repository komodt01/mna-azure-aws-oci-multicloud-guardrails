# ---------------------------
# Custom Policy Definitions
# ---------------------------

# Deny enabling public blob access on Storage Accounts
resource "azurerm_policy_definition" "deny_public_storage" {
  name         = "${var.prefix}-deny-public-storage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny public blob access on Storage Accounts"
  description  = "Prevents creating/updating storage accounts with public blob access enabled."

  policy_rule = <<POLICY
{
  "if": {
    "allOf": [
      { "field": "type", "equals": "Microsoft.Storage/storageAccounts" },
      { "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess", "equals": true }
    ]
  },
  "then": { "effect": "Deny" }
}
POLICY
}

# Audit Key Vaults without purge protection (visibility without blocking)
resource "azurerm_policy_definition" "audit_kv_no_purge_protection" {
  name         = "${var.prefix}-audit-kv-purge"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Key Vault without purge protection"
  description  = "Flags Key Vaults that do not have purge protection enabled."

  policy_rule = <<POLICY
{
  "if": {
    "allOf": [
      { "field": "type", "equals": "Microsoft.KeyVault/vaults" },
      { "field": "Microsoft.KeyVault/vaults/enablePurgeProtection", "equals": false }
    ]
  },
  "then": { "effect": "Audit" }
}
POLICY
}


# ---------------------------
# Policy Set (Initiative)
# ---------------------------
resource "azurerm_policy_set_definition" "mna_guardrails" {
  name         = "${var.prefix}-guardrails"
  display_name = "MNA Guardrails (custom)"
  policy_type  = "Custom"
  description  = "Basic guardrails: deny public storage; audit Key Vault purge protection."

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_public_storage.id
    reference_id         = "denyPublicStorage"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_kv_no_purge_protection.id
    reference_id         = "auditKvNoPurge"
  }
}

# ---------------------------
# Assignment at RG scope (v4 resource)
# ---------------------------
resource "azurerm_resource_group_policy_assignment" "mna_guardrails_rg" {
  name                 = "${var.prefix}-guardrails-rg"
  display_name         = "MNA Guardrails (RG)"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_set_definition.mna_guardrails.id

  # ensure definitions exist before assignment
  depends_on = [
    azurerm_policy_definition.deny_public_storage,
    azurerm_policy_definition.audit_kv_no_purge_protection,
    azurerm_policy_set_definition.mna_guardrails
  ]
}
