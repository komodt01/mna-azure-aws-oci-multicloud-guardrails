Overview

This project explores how an enterprise can establish an initial security architecture when an acquisition introduces cloud environments that were designed and operated independently.

This project explores how an enterprise can establish an initial security architecture when an acquisition introduces cloud environments that were designed and operated independently.

The scenario assumes an acquiring organization with Microsoft Azure as its primary enterprise security and monitoring environment and an acquired organization operating workloads across AWS and Oracle Cloud Infrastructure (OCI).

Rather than immediately forcing all three cloud environments into an identical technical model, the architecture establishes common security objectives while allowing each cloud to use appropriate native capabilities.

The implemented demonstration focuses on selected controls for:

Infrastructure as Code
Audit logging
Centralized Azure logging
Encryption and key management
Protected audit-log storage
Storage lifecycle configuration
Reference detection logic

The project also identifies identity federation, broader policy enforcement, multi-cloud telemetry integration, automated remediation, and continuous compliance as future-state capabilities rather than implemented controls.

1. Architecture Problem

Mergers and acquisitions can introduce cloud environments with different:

Identity systems
Administrative models
Logging configurations
Encryption standards
Key-management practices
Monitoring platforms
Resource structures
Network architectures
Security tooling
Operational ownership
Configuration standards

Immediately migrating or redesigning every inherited workload can create significant operational risk.

At the same time, leaving the acquired environments outside enterprise security governance indefinitely creates security and compliance risk.

The architecture therefore addresses the question:

How can an enterprise establish minimum security expectations and visibility across newly acquired cloud environments without requiring immediate platform standardization?

2. Architecture Objective

The objective is to establish an initial security baseline that supports:

Discover → Assess → Establish Visibility → Protect Critical Assets → Apply Minimum Guardrails → Identify Exceptions → Determine Target State

The architecture distinguishes between:

Immediate Security Stabilization

Controls that reduce near-term risk and improve visibility.

Target-State Integration

Capabilities that require additional planning, organizational integration, application analysis, and operational maturity.

This distinction is important during M&A because the most secure long-term architecture may not be the safest change to make immediately after acquisition.

3. Architecture Principles
Standardize Security Outcomes, Not Cloud Implementations

AWS, Azure, and OCI provide different security services and operating models.

The architecture establishes common objectives such as:

Record administrative activity
Protect sensitive information
Control cryptographic keys
Preserve security evidence
Detect important configuration changes

Each cloud can satisfy those objectives using its native capabilities.

Establish Visibility Early

Security teams cannot effectively govern inherited environments they cannot observe.

Logging and monitoring therefore become early architecture priorities.

Protect Critical Assets Before Broad Standardization

High-value data, administrative access, encryption keys, and audit records should receive priority over lower-risk configuration differences.

Automate Repeatable Controls

Terraform represents selected infrastructure and security configuration as code.

This improves repeatability and creates a foundation for future validation and policy enforcement.

Preserve Business Continuity

Security changes during acquisition must consider application dependencies and operational impact.

A technically stronger control that interrupts a critical inherited service may introduce greater immediate business risk than a controlled temporary exception.

4. Architecture Overview

The conceptual architecture follows:

Enterprise Security Requirements

↓

Cloud-Specific Security Implementation

↓

Azure | AWS | OCI

↓

Cloud-Native Logging and Security Controls

↓

Central Security Visibility

↓

Investigation / Remediation / Governance

Azure acts as the conceptual enterprise monitoring anchor in this project.

This does not mean every security control must be implemented in Azure.

AWS and OCI retain their native security capabilities.

5. Microsoft Azure Implementation

The Azure Terraform configuration demonstrates selected components of the acquiring organization's security environment.

Resource Group

A Resource Group provides the management boundary for the Azure demonstration resources.

Log Analytics Workspace

Log Analytics provides the centralized Azure destination for supported telemetry.

This establishes the foundation for:

Security investigation
Querying
Detection development
Operational visibility
Azure Key Vault

Key Vault represents centralized Azure protection for cryptographic material and secrets.

The project also configures diagnostic settings associated with Key Vault.

Diagnostic Settings

Diagnostic settings demonstrate the architecture pattern:

Protected Resource → Diagnostic Telemetry → Log Analytics

This illustrates how security-relevant activity can become available for centralized monitoring.

Architecture Decision

Logging is treated as part of the security architecture rather than an optional operational add-on.

6. AWS Implementation

The AWS baseline focuses primarily on auditability and protection of audit records.

AWS CloudTrail

A multi-Region CloudTrail records AWS API activity.

Multi-Region logging improves visibility into administrative activity occurring outside a single AWS Region.

Log File Validation

CloudTrail log file validation is enabled.

This provides additional evidence for detecting whether CloudTrail log files have been modified after delivery.

Amazon S3

CloudTrail records are stored in an S3 bucket.

The bucket serves as security evidence storage rather than general application storage.

AWS KMS

AWS Key Management Service provides cryptographic key management for the logging architecture.

Architecture Pattern

AWS API Activity → CloudTrail → Protected S3 Storage

Security Objective

The primary objective is to create a defensible audit trail for inherited AWS administrative activity.

7. OCI Implementation

The OCI demonstration focuses primarily on key management and protected storage.

OCI Vault

Terraform creates an OCI Vault used for cryptographic key management.

Customer-Managed Key

A key within OCI Vault provides the cryptographic control used by the storage architecture.

OCI Object Storage

The project creates an Object Storage bucket configured to use the OCI customer-managed key.

Lifecycle Configuration

A lifecycle policy demonstrates management of stored objects over time.

Architecture Pattern

OCI Object Storage → Customer-Managed Key → OCI Vault

Logging Consideration

OCI provides native audit capabilities.

A complete OCI-to-Sentinel ingestion pipeline is not implemented in this project.

Centralizing selected OCI telemetry would therefore be part of the future-state architecture.

8. Infrastructure as Code

Terraform is used to represent the demonstrated controls across all three cloud platforms.

Separate configurations exist for:

Azure
AWS
OCI

The objective is not to hide cloud differences behind a single abstraction.

Instead, Terraform provides a consistent deployment mechanism while preserving cloud-native services.

Architecture Benefits

Infrastructure as Code supports:

Repeatability
Peer review
Configuration visibility
Change planning
Reduced manual configuration
Reusable baselines
Important Limitation

Terraform does not automatically create governance.

Enterprise governance also requires:

Security requirements
Architecture standards
Approval processes
Exception handling
Ownership
Validation
Monitoring
9. Identity Architecture

Identity federation is a proposed target-state capability rather than an implemented component.

The architecture decision proposes Microsoft Entra ID as the primary enterprise workforce Identity Provider.

The intended model is:

Enterprise User → Entra ID → Federated Cloud Access → Cloud-Native Authorization

AWS could integrate through AWS IAM Identity Center, while OCI federation could be introduced during later integration.

The architecture deliberately separates:

Authentication

from:

Cloud-native authorization

This allows centralized enterprise workforce identity without eliminating AWS IAM or OCI IAM.

10. Monitoring and Detection

The repository contains example KQL queries representing security detection concepts.

The monitoring examples focus on conditions such as:

Storage configuration changes
Potential public exposure
Activity requiring validation against encryption requirements

These queries are reference detection concepts rather than production Microsoft Sentinel analytic rules.

Monitoring Architecture

A future-state architecture could follow:

Cloud Activity

↓

Cloud-Native Logging

↓

Telemetry Collection

↓

Microsoft Sentinel

↓

Detection

↓

Investigation

↓

Response

AWS and OCI telemetry ingestion and normalization would need to be implemented before equivalent cross-cloud Sentinel analytics could reliably operate.

11. Detection vs. Validation

An important architecture distinction is that a configuration event does not automatically prove a vulnerability.

For example:

Storage Configuration Change

does not automatically mean:

Storage Is Publicly Accessible

The proper security process is:

Configuration Event → Potential Condition → Investigation → Validation → Remediation

This reduces the risk of treating incomplete telemetry as definitive security evidence.

12. Governance and Architecture Decisions

The project uses Architecture Decision Records to document important target-state choices.

The identity ADR proposes Entra ID as the primary enterprise workforce IdP.

A useful architecture decision should capture:

Context
Decision
Rationale
Alternatives
Security implications
Tradeoffs
Consequences
Implementation status

This separates an architecture recommendation from a capability that has actually been deployed.

13. Exception Management

M&A environments frequently contain controls that cannot be immediately standardized.

Rather than choosing between immediate enforcement and indefinite noncompliance, the architecture uses a risk-based exception model.

An exception should identify:

Requirement
Current gap
Business justification
Risk
Compensating controls
Owner
Approval
Remediation plan
Review or expiration date

Temporary exceptions should remain visible and governed.

14. Architecture Tradeoffs
Standardization vs. Business Continuity

Immediate standardization reduces inconsistency but may disrupt inherited applications.

The architecture prioritizes risk-based sequencing.

Centralization vs. Cloud-Native Capabilities

Centralized governance improves enterprise visibility.

Cloud-native controls often provide deeper platform integration.

The architecture therefore centralizes security requirements and selected visibility while retaining appropriate native controls.

Prevention vs. Detection

Preventive controls can stop unsafe configurations but may also interrupt legitimate operations.

Detection can provide greater flexibility but allows risk to exist until remediation occurs.

The appropriate control depends on:

Risk severity
Confidence in the rule
Business impact
Blast radius
Reversibility
Operational maturity
Automation vs. Operational Risk

Not every finding should automatically trigger remediation.

A useful decision model is:

Confidence → Business Impact → Blast Radius → Reversibility → Approval

Low-risk and well-understood conditions are stronger candidates for automation.

High-impact changes may require human approval.

15. Failure Paths and Operational Risks
Logging Failure

If telemetry is not successfully delivered, security teams may lose visibility into administrative activity.

Response

Monitor logging health and treat telemetry failure as a security condition.

Key-Access Failure

Incorrect key permissions can prevent applications or storage services from accessing encrypted information.

Response

Validate permissions and recovery procedures before enforcing stronger key controls broadly.

Excessive Enforcement

A new security guardrail may block legitimate inherited workloads.

Response

Use staged enforcement, impact assessment, exception management, and controlled rollout.

Identity Federation Failure

Federation problems could prevent administrators from accessing cloud environments.

Response

Design controlled emergency-access mechanisms and validate them independently of normal federation.

Central Monitoring Dependency

Centralized monitoring creates operational dependencies on ingestion pipelines, schemas, connectors, and retention.

Response

Monitor telemetry health and preserve appropriate cloud-native evidence sources.

16. Validation and Evidence

The architecture should distinguish between deployment evidence and security outcome evidence.

Examples of technical evidence include:

Terraform configuration
Terraform plans
Cloud resource configuration
CloudTrail configuration
Diagnostic settings
Key configuration
Storage configuration
KQL detection logic
Architecture Decision Records

These artifacts demonstrate configuration and architecture intent.

They do not independently prove regulatory compliance or complete production security.

17. Compliance Considerations

The architecture can support security objectives commonly associated with requirements involving:

Access control
Encryption
Audit logging
Monitoring
Evidence retention
Configuration management

However:

Cloud Control ≠ Compliance Requirement ≠ Compliance Certification

Compliance depends on the complete organizational control environment, including people, processes, policies, technical controls, evidence, and scope.

This project therefore demonstrates security architecture patterns rather than claiming compliance certification.

18. Future-State Architecture

The demonstrated baseline could evolve to include:

Identity
Entra ID federation
AWS IAM Identity Center
OCI federation
Privileged-access governance
Access reviews
Governance
Azure Policy
AWS Config
AWS organizational guardrails
OCI Cloud Guard
Policy-as-Code
CI/CD validation
Monitoring
AWS telemetry ingestion
OCI telemetry ingestion
Expanded Sentinel detections
Detection tuning
Security dashboards
Response
SOAR integration
Controlled automated remediation
Approval workflows
Incident-response integration
Network Security
Segmentation
Private connectivity
Centralized connectivity patterns
Ingress and egress governance
Continuous Assurance
Configuration monitoring
Exception tracking
Evidence collection
Architecture review
Continuous control validation
19. Implementation Status
Demonstrated
Terraform-based Azure baseline
Azure Resource Group
Azure Log Analytics
Azure Key Vault
Azure diagnostic settings
AWS KMS
AWS S3 audit-log storage
Multi-Region AWS CloudTrail
CloudTrail log file validation
OCI Vault
OCI customer-managed key
OCI Object Storage encryption
OCI storage lifecycle configuration
Reference KQL detection concepts
Proposed / Future State
Enterprise identity federation
AWS IAM Identity Center integration
OCI identity federation
Full AWS/OCI Sentinel ingestion
Azure Policy
AWS Config and organizational guardrails
OCI Cloud Guard
Policy-as-Code
Automated remediation
SOAR
Broader network integration
Continuous compliance monitoring
20. Architecture Outcome

The project demonstrates that M&A cloud security does not require an immediate decision to migrate, rebuild, or standardize every inherited workload.

A more controlled architecture sequence is:

Acquire

↓

Discover

↓

Assess

↓

Establish Visibility

↓

Protect Critical Assets

↓

Apply Minimum Guardrails

↓

Govern Exceptions

↓

Determine Target State

This provides security teams with a way to reduce immediate risk while allowing the enterprise to make deliberate decisions about migration, modernization, consolidation, or retirement.

Architect's Takeaway

Multi-cloud security during an acquisition is primarily a governance and risk-integration problem, not a requirement to make every cloud technically identical.

The architecture should establish common enterprise security outcomes while preserving appropriate cloud-native implementation.

The central question is not:

How do we make AWS and OCI look like Azure?

It is:

What security outcomes must be consistent across the enterprise, which controls need to be implemented immediately, and which changes can safely evolve as the acquired environment moves toward its target state?
