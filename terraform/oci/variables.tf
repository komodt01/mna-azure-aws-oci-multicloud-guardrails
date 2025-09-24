variable "prefix" {
  description = "Name prefix for OCI resources"
  type        = string
}

variable "region" {
  description = "OCI region (e.g., us-phoenix-1)"
  type        = string
  default     = "us-phoenix-1"
}

variable "tenancy_ocid" {
  description = "Tenancy OCID (needed to read Object Storage namespace)"
  type        = string
}

variable "compartment_ocid" {
  description = "Target compartment OCID for vault, key, and bucket"
  type        = string
}

variable "retention_days" {
  description = "Delete objects after N days (demo value; 30*)"
  type        = number
  default     = 30
}
