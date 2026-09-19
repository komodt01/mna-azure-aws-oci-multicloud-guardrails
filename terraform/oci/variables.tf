variable "prefix" {
  description = "Name prefix for OCI resources"
  type        = string
}

variable "region" {
  description = "OCI region for deployed resources"
  type        = string
  default     = "us-phoenix-1"
}

variable "tenancy_ocid" {
  description = "OCI tenancy OCID used to retrieve the Object Storage namespace"
  type        = string
}

variable "compartment_ocid" {
  description = "Target compartment OCID for the Vault, key, and Object Storage resources"
  type        = string
}

variable "retention_days" {
  description = "Number of days objects are retained before lifecycle deletion"
  type        = number
  default     = 30
}
