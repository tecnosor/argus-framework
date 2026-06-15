---
name: gdpr
description: "GDPR (General Data Protection Regulation) compliance checklist. Validates data processing principles, data subject rights, encryption, PII handling, and privacy-by-design. Use when reviewing features that process personal data of EU residents."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev, frontend-dev
  phase: review, planning
---

# GDPR Compliance Skill

You are executing a **GDPR (General Data Protection Regulation)** compliance assessment.

**Scope:** This skill applies whenever the project processes personal data of EU residents.
Personal data includes: names, emails, phone numbers, addresses, IPs, cookies, financial identifiers, and any data that can identify a natural person.

---

## Applicability

This skill is **required** if the project:
- Stores, processes, or transfers personal data
- Has EU users or customers
- Handles customer profiles, KYC data, or account information
- Uses cookies, analytics, or tracking

This skill is **not required** if the project processes only anonymized or fully synthetic data.

---

## Data Processing Principles

- [ ] **Lawfulness**: A valid legal basis is identified for each processing activity
  - Consent (freely given, specific, informed, unambiguous)
  - Contract (necessary for a contract)
  - Legal obligation (required by law)
  - Vital interests (life or death)
  - Public task (official authority)
  - Legitimate interests (balanced against user rights)
- [ ] **Purpose Limitation**: Data is collected only for specified, explicit, and legitimate purposes
- [ ] **Data Minimization**: Only data strictly necessary for the purpose is collected
- [ ] **Accuracy**: Personal data is kept accurate and up to date
- [ ] **Storage Limitation**: Retention periods are defined, documented, and enforced
- [ ] **Integrity & Confidentiality**: Appropriate technical and organizational measures protect personal data
- [ ] **Accountability**: The organization demonstrates compliance with records and policies

---

## Data Subject Rights

Verify that mechanisms exist for:

- [ ] **Right of Access**: Users can request and receive a copy of their personal data
- [ ] **Right to Rectification**: Users can correct inaccurate or incomplete data
- [ ] **Right to Erasure**: Users can request deletion of their data ("right to be forgotten")
- [ ] **Right to Portability**: Users can export their data in a structured, machine-readable format
- [ ] **Right to Restrict Processing**: Users can limit how their data is used
- [ ] **Right to Object**: Users can object to processing based on legitimate interests or direct marketing
- [ ] **Rights Related to Automated Decision-Making**: Users can contest decisions made solely by automated means

---

## Technical Requirements

- [ ] **Privacy by Design**: Privacy considerations are embedded in architecture from the start
- [ ] **Privacy by Default**: The most privacy-protective settings are the default
- [ ] **Data Protection Impact Assessment (DPIA)**: Conducted for high-risk processing
- [ ] **Encryption at Rest**: Personal data encrypted with AES-256 or equivalent
- [ ] **Encryption in Transit**: TLS 1.2+ for all data transmission
- [ ] **Pseudonymization**: Applied where possible to reduce risk
- [ ] **Access Controls**: Role-based access with principle of least privilege
- [ ] **Audit Logging**: All access to personal data is logged (who, when, why)
- [ ] **Breach Notification**: Process to notify supervisory authorities within 72 hours
- [ ] **Records of Processing**: Maintained for all processing activities (Article 30)
- [ ] **Data Processing Agreements (DPA)**: In place with all processors and sub-processors

---

## Code-Level Checks

- [ ] No personal data in log statements
- [ ] No personal data in error messages returned to clients
- [ ] No personal data in URL parameters or query strings
- [ ] No personal data in browser local/session storage without encryption
- [ ] Consent withdrawal mechanism implemented and honored
- [ ] Data export endpoint available for portability requests
- [ ] Data deletion cascade works correctly across all tables
- [ ] PII is masked or tokenized where full value is not required

---

## Report Format

```markdown
# GDPR Assessment Report

## Scope: [module/feature assessed]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Findings

### Data Processing Principles — [🔴|🟡|✅]
[findings]

### Data Subject Rights — [🔴|🟡|✅]
[findings]

### Technical Requirements — [🔴|🟡|✅]
[findings]

### Code-Level Checks — [🔴|🟡|✅]
[findings]

## Summary
- 🔴 Critical: X
- 🟡 Warning: Y
- ✅ Pass: Z
- **Status**: [COMPLIANT | PARTIAL | NON-COMPLIANT]

## Action Items
1. [priority action]
```

---

## Rules

1. **Always assess applicability first** — do not run checks if GDPR does not apply
2. **Evidence-based findings** — cite specific code, configurations, or documentation
3. **PII exposure is always blocking** — any leak of personal data is critical
4. **Provide remediation** — every finding must include a fix recommendation
5. **Cross-reference with secure-coder skill** — PII in logs is also a secure-coder violation
