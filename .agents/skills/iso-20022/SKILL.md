---
name: iso-20022
description: "ISO 20022 financial messaging standard compliance checklist. Validates payment messages (pain, pacs, camt), schema compliance, XML validation, and end-to-end payment flows. Use for banking payment systems, real-time transfers, and cross-border payments."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev
  phase: review, planning
---

# ISO 20022 Compliance Skill

You are executing an **ISO 20022 financial messaging standard** assessment.

**Scope:** This skill applies to payment systems, banking integrations, and financial services that exchange ISO 20022 messages (pain, pacs, camt, reda, auth, etc.).

---

## Applicability

This skill is **required** if the project:
- Processes or generates payment messages (credit transfers, direct debits, instant payments)
- Integrates with SWIFT, SEPA, real-time payment (RTP) systems
- Uses ISO 20022 XML schemas for financial messaging
- Operates a payment gateway or banking core system
- Handles cross-border or domestic payments using ISO 20022

This skill is **not required** if the project does not process financial messages or uses only proprietary APIs.

---

## Message Type Coverage

| Category | Message Type | When to Check |
|----------|-------------|---------------|
| **Payment Initiation** | `pain.001` (Customer Credit Transfer Initiation) | Outgoing credit transfers |
| **Payment Initiation** | `pain.008` (Customer Direct Debit Initiation) | Direct debits |
| **Payment Initiation** | `pain.009` (Mandate Initiation) | Mandate management |
| **Payment Clearing** | `pacs.008` (FIToFICustomerCreditTransfer) | Interbank credit transfers |
| **Payment Clearing** | `pacs.002` (FIToFIPaymentStatusReport) | Payment status reports |
| **Payment Clearing** | `pacs.004` (PaymentReturn) | Payment returns |
| **Cash Management** | `camt.052` (BankToCustomerAccountReport) | Account reports |
| **Cash Management** | `camt.053` (BankToCustomerStatement) | Account statements |
| **Cash Management** | `camt.054` (BankToCustomerDebitCreditNotification) | Transaction notifications |
| **Remittance** | `remt.001` (CustomerCreditTransferInitiation) | Remittance advice |

---

## Schema Validation

- [ ] **XML Schema Valid**: All messages validate against the ISO 20022 XML schema (XSD)
- [ ] **Schema Version**: Correct schema version used (e.g., 2019, 2022)
- [ ] **Business Message Identifier (BMI)**: Unique and properly formatted
- [ ] **Message Identification**: Present and unique within the business context
- [ ] **Creation DateTime**: ISO 8601 format with timezone

## Message Structure

- [ ] **Header (Business Application Header)**: Contains `From`, `To`, `BizMsgIdr`, `MsgDefIdr`, `CreDt`
- [ ] **Group Header**: Contains `MsgId`, `CreDtTm`, `NbOfTxs`, `CtrlSum`
- [ ] **Transaction Details**: All required fields populated per message type
- [ ] **Payment Information**: `PmtInf` block with `PmtInfId`, `PmtMtd`, `BtchBookg`, `NbOfTxs`, `CtrlSum`
- [ ] **Debtor/Creditor Information**: `Dbtr`, `Cdtr`, `DbtrAcct`, `CdtrAcct`, `DbtrAgt`, `CdtrAgt`
- [ ] **Instructed Amount**: `InstdAmt` with correct currency (EUR for SEPA)
- [ ] **Purpose Code**: `Purp` with valid ISO 20022 purpose codes (e.g., `SALA`, `SUPP`, `CASH`)
- [ ] **Remittance Information**: `RmtInf` with `Ustrd` or `Strd` for reconciliation

## Data Quality

- [ ] **IBAN Validation**: IBANs validated using country-specific check digits
- [ ] **BIC/SWIFT Validation**: BICs validated against SWIFT directory
- [ ] **Currency Codes**: ISO 4217 currency codes (EUR, USD, GBP, etc.)
- [ ] **Amount Precision**: Decimal precision matches currency requirements (EUR = 2 decimals)
- [ ] **Character Set**: UTF-8 encoding, no control characters
- [ ] **Field Length**: All fields within maximum length constraints
- [ ] **No Empty Optional Blocks**: Empty optional blocks omitted rather than left blank

## End-to-End Tracking

- [ ] **End-to-End Identification**: `EndToEndId` present and unique per transaction
- [ ] **Transaction Identification**: `TxId` present and unique within batch
- [ ] **Instruction Identification**: `InstrId` present if applicable
- [ ] **Clearing Reference**: `ClrSysRef` populated for interbank transfers
- [ ] **Settlement Date**: `IntrBkSttlmDt` or `SttlmDt` correctly set

## SEPA Specific (If Applicable)

- [ ] **SEPA Credit Transfer**: `SCT` indicator or `SEPA` service level
- [ ] **SEPA Direct Debit**: `SDD` service level with CORE or B2B scheme
- [ ] **SEPA Instant**: `SCTInst` service level with `true` for instant payments
- [ ] **Mandate Reference**: `MndtId` present and unique for direct debits
- [ ] **Creditor Identifier**: `CdtrSchmeId` with valid creditor identifier

## API / Integration

- [ ] **Message Parsing**: Robust parsing of incoming ISO 20022 XML
- [ ] **Error Handling**: Graceful handling of invalid or malformed messages
- [ ] **Idempotency**: Duplicate message detection using `BizMsgIdr` or `MsgId`
- [ ] **Acknowledgments**: Proper acknowledgment (pacs.002) sent for received messages
- [ ] **Status Tracking**: Payment status tracked through the full lifecycle
- [ ] **Audit Trail**: All messages logged with timestamp and correlation ID

---

## Code-Level Checks

- [ ] XML serialization uses proper namespaces (`xmlns`, `xsi`)
- [ ] Schema validation library configured with ISO 20022 XSD files
- [ ] IBAN validation library (e.g., `IBAN.js`, `iban-java`) used
- [ ] BIC validation against SWIFT BIC directory or API
- [ ] Amount formatting uses `BigDecimal` or equivalent (no floating point)
- [ ] Date formatting uses ISO 8601 with timezone offset
- [ ] Message validation happens before sending to network
- [ ] Rejected messages produce detailed error reports (pacs.002)

---

## Report Format

```markdown
# ISO 20022 Assessment Report

## Scope: [payment module/feature]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Message Types Assessed
- [ ] pain.001
- [ ] pain.008
- [ ] pacs.008
- [ ] pacs.002
- [ ] camt.053
- [ ] ...

## Findings

### Schema Validation — [🔴|🟡|✅]
[findings]

### Message Structure — [🔴|🟡|✅]
[findings]

### Data Quality — [🔴|🟡|✅]
[findings]

### End-to-End Tracking — [🔴|🟡|✅]
[findings]

### SEPA Specific — [🔴|🟡|✅]
[findings]

### API / Integration — [🔴|🟡|✅]
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

1. **Assess applicability first** — ISO 20022 only applies to payment/messaging systems
2. **Validate against real XSD** — do not rely on informal checks
3. **IBAN/BIC validation is critical** — invalid identifiers cause payment failures
4. **Test with real message samples** — use anonymized production messages if possible
5. **Cross-reference with PSD2** — if both apply, payment flows must satisfy both
