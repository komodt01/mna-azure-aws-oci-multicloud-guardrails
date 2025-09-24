# Business Use Cases

*All numeric values (e.g., timeframes or costs) annotated like `30*` are fictional for this demo.*

Each scenario includes **Business Goal**, **When to Use**, **Architecture Response**, **Controls & Evidence**, **KPIs**, **Stakeholders**, and **Trade-offs**.

---

## 1) M&A Cloud Onboarding (AWS/OCI → Azure-Anchored)
**Business Goal:** Integrate an acquired company’s cloud resources under corporate guardrails fast, without breaking operations.  
**When to Use:** Day-1/Day-30 integration plans; fragmented accounts/tenancies; inconsistent logging/encryption.  
**Architecture Response:**  
- Deploy this repo’s **Azure landing zone** and **AWS/OCI baselines**.  
- Centralize activity logs; enforce **CMEK-by-default**; tag and segment environments.  
**Controls & Evidence:** NIST CSF (PR.AC, PR.DS, DE.AE), ISO 27001 (A.5, A.8, A.12), CSA CCM (IAM-12, EKM-02, LOG-01).  
- Evidence: Terraform state, policies, diagnostic settings, CloudTrail config, OCI Vault/KMS config.  
**KPIs:** `T_{day1}*` to baseline logs, `% accounts with CMEK`, `% resources with diagnostics`.  
**Stakeholders:** Corp SecArch, Cloud Platform, M&A Integrations, BU App Owners.  
**Trade-offs:** Speed vs. depth of controls; temporary exceptions tracked in ADRs.

---

## 2) Regulatory Uplift for Insurance/Financial Services
**Business Goal:** Meet PCI/ISO audits and client due-diligence with consistent, testable guardrails.  
**When to Use:** Upcoming audit, customer security questionnaire, or new regulated workload.  
**Architecture Response:**  
- Enforce **diagnostic settings** → Log Analytics; **multi-region CloudTrail**; **OCI Vault/KMS**.  
- Add Azure Policy/AWS Config/OCI Cloud Guard (extend from this baseline).  
**Controls & Evidence:** PCI DSS 10 (logging), 3 (encryption), ISO 27001 A.8/A.12, CSA CCM LOG-01/EKM-02.  
**KPIs:** `% resources auto-remediated`, `Mean time to evidence (MTEE*)`, `Policy compliance %`.  
**Stakeholders:** Compliance, Risk, Internal Audit, SecOps.  
**Trade-offs:** Stricter policies can slow experiments; document exceptions + compensating controls.

---

## 3) Data Protection Modernization (PII/PCI)
**Business Goal:** Reduce breach impact and audit findings by ensuring encryption and preventing public data exposure.  
**When to Use:** Handling PII/PCI; migrating sensitive data to cloud; prior findings on encryption/public buckets.  
**Architecture Response:**  
- **CMEK everywhere** (Azure Key Vault, AWS KMS, OCI Vault).  
- Detections for **public storage** & **no-CMEK** (see `monitoring/sentinel/detections`).  
**Controls & Evidence:** NIST PR.DS, ISO 27001 A.8/A.10, CSA CCM EKM-02.  
**KPIs:** `% storage with CMEK`, `# public exposure detections (↓)`, `Time to remediate*`.  
**Stakeholders:** Data Owners, App Teams, SecOps.  
**Trade-offs:** Key management overhead; rotation windows; cross-cloud key governance.

---

## 4) Post-Incident Hardening / Gap Closure
**Business Goal:** After an incident or red-team exercise, close monitoring & control gaps quickly.  
**When to Use:** Findings cite missing logs, no detections, or poor evidence quality.  
**Architecture Response:**  
- Centralize logs; deploy KQL detections; add playbooks for auto-response (SOAR).  
- Expand Terraform to cover more services with diagnostics by default.  
**Controls & Evidence:** NIST DE.AE/RS.AN, ISO 27001 A.12, CSA CCM LOG-01/IVS-06.  
**KPIs:** `MTTD/MTTR*`, `Alert fidelity`, `% services with diagnostics`.  
**Stakeholders:** IR team, CISO, Platform, App Owners.  
**Trade-offs:** Increased log costs; tune retention to `30*`/`90*` days per risk.

---

## 5) Regional Expansion & Data Residency
**Business Goal:** Enter new markets while respecting data-residency and sovereignty rules.  
**When to Use:** Opening EU/APAC regions; subject to GDPR/industry mandates.  
**Architecture Response:**  
- Spin up regionalized **guardrails** and **CMEK in-region**; ensure log storage stays in-region.  
- Use tagging to drive residency policies and routing.  
**Controls & Evidence:** GDPR Art. 5/32 (principles, security), ISO 27001 A.8, CSA CCM DSI-01.  
**KPIs:** `% data stores with in-region CMEK`, `% logs stored in-region`, `Residency policy violations`.  
**Stakeholders:** Legal/Privacy, Compliance, Platform, BU Leads.  
**Trade-offs:** Duplication of services; higher OPEX; cross-region latency.

---

## 6) Third-Party/Vendor Integration
**Business Goal:** Onboard vendor workloads safely with least privilege and full observability.  
**When to Use:** New SaaS/PaaS partner integration, data exchange, or private connectivity.  
**Architecture Response:**  
- Standardize **least-privilege roles**, **private connectivity**, and **central logging**.  
- Stipulate CMEK and logging in vendor contracts; validate via evidence artifacts.  
**Controls & Evidence:** NIST PR.AC/PR.DS, ISO 27001 A.5/A.9, CSA CCM IAM-12/SEF-02.  
**KPIs:** `Time-to-onboard*`, `# of exceptions`, `Evidence completeness score*`.  
**Stakeholders:** Vendor Mgmt, Security, Networking, App Owners.  
**Trade-offs:** Contract friction; additional onboarding steps.

---

## 7) Platform Engineering Guardrails (Golden Path)
**Business Goal:** Provide product teams a paved-road baseline that bakes in security & compliance.  
**When to Use:** Multiple teams deploying independently; need consistent controls and faster reviews.  
**Architecture Response:**  
- Publish this baseline as a **starter platform**; integrate with CI checks (OPA/Conftest) pre-merge.  
**Controls & Evidence:** CSA CCM SEF-02/IVS-12, ISO 27001 A.12.  
**KPIs:** `Lead time to deploy*`, `Policy compliance %`, `# review findings per release (↓)`.  
**Stakeholders:** Platform Eng, App Teams, Security Architecture.  
**Trade-offs:** Governance vs. flexibility; allow opt-outs via ADRs and exception workflow.