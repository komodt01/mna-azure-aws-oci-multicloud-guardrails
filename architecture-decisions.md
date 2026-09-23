# Architecture Considerations — M&A Multi-Cloud Guardrails

## Architecture Decisions During an Acquisition

The first security architecture delivered during an acquisition is rarely the final architecture.

There is usually a period where inherited systems must continue operating while the acquiring organization learns how they work, who depends on them, what data they contain, and which security assumptions can safely change.

The architecture challenge is deciding what needs to change now, what can wait, and what evidence is required before accepting either decision.

---

## What Must Be Standardized Immediately?

Not every enterprise standard needs to be imposed on day one.

Some conditions, however, may represent enough risk that they require early action.

Examples could include:

- Unknown or unnecessary privileged access.
- Missing audit visibility.
- Uncontrolled public exposure.
- Unprotected sensitive data.
- Unmanaged encryption keys.
- High-risk legacy identities.
- Security controls that can be disabled without visibility.

The decision should be based on the consequence of leaving the condition in place, not simply on whether the acquired environment matches the acquiring organization's preferred architecture.

A useful question is:

**What could cause material harm before we finish the integration?**

Those conditions deserve priority.

---

## What Can Remain Cloud-Specific?

Standardization does not require identical technology.

AWS CloudTrail does not need to become an Azure service.

OCI Vault does not need to behave exactly like Azure Key Vault.

AWS IAM does not need to be replaced simply because the acquiring organization primarily operates Azure.

The enterprise should standardize outcomes where practical:

**Administrative activity is auditable.**

**Sensitive data is appropriately protected.**

**Privileged access is governed.**

**Security-relevant changes are visible.**

**Exceptions have owners and review dates.**

How those requirements are implemented can remain cloud-specific.

This reduces unnecessary migration work and preserves useful native capabilities while still moving the acquired environment toward an enterprise security model.

---

## What Risk Can Temporarily Remain?

An acquisition will often uncover controls that cannot be changed immediately without affecting business operations.

The architecture needs to distinguish between:

**risk that has not been discovered**

and

**risk that has been identified and deliberately accepted for a limited period.**

Those are not the same state.

Where immediate remediation is not appropriate, the decision should identify:

- The security gap.
- The business dependency.
- The consequence of leaving the gap in place.
- Any compensating controls.
- The accountable owner.
- The intended remediation.
- The point when the decision will be reviewed again.

An interim architecture becomes dangerous when temporary decisions stop having an expiration or reassessment point.

---

## Who Has Authority to Decide?

M&A security decisions cross organizational boundaries.

The acquired application team may understand the workload better than the acquiring security team.

The security team may understand the enterprise requirement better than the workload owner.

The business owner may understand the impact of disruption better than either.

The cloud platform team may understand the technical consequences of changing the control.

Architecture governance needs to bring those perspectives together without confusing their authority.

For example:

**A workload owner can explain why a guardrail creates an operational problem.**

That does not automatically make the workload owner the risk-acceptance authority.

Likewise:

**A security team can identify a control deficiency.**

That does not mean remediation should be automated without understanding the business impact.

Clear decision rights become particularly important during an acquisition because organizational responsibilities may still be changing.

---

## What Evidence Is Enough to Call an Environment Governed?

Deploying Terraform does not by itself establish governance.

Neither does connecting a cloud to a central security organization.

The enterprise should be able to demonstrate that important controls are operating and that someone is accountable for them.

Evidence might include:

- Administrative activity is being recorded.
- Required logs are reaching their intended destination.
- Critical storage protections are enabled.
- Encryption requirements are being met.
- Preventive guardrails actually deny prohibited configurations.
- Detective controls generate usable findings.
- Exceptions can be identified and traced to owners.
- Security-sensitive changes can be reviewed.
- Privileged identities are known.
- Control failures can be investigated.

The exact evidence will differ among Azure, AWS, and OCI.

The important point is that governance should be demonstrable rather than assumed.

---

## When Does the Interim Architecture Become Technical Debt?

Temporary M&A architecture is often necessary.

It can also become permanent without anyone explicitly deciding that it should.

Examples include:

- Local administrative accounts that were supposed to be temporary.
- Manual monitoring processes.
- Cloud-specific exceptions with no review date.
- Duplicate security tooling.
- Temporary network connectivity.
- Legacy service accounts.
- Incomplete telemetry integration.
- Transitional ownership models.

These decisions should eventually lead somewhere:

**Retain → Improve → Integrate → Migrate → Replace → Retire**

If the organization cannot explain which direction an interim control is moving, the transition architecture may be turning into unmanaged technical or security debt.

---

## A Practical Decision Test

For each inherited security condition, the architecture team should be able to ask:

**What is the risk?**

**Do we understand the dependency?**

**Can we safely enforce the enterprise requirement now?**

**If not, what protects us in the meantime?**

**Who owns the decision?**

**What evidence tells us the control is working?**

**When will we revisit the decision?**

That is more useful during an acquisition than trying to make every cloud conform immediately to the same technical design.

The objective is controlled convergence.

Some controls may converge quickly.

Some may remain cloud-native indefinitely.

Some workloads may ultimately leave the environment altogether.

The architecture should make those outcomes deliberate rather than accidental.
