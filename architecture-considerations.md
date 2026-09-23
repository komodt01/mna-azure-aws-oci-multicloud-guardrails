# Architecture Considerations — M&A Multi-Cloud Integration

## The Architecture Problem After the Baseline

The immediate security problem following an acquisition is reducing uncertainty and material exposure without disrupting inherited business services.

The longer-term architecture problem is different:

**What should the enterprise ultimately do with the environments it inherited?**

The implemented project establishes selected security controls across Azure, AWS, and OCI. The accompanying trust-boundary analysis examines how authority, visibility, control, and trust change as those environments come under enterprise governance.

The considerations below address decisions that remain after an initial security baseline has been established.

They are architecture considerations, not capabilities implemented by this project.

---

## Decision 1 — What Must Be Standardized Now?

The enterprise does not need every cloud to use identical technology.

It does need to determine which security outcomes are non-negotiable.

Examples may include:

- Administrative activity must be attributable.
- Critical security events must be retained.
- Sensitive data must be appropriately encrypted.
- Public exposure must be explicitly authorized.
- Privileged access must be controlled.
- Security controls must not be silently disabled.
- Material security exceptions must have accountable owners.
- Critical assets must have identified operational ownership.

The architecture question is therefore not:

**Can Azure, AWS, and OCI be configured identically?**

It is:

**Which security requirements must every environment satisfy, and what evidence demonstrates that each environment satisfies them?**

This allows enterprise governance to remain consistent while implementation remains appropriate to each cloud platform.

---

## Decision 2 — What Should Remain Cloud-Specific?

Standardizing a security requirement does not automatically justify replacing a cloud-native capability.

AWS, Azure, and OCI have different identity models, logging services, key-management capabilities, policy mechanisms, network constructs, and operational tooling.

Replacing effective native controls solely for technical uniformity can introduce:

- Additional dependencies.
- Operational complexity.
- Integration failure modes.
- Increased cost.
- Loss of platform-specific capability.
- New skills requirements.
- Additional migration risk.

The architecture should therefore distinguish between:

**Enterprise security requirement**

and

**Cloud-specific enforcement mechanism**

For example, the enterprise may require protected administrative audit evidence without requiring all three clouds to generate and store that evidence using the same service.

Cloud-specific implementation is acceptable when the resulting security outcome, ownership, and evidence satisfy the enterprise requirement.

---

## Decision 3 — Which Inherited Risks Can Temporarily Remain?

An acquisition can reveal security conditions that cannot all be corrected immediately.

Some controls may be missing.

Some workloads may depend on configurations that do not meet the acquiring organization's standards.

Some remediation may require application changes, testing, vendor involvement, downtime, or business approval.

The architecture therefore needs a way to distinguish:

**Unacceptable exposure requiring immediate action**

from

**Temporary risk that can be governed while remediation is planned**

That decision should consider factors such as:

- Business criticality.
- Data sensitivity.
- Internet exposure.
- Administrative privilege.
- Threat likelihood.
- Existing compensating controls.
- Potential blast radius.
- Regulatory obligations.
- Remediation complexity.
- Business disruption.
- Planned workload disposition.

Temporary acceptance should not become permanent through inattention.

Where risk is intentionally retained, the organization should establish an owner, rationale, compensating controls, remediation plan, and review or expiration point.

The security exception becomes part of the transition architecture.

---

## Decision 4 — Who Has Authority During the Transition?

M&A integration creates overlapping administrative models.

The acquiring organization may have enterprise security teams, identity administrators, cloud platform teams, and centralized operations.

The acquired organization may still have administrators who understand systems that the acquiring organization does not yet fully understand.

Removing inherited access too quickly can create operational risk.

Leaving inherited authority unchanged indefinitely creates security risk.

The architecture therefore needs an explicit transition of administrative authority.

Questions include:

- Who currently administers each cloud environment?
- Which inherited administrators still require access?
- Which enterprise teams require new access?
- Who may change security guardrails?
- Who may modify logging?
- Who controls encryption keys?
- Who may create or approve exceptions?
- Who owns incident response?
- Who can change Terraform or deployment credentials?
- Which administrative privileges should be separated?
- When should inherited privileges be reduced or removed?

Administrative transition should be treated as an architecture workstream rather than merely an account-cleanup activity.

The objective is to move from inherited authority to deliberate authority without creating either an operational vacuum or unnecessary persistent privilege.

---

## Decision 5 — What Evidence Is Enough to Claim Control?

Deploying a security control and proving that the security requirement is being met are different things.

For example:

**CloudTrail enabled**

does not automatically prove:

**All required AWS administrative activity is available for investigation.**

Likewise:

**Microsoft Sentinel exists**

does not mean:

**Azure, AWS, and OCI all have centralized monitoring.**

The current implementation intentionally maintains this distinction. Sentinel provides selected Azure monitoring, while AWS and OCI telemetry ingestion into Sentinel is not implemented.

As integration progresses, the enterprise should define what evidence is required for each security requirement.

Evidence may include:

- Configuration state.
- Policy evaluation.
- Audit records.
- Detection results.
- Access reviews.
- Encryption configuration.
- Exception records.
- Change history.
- Test results.
- Incident evidence.

This creates an important architecture progression:

**Requirement → Control → Evidence → Evaluation → Decision**

Without evidence, the enterprise may have deployed controls without being able to demonstrate that those controls provide the intended outcome.

---

## Decision 6 — When Does Temporary Architecture Become Technical Debt?

M&A programs frequently introduce interim arrangements.

Examples could include:

- Separate identity systems.
- Temporary administrative roles.
- Duplicate monitoring tools.
- Manual evidence collection.
- Transitional network paths.
- Cloud-specific exception processes.
- Temporary logging destinations.
- Multiple deployment mechanisms.
- Workloads retained on platforms expected to change later.

Temporary architecture is not automatically poor architecture.

It becomes a problem when the organization no longer knows:

- Why the temporary state exists.
- Who owns it.
- Which risk it introduces.
- What condition should cause it to change.
- Whether it is still required.
- When it should be reviewed.

Transitional architecture should therefore have an explicit reason and exit condition.

A useful distinction is:

**Temporary by decision**

versus

**Permanent by neglect**

Architecture review should identify when an interim M&A control has crossed from intentional transition state into unmanaged technical or security debt.

---

## Decision 7 — What Determines the Target State?

The target state should not be predetermined solely by the acquiring organization's preferred cloud.

An inherited AWS or OCI workload may remain where it is if that decision provides acceptable security, resilience, operational support, cost, and business value.

Another workload may be a strong candidate for migration, modernization, consolidation, or retirement.

Possible outcomes include:

- Retain.
- Modernize.
- Replatform.
- Migrate.
- Consolidate.
- Retire.

The decision should consider:

- Business value.
- Data sensitivity.
- Security exposure.
- Application dependencies.
- Resilience requirements.
- Regulatory requirements.
- Platform capability.
- Operational skills.
- Vendor dependencies.
- Migration complexity.
- Cost.
- Long-term ownership.
- Technical debt.

Security architecture contributes to the decision but does not make the decision based on security in isolation.

The target state should reflect the combined business and technology context of the workload.

---

## A Practical Architecture Decision Test

For each inherited workload or cloud capability, the architecture review should be able to answer:

**What does it support?**

**Who owns it?**

**Who administers it?**

**What data does it process?**

**Which enterprise security requirements apply?**

**Which controls currently satisfy those requirements?**

**What evidence demonstrates that they work?**

**Which requirements are not satisfied?**

**What risk exists because of those gaps?**

**Can that risk temporarily remain?**

**Who owns the exception?**

**What is the intended long-term disposition?**

**What event or date should trigger the next architecture decision?**

If those questions cannot be answered, the organization does not yet have enough information to treat the inherited environment as fully integrated.

---

## Architecture Perspective

The goal of M&A cloud security is not immediate technical uniformity.

It is to move deliberately from:

**Inherited environment → Understood environment → Governed environment → Deliberate target state**

That transition requires both security controls and architecture decisions.

The enterprise should be able to explain not only which controls exist, but also:

**Why a control is required → Who owns it → Where it is enforced → What evidence it produces → Which exceptions remain → Why the workload is staying, changing, or leaving**

The resulting architecture may continue to use multiple cloud platforms.

What matters is that differences between those platforms are **understood and governed rather than simply inherited**.
