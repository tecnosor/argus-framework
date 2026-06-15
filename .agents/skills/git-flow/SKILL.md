---
name: git-flow
description: "Git workflow management following {{GIT_WORKFLOW}} strategy. Enforces branch naming conventions ({{BRANCH_NAMING}}), commit message format ({{COMMIT_CONVENTION}}), and proper merge/rebase practices. Use for all git operations: branching, committing, merging, and PR creation."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: all-agents
  phase: development, review
---

# Git Flow Skill

You are managing **Git operations** for **{{PROJECT_NAME}}** following the
**{{GIT_WORKFLOW}}** strategy.

---

## Branch Strategy: {{GIT_WORKFLOW}}

### Branch Types

| Branch | Purpose | Naming Convention | From | Merges To |
|--------|---------|-------------------|------|-----------|
| `main` | Production-ready code | `main` | — | — |
| `develop` | Integration branch | `develop` | `main` | `main` |
| `feature/*` | New features | `{{BRANCH_NAMING}}` | `develop` | `develop` |
| `fix/*` | Bug fixes | `{{BRANCH_NAMING}}` | `develop` | `develop` |
| `hotfix/*` | Production hotfixes | `{{BRANCH_NAMING}}` | `main` | `main` + `develop` |
| `release/*` | Release preparation | `release/vX.Y.Z` | `develop` | `main` + `develop` |

### Branch Naming: {{BRANCH_NAMING}}

```
feature/{{PROJECT_KEY}}-123-add-user-authentication
fix/{{PROJECT_KEY}}-456-fix-login-timeout
hotfix/{{PROJECT_KEY}}-789-critical-security-patch
release/v1.2.0
```

**Rules:**
- Lowercase only
- Hyphens as separators (no underscores, no spaces)
- Include ticket/issue reference when available
- Descriptive but concise (max 50 chars after ticket reference)

---

## Commit Messages: {{COMMIT_CONVENTION}}

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

| Type | When to Use |
|------|-------------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or modifying tests |
| `docs` | Documentation changes |
| `chore` | Build process, tooling, dependencies |
| `perf` | Performance improvement |
| `style` | Formatting, whitespace (no code change) |
| `ci` | CI/CD configuration changes |
| `revert` | Reverting a previous commit |

### Scope

Use the affected module/component:
- `auth`, `api`, `ui`, `db`, `config`, `test`, etc.

### Subject Rules
- Imperative mood: "add feature" not "added feature"
- No period at the end
- Max 72 characters
- Lowercase (except proper nouns)

### Body
- Explain WHAT changed and WHY (not HOW — that is in the code)
- Wrap at 72 characters
- Separate from subject with blank line

### Footer
- Reference issues: `Refs: {{PROJECT_KEY}}-123`
- Breaking changes: `BREAKING CHANGE: description`

### Examples

```
feat(auth): add JWT token refresh endpoint

Implement POST /v1/auth/refresh to allow token renewal without
re-authentication. Validates refresh token expiry and issues new
access token with 15-minute TTL.

Refs: {{PROJECT_KEY}}-123
```

```
fix(api): handle null response from payment gateway

The payment gateway occasionally returns null for pending transactions.
Added null check with retry logic (max 3 attempts, exponential backoff).

Refs: {{PROJECT_KEY}}-456
```

---

## Workflow Rules

### Before Starting Work

1. **Pull latest**: `git pull --rebase origin develop`
2. **Create branch**: `git checkout -b feature/{{PROJECT_KEY}}-123-description`
3. **Verify clean state**: `git status` should show nothing

### During Development

1. **Commit frequently**: Small, atomic commits (one logical change per commit)
2. **Follow message format**: Every commit must follow the convention above
3. **No WIP commits in final branch**: Use `git rebase -i` to squash before PR

### Before Creating PR

1. **Rebase on develop**: `git rebase origin/develop`
2. **Resolve conflicts**: If any, resolve and continue rebase
3. **Run full build**: `{{BUILD_COMMAND}}` && `{{TEST_COMMAND}}` && `{{LINT_COMMAND}}`
4. **Check for secrets**: `git diff develop -- | grep -i "password\|secret\|token\|key"`
5. **Review your own diff**: `git diff develop` — read every line

### Creating PR

1. **Push**: `git push origin feature/{{PROJECT_KEY}}-123-description`
2. **Create PR/MR** using the appropriate parameterized template below
3. **Assign reviewers** (at least 1 required by branch protection)
4. **Link to issue/ticket** in the description

### Parameterized PR Templates

Use the template that matches the change type. Replace all `{{PLACEHOLDER}}` markers with real values from the current task.

#### Feature PR Template

```markdown
## Description

This PR implements {{FEATURE_DESCRIPTION}}.

Closes {{ISSUE_KEY}}

## Changes

- {{CHANGE_1}}
- {{CHANGE_2}}
- {{CHANGE_3}}

## Architecture / Design

- Pattern: {{ARCHITECTURE}}
- Affected modules: {{AFFECTED_MODULES}}
- API changes: {{API_CHANGES}}
- Database changes: {{DATABASE_CHANGES}}

## Compliance & Security

- [ ] OWASP Top 10 reviewed
- [ ] GDPR compliance checked ({{GDPR_APPLICABLE}})
- [ ] DORA compliance checked ({{DORA_APPLICABLE}})
- [ ] MiCA compliance checked ({{MICA_APPLICABLE}})
- [ ] PSD2 compliance checked ({{PSD2_APPLICABLE}})
- [ ] PCI-DSS compliance checked ({{PCI_APPLICABLE}})
- [ ] No secrets in code
- [ ] No PII in logs

## Testing

- [ ] Unit tests added/updated (coverage >= {{MIN_COVERAGE}})
- [ ] Integration tests added/updated
- [ ] Build passes: `{{BUILD_COMMAND}}`
- [ ] Tests pass: `{{TEST_COMMAND}}`
- [ ] Lint passes: `{{LINT_COMMAND}}`

## How to Test

{{TEST_INSTRUCTIONS}}

## Screenshots / Evidence

{{SCREENSHOTS_OR_EVIDENCE}}

## Checklist

- [ ] Branch follows naming convention: `{{BRANCH_NAMING}}`
- [ ] Commits follow convention: `{{COMMIT_CONVENTION}}`
- [ ] No WIP or fixup commits
- [ ] Self-review completed
- [ ] Documentation updated if needed
```

#### Bug Fix PR Template

```markdown
## Description

Fixes {{BUG_DESCRIPTION}}.

Closes {{ISSUE_KEY}}

## Root Cause

{{ROOT_CAUSE}}

## Fix

{{FIX_DESCRIPTION}}

## Affected Files

{{AFFECTED_FILES}}

## Testing

- [ ] Regression test added
- [ ] Build passes: `{{BUILD_COMMAND}}`
- [ ] Tests pass: `{{TEST_COMMAND}}`
- [ ] Lint passes: `{{LINT_COMMAND}}`

## How to Reproduce (Before Fix)

{{REPRO_STEPS}}

## Verification (After Fix)

{{VERIFICATION_STEPS}}
```

#### Security Fix PR Template [CONDITIONAL]

```markdown
## Description

Fixes security issue: {{SECURITY_TITLE}}.

Closes {{ISSUE_KEY}}

## OWASP Category

{{OWASP_CATEGORY}}

## Severity

{{SECURITY_SEVERITY}}

## Vulnerability

{{SECURITY_DESCRIPTION}}

## Fix

{{FIX_DESCRIPTION}}

## Impact

{{SECURITY_IMPACT}}

## Testing

- [ ] Security test added
- [ ] OWASP Top 10 re-checked
- [ ] Build passes: `{{BUILD_COMMAND}}`
- [ ] Tests pass: `{{TEST_COMMAND}}`

## Responsible Disclosure

{{DISCLOSURE_STATUS}}
```

#### Documentation / Chore PR Template

```markdown
## Description

{{DESCRIPTION}}

## Type of Change

- [ ] Documentation update
- [ ] Build/CI change
- [ ] Dependency update
- [ ] Configuration change
- [ ] Other: ___

## Checklist

- [ ] No functional code changes (or clearly documented if any)
- [ ] Build passes: `{{BUILD_COMMAND}}`
- [ ] Lint passes: `{{LINT_COMMAND}}`
```

### Creating PR via GitHub CLI

```bash
# Create PR from current branch to develop
gh pr create \
  --base develop \
  --title "{{PR_TITLE}}" \
  --body-file pr-description.md \
  --reviewer {{REVIEWER_USERNAME}}

# Or with inline body
gh pr create \
  --base develop \
  --title "{{PR_TITLE}}" \
  --body "$(cat pr-description.md)"
```

### After PR Merge

1. **Delete branch**: `git branch -d feature/{{PROJECT_KEY}}-123-description`
2. **Pull latest develop**: `git checkout develop && git pull`

---

## Merge vs Rebase

| Scenario | Strategy |
|----------|----------|
| Feature branch into develop | **Squash merge** (clean history) |
| Develop into main (release) | **Merge commit** (preserve history) |
| Hotfix into main | **Merge commit** |
| Update feature branch with develop | **Rebase** (linear history) |
| Pull from remote | **Rebase** (`git pull --rebase`) |

**Never force-push to shared branches** (main, develop).

---

## Git Hygiene Checklist

- [ ] No merge commits in feature branch (rebase instead)
- [ ] No WIP/fixup commits in final PR
- [ ] No secrets in commit history
- [ ] No large binary files committed (use LFS if needed)
- [ ] `.gitignore` covers build artifacts, IDE files, env files
- [ ] Branch name follows convention
- [ ] All commits follow message convention
- [ ] Signed commits if required by project policy

---

## Emergency Procedures

### Hotfix Flow
1. `git checkout main && git pull`
2. `git checkout -b hotfix/{{PROJECT_KEY}}-XXX-critical-fix`
3. Fix the issue
4. `git push origin hotfix/{{PROJECT_KEY}}-XXX-critical-fix`
5. Create PR to `main` with expedited review
6. After merge: cherry-pick to `develop`
7. Tag the release

### Reverting a Bad Merge
1. `git revert -m 1 <merge-commit-hash>` (for merge commits)
2. Create PR with explanation of what is being reverted and why
3. Follow normal review process

---

## PR Template Placeholder Reference

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{{FEATURE_DESCRIPTION}}` | What the feature does | "add two-factor authentication" |
| `{{ISSUE_KEY}}` | Related Jira/GitHub issue | "PROJ-123" or "#123" |
| `{{CHANGE_1}}` | Specific code change | "Add TOTP service" |
| `{{ARCHITECTURE}}` | Architecture pattern used | "DDD + Clean Architecture" |
| `{{AFFECTED_MODULES}}` | Modules changed | "auth, api, ui" |
| `{{API_CHANGES}}` | API endpoints added/changed | "POST /v1/auth/2fa/enable" |
| `{{DATABASE_CHANGES}}` | Schema/migration changes | "Add two_factor_auth table" |
| `{{GDPR_APPLICABLE}}` | Whether GDPR applies | "Yes — touches PII" |
| `{{DORA_APPLICABLE}}` | Whether DORA applies | "Yes — financial entity" |
| `{{MICA_APPLICABLE}}` | Whether MiCA applies | "No — no crypto assets" |
| `{{PSD2_APPLICABLE}}` | Whether PSD2 applies | "No — no payments" |
| `{{PCI_APPLICABLE}}` | Whether PCI-DSS applies | "No — tokenized payments" |
| `{{MIN_COVERAGE}}` | Minimum test coverage | "80%" |
| `{{BUILD_COMMAND}}` | Build command | "mvn clean compile" |
| `{{TEST_COMMAND}}` | Test command | "mvn test" |
| `{{LINT_COMMAND}}` | Lint command | "npm run lint" |
| `{{TEST_INSTRUCTIONS}}` | How reviewers can test | "1. Run tests..." |
| `{{SCREENSHOTS_OR_EVIDENCE}}` | Visual proof or logs | "Screenshot attached" |
| `{{BRANCH_NAMING}}` | Branch naming convention | "feature/PROJ-123-description" |
| `{{COMMIT_CONVENTION}}` | Commit message format | "Conventional Commits" |
| `{{BUG_DESCRIPTION}}` | Short bug description | "login fails with valid credentials" |
| `{{ROOT_CAUSE}}` | Why the bug happened | "null pointer in auth service" |
| `{{FIX_DESCRIPTION}}` | How it was fixed | "add null check and retry" |
| `{{AFFECTED_FILES}}` | Files changed | "src/auth/..." |
| `{{REPRO_STEPS}}` | Steps to reproduce | "1. Go to login..." |
| `{{VERIFICATION_STEPS}}` | Steps to verify fix | "1. Run login test..." |
| `{{SECURITY_TITLE}}` | Security issue title | "SQL injection in search" |
| `{{OWASP_CATEGORY}}` | OWASP category | "A03: Injection" |
| `{{SECURITY_SEVERITY}}` | Severity | "Critical" |
| `{{SECURITY_DESCRIPTION}}` | Vulnerability description | "User input concatenated into query" |
| `{{SECURITY_IMPACT}}` | Impact | "Data exfiltration possible" |
| `{{FIX_DESCRIPTION}}` | Security fix | "Use parameterized queries" |
| `{{DISCLOSURE_STATUS}}` | Disclosure status | "Reported privately, now fixed" |
| `{{PR_TITLE}}` | PR title | "feat(auth): add 2FA" |
| `{{REVIEWER_USERNAME}}` | GitHub reviewer | "@teammate" |
| `{{DESCRIPTION}}` | General description | "Update CI pipeline" |

---

## How to Use PR Templates

1. **Pick the template** that matches the change type (feature, bug, security, docs/chore)
2. **Copy the template** into a temporary file (e.g., `pr-description.md`)
3. **Replace every placeholder** with real values from the current task
4. **Review the description** before submitting
5. **Submit the PR** via GitHub/GitLab web UI or CLI

### Quick Command Workflow

```bash
# 1. Create branch
git checkout -b feature/{{PROJECT_KEY}}-123-short-description

# 2. Make changes and commit

# 3. Push
git push origin feature/{{PROJECT_KEY}}-123-short-description

# 4. Create PR description from template
cp .github/pull_request_template.md pr-description.md
# Edit pr-description.md, replacing placeholders

# 5. Create PR
gh pr create --base develop --title "feat(scope): description" --body-file pr-description.md

# 6. Clean up
rm pr-description.md
```

---

## Rules

1. **Always use a template** — never submit an empty PR description
2. **Replace all placeholders** — raw templates are not acceptable
3. **Link to issues** — every PR should reference at least one issue/ticket
4. **Include testing instructions** — reviewers must know how to verify
5. **Security fixes get the security template** — do not use generic templates for security
6. **Self-review before requesting review** — read your own diff first
