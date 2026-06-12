---
name: owasp-top10
description: "OWASP Top 10 (2021) security vulnerability checklist. Systematically checks each vulnerability category against the codebase. Produces blocking findings for any vulnerabilities found. Use during code review, security audits, and before merge requests."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, testing, backend-dev, frontend-dev
  phase: review, testing, development
---

# OWASP Top 10 Security Checklist

You are executing an **OWASP Top 10 (2021)** security assessment against the codebase.
Every finding in this checklist is treated as **BLOCKING** unless explicitly marked otherwise.

---

## A01:2021 — Broken Access Control

### Checks
- [ ] Authentication required for all protected endpoints
- [ ] Authorization checks verify user has permission for the specific resource (not just role)
- [ ] No IDOR (Insecure Direct Object Reference) — cannot access other users' resources by changing IDs
- [ ] CORS configured correctly — no wildcard origins in production
- [ ] Directory traversal prevented — no user input in file paths without sanitization
- [ ] JWT tokens validated server-side (signature, expiry, issuer)
- [ ] Admin endpoints isolated with additional authentication
- [ ] Rate limiting on authentication endpoints
- [ ] Session invalidation on logout
- [ ] Principle of least privilege applied to all roles

### Code Patterns to Search For
```
# Look for missing auth checks
grep -r "@GetMapping\|@PostMapping\|@PutMapping\|@DeleteMapping" --include="*.java"
# Verify each has corresponding @PreAuthorize or security check

# Look for IDOR vulnerabilities
grep -r "findById\|getById" --include="*.java"
# Verify ownership check after retrieval
```

---

## A02:2021 — Cryptographic Failures

### Checks
- [ ] No weak algorithms (MD5, SHA1 for security purposes, DES, RC4)
- [ ] No hardcoded encryption keys, IVs, or salts
- [ ] TLS 1.2+ for all communications
- [ ] Passwords hashed with bcrypt/scrypt/Argon2 (not MD5/SHA)
- [ ] Sensitive data encrypted at rest (AES-256-GCM)
- [ ] Certificate validation not disabled (no `TrustAllCertificates`)
- [ ] Random number generation uses `SecureRandom`, not `Random`
- [ ] No sensitive data in URL parameters
- [ ] HTTP Strict Transport Security (HSTS) header set
- [ ] Proper key management (rotation, storage in vault/KMS)

### Code Patterns to Search For
```
# Weak algorithms
grep -rn "MD5\|SHA1\|DES\|RC4" --include="*.java" --include="*.ts"
# Hardcoded keys
grep -rn "secret\|password\|key\s*=" --include="*.java" --include="*.ts"
# Disabled certificate validation
grep -rn "TrustAll\|ALLOW_ALL\|setHostnameVerifier" --include="*.java"
```

---

## A03:2021 — Injection

### Checks
- [ ] **SQL Injection**: All queries use parameterized statements or prepared statements
- [ ] **NoSQL Injection**: MongoDB/Redis queries use proper escaping
- [ ] **Command Injection**: No `Runtime.exec()` or `ProcessBuilder` with user input
- [ ] **LDAP Injection**: LDAP queries properly escaped
- [ ] **XSS (Reflected)**: User input escaped in HTML output
- [ ] **XSS (Stored)**: User-generated content sanitized before storage and rendering
- [ ] **XSS (DOM)**: No `innerHTML` with user input, use `textContent` or sanitization
- [ ] **Template Injection**: No user input in template expressions
- [ ] **Header Injection**: No user input in HTTP headers without validation
- [ ] **ORM Injection**: No raw SQL in ORM queries

### Code Patterns to Search For
```
# SQL injection - raw string concatenation
grep -rn "SELECT.*+\|INSERT.*+\|UPDATE.*+\|DELETE.*+" --include="*.java"
# Command injection
grep -rn "Runtime.exec\|ProcessBuilder\|exec(" --include="*.java" --include="*.ts"
# XSS - innerHTML
grep -rn "innerHTML\|v-html\|dangerouslySetInnerHTML" --include="*.ts" --include="*.vue" --include="*.tsx"
```

---

## A04:2021 — Insecure Design

### Checks
- [ ] Rate limiting on all public endpoints
- [ ] Input validation at all trust boundaries (API controllers, message consumers)
- [ ] Business logic validates invariants (not just input format)
- [ ] No trust of client-side validation alone
- [ ] Resource limits defined (max upload size, max query results, timeouts)
- [ ] Fail-secure: errors do not expose internal state
- [ ] Segregation of duties enforced (e.g., user who creates cannot approve)
- [ ] Anti-replay mechanisms for financial transactions
- [ ] Idempotency for payment operations

---

## A05:2021 — Security Misconfiguration

### Checks
- [ ] Debug mode disabled in production configurations
- [ ] Default credentials changed
- [ ] Unnecessary features/endpoints disabled
- [ ] Error messages do not expose stack traces or internal paths
- [ ] Security headers set (CSP, X-Frame-Options, X-Content-Type-Options)
- [ ] Directory listing disabled
- [ ] Default error pages replaced with custom ones
- [ ] Framework version not exposed in headers
- [ ] CORS restricted to known origins
- [ ] Environment-specific configurations properly separated

---

## A06:2021 — Vulnerable and Outdated Components

### Checks
- [ ] Dependency scan run (npm audit, mvn dependency-check, etc.)
- [ ] No known critical CVEs in dependencies
- [ ] Dependencies actively maintained (no abandoned libraries)
- [ ] Transitive dependencies also checked
- [ ] Version pinning in place (lock files committed)
- [ ] Automated dependency update tool configured (Dependabot, Renovate)

### Commands to Run
```bash
# Node.js
npm audit --audit-level=critical

# Maven
mvn dependency-check:check

# Gradle
gradle dependencyCheckAnalyze

# Python
pip-audit

# Go
govulncheck ./...
```

---

## A07:2021 — Identification and Authentication Failures

### Checks
- [ ] Password complexity requirements enforced (min 12 chars, mixed case, numbers, special)
- [ ] Account lockout after failed attempts (5-10 attempts, exponential backoff)
- [ ] Multi-factor authentication available/enforced for sensitive operations
- [ ] Session IDs not exposed in URLs
- [ ] Session timeout configured (idle and absolute)
- [ ] Password reset flow is secure (time-limited tokens, no password hints)
- [ ] No credential stuffing vulnerability (rate limiting + CAPTCHA)
- [ ] Secure password storage (bcrypt with cost factor >= 12)
- [ ] Registration validates email uniqueness

---

## A08:2021 — Software and Data Integrity Failures

### Checks
- [ ] CI/CD pipeline integrity (signed commits, protected branches)
- [ ] No insecure deserialization (Java `ObjectInputStream`, pickle, etc.)
- [ ] CDN and external script integrity verified (SRI hashes)
- [ ] Software updates verified (signature checks)
- [ ] No unsigned or unverified plugins/extensions loaded

### Code Patterns to Search For
```
# Insecure deserialization
grep -rn "ObjectInputStream\|pickle.loads\|yaml.load\|unserialize" --include="*.java" --include="*.py" --include="*.php"
```

---

## A09:2021 — Security Logging and Monitoring Failures

### Checks
- [ ] Authentication events logged (success and failure)
- [ ] Authorization failures logged
- [ ] Input validation failures logged
- [ ] No PII in log output
- [ ] No credentials/tokens in log output
- [ ] Log integrity protected (tamper-evident)
- [ ] Alerting configured for suspicious patterns
- [ ] Logs retained per compliance requirements
- [ ] Audit trail for sensitive operations (financial transactions, data access)

---

## A10:2021 — Server-Side Request Forgery (SSRF)

### Checks
- [ ] User-supplied URLs validated against allowlist
- [ ] No internal network access from user-supplied URLs
- [ ] URL schemes restricted (no `file://`, `gopher://`, etc.)
- [ ] DNS rebinding protection in place
- [ ] Response from external requests not returned directly to user

### Code Patterns to Search For
```
# SSRF - URL construction from user input
grep -rn "new URL\|HttpClient\|fetch\|axios" --include="*.java" --include="*.ts"
# Verify URL is validated before use
```

---

## Assessment Output Format

```markdown
# OWASP Top 10 Assessment

## Project: {{PROJECT_NAME}}
## Date: YYYY-MM-DD
## Scope: [files/modules assessed]

| Category | Status | Findings |
|----------|--------|----------|
| A01: Broken Access Control | 🔴/✅ | X issues |
| A02: Cryptographic Failures | 🔴/✅ | X issues |
| A03: Injection | 🔴/✅ | X issues |
| A04: Insecure Design | 🔴/✅ | X issues |
| A05: Security Misconfiguration | 🔴/✅ | X issues |
| A06: Vulnerable Components | 🔴/✅ | X issues |
| A07: Auth Failures | 🔴/✅ | X issues |
| A08: Integrity Failures | 🔴/✅ | X issues |
| A09: Logging Failures | 🔴/✅ | X issues |
| A10: SSRF | 🔴/✅ | X issues |

## Critical Findings (Must Fix)
1. [A0X] [file:line] — [description] — [remediation]

## Recommendations
1. [description]

## Verdict: [SECURE | VULNERABILITIES FOUND — X blocking issues]
```

## Rules

1. **Every OWASP finding is BLOCKING** — no exceptions
2. **Search the code** — do not rely on assumptions, actually grep for patterns
3. **Be specific** — cite file:line for every finding
4. **Provide remediation** — tell the developer how to fix it
5. **Check dependencies** — run actual scan commands, do not guess
