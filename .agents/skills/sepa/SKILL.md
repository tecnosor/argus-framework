---
name: sepa
description: "SEPA (Single Euro Payments Area) compliance checklist. Validates SEPA Credit Transfer, SEPA Direct Debit, and SEPA Instant payments. Checks IBAN/BIC rules, scheme compliance, mandate management, and settlement timing. Use for euro payment processing in the EU/EEA."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev
  phase: review, planning
---

# SEPA Compliance Skill

You are executing a **SEPA (Single Euro Payments Area)** compliance assessment.

**Scope:** This skill applies to all euro payment processing within the EU/EEA, including SEPA Credit Transfer, SEPA Direct Debit, and SEPA Instant Credit Transfer.

---

## Applicability

This skill is **required** if the project:
- Initiates or receives SEPA credit transfers
- Manages SEPA direct debits (CORE or B2B scheme)
- Processes SEPA instant payments
- Holds SEPA mandates or creditor identifiers
- Integrates with SEPA clearing mechanisms (STEP2, RT1, TIPS)

This skill is **not required** if the project only handles non-euro currencies or non-EEA payments.

---

## SEPA Credit Transfer (SCT)

### Requirements
- [ ] **IBAN Only**: Payments use IBAN; BIC is optional for intra-EEA transfers
- [ ] **Euro Currency**: Amounts denominated in EUR
- [ ] **Maximum Execution Time**: D+1 for standard SCT (next business day)
- [ ] **Amount Limits**: No maximum amount limit (national limits may apply)
- [ ] **Purpose Codes**: Valid ISO 20022 purpose codes used
- [ ] **Remittance Information**: Structured (`Strd`) or unstructured (`Ustrd`) remittance info
- [ ] **Transaction Reference**: End-to-end ID unique per transaction
- [ ] **Payment Type**: Service level `SEPA` or `SCT`

### Validation Checks
- [ ] Debtor IBAN is valid and belongs to an EEA country
- [ ] Creditor IBAN is valid and belongs to an EEA country
- [ ] Amount > 0 and formatted with 2 decimal places
- [ ] Execution date is not in the past
- [ ] Payment instruction is not rejected before execution

---

## SEPA Direct Debit (SDD)

### Requirements

#### CORE Scheme
- [ ] **Creditor Identifier**: Valid creditor identifier registered with national bank
- [ ] **Mandate Reference**: Unique `MndtId` per mandate
- [ ] **Mandate Date**: Date of signing or electronic acceptance
- [ ] **Mandate Amendment**: Proper handling of mandate changes (amendment indicator)
- [ ] **Mandate Cancellation**: Cancellation process implemented
- [ ] **First Collection**: First collection flagged with `FrstColltnDt` and `SeqTp` = `FRST`
- [ ] **Recurring Collections**: Sequence type `RCUR` for subsequent collections
- [ ] **Final Collection**: Sequence type `FNAL` for last collection
- [ ] **Pre-Notification**: Debtor notified 14 calendar days before first collection (unless reduced)
- [ ] **Refund Window**: 8 weeks for unconditional refund; 13 months for unauthorized
- [ ] **Maximum Execution Time**: D+1 for collection
- [ ] **Reversal**: Reversal (`pacs.007`) supported within 10 banking days

#### B2B Scheme
- [ ] **B2B Mandate**: Explicit B2B mandate type (not CORE)
- [ ] **Debtor Authorization**: Debtor bank verifies authorization before debiting
- [ ] **No Refund**: No refund right for B2B (unlike CORE)
- [ ] **Pre-Notification**: Timing agreed between creditor and debtor
- [ ] **Mandate Management**: Same mandate rules as CORE but with B2B-specific identifiers

### Validation Checks
- [ ] Mandate is active and not expired
- [ ] Mandate reference matches the creditor identifier
- [ ] Collection amount does not exceed mandate limits
- [ ] Collection date respects pre-notification period
- [ ] Debtor account accepts direct debits
- [ ] Amended mandate is properly flagged and tracked

---

## SEPA Instant Credit Transfer (SCT Inst)

### Requirements
- [ ] **Execution Time**: Funds available within 10 seconds (max 20 seconds)
- [ ] **Maximum Amount**: €100,000 per transaction (unless higher limit agreed)
- [ ] **24/7/365**: Available at all times, including weekends and holidays
- [ ] **Confirmation**: Real-time confirmation (acceptance or rejection)
- [ ] **Reachability**: Check if both debtor and creditor banks are reachable via SCT Inst
- [ ] **Fallback**: Standard SCT fallback if SCT Inst unavailable
- [ ] **Service Level**: `SCTInst` or equivalent service level code

### Validation Checks
- [ ] Amount <= €100,000 (or agreed limit)
- [ ] Both banks are reachable via instant scheme
- [ ] Timeout handling for non-response
- [ ] Reconciliation of instant vs. standard SCT

---

## Cross-Border (Non-EEA) Considerations

- [ ] **IBAN Countries**: SCT applies to IBAN countries in SEPA zone (EU + EEA + Monaco, San Marino, Switzerland, UK)
- [ ] **Currency Conversion**: Non-EUR accounts may require conversion
- [ ] **Fee Transparency**: Fees split between debtor and creditor (SHA)
- [ ] **Regulatory Compliance**: Local regulations may apply alongside SEPA

---

## Code-Level Checks

- [ ] IBAN validation covers all SEPA countries (36+ country codes)
- [ ] BIC validation for cross-border transfers where required
- [ ] Amount stored as decimal with exact precision (no rounding errors)
- [ ] Execution date calculation respects banking days and holidays
- [ ] Mandate expiration dates are tracked and enforced
- [ ] Pre-notification scheduling and logging
- [ ] Reversal/reject handling within 10 banking days
- [ ] Reconciliation of end-to-end IDs across settlement reports
- [ ] Audit trail for all SEPA transactions

---

## Report Format

```markdown
# SEPA Assessment Report

## Scope: [payment module/feature]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Schemes Assessed
- [ ] SEPA Credit Transfer (SCT)
- [ ] SEPA Direct Debit CORE
- [ ] SEPA Direct Debit B2B
- [ ] SEPA Instant Credit Transfer (SCT Inst)

## Findings

### SEPA Credit Transfer — [🔴|🟡|✅]
[findings]

### SEPA Direct Debit — [🔴|🟡|✅]
[findings]

### SEPA Instant — [🔴|🟡|✅]
[findings]

### Cross-Border — [🔴|🟡|✅]
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

1. **IBAN validation is mandatory** — all SEPA payments must validate IBAN
2. **Mandate management is critical** — direct debit without valid mandates is illegal
3. **Pre-notification timing** — 14 days before first collection unless contractually reduced
4. **Refund handling** — CORE allows 8-week unconditional refund; implement it
5. **Cross-reference with ISO 20022** — SEPA uses ISO 20022 message formats
6. **Cross-reference with PSD2** — SEPA is a payment service under PSD2
