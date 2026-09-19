# ----------------------------------------
# Object Storage IAM Policies
# ----------------------------------------

# Allow the regional Object Storage service to use KMS keys
# in the governed compartment.
resource "oci_identity_policy" "os_use_kms" {
  compartment_id = var.tenancy_ocid
  name           = "${var.prefix}-os-use-kms-${replace(var.region, "-", "")}"
  description    = "Allow Object Storage to use KMS keys in the governed compartment"

  statements = [
    "Allow service objectstorage-${var.region} to use keys in compartment id ${var.compartment_ocid}"
  ]
}

# Allow the Object Storage lifecycle service to manage objects
# required by the configured lifecycle policy.
resource "oci_identity_policy" "os_manage_object_family" {
  compartment_id = var.tenancy_ocid
  name           = "${var.prefix}-os-manage-objectfamily-${replace(var.region, "-", "")}"
  description    = "Allow Object Storage to manage object-family for lifecycle operations"

  statements = [
    "Allow service objectstorage-${var.region} to manage object-family in compartment id ${var.compartment_ocid}"
  ]
}

# Allow time for OCI IAM policy propagation before dependent
# Object Storage resources are configured.
resource "time_sleep" "wait_policy" {
  depends_on = [
    oci_identity_policy.os_use_kms,
    oci_identity_policy.os_manage_object_family
  ]

  create_duration = "45s"
}
