---
name: psd2
description: "PSD2 (Payment Services Directive 2) compliance checklist. Validates strong customer authentication, API security, access control, and transaction monitoring for payment services in the EU."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev
  phase: review, planning
---

# PSD2 Compliance Skill

You are executing a **PSD2 (Payment Services Directive 2)** compliance assessment.

**Scope:** This skill applies to payment service providers (PSPs), banks, payment initiation services (PIS), account information services (AIS), and electronic money institutions in the EU/EEA.

---

## Applicability

This skill is **required** if the project:
- Initiates payments or transfers funds
- Provides account information aggregation
- Issues electronic money
- Operates as a payment institution or bank
- Exposes Open Banking APIs

This skill is **not required** if the project does not handle payments or account data.

---

## Strong Customer Authentication (SCA)

- [ ] **Two-Factor Authentication**: At least 2 of knowledge, possession, and inherence
- [ ] **Independent Factors**: Authentication elements are independent (one compromised does not compromise others)
- [ ] **Dynamic Linking**: Authentication linked to specific transaction amount and payee
- [ ] **SCA Exemptions**: Properly applied and documented exemptions:
  - Low-value transactions (below €30, cumulative limit €100 or 5 transactions)
  - Subscription/recurring transactions (same amount, same payee)
  - Merchant-initiated transactions
  - Secure corporate payment exemptions
  - Transaction risk analysis (TRA)
- [ ] **Revocation**: Stolen or lost authentication instruments can be revoked

---

## API Security (Open Banking)

- [ ] **eIDAS Certificates**: TPP identification via qualified certificates (QWACs/QSEALs)
- [ ] **Consent Management**: Explicit user consent for PIS and AIS
- [ ] **Access Scope**: Access limited to what user consented to
- [ ] **Token Management**: Secure OAuth tokens with expiry and refresh
- [ ] **API Versioning**: Proper versioning strategy for Open Banking APIs
- [ ] **Rate Limiting**: Per-TPP and per-endpoint rate limits
- [ ] **Error Handling**: Standardized error responses (XS2A)

---

## Transaction Monitoring

- [ ] **Real-Time Monitoring**: Transactions monitored for fraud in real time
- [ ] **Risk Scoring**: Transaction Risk Analysis (TRA) for SCA exemption decisions
- [ ] **Velocity Checks**: Unusual transaction patterns detected
- [ ] **Device Fingerprinting**: Device trust signals used where appropriate
- [ ] **Suspicious Transaction Reporting**: Process to report suspicious activity to authorities
- [ ] **User Notifications**: Users notified of suspicious or high-risk transactions

---

## Code-Level Checks

- [ ] SCA challenge flows implemented for sensitive operations
- [ ] Consent expiry and revocation handled correctly
- [ ] Payment amount and payee cannot be tampered with after SCA
- [ ] OAuth scopes enforced at API level
- [ ] Audit logs for all payment and account access events
- [ ] Idempotency keys for payment initiation endpoints
- [ ] Proper error codes returned for SCA failures and exemptions

---

## Report Format

```markdown
# PSD2 Assessment Report

## Scope: [module/feature assessed]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Findings

### Strong Customer Authentication — [🔴|🟡|✅]
[findings]

### API Security — [🔴|🟡|✅]
[findings]

### Transaction Monitoring — [🔴|🟡|✅]
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

1. **Skip if not payment-related** — PSD2 applies only to payment services
2. **SCA is the core requirement** — most PSD2 technical controls center on strong authentication
3. **Exemptions need evidence** — document why each SCA exemption applies
4. **Cross-reference with secure-coder and owasp-top10** for API security
5. **Open Banking standards vary by country** — confirm local regulator requirements
