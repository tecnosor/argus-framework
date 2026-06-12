# Security Policy — {{PROJECT_NAME}}

> This document defines the security requirements and policies for the project.
> Generated during agentic installation based on compliance scope and project analysis.

---

## Security Classification

**Project Type**: Banking / Financial Services
**Data Sensitivity**: {{DATA_CLASSIFICATION}}
**Compliance Frameworks**: {{COMPLIANCE_FRAMEWORKS}}

---

## Authentication & Authorization

### Authentication Mechanism: {{AUTH_MECHANISM}}

- Minimum password complexity: 12 characters, mixed case, numbers, special characters
- Password hashing: bcrypt (cost factor >= 12) or Argon2
- Session management: {{SESSION_STRATEGY}}
- Multi-factor authentication: {{MFA_REQUIREMENT}}
- Account lockout: After 5 failed attempts, 15-minute lockout

### Authorization Model: {{AUTHZ_MECHANISM}}

- Role-based access control (RBAC) with principle of least privilege
- Resource-level authorization (users can only access their own resources)
- Segregation of duties for financial operations
- Admin operations require elevated authentication

---

## Data Protection

### Encryption

| Data State | Algorithm | Key Management |
|-----------|-----------|---------------|
| In transit | TLS 1.2+ (TLS 1.3 preferred) | Certificate management via {{CERT_MANAGER}} |
| At rest (database) | AES-256-GCM | {{KEY_MANAGEMENT}} |
| At rest (files) | AES-256-GCM | {{KEY_MANAGEMENT}} |
| Passwords | bcrypt / Argon2 | N/A (one-way hash) |

### Data Classification

| Level | Description | Examples | Handling |
|-------|-------------|----------|----------|
| **Public** | No sensitivity | Marketing content, public docs | Standard protection |
| **Internal** | Low sensitivity | Internal documentation, configs | Access restricted to employees |
| **Confidential** | High sensitivity | PII, account data | Encrypted, access logged, minimized |
| **Restricted** | Critical sensitivity | Credentials, encryption keys | Vault storage, strict access, audited |

### PII Handling Rules

1. **Minimize collection** — only collect data necessary for the purpose
2. **Encrypt at rest** — all PII encrypted in database
3. **Never log PII** — no email, phone, SSN, or account numbers in logs
4. **Mask in responses** — show only last 4 digits of sensitive identifiers
5. **Retention limits** — delete PII after retention period expires
6. **Access audit** — log all access to PII with who, when, and why

---

## Input Validation

### Rules

1. **Validate at all boundaries** — API controllers, message consumers, file uploads
2. **Whitelist over blacklist** — define what is allowed, not what is forbidden
3. **Server-side validation is mandatory** — client-side validation is UX only
4. **Type checking** — validate data types before processing
5. **Length limits** — enforce maximum lengths on all string inputs
6. **File upload validation** — check type (magic bytes), size, and content

### Validation Framework: {{VALIDATION_FRAMEWORK}}

---

## Secrets Management

### Rules

1. **No secrets in code** — never hardcode passwords, API keys, or tokens
2. **Environment variables** — for non-production secrets
3. **Secret vault** — {{SECRET_VAULT}} for production secrets
4. **Rotation policy** — secrets rotated every {{SECRET_ROTATION_DAYS}} days
5. **Access audit** — all secret access logged and monitored
6. **`.env` in `.gitignore`** — never commit environment files

### Secret Storage: {{SECRET_VAULT}}

---

## Dependency Security

### Requirements

1. **Automated scanning** — {{DEPENDENCY_SCANNER}} configured
2. **No critical CVEs** — block deployment if critical vulnerabilities exist
3. **Lock files committed** — ensure reproducible builds
4. **Regular updates** — dependencies updated monthly minimum
5. **License compliance** — no GPL or copyleft licenses in proprietary code

---

## Logging & Monitoring

### Security Events to Log

- Authentication success and failure
- Authorization failures
- Input validation failures
- Sensitive data access
- Configuration changes
- Administrative actions
- Session creation and termination

### Logging Rules

1. **Structured logging** — JSON format with consistent fields
2. **No PII** — never log personal data, credentials, or tokens
3. **Correlation IDs** — trace requests across services
4. **Retention** — security logs retained for {{LOG_RETENTION_DAYS}} days
5. **Tamper-evident** — logs stored in append-only storage

---

## Incident Response

### Classification

| Severity | Description | Response Time |
|----------|-------------|---------------|
| **Critical** | Active breach, data exfiltration | 15 minutes |
| **High** | Vulnerability exploited, service degraded | 1 hour |
| **Medium** | Vulnerability discovered, not yet exploited | 24 hours |
| **Low** | Minor security issue, no immediate risk | 1 week |

### Response Process

1. **Detect** — automated alerting + manual discovery
2. **Contain** — isolate affected systems
3. **Investigate** — root cause analysis
4. **Remediate** — fix vulnerability and deploy
5. **Report** — notify stakeholders and regulators (GDPR: 72 hours)
6. **Learn** — post-incident review and process improvement

---

## Network Security

- All external communication over TLS 1.2+
- Internal service communication encrypted (mTLS preferred)
- CORS restricted to known origins
- Rate limiting on all public endpoints
- WAF (Web Application Firewall) in front of public APIs
- DDoS protection enabled

---

## Compliance Mapping

| Requirement | GDPR | DORA | PCI-DSS | Implementation |
|-------------|------|------|---------|----------------|
| Data encryption | Art. 32 | Art. 6 | Req. 3, 4 | AES-256 + TLS 1.2+ |
| Access control | Art. 25, 32 | Art. 6 | Req. 7, 8 | RBAC + MFA |
| Audit logging | Art. 30 | Art. 9 | Req. 10 | Structured logging |
| Incident response | Art. 33, 34 | Art. 11 | Req. 12.10 | IR process above |
| Data minimization | Art. 5 | — | Req. 3.1 | Collection policy |

---

*This document is maintained by the agentic framework. Update it when security requirements change.*
