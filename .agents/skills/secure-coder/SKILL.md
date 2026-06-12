---
name: secure-coder
description: "OWASP-based secure coding checklist. BLOCKING security validation that stops task progression if critical violations found. Checks for secrets in code, injection prevention, input validation, PII in logs, dependency CVEs, and least privilege access. Use before every PR and when reviewing security-sensitive changes."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: backend-dev, frontend-dev, reviewer, testing
  phase: development, review
---

# Secure Coder Skill

You are performing a **Security Coding Validation** based on OWASP guidelines.

**This is a BLOCKING check.** If critical security violations are found, the task
cannot proceed until they are resolved.

---

## Critical Checks (BLOCKING — Stop Everything)

### 1. No Secrets in Code

**Search for:**
```bash
# Common secret patterns
grep -rn "password\s*=\s*['\"]" --include="*.java" --include="*.ts" --include="*.py" --include="*.go"
grep -rn "api[_-]?key\s*=\s*['\"]" --include="*.java" --include="*.ts" --include="*.py" --include="*.go"
grep -rn "secret\s*=\s*['\"]" --include="*.java" --include="*.ts" --include="*.py" --include="*.go"
grep -rn "token\s*=\s*['\"]" --include="*.java" --include="*.ts" --include="*.py" --include="*.go"
grep -rn "BEGIN.*PRIVATE KEY" --include="*.java" --include="*.ts" --include="*.py" --include="*.pem"
grep -rn "AKIA[0-9A-Z]{16}" --include="*.java" --include="*.ts" --include="*.py"  # AWS keys
```

**Rules:**
- No hardcoded passwords, API keys, tokens, or certificates
- All secrets from environment variables or secret management (Vault, AWS Secrets Manager, etc.)
- `.env` files in `.gitignore`
- No secrets in test fixtures (use test-specific values that are clearly fake)

### 2. No Injection Vulnerabilities

**Search for:**
```bash
# SQL injection — string concatenation in queries
grep -rn "SELECT.*+\|INSERT.*+\|UPDATE.*+\|DELETE.*+" --include="*.java"
grep -rn "rawQuery\|executeQuery.*+" --include="*.java"

# Command injection
grep -rn "Runtime.getRuntime().exec\|ProcessBuilder" --include="*.java"
grep -rn "child_process\|exec(\|execSync(" --include="*.ts" --include="*.js"

# XSS
grep -rn "innerHTML\|v-html\|dangerouslySetInnerHTML\|document.write" \
  --include="*.ts" --include="*.tsx" --include="*.vue" --include="*.js"
```

**Rules:**
- All SQL queries use parameterized statements
- No string concatenation in SQL/NoSQL queries
- No `Runtime.exec()` with user input
- No `innerHTML` with user-generated content
- All user input sanitized before use in queries or HTML

### 3. Input Validation at Boundaries

**Check:**
- [ ] All API controller methods validate input (Bean Validation, Zod, Joi, etc.)
- [ ] File uploads validate type, size, and content
- [ ] Path parameters validated (no directory traversal)
- [ ] Query parameters validated and type-checked
- [ ] Request body validated against schema
- [ ] Headers validated where security-relevant (Authorization, Content-Type)

---

## Important Checks (WARNING — Should Fix)

### 4. No PII in Logs

**Search for:**
```bash
grep -rn "log\.\|logger\.\|console.log\|print(" --include="*.java" --include="*.ts" --include="*.py" | \
  grep -i "email\|phone\|ssn\|passport\|address\|name\|dob\|birth"
```

**Rules:**
- No email addresses in log output
- No phone numbers in log output
- No national IDs (SSN, passport, DNI) in log output
- No full names combined with other identifiers
- No financial account numbers (mask to last 4)
- Use structured logging with PII filters

### 5. Dependency Security

**Check:**
```bash
# Node.js
npm audit --audit-level=high

# Maven
mvn org.owasp:dependency-check-maven:check

# Python
pip-audit

# Go
govulncheck ./...
```

**Rules:**
- No critical or high CVEs in dependencies
- Dependencies actively maintained
- Lock files committed and up to date
- Automated dependency scanning configured

### 6. Authentication & Authorization

**Check:**
- [ ] All protected endpoints require authentication
- [ ] Authorization checks verify resource ownership (not just role)
- [ ] Passwords stored with bcrypt (cost >= 12) or Argon2
- [ ] JWT tokens have expiry, signature validation, and issuer check
- [ ] Session management follows secure practices
- [ ] Rate limiting on authentication endpoints
- [ ] Account lockout after failed attempts

### 7. Least Privilege Access

**Check:**
- [ ] Database connections use application-specific user (not admin)
- [ ] API keys have minimum required permissions
- [ ] File system access restricted to necessary directories
- [ ] Network access restricted to necessary hosts/ports
- [ ] Cloud IAM roles follow least privilege principle

### 8. Data Protection

**Check:**
- [ ] Sensitive data encrypted at rest
- [ ] TLS 1.2+ for all communications
- [ ] No sensitive data in URL parameters
- [ ] No sensitive data in browser local storage (use session storage or httpOnly cookies)
- [ ] Sensitive responses do not include unnecessary data
- [ ] Error messages do not expose internal details

---

## Advisory Checks (NICE TO HAVE)

### 9. Security Headers

- [ ] Content-Security-Policy header set
- [ ] X-Content-Type-Options: nosniff
- [ ] X-Frame-Options: DENY or SAMEORIGIN
- [ ] Strict-Transport-Security header set
- [ ] Referrer-Policy header set
- [ ] Permissions-Policy header set

### 10. Logging & Monitoring

- [ ] Security events logged (auth failures, access denied)
- [ ] Audit trail for sensitive operations
- [ ] Log integrity protected
- [ ] Alerting configured for suspicious patterns

---

## Security Validation Report

```markdown
# Security Validation Report

## Scope: [files/changes being validated]

### Critical (BLOCKING)
| Check | Status | Findings |
|-------|--------|----------|
| Secrets in code | ✅/🔴 | [details] |
| Injection vulnerabilities | ✅/🔴 | [details] |
| Input validation | ✅/🔴 | [details] |

### Important (WARNING)
| Check | Status | Findings |
|-------|--------|----------|
| PII in logs | ✅/🟡 | [details] |
| Dependency CVEs | ✅/🟡 | [details] |
| Auth/AuthZ | ✅/🟡 | [details] |
| Least privilege | ✅/🟡 | [details] |
| Data protection | ✅/🟡 | [details] |

### Advisory
| Check | Status | Findings |
|-------|--------|----------|
| Security headers | ✅/🔵 | [details] |
| Logging & monitoring | ✅/🔵 | [details] |

## Verdict
- **Critical violations**: X → [BLOCKING — must fix before proceeding]
- **Warnings**: X → [should fix before merge]
- **Overall**: ✅ SECURE | ❌ SECURITY VIOLATIONS FOUND
```

---

## Rules

1. **Critical = BLOCKING** — no exceptions. Secrets, injections, and missing input validation stop the task.
2. **Search the actual code** — do not assume, grep for patterns
3. **Be specific** — cite file:line for every finding
4. **Provide fix guidance** — tell the developer exactly how to remediate
5. **Re-validate after fixes** — run the check again after changes are made
