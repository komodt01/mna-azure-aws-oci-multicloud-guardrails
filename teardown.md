# Teardown Guide

> *Numbers marked with `*` are fictional. Destroy resources in the order shown to avoid dependency errors and extra costs.*

## Azure
```bash
cd terraform/azure
terraform destroy
```
**Notes:** Key Vault has soft-delete/purge-protection features. If you enabled purge protection in custom variants, you may need to wait the retention window before reusing the name.

## AWS
```bash
cd terraform/aws
terraform destroy
```
**Notes:** CloudTrail must be deleted before the KMS key and S3 bucket policies can be removed. The Terraform plan handles ordering, but if you added manual bucket protections, remove them first.

## OCI
```bash
cd terraform/oci
terraform destroy
```
**Notes:** Buckets with retention/lifecycle policies and keys in Vault may have constraints. Terraform removes lifecycle policies first, then the bucket, then keys and vault. If you enabled additional locks or custom policies manually, remove those first.