# Technologies Used (What it is & How it works)

> *Asterisk reminder:* any numbers shown like `30*` (days, versions, retentions) are **fictional** for this portfolio project.

## Terraform
**What:** IaC tool to declaratively create cloud resources.  
**How:** You define `.tf` files and run `terraform init/plan/apply`. Providers (azurerm, aws, oci) translate config into API calls.

## Azure Resource Manager (azurerm) + Azure Policy + Key Vault + Log Analytics
**What:** Azure’s control plane (ARM) with Terraform provider; Policy enforces guardrails; Key Vault stores secrets/keys; Log Analytics centralizes logs.  
**How:** Terraform calls the ARM API to create a Resource Group, Log Analytics Workspace, and a Key Vault. Diagnostic settings push Key Vault audit logs to the workspace for monitoring and detection.

## AWS CloudTrail + KMS + S3
**What:** CloudTrail records API activity; KMS manages encryption keys; S3 stores CloudTrail logs.  
**How:** Terraform creates a KMS key and an S3 bucket. CloudTrail is configured to write **multi-region** logs into the bucket with log file validation enabled to detect tampering.

## Oracle Cloud Infrastructure (OCI) – Vault/KMS + Object Storage + Logging (note)
**What:** OCI Vault (KMS) manages keys; Object Storage stores data; Audit/Logging provide activity trails.  
**How:** Terraform creates a **Vault** and **Key**, then an Object Storage bucket with **default KMS encryption**. A lifecycle policy removes objects after a fictional retention period. (Audit logs are enabled by default in OCI; streaming those logs to a bucket or Logging Analytics can be added later via Service Connector Hub.)

## Microsoft Sentinel (optional)
**What:** Azure-native SIEM/SOAR.  
**How:** You can connect Azure logs natively; AWS/OCI logs can be exported/ingested to the workspace. The provided KQL samples demonstrate detections for public storage and missing CMEK.

---

## Why these choices
- **Data-centric controls:** default encryption with customer-managed keys (CMEK/KMS/Key Vault) across clouds.
- **Auditability:** CloudTrail/OCI Audit + Azure diagnostic settings → centralized analytics.
- **Guardrails-first:** baselines are intentionally minimal yet enforceable; expand with Policies/SCPs/Cloud Guard as needed.

## Operations summary
- **Day 0/1:** Deploy baselines with Terraform.
- **Day 2+:** Add policies to deny/auto-remediate non-compliant resources, onboard more services, wire detections to alerts.