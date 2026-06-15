---
name: eidas
description: "eIDAS (Electronic Identification, Authentication and Trust Services) compliance checklist. Validates electronic identity, qualified signatures, trust services, and KYC/AML workflows. Use for banking KYC, digital onboarding, remote identification, and electronic signatures in the EU."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev, frontend-dev
  phase: review, planning
---

# eIDAS Compliance Skill

You are executing an **eIDAS (Electronic Identification, Authentication and Trust Services)** compliance assessment.

**Scope:** This skill applies to EU banking and financial services that use electronic identity, digital signatures, remote identification, or trust services for customer onboarding, KYC, or transaction authorization.

---

## Applicability

This skill is **required** if the project:
- Uses electronic identity verification for customer onboarding (KYC)
- Accepts or issues qualified electronic signatures (QES)
- Provides remote identification services
- Uses digital certificates or trust services
- Operates a trust service provider (TSP) or qualified trust service provider (QTSP)
- Integrates with national eID schemes (e.g., DNIe, BankID, Itsme)
- Processes cross-border electronic identity from other EU member states

This skill is **not required** if the project uses only username/password authentication without any electronic identity or trust service.

---

## Electronic Identification (eID)

### Levels of Assurance

| Level | Description | When Required |
|-------|-------------|---------------|
| **Low** | Self-asserted identity | Minimal risk operations |
| **Substantial** | Verified identity with evidence | Standard banking onboarding, KYC |
| **High** | Verified identity with rigorous evidence | High-risk transactions, QES issuance |

### Requirements
- [ ] **Identity Verification**: Customer identity verified against authoritative sources
- [ ] **Document Verification**: ID documents validated (e.g., passport, national ID)
- [ ] **Liveness Detection**: Biometric liveness check for remote identification
- [ ] **Biometric Matching**: Face-to-photo matching for remote onboarding
- [ ] **Cross-Border Recognition**: Other EU member states' eID recognized (eIDAS 2.0)
- [ ] **Identity Wallet**: Support for EU Digital Identity Wallet (eIDAS 2.0)
- [ ] **Audit Trail**: All identification events logged with timestamp and method
- [ ] **Data Retention**: Identification data retained only as long as legally required

---

## Qualified Electronic Signatures (QES)

### Requirements
- [ ] **QES Issuance**: Qualified certificates issued only by Qualified Trust Service Providers (QTSPs)
- [ ] **Signature Validation**: QES validated with proper certificate chain
- [ ] **Certificate Status**: OCSP or CRL checks for certificate revocation
- [ ] **Time Stamping**: Qualified electronic timestamps applied where required
- [ ] **Long-Term Validation**: PAdES-LTA or XAdES-LTA for long-term legal validity
- [ ] **Signature Creation**: Private key generated in secure environment (e.g., HSM, smart card)
- [ ] **Biometric Signature**: Optional dynamic biometric signature (pressure, speed, acceleration)
- [ ] **Signature Evidence**: All signature data (certificate, timestamp, audit) preserved

### Signature Types
- [ ] **Simple Electronic Signature (SES)**: Basic signature for low-risk operations
- [ ] **Advanced Electronic Signature (AdES)**: Identifiable signer, tamper-evident
- [ ] **Qualified Electronic Signature (QES)**: Highest assurance, legally equivalent to handwritten

---

## Trust Services

### Requirements
- [ ] **QTSP Validation**: Trust service provider is listed in EU Trusted List
- [ ] **Certificate Transparency**: Certificates logged in CT logs where applicable
- [ ] **Qualified Certificate**: EU Qualified Certificate for electronic seals (QSealC)
- [ ] **Qualified Timestamp**: Timestamp from qualified TSP for legal validity
- [ ] **Qualified Electronic Registered Delivery**: Registered delivery with proof of receipt
- [ ] **Qualified Preservation**: Long-term preservation of qualified signatures
- [ ] **Website Authentication**: Qualified website authentication certificates (QWACs) for PSD2

---

## KYC / AML Integration

- [ ] **Customer Identification**: Name, address, date of birth, national ID number verified
- [ ] **Beneficial Owner**: Ultimate beneficial owner (UBO) identified for corporate clients
- [ ] **PEP Screening**: Politically exposed persons screened
- [ ] **Sanctions Screening**: Customer screened against EU, OFAC, UN sanctions lists
- [ ] **Risk Assessment**: Customer risk profile established (low, medium, high)
- [ ] **Ongoing Monitoring**: Customer transactions monitored against risk profile
- [ ] **Document Retention**: KYC documents retained for regulatory period (typically 5 years)
- [ ] **Re-identification**: Re-identification triggered when customer data changes significantly

---

## PSD2 API Authentication (eIDAS Certificates)

- [ ] **QWAC**: Qualified Website Authentication Certificate for TPP identification
- [ ] **QSealC**: Qualified Electronic Seal Certificate for message signing
- [ ] **Certificate Validation**: Certificate validated against EU Trusted List
- [ ] **Mutual TLS**: mTLS with eIDAS certificates for XS2A APIs
- [ ] **Certificate Expiry**: Expiry monitoring and renewal process
- [ ] **Certificate Revocation**: Revocation handled gracefully (OCSP stapling)

---

## Code-Level Checks

- [ ] Identity verification flow is idempotent (no duplicate accounts for same person)
- [ ] Biometric data encrypted at rest and in transit (never stored in plain text)
- [ ] Document images deleted after verification (only metadata retained)
- [ ] Signature private keys never leave the secure device (HSM, smart card, mobile secure element)
- [ ] Certificate validation library configured with EU Trusted List
- [ ] KYC data access is role-based and audited
- [ ] Cross-border eID recognized (eIDAS 2.0 interoperability)
- [ ] Fallback authentication for non-eIDAS users (e.g., non-EU residents)

---

## eIDAS 2.0 (Future Considerations)

- [ ] **EU Digital Identity Wallet**: Support for EU Wallet-based identity
- [ ] **Selective Disclosure**: Users can share only necessary attributes
- [ ] **Zero-Knowledge Proofs**: Cryptographic proof of identity without revealing data
- [ ] **QR Code Authentication**: Wallet-based QR code authentication for online banking
- [ ] **Attestation**: Verifiable credentials from government issuers

---

## Report Format

```markdown
# eIDAS Assessment Report

## Scope: [module/feature assessed]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Findings

### Electronic Identification — [🔴|🟡|✅]
[findings]

### Qualified Electronic Signatures — [🔴|🟡|✅]
[findings]

### Trust Services — [🔴|🟡|✅]
[findings]

### KYC / AML — [🔴|🟡|✅]
[findings]

### PSD2 API Authentication — [🔴|🟡|✅]
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

1. **QES is legally binding** — treat it as equivalent to a handwritten signature
2. **Biometric data is sensitive** — apply GDPR protections to biometric data
3. **Cross-border eID must be recognized** — eIDAS 2.0 mandates interoperability
4. **Trust services must be qualified** — only QTSPs can issue QES certificates
5. **KYC data is high-risk** — protect it with the same rigor as payment data
6. **Cross-reference with GDPR** — eIDAS data is personal data
7. **Cross-reference with PSD2** — eIDAS certificates authenticate TPPs
8. **Cross-reference with AML** — KYC requirements overlap with AML
