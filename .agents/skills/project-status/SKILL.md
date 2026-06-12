---
name: project-status
description: "Reads and reports the current project status from issue tracker, git activity, and codebase health. Provides board overview, WIP tracking, blocker identification, and sprint progress. Use for status reports, standup summaries, and project health checks."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: orchestrator
  phase: planning, review
---

# Project Status Skill

You are generating a **Project Status Report** for **{{PROJECT_NAME}}**.

## Purpose

Provide a comprehensive view of the current project state by combining data from
the issue tracker, git repository, and codebase health metrics.

---

## Data Sources

### 1. Issue Tracker Status

If `{{ISSUE_TRACKER}}` is Jira:

```bash
# Get all issues in current sprint/active board
curl -s -H "$AUTH_HEADER" \
  "${JIRA_URL}/search?jql=project={{PROJECT_KEY}}+AND+sprint+in+openSprints()&maxResults=100"

# Get issues by status
curl -s -H "$AUTH_HEADER" \
  "${JIRA_URL}/search?jql=project={{PROJECT_KEY}}+AND+status=\"In+Progress\"&maxResults=50"

# Get blockers
curl -s -H "$AUTH_HEADER" \
  "${JIRA_URL}/search?jql=project={{PROJECT_KEY}}+AND+priority=\"Highest\"+AND+status!=\"Done\"&maxResults=50"
```

If GitHub Issues:

```bash
gh issue list --state open --label "in-progress"
gh issue list --state open --label "blocked"
gh project view --owner <owner> --number <number>
```

### 2. Git Activity

```bash
# Recent commits (last 7 days)
git log --since="7 days ago" --oneline --all

# Active branches
git branch -a --sort=-committerdate | head -10

# Unmerged PRs (GitHub)
gh pr list --state open

# Merge frequency (last 30 days)
git log --merges --since="30 days ago" --oneline | wc -l
```

### 3. Codebase Health

```bash
# Test coverage (if available)
# Maven: check target/site/jacoco/index.html
# npm: check coverage/lcov-report/index.html

# TODO/FIXME count
grep -rn "TODO\|FIXME" --include="*.java" --include="*.ts" --include="*.tsx" --include="*.vue" src/ | wc -l

# Dependency freshness
# npm: npm outdated
# Maven: mvn versions:display-dependency-updates
```

---

## Report Format

```markdown
# Project Status Report — {{PROJECT_NAME}}
## Date: YYYY-MM-DD

### Board Overview

| Status | Count | Issues |
|--------|-------|--------|
| Backlog | X | |
| To Do | X | |
| In Progress | X | [list] |
| In Review | X | [list] |
| Testing | X | [list] |
| Done (this sprint) | X | |

### WIP Check
- **In Progress**: X / 2 (WIP limit)
- **Status**: ✅ Within limit | ⚠️ At limit | 🔴 Exceeds limit

### Blockers
1. [PROJ-XXX] — [description] — [assigned to] — [days blocked]

### Recent Activity (Last 7 Days)
- Commits: X
- PRs merged: X
- PRs opened: X
- Issues closed: X
- Issues created: X

### Sprint Progress
- **Total story points**: X
- **Completed**: X (XX%)
- **Remaining**: X (XX%)
- **Days remaining**: X

### Codebase Health
- **Test coverage**: XX% (target: {{MIN_COVERAGE}}%)
- **TODO/FIXME count**: X
- **Outdated dependencies**: X
- **Build status**: ✅ Passing | ❌ Failing

### Key Risks
1. [risk description and impact]

### Recommendations
1. [actionable recommendation]
```

---

## Standup Summary

For daily standup format:

```markdown
## Standup Summary — YYYY-MM-DD

### Yesterday
- [PROJ-XXX] [description] — [status change]

### Today
- [PROJ-XXX] [description] — [planned action]

### Blockers
- [description] — [who can help]
```

---

## Rules

1. **Read-only** — never modify issues or code when generating status
2. **Current data** — always fetch fresh data, do not use cached results
3. **Actionable** — highlight blockers and risks that need attention
4. **Concise** — status reports should be scannable in 30 seconds
5. **WIP awareness** — always check and report WIP limit compliance
