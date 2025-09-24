# mna-azure-aws-oci-multicloud-guardrails

*All numeric values in this project are marked with an asterisk (e.g., `30*` days) to indicate they are fictional for demonstration purposes.*

*Azure-anchored multi-cloud M&A security blueprint with Terraform guardrails for AWS & OCI, CMEK-by-default, centralized logging, and Sentinel detections (fictional numbers noted).*

Design and prove a secure, **Azure-anchored** landing zone with **multi-cloud guardrails** for **AWS and OCI** suitable for onboarding an acquired company. 
The repo contains **Terraform** for baseline controls, plus docs you can hand to stakeholders.

## What you get
- **Azure baseline**: Resource Group, Log Analytics Workspace, Key Vault, **diagnostic settings to central logging**.
- **AWS baseline**: KMS key, S3 bucket for CloudTrail, **multi-region CloudTrail** with log file validation.
- **OCI baseline**: KMS **Vault & Key** (CMEK), Object Storage bucket with default encryption, **lifecycle rule** for demo retention.
- **Docs**: `README.md`, `technologies.md` (what & how), `teardown.md` (clean removal), `business-use-cases.md`, sample detections for Sentinel.
- **Asterisk note**: Any numbers tagged with `*` (like `30*` days) are **fictional** and chosen purely for the demo.

## Structure
```text
mna-azure-aws-oci-multicloud-guardrails/
├─ README.md
├─ technologies.md
├─ teardown.md
├─ business-use-cases.md
├─ .gitignore
├─ terraform/
│  ├─ azure/
│  │  ├─ providers.tf
│  │  ├─ variables.tf
│  │  ├─ main.tf
│  │  └─ outputs.tf
│  ├─ aws/
│  │  ├─ providers.tf
│  │  ├─ variables.tf
│  │  ├─ main.tf
│  │  └─ outputs.tf
│  └─ oci/
│     ├─ providers.tf
│     ├─ variables.tf
│     ├─ main.tf
│     └─ outputs.tf
└─ monitoring/
   └─ sentinel/
      └─ detections/
         ├─ public_storage.kql
         └─ no_cmek.kql
```

---

## Prerequisites
- **Terraform** ≥ 1.6
- **Azure**: `az login` authorized to create resource groups, workspaces, and Key Vaults
- **AWS**: `aws configure` with a role/user allowed to create KMS, S3, and CloudTrail
- **OCI**: OCI CLI (`oci setup config`) or environment vars and a user with permissions in the target **compartment**

> ⚠️ Costs: resources may incur small charges. Keep retention and regions minimal. See `teardown.md` to remove all resources when done.

---

## Quickstart

### 1) Azure baseline
1. Create `terraform/azure/terraform.tfvars`:
   ```hcl
   prefix         = "mna"
   location       = "eastus"
   retention_days = 30  # 30*
   tags = {
     Project     = "MNA-Demo"
     Environment = "dev"
   }
   ```
2. Deploy:
   ```bash
   cd terraform/azure
   terraform init
   terraform plan
   terraform apply
   ```
3. Verify in Azure Portal:
   - Resource Group, Log Analytics Workspace, Key Vault exist
   - Key Vault has **diagnostic settings** sending logs to the workspace

### 2) AWS baseline
1. Create `terraform/aws/terraform.tfvars`:
   ```hcl
   prefix = "mna"
   region = "us-east-1"
   ```
2. Deploy:
   ```bash
   cd terraform/aws
   terraform init
   terraform plan
   terraform apply
   ```
3. Verify:
   - S3 bucket for CloudTrail logs
   - KMS key for CloudTrail encryption
   - CloudTrail enabled for **multi-region** with log file validation

### 3) OCI baseline
1. Create `terraform/oci/terraform.tfvars`:
   ```hcl
   prefix           = "mna"
   region           = "us-phoenix-1"
   compartment_ocid = "ocid1.compartment.oc1..xxxx"
   retention_days   = 30  # 30*
   ```
2. Deploy:
   ```bash
   cd terraform/oci
   terraform init
   terraform plan
   terraform apply
   ```
3. Verify in OCI Console:
   - **Vault** and **Key** created (CMEK)
   - **Object Storage** bucket exists and shows encryption with your KMS key
   - **Lifecycle** rule present for demo retention

---

## Monitoring quickstart (optional)
- Import the KQL files in `monitoring/sentinel/detections/` into **Microsoft Sentinel** analytic rules (or use them manually in Logs).
- Examples:
  - `public_storage.kql` – flags public storage exposure patterns
  - `no_cmek.kql` – flags resources missing Customer-Managed Keys

---

## Business Use Cases (overview)
This project is appropriate for several real-world scenarios. Highlights:
- **M&A cloud onboarding** — bring an acquired AWS/OCI footprint under Azure-anchored guardrails quickly.
- **Regulatory uplift** — demonstrate baseline controls for PCI/ISO 27001/CSA CCM with evidence.
- **Data protection modernization** — enforce CMEK-by-default and detect public storage across clouds.
- **Post-incident hardening** — centralize logs and add detections/playbooks to close gaps.
- **Regional expansion & data residency** — stand up compliant guardrails in new regions.
- **Third-party/vendor integration** — apply least privilege, private connectivity, and logging standards.

👉 See **[business-use-cases.md](./business-use-cases.md)** for detailed narratives, KPIs, and stakeholder mapping.

---

## Next steps you can add
- Azure Policy & OCI Cloud Guard baselines; AWS Config rules + conformance packs
- Federation patterns and CI checks (OPA/Conftest) to enforce guardrails pre-deploy
- Sentinel Workbook & Playbooks (SOAR) for auto-remediation

---

## Teardown
See [`teardown.md`](./teardown.md) for safe destroy steps per cloud.