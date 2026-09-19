# Technologies Used

## Purpose

This document describes the technologies used in the M&A Multi-Cloud Security Guardrails project and distinguishes between capabilities implemented in the repository and potential future-state extensions.

The project uses Terraform to implement selected security baseline controls across Microsoft Azure, AWS, and Oracle Cloud Infrastructure (OCI).

The guiding architecture principle is:

**Standardize the security requirement, not necessarily the cloud implementation.**

---

# Terraform

**What it is:**
Infrastructure as Code (IaC) technology used to define and provision cloud resources declaratively.

**How it is used here:**
Separate Terraform configurations implement selected baseline controls for Azure, AWS, and OCI.

The general deployment workflow is:

```text
terraform init
terraform plan
terraform apply
```

**Architecture value:**

* Repeatability
* Configuration visibility
* Change review
* Reduced manual configuration
* Reproducible security baselines
* Foundation for future automated validation and governance

Terraform does not by itself establish security governance. Policies, standards, review processes, risk decisions, and exception management determine how the organization governs the resulting environment.

---

# Microsoft Azure

## Azure Resource Manager

**What it is:**
Azure's resource-management and control plane.

**How it is used here:**
The Azure Terraform provider creates and manages the Azure resources used by the project.

---

## Azure Log Analytics

**What it is:**
Azure service for collecting and querying operational and security telemetry.

**How it is used here:**
A Log Analytics Workspace provides the centralized Azure logging destination used by the project and supports the implemented Microsoft Sentinel configuration.

---

## Azure Key Vault

**What it is:**
Managed Azure service for protecting cryptographic keys, secrets, and certificates.

**How it is used here:**
The project creates a Key Vault as a protected Azure resource used to demonstrate security configuration, diagnostic logging, and policy evaluation.

---

## Azure Diagnostic Settings

**What they are:**
Configuration used to route supported Azure resource logs and metrics to destinations such as Log Analytics.

**How they are used here:**
Key Vault diagnostic settings send supported audit events and metrics to the Log Analytics Workspace.

This demonstrates the relationship between a protected resource and centralized Azure monitoring.

---

## Azure Policy

**What it is:**
Azure governance capability for evaluating and enforcing resource configuration requirements.

**How it is used here:**
The project implements two Azure Policy guardrails and groups them into an M&A security guardrail initiative assigned at Resource Group scope.

### Preventive Guardrail

Azure Storage Accounts configured with public blob access are denied.

This demonstrates preventive enforcement for a condition the architecture treats as an unacceptable baseline configuration.

### Detective Guardrail

Key Vaults without purge protection enabled are audited.

This demonstrates detective governance for a condition requiring visibility and review rather than immediate deployment prevention.

The two controls demonstrate an important architecture distinction:

**Public blob access → Preventive / Deny**

**Missing Key Vault purge protection → Detective / Audit**

Broader Azure Policy coverage remains a future-state extension.

---

## Microsoft Sentinel

**What it is:**
Microsoft's cloud-native SIEM and security analytics platform.

**How it is used here:**
Terraform enables Microsoft Sentinel on the project's Log Analytics Workspace and creates two scheduled Azure-focused analytic rules.

The implemented rules identify:

* Storage configuration changes requiring review
* Storage account configuration activity requiring encryption review

The rules use AzureActivity as an investigation signal.

They intentionally do not claim that configuration activity independently proves that a resource is publicly exposed or lacks a customer-managed encryption key.

The detection model is:

**Configuration Event → Potential Condition → Investigation → Validated Risk → Remediation or Approved Exception**

Readable KQL versions of the implemented detections are maintained under:

`monitoring/sentinel/detections/`

---

## Current Azure Monitoring Boundary

The implemented Sentinel configuration processes Azure telemetry only.

The repository does not implement:

* AWS telemetry ingestion into Sentinel
* OCI telemetry ingestion into Sentinel
* Cross-cloud telemetry normalization
* Cross-cloud Sentinel analytic rules

Those capabilities would require additional telemetry ingestion, schema mapping, normalization, and detection engineering.

---

## Future Azure Extensions

A broader enterprise implementation could introduce capabilities such as:

* Broader Azure Policy coverage
* Expanded diagnostic enforcement
* Microsoft Defender for Cloud
* Privileged Identity Management
* Additional Sentinel detections
* SOAR integration
* Automated response workflows

These are future-state extensions rather than controls implemented in the current project.

---

# Amazon Web Services

## AWS CloudTrail

**What it is:**
AWS service for recording account and API activity.

**How it is used here:**
The project configures a multi-Region CloudTrail with global service events and log-file validation.

This provides an audit trail supporting:

* Security investigation
* Administrative activity review
* Change analysis
* Evidence collection

---

## Amazon S3

**What it is:**
AWS object-storage service.

**How it is used here:**
An S3 bucket stores CloudTrail logs.

The Terraform configuration includes:

* Public-access blocking
* Versioning
* SSE-KMS encryption
* CloudTrail bucket permissions
* Lifecycle retention

The bucket represents protected audit storage rather than general application storage.

---

## AWS Key Management Service

**What it is:**
Managed AWS service for creating and controlling cryptographic keys.

**How it is used here:**
The project creates a KMS key used by the CloudTrail logging architecture.

The implementation includes:

* KMS key
* Automatic key rotation
* KMS alias

This provides customer-controlled encryption for the audit-log storage architecture.

---

## Future AWS Extensions

A broader enterprise implementation could add:

* AWS Config
* AWS Organizations
* Service Control Policies
* Security Hub
* GuardDuty
* IAM Identity Center
* Centralized SIEM integration
* Additional preventive and detective guardrails

These capabilities are not represented as implemented controls in the current project.

---

# Oracle Cloud Infrastructure

## OCI Vault

**What it is:**
OCI service for managing encryption keys and cryptographic operations.

**How it is used here:**
Terraform creates an OCI Vault and an AES-256 customer-managed encryption key.

The key uses:

`protection_mode = "SOFTWARE"`

The project therefore demonstrates a customer-managed key but does not claim that the key is HSM-protected.

---

## OCI Object Storage

**What it is:**
OCI object-storage service.

**How it is used here:**
The project creates an Object Storage bucket configured to use the OCI customer-managed key for encryption.

The implementation includes:

* Customer-managed-key encryption
* Object versioning
* Lifecycle-based retention

The default lifecycle configuration deletes objects after 30 days.

---

## OCI IAM Policies

**What they are:**
OCI policies defining permissions for identities and cloud services.

**How they are used here:**
The project creates policies allowing the regional Object Storage service to:

* Use KMS keys in the governed compartment
* Manage the object family required for lifecycle operations

A short Terraform-managed wait is included after policy creation to allow IAM policy propagation before dependent Object Storage configuration proceeds.

---

## OCI Audit and Logging

OCI provides native audit capabilities for tenancy activity.

The current project does not implement OCI telemetry ingestion into Microsoft Sentinel.

A future architecture could use OCI logging and integration capabilities to route selected security telemetry into an enterprise monitoring platform.

---

## Future OCI Extensions

Potential extensions include:

* OCI Cloud Guard
* Security Zones
* Expanded IAM governance
* Service Connector Hub
* Centralized security telemetry
* Additional configuration monitoring

---

# Why These Technologies Were Selected

## Infrastructure as Code

Terraform allows selected cloud controls to be represented consistently while still using each provider's native services.

The common element is the security requirement rather than identical implementation syntax or cloud services.

---

## Auditability

AWS CloudTrail and Azure diagnostic logging demonstrate implemented approaches for capturing security-relevant activity.

OCI provides native audit capabilities, although OCI-to-Sentinel ingestion is outside the implemented scope of this project.

---

## Data Protection

Azure Key Vault, AWS KMS, and OCI Vault represent cloud-native key-management capabilities.

AWS and OCI Terraform demonstrate customer-controlled encryption within their respective storage architectures.

The exact implementation differs among platforms.

The architecture principle remains:

**Standardize the security requirement, not necessarily the cloud implementation.**

---

## Preventive and Detective Governance

Azure Policy demonstrates that guardrails should be selected according to risk rather than applying the same enforcement action to every condition.

The project demonstrates:

**Prevent when the condition is unacceptable and sufficiently understood.**

**Detect when investigation or business context is required before enforcement.**

---

## Monitoring and Investigation

Log Analytics and Microsoft Sentinel provide the implemented Azure monitoring capability.

The scheduled analytic rules demonstrate investigation-oriented detection rather than treating telemetry as definitive proof of an insecure state.

This supports the broader security process:

**Signal → Investigation → Validation → Decision → Remediation or Exception**

---

# Implemented vs. Future-State Capabilities

## Implemented

The repository implements selected examples of:

* Terraform-based cloud provisioning
* Azure Resource Group
* Azure Log Analytics Workspace
* Azure Key Vault
* Key Vault diagnostic settings
* Azure Policy guardrails
* Azure Policy initiative and Resource Group assignment
* Microsoft Sentinel onboarding
* Two Azure-focused scheduled Sentinel analytic rules
* AWS CloudTrail
* Multi-Region AWS audit logging
* CloudTrail log-file validation
* AWS KMS
* Protected S3 audit-log storage
* S3 public-access blocking
* S3 versioning
* S3 SSE-KMS
* AWS log lifecycle retention
* OCI Vault
* OCI AES-256 customer-managed key
* OCI Object Storage encryption using the customer-managed key
* OCI Object Storage versioning
* OCI lifecycle configuration
* OCI IAM policies supporting KMS and lifecycle operations

## Future-State / Not Implemented

Potential future-state architecture includes:

* Enterprise identity federation
* AWS federation with Microsoft Entra ID
* OCI federation with Microsoft Entra ID
* Broader Azure Policy coverage
* AWS Config and organizational guardrails
* OCI Cloud Guard
* AWS telemetry ingestion into Sentinel
* OCI telemetry ingestion into Sentinel
* Cross-cloud telemetry normalization
* Cross-cloud Sentinel detections
* Policy-as-Code
* CI/CD security validation
* Automated remediation
* SOAR workflows
* Security exception workflows
* Continuous control monitoring

Keeping these categories separate prevents a reference architecture or proposed target state from being mistaken for a fully implemented production environment.

---

# Architecture Takeaway

The purpose of the technology selection is not to force three cloud platforms into an identical technical design.

Each cloud retains its native capabilities while supporting common enterprise security objectives around:

**Visibility → Protection → Guardrails → Investigation → Governance → Evidence**

The architecture determines the required security outcome.

The cloud platform determines the appropriate technical implementation.

**Standardize the security requirement, not necessarily the cloud implementation.**
