# ADR 0001 — Entra ID as Primary Enterprise Identity Provider

**Status:** Proposed
**Scope:** M&A Multi-Cloud Security Architecture
**Platforms:** Microsoft Azure, AWS, Oracle Cloud Infrastructure

---

## Context

The M&A scenario represented by this project assumes an acquiring organization whose primary enterprise environment is Microsoft Azure and an acquired organization operating workloads across AWS and Oracle Cloud Infrastructure (OCI).

An acquisition can introduce multiple independent identity systems, administrative accounts, access models, and authentication processes.

Maintaining separate workforce identity models indefinitely across each cloud can increase:

* Identity lifecycle complexity
* Administrative overhead
* Orphaned-account risk
* Inconsistent authentication requirements
* Access-review complexity
* Privileged-access risk
* Investigation difficulty

The organization therefore needs a target-state identity model that can provide centralized workforce identity while allowing AWS and OCI to retain their native authorization mechanisms.

---

## Decision

Use **Microsoft Entra ID as the proposed primary enterprise workforce Identity Provider (IdP)** for the M&A target-state architecture.

The intended architecture pattern is:

**Enterprise User → Entra ID → Federated Cloud Access → Cloud-Native Authorization → Cloud Resource**

Under this model:

* Entra ID provides the primary enterprise workforce identity.
* AWS can federate enterprise identities through AWS IAM Identity Center.
* OCI federation can be introduced as part of the future-state integration architecture.
* AWS IAM and OCI IAM remain responsible for cloud-specific authorization.
* Cloud-native workload identities remain separate from human workforce identities.

This is a **proposed architecture decision**.

Identity federation is not implemented by the Terraform baseline contained in this repository.

---

## Rationale

### Centralized Workforce Identity

Using a primary enterprise IdP reduces the need to maintain separate long-lived workforce identities independently within each cloud.

### Identity Lifecycle Governance

Centralized identity provides a stronger foundation for managing:

* Joiners
* Movers
* Leavers
* Authentication requirements
* Group membership
* Access reviews
* Privileged-access processes

### M&A Integration

The acquiring organization can begin bringing acquired personnel and administrative access into its enterprise identity model without requiring immediate migration of every AWS or OCI workload.

### Cloud-Native Authorization

Federation does not require replacing each cloud's authorization model.

The architecture separates:

**Authentication — Who are you?**

from:

**Authorization — What are you allowed to do in this cloud?**

Entra ID can establish enterprise identity while AWS and OCI continue applying their native permissions and resource-access models.

---

## Alternatives Considered

### Maintain Independent Identity Systems

Each cloud could retain separate workforce identities.

**Advantages:**

* Minimal initial integration
* Reduced short-term migration effort
* Lower immediate dependency on the acquiring organization's identity platform

**Disadvantages:**

* Multiple identity lifecycles
* Increased administrative overhead
* Greater risk of stale accounts
* More difficult access reviews
* Inconsistent authentication controls

This may be acceptable temporarily during acquisition discovery but is not the preferred long-term workforce identity model.

---

### Use Separate Cloud Identity Providers

AWS and OCI could each use independent identity platforms.

This preserves greater cloud autonomy but increases identity fragmentation and governance complexity.

---

### Immediate Identity Consolidation

The acquiring organization could require all acquired users and workloads to immediately adopt the enterprise identity architecture.

This could accelerate standardization but introduces greater operational risk during an acquisition when application dependencies and administrative processes may not yet be fully understood.

A phased federation approach provides a more controlled transition.

---

## Security Considerations

Federation changes the trust model.

Compromise of the enterprise IdP could affect access to multiple cloud environments.

The target architecture should therefore consider controls such as:

* Strong multifactor authentication
* Conditional access
* Privileged-access controls
* Least privilege
* Role-based access
* Access reviews
* Emergency-access procedures
* Authentication logging
* Federation monitoring
* Session controls
* Separation of administrative roles

These are target-state architecture considerations and are not all implemented by this repository.

---

## Human vs. Workload Identity

Centralizing workforce authentication does not mean all identities should use Entra ID.

Cloud workloads should generally use platform-native workload identity mechanisms rather than human credentials.

The architecture should distinguish among:

* Workforce identities
* Privileged administrative identities
* Service identities
* Workload identities
* Automation identities
* Emergency-access identities

Each identity type requires an appropriate authentication, authorization, lifecycle, and monitoring model.

---

## M&A Transition Approach

Identity integration should occur in controlled stages.

### Phase 1 — Discovery

Identify:

* Existing workforce identities
* Local cloud users
* Privileged accounts
* Service accounts
* Workload identities
* External identities
* Existing federation
* Authentication requirements
* Application dependencies

### Phase 2 — Risk Assessment

Determine which identities present the greatest risk based on:

* Privilege
* Business criticality
* Data access
* External exposure
* Authentication strength
* Account lifecycle
* Monitoring

### Phase 3 — Federation

Introduce enterprise federation for appropriate workforce identities while preserving required cloud-native authorization.

### Phase 4 — Access Governance

Establish processes for:

* Role assignment
* Privileged access
* Access review
* Deprovisioning
* Exception management

### Phase 5 — Legacy Identity Reduction

Remove unnecessary local workforce identities after dependencies and emergency-access requirements have been validated.

---

## Exception Handling

Some acquired workloads may initially depend on local cloud identities.

An exception should document:

* Identity or workload
* Business requirement
* Reason federation cannot yet be used
* Privileges granted
* Associated risk
* Compensating controls
* Owner
* Remediation plan
* Review or expiration date

This prevents temporary M&A accommodations from becoming unmanaged permanent access paths.

---

## Consequences

### Positive

* More consistent enterprise authentication
* Reduced workforce identity fragmentation
* Improved lifecycle governance
* Better foundation for access reviews
* Clearer separation between authentication and cloud authorization
* Supports gradual M&A integration

### Negative

* Greater dependency on the enterprise IdP
* Federation configuration and operational complexity
* Potentially larger identity-related blast radius
* Acquired applications may require transition periods
* Emergency-access mechanisms must be maintained and tested

---

## Implementation Status

**Architecture decision:** Proposed

**Implemented in this repository:** No

The current Terraform demonstration focuses on selected logging, encryption, key-management, storage, and monitoring controls.

Identity federation represents a **future-state architecture capability** for extending the M&A security model.

---

## Architecture Principle

The objective is not to eliminate AWS IAM or OCI IAM.

The objective is to establish a consistent enterprise identity trust model while retaining cloud-native authorization.

**Centralize enterprise identity where appropriate. Preserve cloud-native authorization where it provides the correct control boundary.**
