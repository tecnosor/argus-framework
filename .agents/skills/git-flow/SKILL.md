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
2. **Create PR/MR** with:
   - Title: follows commit convention format
   - Description: What, Why, How to test, Screenshots (if UI)
   - Link to issue/ticket
   - Assign reviewers

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
