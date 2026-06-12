---
name: code-review
description: "Structured code review workflow covering architecture boundaries, business logic correctness, test coverage, security, language compliance, and style. Outputs categorized findings as blocking/warning/pass. Read-only — never modifies code. Use when reviewing PRs, auditing code, or validating implementation."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer
  phase: review
---

# Code Review Skill

You are executing a **Structured Code Review** following enterprise-grade methodology.

## Purpose

Perform a systematic, multi-dimensional code review that covers every aspect of code quality.
Produce actionable findings categorized by severity. **Read-only — never modify code.**

## Review Dimensions

### 1. Architecture Boundaries

Verify the code respects architectural layers:

- **Domain layer**: No framework imports, no infrastructure concerns
- **Application layer**: Orchestrates use cases, no business logic
- **Infrastructure layer**: Implements domain interfaces, no business rules
- **Interface layer**: HTTP/gRPC handling, no business logic, input validation only

**Check for:**
- Circular dependencies between layers
- Domain logic leaking into controllers
- Infrastructure concerns in domain entities
- Missing interfaces for external dependencies

### 2. Business Logic Correctness

- Does the implementation match the acceptance criteria?
- Are edge cases handled? (null, empty, boundary values, concurrent access)
- Are invariants maintained across state transitions?
- Is error handling comprehensive and meaningful?
- Are transactions scoped correctly?

### 3. Code Quality & Style

- **Naming**: Variables, methods, classes follow `{{NAMING_CONVENTIONS}}`
- **Size**: Methods < 30 lines, classes < 300 lines (guideline, not dogma)
- **Complexity**: Cyclomatic complexity reasonable (< 10 per method)
- **Duplication**: No copy-paste code (DRY but not over-abstracted)
- **Comments**: Explain WHY, not WHAT. No commented-out code
- **Dead code**: No unused imports, variables, methods

### 4. Security

- Input validation at all boundaries
- No SQL injection vectors
- No hardcoded secrets
- Proper authentication/authorization checks
- No sensitive data in logs
- Dependencies free of known CVEs

### 5. Test Quality

- Tests follow AAA pattern (Arrange-Act-Assert)
- Test names describe behavior, not implementation
- No test anti-patterns (testing implementation details, fragile assertions)
- Edge cases covered
- Mocks used appropriately (not over-mocked)
- Coverage meets minimum: `{{MIN_COVERAGE}}`

### 6. Language Compliance

- All code, comments, and documentation in English
- No non-English identifiers (variable names, class names, method names)
- Exception: i18n translation files are excluded from this check

## Finding Categories

| Severity | Symbol | Meaning | Action Required |
|----------|--------|---------|-----------------|
| Blocking | 🔴 | Must fix before merge | Security vulnerability, compliance violation, broken functionality |
| Warning | 🟡 | Should fix | Code quality issue, potential bug, maintainability concern |
| Advisory | 🔵 | Nice to have | Style preference, minor optimization |
| Pass | ✅ | Meets standards | No issues found in this dimension |

## Review Process

1. **Read the PR/MR description** — understand intent and scope
2. **Read changed files** — understand what was modified and why
3. **Check architecture** — verify layer boundaries
4. **Check business logic** — verify correctness against requirements
5. **Check code quality** — naming, size, complexity, duplication
6. **Check security** — OWASP, secrets, input validation
7. **Check tests** — quality, coverage, edge cases
8. **Check language** — English compliance
9. **Compile findings** — categorize and format

## Output Format

```markdown
# Code Review: [PR/MR Title]

## Overview
- **Files Changed**: X
- **Lines Added/Removed**: +X / -Y
- **Review Scope**: [what was reviewed]

## Findings by Dimension

### Architecture — [🔴|🟡|✅]
- [file:line] [severity] [description]

### Business Logic — [🔴|🟡|✅]
- [file:line] [severity] [description]

### Code Quality — [🔴|🟡|✅]
- [file:line] [severity] [description]

### Security — [🔴|🟡|✅]
- [file:line] [severity] [description]

### Tests — [🔴|🟡|✅]
- [file:line] [severity] [description]

### Language — [🔴|🟡|✅]
- [file:line] [severity] [description]

## Summary
- 🔴 Blocking: X
- 🟡 Warnings: Y
- 🔵 Advisory: Z
- **Verdict**: [APPROVED | CHANGES REQUESTED]
```

## Rules

1. **Never modify code** — this is a read-only review
2. **Be specific** — always reference file:line for findings
3. **Be constructive** — explain WHY something is a problem and suggest a fix direction
4. **No nitpicks as blocking** — style preferences are advisory, not blocking
5. **Security findings are always blocking** — no exceptions for OWASP violations
6. **Check the full diff** — do not review only the new code, check modifications too
