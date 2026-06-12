---
name: history-scan
description: "Analyzes git history to map commits, branches, and changes into structured documentation. Identifies contributors, change patterns, release history, and technical debt indicators. Use for release notes, changelog generation, audit trails, and understanding project evolution."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: orchestrator, reviewer
  phase: planning, review
---

# History Scan Skill

You are performing a **Git History Analysis** for **{{PROJECT_NAME}}**.

## Purpose

Analyze the git repository history to extract structured information for
documentation, auditing, release notes, and project health assessment.

---

## Analysis Capabilities

### 1. Change Mapping

Map recent changes to understand what was modified:

```bash
# Recent commits with files changed
git log --oneline --name-status -20

# Changes in a specific time range
git log --since="2026-01-01" --until="2026-06-12" --oneline

# Changes by specific author
git log --author="name" --oneline -20

# Changes to specific file/directory
git log --oneline -- path/to/file
```

### 2. Contributor Analysis

```bash
# Contributors by commit count
git shortlog -sn --all

# Contributors by lines changed
git log --format='%aN' | sort -u | while read name; do
  echo "$name: $(git log --author="$name" --pretty=tformat: --numstat | \
    awk '{add+=$1; del+=$2} END {print "+"add" -"del}')"
done

# Recent activity by contributor
git log --since="30 days ago" --format="%aN" | sort | uniq -c | sort -rn
```

### 3. Release History

```bash
# Tags (releases)
git tag -l --sort=-v:refname

# Commits between releases
git log v1.0.0..v1.1.0 --oneline

# Changelog from commits
git log v1.0.0..v1.1.0 --pretty=format:"%h %s" --no-merges
```

### 4. Branch Analysis

```bash
# All branches with last commit date
git branch -a --sort=-committerdate --format='%(refname:short) %(committerdate:short)'

# Stale branches (no commits in 30+ days)
git branch -a --sort=-committerdate --format='%(refname:short) %(committerdate:short)' | \
  awk '$2 < "2026-05-13"'

# Branch merge status
git branch --merged develop
git branch --no-merged develop
```

### 5. Technical Debt Indicators

```bash
# Files with most changes (potential hotspots)
git log --pretty=format: --name-only | sort | uniq -c | sort -rn | head -20

# Largest files in repo
git ls-files | xargs wc -l | sort -rn | head -20

# TODO/FIXME/HACK comments
git grep -n "TODO\|FIXME\|HACK\|XXX\|WORKAROUND" -- '*.java' '*.ts' '*.tsx' '*.vue'

# Commit patterns suggesting debt
git log --oneline --all --grep="quick fix\|temporary\|hack\|workaround\|TODO" -i
```

### 6. Security History

```bash
# Commits mentioning security
git log --oneline --all --grep="security\|vulnerability\|CVE\|patch\|fix.*auth" -i

# History of sensitive files
git log --oneline -- "**/security*" "**/auth*" "**/crypto*" "**/secret*"

# Deleted sensitive files
git log --diff-filter=D --name-only --oneline -- "*.env" "*.key" "*.pem"
```

---

## Output Formats

### Changelog Format

```markdown
# Changelog — vX.Y.Z (YYYY-MM-DD)

## Features
- [hash] feat(scope): description (#PR)
- [hash] feat(scope): description (#PR)

## Bug Fixes
- [hash] fix(scope): description (#PR)

## Performance
- [hash] perf(scope): description (#PR)

## Breaking Changes
- [hash] feat(scope)!: description (#PR)

## Contributors
- @contributor1 (X commits)
- @contributor2 (Y commits)
```

### Project Health Report

```markdown
# Project Health Report

## Period: [date range]

### Activity
- Total commits: X
- Active contributors: X
- Files changed: X
- Lines added/removed: +X / -X

### Hotspots (most changed files)
1. path/to/file.java — X changes
2. path/to/file.ts — X changes

### Technical Debt Signals
- TODO/FIXME comments: X
- "Quick fix" commits: X
- Stale branches: X

### Security Signals
- Security-related commits: X
- Sensitive file changes: X
- Dependency updates: X

### Recommendations
1. [recommendation based on analysis]
```

---

## Rules

1. **Read-only analysis** — never modify git history
2. **Respect privacy** — do not expose personal information beyond what is in git
3. **Time-bounded** — always specify a time range for analysis
4. **Actionable output** — findings should lead to decisions, not just information
5. **No blame** — contributor analysis is for understanding, not finger-pointing
