---
name: compliance-eu
description: "EU regulatory compliance checklist covering GDPR (personal data protection), DORA (digital operational resilience), MiCA (crypto asset markets), PSD2 (payment services), and PCI-DSS (payment card security). Applies conditionally based on project scope. Use when reviewing features that handle personal data, financial transactions, or crypto operations."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev
  phase: review, planning
---

# EU Compliance Skill

You are executing an **EU Regulatory Compliance Assessment** for a banking/financial
software project. This skill covers the major EU regulatory frameworks that apply
to financial technology.

## Applicability Assessment

Before running the full checklist, determine which regulations apply:

| Regulation | Applies When |
|-----------|-------------|
| **GDPR** | Any processing of personal data (names, emails, IPs, cookies, financial identifiers) |
| **DORA** | Financial entities or ICT service providers to financial entities |
| **MiCA** | Crypto-asset issuance, trading, custody, or stablecoin operations |
| **PSD2** | Payment initiation, account information services, electronic money |
| **PCI-DSS** | Processing, storing, or transmitting payment card data |

**Skip inapplicable sections** based on the project scope. Always document which
regulations were assessed and why others were skipped.

---

## GDPR — General Data Protection Regulation

### Data Processing Principles
- [ ] **Lawfulness**: Legal basis identified for each processing activity (consent, contract, legal obligation, legitimate interest)
- [ ] **Purpose Limitation**: Data collected for specified, explicit, legitimate purposes only
- [ ] **Data Minimization**: Only data that is necessary for the purpose is collected
- [ ] **Accuracy**: Mechanisms to keep personal data accurate and up to date
- [ ] **Storage Limitation**: Retention periods defined and enforced for all personal data
- [ ] **Integrity & Confidentiality**: Appropriate security measures for personal data

### Data Subject Rights
- [ ] **Right of Access**: Users can request and receive their personal data
- [ ] **Right to Rectification**: Users can correct inaccurate personal data
- [ ] **Right to Erasure**: Users can request deletion of their personal data ("right to be forgotten")
- [ ] **Right to Portability**: Users can export their data in machine-readable format
- [ ] **Right to Restrict Processing**: Users can limit how their data is used
- [ ] **Right to Object**: Users can object to processing based on legitimate interest

### Technical Requirements
- [ ] **Privacy by Design**: Privacy considerations embedded in architecture
- [ ] **Privacy by Default**: Most privacy-protective settings as default
- [ ] **Data Protection Impact Assessment (DPIA)**: Conducted for high-risk processing
- [ ] **Encryption**: Personal data encrypted at rest (AES-256) and in transit (TLS 1.2+)
- [ ] **Pseudonymization**: Where possible, personal data pseudonymized
- [ ] **Access Controls**: Role-based access to personal data with audit trail
- [ ] **Breach Notification**: Process to notify authorities within 72 hours of breach
- [ ] **Records of Processing**: Maintained for all processing activities

### Code-Level Checks
- [ ] No PII in log statements
- [ ] No PII in error messages returned to clients
- [ ] No PII in URL parameters or query strings
- [ ] No PII in local storage / session storage without encryption
- [ ] Consent withdrawal mechanism implemented
- [ ] Data export endpoint available for portability
- [ ] Data deletion cascade works correctly across all tables

---

## DORA — Digital Operational Resilience Act

### ICT Risk Management
- [ ] **Risk Assessment**: ICT risks identified, assessed, and documented
- [ ] **Protection Measures**: Preventive controls implemented (firewalls, IDS, WAF)
- [ ] **Detection**: Anomaly detection and monitoring in place
- [ ] **Response & Recovery**: Incident response plan documented and tested
- [ ] **Backup**: Regular backups with tested restoration procedures
- [ ] **Business Continuity**: BCP covers ICT disruptions

### ICT Incident Reporting
- [ ] **Classification**: Incident classification scheme defined (major/significant)
- [ ] **Detection Mechanisms**: Automated alerting for ICT incidents
- [ ] **Reporting Timeline**: Process to report major incidents within regulatory deadlines
- [ ] **Root Cause Analysis**: Post-incident review process
- [ ] **Communication Plan**: Stakeholder notification procedures

### Resilience Testing
- [ ] **Scenario Testing**: ICT resilience tested against failure scenarios
- [ ] **Penetration Testing**: Regular TIBER-EU or equivalent tests
- [ ] **Failover Testing**: Backup systems tested periodically
- [ ] **Load Testing**: Systems tested under stress conditions

### Third-Party Risk
- [ ] **Vendor Assessment**: ICT third-party providers assessed for risk
- [ ] **Contractual Clauses**: DORA compliance clauses in contracts
- [ ] **Monitoring**: Ongoing monitoring of critical third-party providers
- [ ] **Exit Strategy**: Plan for switching providers if needed

---

## MiCA — Markets in Crypto-Assets Regulation

### Authorization & Licensing
- [ ] **CASPs**: Crypto-asset service providers properly authorized
- [ ] **White Paper**: Compliant white paper for any token issuance
- [ ] **Capital Requirements**: Minimum capital maintained as required

### Consumer Protection
- [ ] **Risk Warnings**: Clear, prominent risk disclosures for crypto products
- [ ] **Suitability Assessment**: Appropriateness tests for retail clients
- [ ] **Complaints Handling**: Formal complaints procedure
- [ ] **Conflict of Interest**: Policies to identify and manage conflicts

### Market Integrity
- [ ] **Market Abuse Prevention**: Systems to detect insider dealing and manipulation
- [ ] **Transaction Reporting**: Reporting obligations to competent authorities
- [ ] **Orderly Trading**: Measures to ensure orderly trading conditions

### Stablecoin Requirements (If Applicable)
- [ ] **Reserve Assets**: Adequate reserves maintained for stablecoin backing
- [ ] **Redemption Rights**: Holders can redeem at any time
- [ ] **Governance**: Proper governance of reserve management
- [ ] **Transparency**: Regular reporting on reserve composition

---

## PSD2 — Payment Services Directive 2

### Strong Customer Authentication (SCA)
- [ ] **Multi-Factor**: At least 2 of: knowledge, possession, inherence
- [ ] **Dynamic Linking**: Authentication linked to specific transaction amount/payee
- [ ] **Exemptions**: Proper application of SCA exemptions (low value, recurring, etc.)

### API Security
- [ ] **Open Banking APIs**: Compliant with RTS on SCA and CSC
- [ ] **Access Control**: Proper authorization for payment initiation and account access
- [ ] **Certificate-Based Auth**: eIDAS certificates for PSP identification

### Transaction Monitoring
- [ ] **Real-time Monitoring**: Transaction monitoring for fraud detection
- [ ] **Risk Scoring**: Transaction risk analysis for SCA exemption decisions
- [ ] **Reporting**: Suspicious transaction reporting to authorities

---

## PCI-DSS — Payment Card Industry Data Security Standard

### Data Protection
- [ ] **No Storage**: Card verification codes (CVV) never stored after authorization
- [ ] **Encryption**: Cardholder data encrypted at rest and in transit
- [ ] **Masking**: PAN masked when displayed (show only first 6 / last 4)
- [ ] **Key Management**: Cryptographic keys managed securely

### Access Control
- [ ] **Least Privilege**: Access to cardholder data restricted to need-to-know
- [ ] **Authentication**: Strong authentication for all access to cardholder data
- [ ] **Audit Trail**: All access to cardholder data logged

### Network Security
- [ ] **Segmentation**: Cardholder data environment isolated from other networks
- [ ] **Firewall**: Firewall rules reviewed and restrictive
- [ ] **No Default Passwords**: All default passwords changed

---

## Compliance Report Format

```markdown
# EU Compliance Assessment Report

## Project: {{PROJECT_NAME}}
## Date: YYYY-MM-DD
## Scope: [what was assessed]

## Applicability
| Regulation | Applicable | Reason |
|-----------|-----------|--------|
| GDPR | Yes/No | [reason] |
| DORA | Yes/No | [reason] |
| MiCA | Yes/No | [reason] |
| PSD2 | Yes/No | [reason] |
| PCI-DSS | Yes/No | [reason] |

## Findings

### GDPR — [🔴|🟡|✅]
[findings with severity]

### DORA — [🔴|🟡|✅]
[findings with severity]

### MiCA — [🔴|🟡|✅]
[findings with severity]

### PSD2 — [🔴|🟡|✅]
[findings with severity]

### PCI-DSS — [🔴|🟡|✅]
[findings with severity]

## Summary
- 🔴 Critical Compliance Gaps: X
- 🟡 Recommendations: Y
- **Overall Compliance Status**: [COMPLIANT | PARTIAL | NON-COMPLIANT]

## Action Items
1. [priority action to achieve compliance]
```

## Rules

1. **Assess applicability first** — do not run irrelevant checks
2. **Evidence-based** — cite specific code, configurations, or documentation
3. **Severity-appropriate** — PII exposure and data breaches are always critical
4. **Actionable** — every finding includes a remediation recommendation
5. **Stay current** — reference the latest regulatory guidance
