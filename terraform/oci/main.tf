# ----------------------------------------
# Object Storage Namespace
# ----------------------------------------

data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.tenancy_ocid
}

# ----------------------------------------
# OCI Vault and Customer-Managed Key
# ----------------------------------------

resource "oci_kms_vault" "vault" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.prefix}-vault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "cmek" {
  compartment_id      = var.compartment_ocid
  management_endpoint = oci_kms_vault.vault.management_endpoint
  display_name        = "${var.prefix}-cmek"
  protection_mode     = "SOFTWARE"

  key_shape {
    algorithm = "AES"
    length    = 32 # 256-bit
  }
}

# ----------------------------------------
# Object Storage Bucket
# ----------------------------------------

resource "oci_objectstorage_bucket" "logs" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "${var.prefix}-logs"
  storage_tier   = "Standard"
  versioning     = "Enabled"
  kms_key_id     = oci_kms_key.cmek.id

  depends_on = [time_sleep.wait_policy]
}

# ----------------------------------------
# Object Lifecycle Policy
# ----------------------------------------

resource "oci_objectstorage_object_lifecycle_policy" "logs_policy" {
  namespace = data.oci_objectstorage_namespace.ns.namespace
  bucket    = oci_objectstorage_bucket.logs.name

  rules {
    name        = "delete-old-objects"
    action      = "DELETE"
    is_enabled  = true
    time_amount = var.retention_days
    time_unit   = "DAYS"
    target      = "objects"
  }

  depends_on = [time_sleep.wait_policy]
}
