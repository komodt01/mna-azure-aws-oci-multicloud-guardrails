# Trust Boundaries — M&A Multi-Cloud Security Guardrails

## The Boundary Created by an Acquisition

A cloud acquisition creates a security boundary before any technical integration occurs.

The acquiring organization inherits environments that may have their own administrators, identities, policies, logging, network designs, operational processes, and security assumptions.

Ownership may have changed legally.

Trust has not automatically changed technically.

That distinction is central to this architecture.

The security problem is therefore not simply how to connect Azure, AWS, and OCI. The first problem is determining what the acquiring organization can trust about the inherited environments and where enterprise security authority should begin.

The transition can be viewed as:

**Independent Environment → Discovered Environment → Governed Environment → Target-State Environment**

Each stage changes what the enterprise knows, controls, and is prepared to trust.

---

## Before Enterprise Trust

At the beginning of an acquisition, an inherited cloud environment should be treated as something that needs to be understood before broad trust is established.

Discovery should identify areas such as:

- Cloud accounts, subscriptions, and compartments.
- Administrative identities.
- Privileged access paths.
- Workload and service identities.
- Internet exposure.
- Sensitive data.
- Encryption and key ownership.
- Logging.
- Security tooling.
- External integrations.
- Business owners.
- Existing exceptions.
- Dependencies between workloads.

An acquired AWS account, OCI tenancy, or Azure environment being owned by the same company does not make its existing security state known.

This is why the project places discovery and assessment before broad standardization.

---

## When Enterprise Security Begins to Reach Into the Acquired Environment

The next boundary appears when the acquiring organization begins introducing its security requirements.

The objective is not to immediately replace every inherited control.

Instead, the enterprise establishes minimum expectations around areas such as:

**Visibility → Data Protection → Guardrails → Investigation → Governance**

The implementation demonstrates different ways those requirements can be satisfied using cloud-native services.

Azure uses capabilities including Azure Policy, Log Analytics, Key Vault diagnostic settings, and Microsoft Sentinel.

AWS uses CloudTrail, KMS, and protected S3 audit storage.

OCI uses Vault, customer-managed encryption, Object Storage controls, and IAM policies supporting the implemented services.

The technologies differ because the enforcement points differ.

The security requirement can be common without pretending that the three cloud control planes are the same.

---

## Enterprise Governance Does Not Replace Cloud-Native Authorization

A central security organization can define a requirement such as:

**Administrative activity must be auditable.**

The actual enforcement may still occur inside the individual cloud.

Likewise:

**Sensitive storage must be protected from inappropriate public exposure.**

does not require Azure, AWS, and OCI to implement that requirement through identical services.

This creates an important division of responsibility:

**Enterprise Security defines required outcomes.**

**Cloud control planes enforce cloud-specific controls.**

**Workload owners operate applications within those controls.**

Those responsibilities can overlap, but they should not become indistinguishable.

A centralized security standard should not create the false assumption that the central security team directly controls every cloud authorization decision.

---

## Identity During the Transition

Identity is particularly sensitive during an acquisition because inherited environments may contain local administrators, service accounts, workload identities, external identities, and existing federation relationships.

The repository proposes Microsoft Entra ID as a future primary enterprise workforce identity provider.

That federation is not implemented by the current Terraform baseline.

This means the current architecture should not be interpreted as already having a centralized identity trust model across Azure, AWS, and OCI.

During transition, the enterprise needs to understand:

- Which local identities still exist.
- Which identities are privileged.
- Which identities belong to people who no longer require access.
- Which applications depend on service accounts.
- Which identities are used for emergency access.
- Which third parties retain access.
- Which identities can modify security controls.

Federation can later reduce workforce identity fragmentation, but federation itself creates a larger trust relationship.

If the enterprise IdP becomes trusted by multiple clouds, compromise or incorrect administration of that identity system can affect multiple environments.

Centralization simplifies governance while potentially increasing the blast radius of an identity failure.

That tradeoff belongs in the target-state architecture.

---

## Inherited Administration vs. Enterprise Administration

One of the most important transition points is administrative authority.

An acquired environment may initially depend on administrators from the acquired organization because they understand application dependencies and operating procedures.

Immediately removing that access could create business risk.

Leaving it indefinitely creates security risk.

The transition therefore needs a controlled movement from:

**Inherited Administrative Authority**

toward:

**Enterprise-Governed Administrative Authority**

That does not necessarily mean every administrator disappears.

It means privileged access eventually needs clear ownership, authentication requirements, authorization, monitoring, review, and removal criteria.

Temporary administrative arrangements should remain visible as transition decisions rather than silently becoming permanent architecture.

---

## The Exception Boundary

M&A environments rarely conform immediately to every enterprise security requirement.

That makes exception handling part of the security architecture rather than an administrative afterthought.

There are several different authorities involved:

**Workload owner** — understands the operational dependency.

**Security architecture or risk authority** — evaluates the security impact.

**Business owner** — understands the consequence of disruption.

**Cloud/platform team** — understands how the control is implemented.

An application owner may have a legitimate reason to request an exception.

That does not mean the application owner should independently decide that the associated security risk is acceptable.

Likewise, a security team should understand business impact before forcing remediation that could interrupt an acquired business service.

A governed exception creates a controlled bridge between those responsibilities.

It should identify the requirement, gap, risk, business justification, compensating controls, owner, remediation plan, and review point.

The important boundary is between:

**requesting an exception**

and

**authorizing continued exposure to the risk.**

---

## Central Monitoring Has a Boundary Too

The scenario uses Azure as the enterprise monitoring anchor.

The implemented Microsoft Sentinel capability currently processes Azure telemetry only.

That means there is a real monitoring boundary:

```text
Azure telemetry → Sentinel → Implemented

AWS telemetry → Sentinel → Not implemented

OCI telemetry → Sentinel → Not implemented
```

The existence of a central SIEM does not automatically create centralized visibility.

AWS and OCI would require telemetry collection, transport, normalization, mapping, and detection logic before the enterprise could claim meaningful centralized monitoring of those environments.

Until then, the enterprise has different levels of visibility across the three clouds.

That difference matters during incident investigation.

An analyst should know whether an absence of Sentinel evidence means:

**nothing happened**

or:

**that environment is not yet providing the required telemetry.**

Those are very different conclusions.

---

## Cloud Ownership Does Not Create Cloud-to-Cloud Trust

Azure, AWS, and OCI are part of the same enterprise scenario.

That does not mean they should automatically trust each other.

A future application dependency between clouds should establish only the connectivity and authorization required for that dependency.

The architecture should avoid turning enterprise ownership into broad network or identity trust between cloud environments.

For example, introducing private connectivity between clouds would not by itself justify unrestricted routing between workloads.

Likewise, centralized workforce identity would not mean that every federated user should receive equivalent authority in every cloud.

Enterprise integration should make trust more explicit, not broader.

---

## Security Controls Are Also Administrative Assets

The controls introduced during the acquisition can themselves become targets.

Examples include:

- Azure Policy definitions and assignments.
- Sentinel configuration.
- Log Analytics configuration.
- AWS CloudTrail.
- CloudTrail log storage.
- AWS KMS.
- OCI Vault.
- OCI IAM policies.
- Terraform state and deployment credentials.

An identity capable of disabling logging, changing a guardrail, weakening key policy, or altering the infrastructure definition may have more security impact than an identity operating an ordinary workload.

Administrative access to the security control plane therefore needs its own protection.

The team subject to a security control should not automatically have unrestricted authority to disable the control or erase the evidence it produces.

---

## The Target State Is a Security Decision

Not every inherited workload has to reach the same destination.

After discovery, risk reduction, and stabilization, workloads may be:

- Retained.
- Modernized.
- Migrated.
- Consolidated.
- Replatformed.
- Retired.

The security architecture supports that decision rather than assuming the answer in advance.

A workload retained in AWS can still meet enterprise security requirements.

An OCI workload does not necessarily need to move to Azure simply because Azure is the acquiring organization's primary platform.

Conversely, preserving an inherited platform should not be used as a reason to preserve unnecessary inherited security risk.

The decision should consider business value, security exposure, operational dependency, cost, resilience, and long-term ownership.

---

## How Trust Changes During the Acquisition

The overall security transition is not:

**Acquired → Trusted**

It is closer to:

```text
Acquire
   ↓
Discover what exists
   ↓
Identify who has authority
   ↓
Establish visibility
   ↓
Protect critical assets
   ↓
Introduce minimum guardrails
   ↓
Govern necessary exceptions
   ↓
Reduce inherited administrative risk
   ↓
Determine the target state
```

Trust increases as evidence, control, and ownership improve.

The objective is not to make three clouds identical.

It is to reach a point where the enterprise can explain:

**Who administers each environment?**

**Which identities are trusted?**

**Where are security requirements enforced?**

**Who can change those controls?**

**Which deviations have been explicitly accepted?**

**What evidence exists when something goes wrong?**

That is the security boundary created by M&A integration.
