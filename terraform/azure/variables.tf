variable "subscription_id" {
  description = "Azure subscription ID to deploy into"
  type        = string
}

variable "prefix" {
  description = "Name prefix for Azure resources"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "retention_days" {
  description = "Log Analytics data retention in days (fictional demo like 30*)"
  type        = number
  default     = 30
}

variable "kv_sku_name" {
  description = "Key Vault SKU (standard or premium)"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Common tags to apply"
  type        = map(string)
  default     = {}
}
