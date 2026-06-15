---
name: pci-dss
description: "PCI-DSS (Payment Card Industry Data Security Standard) compliance checklist. Validates cardholder data protection, encryption, access control, network security, and vulnerability management. Use when processing, storing, or transmitting payment card data."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev, devops
  phase: review, planning
---

# PCI-DSS Compliance Skill

You are executing a **PCI-DSS (Payment Card Industry Data Security Standard)** compliance assessment.

**Scope:** This skill applies whenever the project processes, stores, or transmits payment card data (cardholder data or sensitive authentication data).

---

## Applicability

This skill is **required** if the project:
- Stores primary account numbers (PANs)
- Processes card payments
- Transmits cardholder data
- Stores card verification codes (CVV/CVC) — although this is generally prohibited
- Touches payment card data in any way

This skill is **not required** if the project uses fully tokenized payment flows where card data never touches your systems.

---

## Data Protection

- [ ] **No CVV Storage**: Card verification codes are never stored after authorization
- [ ] **PAN Encryption**: Primary account numbers encrypted at rest with AES-256 or equivalent
- [ ] **Transmission Encryption**: TLS 1.2+ for all cardholder data transmission
- [ ] **PAN Masking**: PAN masked when displayed (show only first 6 / last 4 digits)
- [ ] **Key Management**: Cryptographic keys managed securely (HSM or KMS)
- [ ] **Key Rotation**: Keys rotated per policy
- [ ] **Data Retention**: Cardholder data retained only as long as necessary
- [ ] **Data Disposal**: Secure deletion procedures for cardholder data

---

## Access Control

- [ ] **Least Privilege**: Access to cardholder data restricted to need-to-know
- [ ] **Role-Based Access**: Roles defined and enforced
- [ ] **Strong Authentication**: Multi-factor authentication for all access to cardholder data
- [ ] **Unique User IDs**: No shared accounts
- [ ] **Access Review**: Regular review of access rights
- [ ] **Audit Trail**: All access to cardholder data logged with user, action, timestamp

---

## Network Security

- [ ] **Network Segmentation**: Cardholder data environment (CDE) isolated from other networks
- [ ] **Firewalls**: Perimeter and internal firewalls configured and reviewed
- [ ] **No Default Passwords**: All default passwords changed
- [ ] **Inbound/Outbound Traffic**: Traffic restricted to necessary ports and protocols
- [ ] **Wireless Security**: Wireless networks secured if part of CDE
- [ ] **Vulnerability Scanning**: Regular external and internal scans

---

## Vulnerability & Patch Management

- [ ] **Security Patches**: Critical patches applied within 30 days
- [ ] **Vulnerability Scanning**: Quarterly scans by approved vendors
- [ ] **Penetration Testing**: Annual penetration testing
- [ ] **Antivirus/Antimalware**: Deployed and kept current
- [ ] **Secure Development**: SDLC includes security reviews
- [ ] **Dependency Management**: No known CVEs in dependencies

---

## Code-Level Checks

- [ ] No PAN or CVV in logs, errors, or URLs
- [ ] No cardholder data in session storage or local storage
- [ ] Payment forms served over HTTPS with HSTS
- [ ] Tokenization preferred over storing PANs
- [ ] Input validation on all payment fields
- [ ] Secure handling of payment callbacks and webhooks
- [ ] Audit logs for all payment transactions

---

## Report Format

```markdown
# PCI-DSS Assessment Report

## Scope: [module/feature assessed]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Findings

### Data Protection — [🔴|🟡|✅]
[findings]

### Access Control — [🔴|🟡|✅]
[findings]

### Network Security — [🔴|🟡|✅]
[findings]

### Vulnerability Management — [🔴|🟡|✅]
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

1. **Tokenization is preferred** — avoid storing cardholder data whenever possible
2. **Any card data exposure is blocking** — PAN/CVV in logs or URLs is critical
3. **Evidence-based** — require scan reports, pentest reports, and configuration audits
4. **Cross-reference with secure-coder** for code-level findings
5. **SAQ vs. ROC** — determine validation level based on transaction volume
