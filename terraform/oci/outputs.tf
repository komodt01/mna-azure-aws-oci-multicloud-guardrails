output "bucket_name" {
  value = oci_objectstorage_bucket.logs.name
}

output "vault_id" {
  value = oci_kms_vault.vault.id
}

output "cmek_id" {
  value = oci_kms_key.cmek.id
}
