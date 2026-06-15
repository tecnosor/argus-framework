---
name: mica
description: "MiCA (Markets in Crypto-Assets Regulation) compliance checklist. Validates authorization, white paper requirements, consumer protection, market integrity, and stablecoin rules. Use for crypto-asset issuance, trading, custody, and stablecoin operations in the EU."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev, legal
  phase: review, planning
---

# MiCA Compliance Skill

You are executing a **MiCA (Markets in Crypto-Assets Regulation)** compliance assessment.

**Scope:** This skill applies to crypto-asset services, token issuers, trading platforms, custodians, and stablecoin operators in the EU.

---

## Applicability

This skill is **required** if the project:
- Issues crypto-assets or tokens
- Operates a crypto-asset trading platform or exchange
- Provides crypto-asset custody or administration services
- Issues or manages stablecoins (asset-referenced tokens or e-money tokens)
- Provides crypto-asset advice or portfolio management

This skill is **not required** if the project does not touch crypto-assets.

---

## Authorization & Licensing

- [ ] **CASPs Authorized**: Crypto-asset service providers are properly authorized by competent authorities
- [ ] **White Paper Filed**: A compliant white paper is filed for any token issuance
- [ ] **Marketing Communications**: All marketing materials are fair, clear, and not misleading
- [ ] **Capital Requirements**: Minimum capital maintained as required by MiCA
- [ ] **Management Body**: Fit and proper requirements met by management
- [ ] **Cross-Border Notifications**: Notifications filed for cross-border services

---

## Consumer Protection

- [ ] **Risk Warnings**: Clear, prominent, and non-misleading risk disclosures for retail clients
- [ ] **Suitability Assessment**: Appropriateness tests for retail clients where required
- [ ] **Complaints Handling**: Formal complaints procedure accessible to users
- [ ] **Conflict of Interest**: Policies to identify, manage, and disclose conflicts
- [ ] **Transparency**: Fees, costs, and risks disclosed clearly
- [ ] **No Unfair Commercial Practices**: No misleading incentives or aggressive marketing

---

## Market Integrity

- [ ] **Market Abuse Prevention**: Systems to detect and prevent insider dealing and market manipulation
- [ ] **Transaction Reporting**: Reporting obligations to competent authorities fulfilled
- [ ] **Orderly Trading**: Measures to ensure orderly trading conditions
- [ ] **Pre- and Post-Trade Transparency**: Transparency requirements met where applicable
- [ ] **Record Keeping**: Transaction records maintained for required periods
- [ ] **Suspicious Activity Monitoring**: Automated alerts for unusual trading patterns

---

## Stablecoin Requirements (If Applicable)

- [ ] **Reserve Assets**: Adequate reserves maintained and segregated
- [ ] **Redemption Rights**: Holders can redeem at any time at par value
- [ ] **Reserve Composition**: Transparent reporting on reserve composition
- [ ] **Custody of Reserves**: Reserves held by secure custodians
- [ ] **Governance**: Proper governance of reserve management
- [ ] **Capital Requirements**: Higher capital requirements met for stablecoin issuers

---

## Code-Level Checks

- [ ] Transaction monitoring logs all crypto-asset transfers
- [ ] Travel Rule compliance for transfers above €1,000 (if applicable)
- [ ] Wallet ownership verification where required
- [ ] Audit trail for all custody operations
- [ ] Clear error messages for restricted jurisdictions or services
- [ ] Rate limiting and abuse prevention on trading endpoints
- [ ] Secure key management for custody operations

---

## Report Format

```markdown
# MiCA Assessment Report

## Scope: [module/feature assessed]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Findings

### Authorization & Licensing — [🔴|🟡|✅]
[findings]

### Consumer Protection — [🔴|🟡|✅]
[findings]

### Market Integrity — [🔴|🟡|✅]
[findings]

### Stablecoin Requirements — [🔴|🟡|✅]
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

1. **Skip if not crypto-related** — MiCA only applies to crypto-asset activities
2. **Legal + technical** — many MiCA requirements are legal/commercial, not purely code
3. **Stablecoins are high-risk** — stablecoin rules are stricter than other crypto-assets
4. **Evidence-based** — cite white papers, authorizations, and system designs
5. **Cross-reference with AML/KYC skills** if available
