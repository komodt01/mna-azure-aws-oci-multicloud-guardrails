# M&A Multi-Cloud Security Guardrails

## Project Overview

This project demonstrates a security architecture approach for onboarding acquired cloud environments into an existing enterprise security model.

The scenario assumes the acquiring organization is primarily Azure-centered while the acquired organization introduces workloads and resources in AWS and Oracle Cloud Infrastructure (OCI).

The architecture problem is not simply:

**How do we deploy the same controls in three clouds?**

It is:

**How can an organization establish minimum security expectations across newly acquired cloud environments while allowing Azure, AWS, and OCI to retain their native architectures and services?**

The project combines architecture analysis with Terraform implementations of selected security guardrails across the three cloud platforms.

It is a portfolio architecture project and should not be interpreted as a complete production landing zone, compliance implementation, or enterprise M&A integration platform.

---

## Business Scenario

Following an acquisition, an enterprise may inherit cloud environments that were designed independently.

Those environments may differ in:

* Identity models
* Administrative access
* Encryption
* Key management
* Logging
* Monitoring
* Network architecture
* Resource organization
* Security tooling
* Configuration standards
* Retention
* Governance

Immediately migrating every acquired workload into the acquiring organization's primary cloud may introduce unnecessary operational and business risk.

The security architecture therefore needs an interim integration model that establishes visibility, protects critical assets, introduces minimum guardrails, and governs exceptions while longer-term workload and cloud decisions are made.

---

## Architecture Objective

The objective is to establish an initial multi-cloud security baseline around:

* Security visibility
* Audit logging
* Encryption and key management
* Storage protection
* Configuration guardrails
* Detection of selected security conditions
* Infrastructure as Code
* Repeatable cloud onboarding
* Evidence generation
* Exception governance
* Controlled evolution toward a longer-term target state

Azure serves as the enterprise monitoring anchor in the scenario while AWS and OCI retain cloud-native security controls.

The core architectural principle is:

**Standardize the security requirement, not necessarily the cloud implementation.**

The overall decision flow is:

**Discover → Assess → Establish Visibility → Protect Critical Assets → Apply Minimum Guardrails → Identify Exceptions → Determine Target State**

---

# Architecture Principles

## 1. Establish Visibility Early

Before attempting broad cloud transformation, the acquiring organization needs visibility into administrative activity and important security events.

Logging and monitoring therefore become early integration requirements.

## 2. Protect Critical Assets

Encryption and key-management controls provide an initial data-protection baseline while the organization evaluates inherited workloads and data.

## 3. Use Cloud-Native Controls

Azure, AWS, and OCI do not need identical technical implementations.

The architecture establishes required security outcomes and uses appropriate native capabilities within each cloud.

## 4. Apply Guardrails According to Risk

Not every security condition should initially be handled the same way.

Some conditions justify preventive enforcement, while others may require detection, investigation, remediation, or a temporary exception.

## 5. Automate Repeatable Baselines

Terraform demonstrates how selected baseline controls can be deployed consistently and reviewed as code.

## 6. Separate Initial Guardrails from Target-State Architecture

An M&A security baseline is not necessarily the final enterprise architecture.

Initial controls reduce exposure and improve visibility while architecture teams determine which workloads should be:

* Retained
* Modernized
* Migrated
* Consolidated
* Replatformed
* Retired

---

# Implemented Demonstration

## Microsoft Azure

The Terraform implementation creates selected Azure security and monitoring components including:

* Resource Group
* Log Analytics Workspace
* Key Vault
* Key Vault diagnostic settings directing supported telemetry to Log Analytics
* Azure Policy guardrails
* Microsoft Sentinel onboarding
* Two scheduled Microsoft Sentinel analytic rules

### Azure Policy Guardrails

The Azure Policy implementation demonstrates two different control strategies.

**Preventive control**

Azure Storage Accounts configured with public blob access are denied.

This represents a condition where the architecture establishes a minimum security requirement through preventive enforcement.

**Detective control**

Key Vaults without purge protection enabled are audited.

This represents a condition where the architecture identifies a configuration gap for review rather than automatically preventing deployment.

Both policies are grouped into an M&A security guardrail initiative and assigned at Resource Group scope.

### Microsoft Sentinel

Microsoft Sentinel is enabled on the Log Analytics Workspace through Terraform.

Two Azure-focused scheduled analytic rules are implemented:

* Storage configuration change requiring review
* Storage configuration requiring encryption review

The rules intentionally treat Azure configuration events as investigation signals rather than definitive evidence of an insecure resource state.

AzureActivity can identify relevant configuration activity, but additional validation is required before determining whether a resource is actually exposed or violates the organization's encryption requirements.

The investigation pattern is:

**Configuration Event → Potential Condition → Investigation → Validated Risk → Remediation or Approved Exception**

---

## AWS

The AWS Terraform implementation demonstrates:

* AWS KMS key
* Automatic KMS key rotation
* KMS alias
* S3 bucket for CloudTrail logs
* S3 public-access blocking
* S3 versioning
* SSE-KMS encryption
* CloudTrail bucket policy
* Object lifecycle retention
* Multi-Region CloudTrail
* Global service event logging
* CloudTrail log-file validation

These controls provide an initial audit, storage-protection, and data-protection baseline for the acquired AWS environment.

---

## Oracle Cloud Infrastructure

The OCI Terraform implementation demonstrates:

* OCI Vault
* AES-256 customer-managed encryption key
* Software-based key protection
* Object Storage bucket
* Object Storage encryption using the customer-managed key
* Object versioning
* Lifecycle-based object retention
* IAM policy allowing Object Storage to use KMS keys
* IAM policy supporting Object Storage lifecycle operations
* IAM policy propagation handling before dependent storage configuration

These controls provide selected encryption and storage-governance capabilities for the acquired OCI environment.

The implemented OCI key uses software protection. The project does not claim that the key is HSM-protected.

---

# Monitoring and Detection

Microsoft Sentinel provides the implemented monitoring capability for the Azure portion of the project.

The repository also maintains readable KQL versions of the implemented Sentinel detections under:

`monitoring/sentinel/detections/`

The two detections focus on:

* Azure Storage configuration activity that may affect public exposure
* Azure Storage account configuration activity requiring encryption review

Neither detection independently proves that the resulting resource configuration is insecure.

The architecture deliberately separates:

**Signal → Investigation → Validation → Decision**

This avoids treating telemetry as stronger evidence than it actually provides.

---

## Current Monitoring Boundary

The implemented Sentinel configuration processes Azure telemetry only.

The repository does **not** implement:

* AWS telemetry ingestion into Microsoft Sentinel
* OCI telemetry ingestion into Microsoft Sentinel
* Cross-cloud telemetry normalization
* Cross-cloud Sentinel analytic rules

A true centralized multi-cloud monitoring architecture would require additional ingestion pipelines, schema mapping, normalization, and detection engineering.

The longer-term architecture could evolve toward:

**Cloud Telemetry → Central Monitoring → Detection → Investigation → Response → Evidence**

That represents a target-state direction rather than the current implementation.

---

# M&A Security Decision Model

An acquisition creates competing priorities.

The organization needs to reduce security exposure without disrupting business services or forcing premature migration decisions.

The security architecture follows this sequence:

**Discover → Assess → Establish Visibility → Protect Critical Assets → Apply Minimum Guardrails → Identify Exceptions → Determine Target State**

## Discover

Identify:

* Cloud accounts and subscriptions
* Workloads
* Data
* Identities
* Administrative paths
* External exposure
* Existing security services
* Logging
* Business owners

## Assess

Determine:

* Business criticality
* Data sensitivity
* Existing controls
* Material security gaps
* Regulatory requirements
* Technical dependencies
* Operational constraints

## Establish Visibility

Identify and enable the security telemetry needed to understand administrative activity, configuration changes, and relevant security events.

Visibility should precede broad transformation because architecture decisions require an understanding of the inherited environment.

## Protect Critical Assets

Prioritize high-risk conditions involving areas such as:

* Sensitive data
* Administrative access
* Encryption
* Public exposure
* Audit logging

## Apply Minimum Guardrails

Establish security requirements that can reasonably be applied without unnecessarily disrupting acquired business operations.

Controls may be:

* Preventive
* Detective
* Corrective
* Procedural

The appropriate control depends on risk, confidence, business impact, and the maturity of the acquired environment.

## Identify Exceptions

Where inherited workloads cannot immediately meet enterprise standards, document:

* Requirement
* Gap
* Risk
* Business justification
* Compensating controls
* Owner
* Remediation plan
* Review date

An exception should represent a governed temporary decision rather than an undocumented deviation from the security standard.

## Determine Target State

Each workload can then be evaluated for:

* Retention
* Modernization
* Migration
* Consolidation
* Replatforming
* Retirement

Security integration therefore supports the business decision rather than forcing the cloud decision prematurely.

---

# Architecture Tradeoffs

## Security Standardization vs. Business Continuity

Immediately enforcing every enterprise standard may disrupt acquired applications.

The initial architecture should prioritize material risks while providing a controlled path toward stronger standardization.

---

## Centralization vs. Cloud-Native Capability

Centralized monitoring can provide enterprise visibility, but each cloud contains useful native security capabilities.

The architecture can establish common security requirements while allowing each cloud to use the native services best suited to satisfying those requirements.

---

## Preventive Controls vs. Detection

Preventive controls provide stronger enforcement but can interfere with inherited workloads whose dependencies are not yet fully understood.

Early M&A integration may therefore require a combination of:

* Preventive controls for clearly unacceptable conditions
* Detective controls for conditions requiring investigation
* Manual remediation where business impact must first be understood
* Temporary exceptions where immediate remediation is not feasible

The implemented Azure Policy examples demonstrate this distinction directly:

**Public blob access → Preventive / Deny**

**Missing Key Vault purge protection → Detective / Audit**

---

## Detection vs. Proof

A security event does not necessarily prove that an insecure state exists.

For example, storage configuration activity may justify investigation without proving that the storage resource became publicly accessible.

The architecture therefore distinguishes between:

**Event → Potential Condition → Validation → Confirmed Risk**

This distinction reduces false assumptions and supports more defensible security decisions.

---

## Automation vs. Operational Risk

Automated remediation can reduce response time but can also interrupt business operations.

Corrective automation should consider:

**Confidence → Business Impact → Blast Radius → Reversibility → Approval**

During an acquisition, automated remediation should be introduced carefully until application dependencies and operational ownership are sufficiently understood.

---

# Identity Architecture

Enterprise identity federation is not implemented by the Terraform in this repository.

The architecture proposes Microsoft Entra ID as a potential future enterprise identity provider for federated access across acquired cloud environments.

That direction is documented as an architecture decision rather than a deployed capability.

Future identity integration could include:

* Federation into AWS
* Federation into OCI
* Centralized workforce identity
* Strong authentication requirements
* Privileged-access governance
* Conditional access
* Joiner/mover/leaver integration

The target-state identity architecture should be introduced only after inherited identities, administrative paths, service accounts, and workload dependencies have been assessed.

---

# Architecture Evolution

The Terraform controls in this repository represent selected baseline guardrails rather than a complete target architecture.

Potential future-state capabilities include:

* Broader Azure Policy coverage
* AWS Config and organizational guardrails
* OCI Cloud Guard
* Enterprise identity federation
* Privileged-access governance
* Network segmentation
* Private connectivity
* Policy-as-Code
* CI/CD security validation
* Expanded Sentinel detections
* AWS and OCI telemetry ingestion into Sentinel
* Cross-cloud telemetry normalization
* SOAR workflows
* Security exception management
* Continuous compliance monitoring

These capabilities should be introduced according to business risk, operational readiness, and the target-state architecture rather than simply because the technology is available.

---

# Repository Structure

```text
mna-azure-aws-oci-multicloud-guardrails/
├── README.md
├── technologies.md
├── teardown.md
├── business-use-cases.md
├── governance/
│   └── adrs/
├── terraform/
│   ├── azure/
│   ├── aws/
│   └── oci/
└── monitoring/
    └── sentinel/
        └── detections/
```

---

# Deployment

## Prerequisites

* Terraform
* Appropriate Azure authentication and permissions
* Appropriate AWS authentication and permissions
* Appropriate OCI authentication and compartment permissions

Cloud resources may incur charges.

The repository includes teardown guidance for removing demonstration resources after use.

## Terraform Workflow

Each cloud contains its own Terraform configuration.

The general workflow is:

```text
terraform init
terraform plan
terraform apply
```

Configuration values should be reviewed before deployment and should not contain production credentials or sensitive information.

After testing, resources should be removed according to the documented teardown process.

---

# What This Project Demonstrates

This project demonstrates:

* M&A security architecture thinking
* Multi-cloud security governance
* Risk-based guardrail adoption
* Preventive and detective control selection
* AWS, Azure, and OCI security capabilities
* Azure Policy
* Microsoft Sentinel detection architecture
* Cloud-native audit logging
* Encryption and customer-managed key management
* Storage protection
* Infrastructure as Code
* Security monitoring
* Investigation-oriented detection design
* Security exception governance
* Architecture tradeoff analysis
* Target-state architecture planning

It also demonstrates an important architecture boundary:

**Implemented controls and target-state recommendations are not the same thing.**

The repository explicitly distinguishes between capabilities implemented through Terraform and capabilities proposed as future architecture.

---

# Architecture Takeaway

An acquisition does not automatically require immediate cloud consolidation.

Security architecture can first establish visibility, protect critical assets, introduce minimum guardrails, and govern exceptions while the organization determines the appropriate long-term disposition of inherited workloads.

The architecture progression is:

**Discover → Assess → Establish Visibility → Protect Critical Assets → Apply Minimum Guardrails → Identify Exceptions → Determine Target State**

The goal is not to make Azure, AWS, and OCI identical.

The goal is to bring acquired environments under a **consistent enterprise security model without creating unnecessary business disruption.**

**Standardize the security requirement, not necessarily the cloud implementation.**
