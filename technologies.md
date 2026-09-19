# Technologies Used

## Purpose

This document describes the technologies used in the M&A Multi-Cloud Security Guardrails project and distinguishes between capabilities demonstrated in the repository and potential future-state extensions.

The project uses Terraform to demonstrate selected security baseline controls across Microsoft Azure, AWS, and Oracle Cloud Infrastructure (OCI).

---

## Terraform

**What it is:**
Infrastructure as Code (IaC) technology used to define and provision cloud resources declaratively.

**How it is used here:**
Separate Terraform configurations demonstrate selected baseline controls for Azure, AWS, and OCI.

The general deployment workflow is:

```text
terraform init
terraform plan
terraform apply
```

Terraform provides a repeatable way to represent infrastructure and security configuration as code that can be reviewed before deployment.

**Architecture value:**

* Repeatability
* Configuration visibility
* Change review
* Reduced manual configuration
* Foundation for future automated validation and governance

Terraform does not by itself establish security governance. The policies, standards, review processes, and exception model surrounding the code determine how the organization governs the environment.

---

## Microsoft Azure

### Azure Resource Manager

**What it is:**
Azure's resource management and control plane.

**How it is used here:**
The Azure Terraform provider creates the resources used in the demonstration.

### Azure Log Analytics

**What it is:**
Azure service for collecting and querying operational and security telemetry.

**How it is used here:**
A Log Analytics Workspace provides the centralized Azure logging destination used by the demonstration.

### Azure Key Vault

**What it is:**
Managed Azure service for protecting cryptographic keys, secrets, and certificates.

**How it is used here:**
The project creates a Key Vault and configures diagnostic settings so supported Key Vault activity can be sent to Log Analytics.

### Azure Diagnostic Settings

**What they are:**
Configuration used to route supported Azure resource logs and metrics to destinations such as Log Analytics.

**How they are used here:**
Diagnostic settings demonstrate the connection between a protected resource and centralized monitoring.

### Future Azure Extensions

A broader enterprise implementation could introduce capabilities such as:

* Azure Policy
* Expanded diagnostic enforcement
* Microsoft Defender for Cloud
* Privileged Identity Management
* Additional Sentinel integrations

These are architecture extensions and should not be interpreted as controls implemented by this repository.

---

## Amazon Web Services

### AWS CloudTrail

**What it is:**
AWS service for recording account and API activity.

**How it is used here:**
The project configures a multi-Region CloudTrail with log file validation.

This provides an audit trail that can support:

* Security investigation
* Administrative activity review
* Change analysis
* Evidence collection

### Amazon S3

**What it is:**
AWS object-storage service.

**How it is used here:**
An S3 bucket stores CloudTrail logs.

The bucket represents protected audit storage rather than general application storage.

### AWS Key Management Service

**What it is:**
Managed service for creating and controlling cryptographic keys.

**How it is used here:**
AWS KMS provides the encryption key used with the CloudTrail logging architecture.

### Future AWS Extensions

A broader enterprise implementation could add:

* AWS Config
* AWS Organizations
* Service Control Policies
* Security Hub
* GuardDuty
* IAM Identity Center
* Centralized SIEM integration

These capabilities are not represented as implemented controls in the current demonstration.

---

## Oracle Cloud Infrastructure

### OCI Vault

**What it is:**
OCI service for managing encryption keys and related cryptographic operations.

**How it is used here:**
Terraform creates an OCI Vault and customer-managed key.

### OCI Object Storage

**What it is:**
OCI object-storage service.

**How it is used here:**
The demonstration creates an Object Storage bucket configured to use the OCI Vault key for encryption.

A lifecycle configuration is also included for demonstration retention.

### OCI Audit and Logging

OCI provides native audit capabilities for activity within the tenancy.

The current project does not implement a complete OCI-to-Sentinel centralized logging pipeline.

A future architecture could use OCI logging and integration capabilities to route selected security telemetry into an enterprise monitoring platform.

### Future OCI Extensions

Potential extensions include:

* OCI Cloud Guard
* Security Zones
* Expanded IAM governance
* Service Connector Hub
* Centralized security telemetry
* Additional configuration monitoring

---

## Microsoft Sentinel

**What it is:**
Microsoft's cloud-native SIEM and security analytics platform.

**How it is represented here:**
The repository contains example KQL detection concepts for conditions such as:

* Public storage exposure
* Resources that may not meet expected encryption requirements

These examples demonstrate detection logic.

They do not represent a complete production Sentinel deployment or a fully implemented multi-cloud ingestion architecture.

A broader design could follow:

**Cloud Telemetry → Central Collection → Detection → Investigation → Response**

---

# Why These Technologies Were Selected

## Infrastructure as Code

Terraform allows selected cloud controls to be represented consistently while still using each provider's native services.

## Auditability

CloudTrail and Azure diagnostic logging demonstrate how security-relevant activity can be captured for investigation and evidence.

OCI's native audit capabilities provide a similar security objective, although centralized ingestion is outside the implemented scope of this project.

## Data Protection

Azure Key Vault, AWS KMS, and OCI Vault demonstrate cloud-native approaches to cryptographic key management.

The exact implementation differs among the platforms.

The architecture principle is therefore:

**Standardize the security requirement, not necessarily the cloud implementation.**

## Monitoring

Log Analytics and the Sentinel detection examples demonstrate how cloud telemetry can contribute to centralized security visibility.

---

# Implemented vs. Future-State Capabilities

The implemented demonstration includes selected examples of:

* Terraform-based cloud provisioning
* Azure centralized logging
* Azure Key Vault diagnostic settings
* AWS CloudTrail
* AWS KMS
* Protected AWS audit-log storage
* OCI Vault
* OCI customer-managed-key storage encryption
* Storage lifecycle configuration
* Example KQL detection logic

Potential future-state architecture includes capabilities such as:

* Enterprise identity federation
* Azure Policy
* AWS Config and organizational guardrails
* OCI Cloud Guard
* Policy-as-Code
* CI/CD security validation
* Broader multi-cloud SIEM integration
* Automated remediation
* Security exception workflows
* Continuous control monitoring

Keeping these categories separate prevents a reference architecture from being mistaken for a fully implemented production environment.

---

# Architecture Takeaway

The purpose of the technology selection is not to force three cloud platforms into an identical technical design.

Each cloud retains its native capabilities while supporting common enterprise security objectives around:

**Visibility → Protection → Governance → Evidence**

The architecture determines the required security outcome.

The cloud platform determines the appropriate technical implementation.
