# Technical Case Study — M&A Multi-Cloud Security Guardrails

## Overview

This project demonstrates how an enterprise can establish an initial security architecture when an acquisition introduces cloud environments that were designed and operated independently.

The scenario assumes an acquiring organization that is primarily Azure-centered while the acquired organization introduces AWS and Oracle Cloud Infrastructure (OCI) environments.

The objective is not to immediately consolidate every workload into a single cloud.

Instead, the architecture establishes common enterprise security requirements while allowing Azure, AWS, and OCI to use appropriate cloud-native controls.

The governing principle is:

**Standardize the security requirement, not necessarily the cloud implementation.**

The architecture follows:

**Discover → Assess → Establish Visibility → Protect Critical Assets → Apply Minimum Guardrails → Identify Exceptions → Determine Target State**

The implemented demonstration includes selected controls for:

* Infrastructure as Code
* Azure logging and monitoring
* Azure Policy guardrails
* Microsoft Sentinel
* AWS audit logging
* Encryption and key management
* Protected storage
* Storage lifecycle management
* Investigation-oriented detection

Enterprise identity federation, AWS and OCI telemetry ingestion into Sentinel, broader cloud governance, automated remediation, and continuous compliance remain future-state capabilities.

---

# 1. Architecture Problem

Mergers and acquisitions can introduce cloud environments with different:

* Identity systems
* Administrative models
* Logging configurations
* Encryption standards
* Key-management practices
* Monitoring platforms
* Resource structures
* Network architectures
* Security tooling
* Operational ownership
* Configuration standards

Immediately migrating or redesigning every inherited workload can create significant operational and business risk.

Leaving acquired environments outside enterprise security governance indefinitely creates a different set of risks.

The architecture therefore addresses:

**How can an enterprise establish minimum security expectations and visibility across newly acquired cloud environments without requiring immediate platform standardization?**

---

# 2. Architecture Objective

The objective is to establish an initial security baseline that supports:

**Discover → Assess → Establish Visibility → Protect Critical Assets → Apply Minimum Guardrails → Identify Exceptions → Determine Target State**

The architecture distinguishes between two stages.

## Immediate Security Stabilization

Controls that reduce near-term risk, establish visibility, and protect important resources.

## Target-State Integration

Capabilities requiring additional planning, organizational integration, application analysis, and operational maturity.

This distinction matters during M&A because the strongest theoretical long-term control may not be the safest control to impose immediately on an inherited production environment.

---

# 3. Architecture Principles

## Standardize Security Outcomes, Not Cloud Implementations

AWS, Azure, and OCI provide different security services and operating models.

The architecture establishes common objectives such as:

* Record important administrative activity
* Protect sensitive information
* Control cryptographic keys
* Protect security evidence
* Identify important configuration activity
* Apply minimum configuration guardrails
* Govern deviations from enterprise requirements

Each cloud can satisfy those objectives through its native capabilities.

---

## Establish Visibility Early

Security teams cannot effectively govern inherited environments they cannot observe.

Logging and monitoring therefore become early architecture priorities.

Visibility also supports better decisions about which controls can safely move from detection to enforcement.

---

## Protect Critical Assets Before Broad Standardization

Sensitive data, administrative access, cryptographic keys, security telemetry, and audit evidence should receive priority over lower-risk configuration differences.

The architecture therefore focuses initial controls on material security outcomes rather than attempting to normalize every cloud configuration immediately.

---

## Match Enforcement to Risk

Not every security requirement should initially use the same enforcement mechanism.

The architecture distinguishes among:

* Preventive controls
* Detective controls
* Corrective controls
* Manual investigation
* Temporary exceptions

The appropriate treatment depends on risk, confidence, business impact, reversibility, and operational maturity.

---

## Automate Repeatable Controls

Terraform represents selected infrastructure and security configuration as code.

This improves repeatability, reviewability, and consistency while preserving cloud-native implementation.

---

## Preserve Business Continuity

Security changes during an acquisition must account for application dependencies and operational impact.

A stronger technical control that unexpectedly interrupts a critical inherited application may introduce greater immediate business risk than a documented temporary exception with compensating controls.

---

# 4. Architecture Overview

The conceptual model is:

**Enterprise Security Requirements**

↓

**Cloud-Specific Guardrails**

↓

**Azure | AWS | OCI**

↓

**Cloud-Native Security Controls and Telemetry**

↓

**Visibility / Detection / Investigation**

↓

**Remediation / Exception / Target-State Decision**

Azure acts as the monitoring anchor for the implemented Azure portion of the project.

This does not mean every security control is centralized in Azure.

AWS and OCI retain native security capabilities.

The current implementation also does not send AWS or OCI telemetry into Microsoft Sentinel.

---

# 5. Microsoft Azure Implementation

The Azure Terraform configuration implements selected components of the acquiring organization's security environment.

## Resource Group

A Resource Group provides the management and policy-assignment boundary for the Azure demonstration resources.

---

## Log Analytics Workspace

A Log Analytics Workspace provides the centralized Azure destination used by the monitoring implementation.

It supports:

* Security investigation
* Querying
* Detection
* Operational visibility
* Microsoft Sentinel

---

## Azure Key Vault

Terraform creates an Azure Key Vault.

The Key Vault provides a protected Azure resource against which diagnostic and policy controls can be demonstrated.

The implemented configuration intentionally has purge protection disabled, allowing the detective Azure Policy control to identify that configuration condition.

---

## Diagnostic Settings

Key Vault diagnostic settings send supported telemetry to Log Analytics.

The architecture pattern is:

**Protected Resource → Diagnostic Telemetry → Log Analytics**

The configuration includes Key Vault audit events and metrics.

This demonstrates that logging is treated as part of the security architecture rather than an optional operational add-on.

---

# 6. Azure Policy Guardrails

Azure Policy is implemented in Terraform.

Two policies demonstrate different M&A guardrail strategies.

## Preventive Control — Public Blob Access

The first policy denies Azure Storage Accounts configured with public blob access enabled.

The architecture decision is:

**Public blob access → Preventive / Deny**

This represents a condition considered sufficiently clear and undesirable to justify preventive enforcement.

---

## Detective Control — Key Vault Purge Protection

The second policy audits Key Vaults where purge protection is not enabled.

The architecture decision is:

**Missing Key Vault purge protection → Detective / Audit**

The policy provides visibility without automatically preventing deployment.

This is useful during an acquisition because some inherited configurations may require investigation and remediation planning before enforcement can safely be increased.

---

## Guardrail Initiative

Both policies are grouped into an M&A security guardrail initiative.

The initiative is assigned at Resource Group scope.

This demonstrates how individual controls can be grouped around a common security objective while still allowing different enforcement effects.

---

## Architecture Decision

The project deliberately demonstrates both prevention and detection.

The decision model is:

**Known unacceptable condition + high confidence → Prevent**

**Condition requiring investigation or transition planning → Detect**

Over time, detective controls may become preventive controls as dependencies become better understood and exceptions are resolved.

---

# 7. Microsoft Sentinel Implementation

Microsoft Sentinel is enabled on the Azure Log Analytics Workspace through Terraform.

The project implements two scheduled analytic rules.

Both run against AzureActivity and generate investigation signals from successful Azure configuration activity.

---

## Detection 1 — Storage Configuration Change

The first rule identifies successful Azure Storage configuration activity that may affect public exposure.

It examines operations associated with storage-account and storage-service configuration.

The rule does **not** claim that a configuration event proves the resource became publicly accessible.

The architecture logic is:

**Configuration Event → Potential Exposure Condition → Investigation → Validate Resource State → Remediation or Exception**

---

## Detection 2 — Encryption Review

The second rule identifies successful Azure Storage account configuration activity requiring review against enterprise encryption and key-management requirements.

Again, the event does not prove that the resulting storage account lacks a customer-managed encryption key.

The architecture logic is:

**Storage Configuration Event → Encryption Review → Validate Key Configuration → Remediation or Exception**

---

## Readable KQL Artifacts

Readable versions of both implemented queries are maintained under:

`monitoring/sentinel/detections/`

These files document the implemented analytic logic.

They are not separate cross-cloud detections.

---

# 8. Detection vs. Validation

An important architecture lesson from the project is that telemetry should not be treated as stronger evidence than it actually provides.

For example:

**Storage Configuration Change**

does not automatically mean:

**Storage Is Publicly Accessible**

Likewise:

**Storage Account Configuration Activity**

does not automatically mean:

**Customer-Managed Encryption Is Missing**

The proper security process is:

**Event → Potential Condition → Investigation → Validation → Decision**

The decision may then result in:

* Remediation
* Additional monitoring
* Compensating controls
* Approved exception
* No action if the condition is determined to be acceptable

This reduces false assumptions and creates a more defensible detection and response process.

---

# 9. Current Monitoring Boundary

The implemented Sentinel configuration processes Azure telemetry.

The project does **not** implement:

* AWS telemetry ingestion into Sentinel
* OCI telemetry ingestion into Sentinel
* Cross-cloud schema normalization
* Cross-cloud Sentinel analytic rules

A true centralized multi-cloud monitoring architecture would require additional work involving:

* Telemetry sources
* Connectors or ingestion pipelines
* Schema mapping
* Normalization
* Retention
* Detection engineering
* Detection tuning
* Monitoring of ingestion health

The target-state pattern could eventually become:

**Cloud Activity → Cloud-Native Logging → Central Collection → Normalization → Sentinel → Detection → Investigation → Response**

That is a future-state architecture rather than the current implementation.

---

# 10. AWS Implementation

The AWS baseline focuses on auditability and protection of audit records.

## AWS CloudTrail

Terraform configures a multi-Region CloudTrail.

The implementation includes:

* Multi-Region logging
* Global service events
* Log-file validation

Multi-Region logging improves visibility into administrative activity that may occur outside a single AWS Region.

---

## Log-File Validation

CloudTrail log-file validation is enabled.

This provides additional integrity evidence for determining whether delivered CloudTrail log files have been modified.

---

## Amazon S3

CloudTrail records are stored in an S3 bucket.

The bucket represents protected security evidence rather than general application storage.

The implementation includes:

* Public-access blocking
* Versioning
* SSE-KMS encryption
* CloudTrail bucket permissions
* Lifecycle retention

---

## AWS KMS

AWS Key Management Service provides cryptographic key management for the logging architecture.

The implementation includes:

* KMS key
* Automatic key rotation
* KMS alias

---

## Architecture Pattern

**AWS API Activity → CloudTrail → KMS-Protected S3 Audit Storage**

The security objective is to create a defensible audit trail for inherited AWS administrative activity.

---

# 11. OCI Implementation

The OCI implementation focuses on key management and protected object storage.

## OCI Vault

Terraform creates an OCI Vault used for cryptographic key management.

---

## Customer-Managed Encryption Key

Terraform creates an AES-256 customer-managed key within the Vault.

The key is configured with:

`protection_mode = "SOFTWARE"`

The implementation therefore demonstrates a customer-managed encryption key but does not claim HSM-backed key protection.

---

## OCI Object Storage

Terraform creates an Object Storage bucket configured to use the customer-managed key.

The implementation includes:

* CMEK encryption
* Object versioning
* Standard storage tier
* Lifecycle management

---

## Lifecycle Configuration

The lifecycle policy deletes objects after the configured retention period.

The default retention value is 30 days.

This demonstrates lifecycle governance rather than indefinite object retention.

---

## OCI IAM Policies

The project creates OCI IAM policies allowing the regional Object Storage service to:

* Use KMS keys in the governed compartment
* Manage object-family resources required for lifecycle operations

Terraform also includes a short wait after policy creation to allow IAM policy propagation before dependent Object Storage configuration proceeds.

---

## Architecture Pattern

**OCI Object Storage → Customer-Managed AES-256 Key → OCI Vault**

OCI provides native audit capabilities, but OCI telemetry ingestion into Microsoft Sentinel is not implemented.

---

# 12. Infrastructure as Code

Terraform represents the demonstrated controls across all three cloud platforms.

Separate configurations exist for:

* Azure
* AWS
* OCI

The objective is not to hide cloud differences behind a single abstraction.

Terraform provides a consistent provisioning mechanism while preserving cloud-native services and security models.

## Architecture Benefits

Infrastructure as Code supports:

* Repeatability
* Peer review
* Configuration visibility
* Change planning
* Reduced manual configuration
* Reusable security baselines

## Important Limitation

Terraform does not automatically create governance.

Enterprise governance also requires:

* Security requirements
* Architecture standards
* Approval processes
* Exception handling
* Ownership
* Validation
* Monitoring
* Evidence

---

# 13. Identity Architecture

Enterprise identity federation is a proposed target-state capability rather than an implemented component.

The architecture decision proposes Microsoft Entra ID as the primary enterprise workforce Identity Provider.

The intended model is:

**Enterprise User → Entra ID → Federated Cloud Access → Cloud-Native Authorization**

AWS could later integrate through appropriate federation and AWS identity capabilities, while OCI federation could be introduced during later integration.

The architecture deliberately separates:

**Authentication**

from:

**Cloud-native authorization**

This allows centralized workforce identity without eliminating the authorization models native to AWS or OCI.

The identity architecture is documented as a proposed architecture decision, not a deployed capability.

---

# 14. Exception Management

M&A environments frequently contain controls that cannot be immediately standardized.

Rather than choosing between immediate enforcement and indefinite noncompliance, the architecture uses a risk-based exception model.

An exception should identify:

* Security requirement
* Current gap
* Business justification
* Risk
* Compensating controls
* Owner
* Approval
* Remediation plan
* Review or expiration date

Temporary exceptions should remain visible and governed.

An exception is therefore not the absence of a security decision.

It is a documented security decision to temporarily accept or compensate for a known deviation.

---

# 15. Architecture Tradeoffs

## Standardization vs. Business Continuity

Immediate standardization reduces inconsistency but may disrupt inherited applications.

The architecture therefore prioritizes risk-based sequencing.

---

## Centralization vs. Cloud-Native Capability

Centralized governance can improve enterprise visibility.

Cloud-native controls often provide deeper platform integration.

The architecture therefore standardizes security objectives while retaining appropriate native controls.

---

## Prevention vs. Detection

Preventive controls can stop unsafe configurations before they exist but may interrupt legitimate inherited workloads.

Detective controls provide greater operational flexibility but allow the condition to exist until it is investigated and remediated.

The appropriate control depends on:

* Risk severity
* Confidence in the requirement
* Business impact
* Blast radius
* Reversibility
* Operational maturity

The implemented Azure policies demonstrate both approaches.

---

## Detection vs. Proof

A telemetry event may identify something worth investigating without proving an insecure resource state.

The architecture therefore separates:

**Signal → Validation → Security Decision**

This prevents monitoring logic from overstating what the underlying data can establish.

---

## Automation vs. Operational Risk

Not every finding should automatically trigger remediation.

A useful decision model is:

**Confidence → Business Impact → Blast Radius → Reversibility → Approval**

Low-risk and well-understood conditions are stronger candidates for automation.

High-impact changes may require human approval.

---

# 16. Failure Paths and Operational Risks

## Logging Failure

If telemetry is not successfully delivered, security teams may lose visibility into administrative activity.

**Response:**
Monitor logging and ingestion health and treat material telemetry failure as a security condition.

---

## Key-Access Failure

Incorrect key permissions can prevent storage services or workloads from accessing encrypted information.

**Response:**
Validate permissions and recovery procedures before broadly enforcing stronger key controls.

---

## Excessive Enforcement

A new preventive guardrail may block legitimate inherited workloads.

**Response:**
Use impact assessment, controlled rollout, exception management, and staged enforcement.

---

## Detection False Positives

Configuration events may trigger investigation even when the resulting resource configuration remains compliant.

**Response:**
Validate actual resource state before remediation and tune detections based on operational evidence.

---

## Identity Federation Failure

Future federation problems could prevent administrators from accessing cloud environments.

**Response:**
Design controlled emergency-access mechanisms and validate them independently of normal federation.

---

## Central Monitoring Dependency

Centralized monitoring introduces dependencies on ingestion pipelines, schemas, connectors, retention, and detection logic.

**Response:**
Monitor telemetry health and preserve appropriate cloud-native evidence sources.

---

## IAM Propagation Delay

Cloud IAM policy changes may not become effective immediately.

The OCI implementation explicitly accounts for this possibility before dependent storage configuration proceeds.

**Response:**
Design deployment dependencies with propagation behavior in mind rather than assuming immediate consistency.

---

# 17. Validation and Evidence

The architecture distinguishes between deployment evidence and security outcome evidence.

Examples of technical evidence include:

* Terraform configuration
* Terraform plans
* Cloud resource configuration
* Azure Policy definitions and assignments
* Sentinel analytic-rule configuration
* KQL detection logic
* CloudTrail configuration
* Diagnostic settings
* Key configuration
* Storage configuration
* IAM policies
* Architecture Decision Records

These artifacts demonstrate configuration and architecture intent.

They do not independently prove:

* Regulatory compliance
* Complete production security
* Successful operation over time
* Absence of configuration drift
* Effective incident response

Operational validation remains necessary.

---

# 18. Compliance Considerations

The architecture can support security objectives commonly associated with requirements involving:

* Access control
* Encryption
* Audit logging
* Monitoring
* Evidence retention
* Configuration management
* Governance

However:

**Cloud Control ≠ Compliance Requirement ≠ Compliance Certification**

Compliance depends on the complete organizational control environment, including:

* People
* Processes
* Policies
* Technical controls
* Evidence
* Scope
* Testing

This project therefore demonstrates security architecture patterns rather than claiming compliance certification.

---

# 19. Future-State Architecture

The demonstrated baseline could evolve in several areas.

## Identity

* Entra ID federation
* AWS workforce federation
* OCI federation
* Privileged-access governance
* Access reviews
* Emergency-access governance

## Governance

* Broader Azure Policy coverage
* AWS Config
* AWS organizational guardrails
* OCI Cloud Guard
* Policy-as-Code
* CI/CD validation
* Formal exception workflows

## Monitoring

* AWS telemetry ingestion into Sentinel
* OCI telemetry ingestion into Sentinel
* Cross-cloud normalization
* Expanded Sentinel detections
* Detection tuning
* Security dashboards
* Ingestion-health monitoring

## Response

* SOAR integration
* Controlled automated remediation
* Approval workflows
* Incident-response integration

## Network Security

* Segmentation
* Private connectivity
* Centralized connectivity patterns
* Ingress governance
* Egress governance

## Continuous Assurance

* Configuration monitoring
* Exception tracking
* Evidence collection
* Architecture review
* Continuous control validation

---

# 20. Implementation Status

## Implemented

### Azure

* Resource Group
* Log Analytics Workspace
* Key Vault
* Key Vault diagnostic settings
* Azure Policy — deny public blob access
* Azure Policy — audit Key Vault purge protection
* M&A Azure Policy initiative
* Resource Group policy assignment
* Microsoft Sentinel onboarding
* Two scheduled Azure-focused analytic rules

### AWS

* AWS KMS key
* KMS key rotation
* KMS alias
* S3 CloudTrail log bucket
* S3 public-access blocking
* S3 versioning
* SSE-KMS
* CloudTrail bucket policy
* Lifecycle retention
* Multi-Region CloudTrail
* Global service events
* CloudTrail log-file validation

### OCI

* OCI Vault
* AES-256 customer-managed key
* Software-based key protection
* Object Storage
* CMEK storage encryption
* Object versioning
* Lifecycle policy
* Object Storage KMS IAM policy
* Object Storage lifecycle IAM policy
* IAM policy propagation handling

### Detection Artifacts

* Readable KQL corresponding to the two implemented Sentinel analytic rules

---

## Proposed / Future State

* Enterprise identity federation
* Entra federation into acquired cloud environments
* AWS workforce federation integration
* OCI identity federation
* AWS telemetry ingestion into Sentinel
* OCI telemetry ingestion into Sentinel
* Cross-cloud telemetry normalization
* Cross-cloud Sentinel detection
* Broader Azure Policy coverage
* AWS Config and organizational guardrails
* OCI Cloud Guard
* Policy-as-Code
* Automated remediation
* SOAR
* Broader network integration
* Continuous compliance monitoring

---

# 21. Architecture Outcome

The project demonstrates that M&A cloud security does not require an immediate decision to migrate, rebuild, or standardize every inherited workload.

A more controlled sequence is:

**Discover**

↓

**Assess**

↓

**Establish Visibility**

↓

**Protect Critical Assets**

↓

**Apply Minimum Guardrails**

↓

**Identify and Govern Exceptions**

↓

**Determine Target State**

This provides security teams with a way to reduce immediate risk while allowing the enterprise to make deliberate decisions about migration, modernization, consolidation, retention, or retirement.

---

# Architect's Takeaway

Multi-cloud security during an acquisition is primarily a **security governance, risk-integration, and architecture problem**, not a requirement to make every cloud technically identical.

The architecture should establish common enterprise security outcomes while preserving appropriate cloud-native implementation.

The central question is not:

**How do we make AWS and OCI look like Azure?**

It is:

**What security outcomes must be consistent across the enterprise, which controls need to be implemented immediately, where are exceptions justified, and which changes can safely evolve as the acquired environment moves toward its target state?**

That leads back to the project's core principle:

**Standardize the security requirement, not necessarily the cloud implementation.**
