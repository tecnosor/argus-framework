#!/usr/bin/env bash

set -euo pipefail

# Reviewer Gate — deterministic governance and git-hygiene checks for CI/CD.
# Outputs a structured findings file and exits 0 (approved) or 1 (changes requested).

REVIEWER_FINDINGS_FILE="${REVIEWER_FINDINGS_FILE:-reviewer-findings.txt}"
rm -f "$REVIEWER_FINDINGS_FILE"
touch "$REVIEWER_FINDINGS_FILE"

BLOCKING_COUNT=0
WARNING_COUNT=0

log_blocking() {
    local file="$1"
    local line="$2"
    local message="$3"
    echo "BLOCKING|${file}|${line}|${message}" >> "$REVIEWER_FINDINGS_FILE"
    BLOCKING_COUNT=$((BLOCKING_COUNT + 1))
}

log_warning() {
    local file="$1"
    local line="$2"
    local message="$3"
    echo "WARNING|${file}|${line}|${message}" >> "$REVIEWER_FINDINGS_FILE"
    WARNING_COUNT=$((WARNING_COUNT + 1))
}

check_governance_files() {
    local files=("CODEOWNERS" "CONTRIBUTING.md" "CODE_OF_CONDUCT.md" "SECURITY.md" "LICENSE")
    for f in "${files[@]}"; do
        if [ ! -f "$f" ]; then
            log_blocking "$f" "1" "Missing required governance file"
        fi
    done
}

check_codeowners() {
    if [ ! -f "CODEOWNERS" ]; then
        return 0
    fi

    if ! grep -qE '^\*\s+@\w+' CODEOWNERS; then
        log_blocking "CODEOWNERS" "1" "CODEOWNERS must define a global owner with '* @username'"
    fi
}

check_conventional_commits() {
    local base_branch="${GITHUB_BASE_REF:-main}"
    local range

    if [ -n "${GITHUB_BASE_REF:-}" ] && git rev-parse "origin/${base_branch}" >/dev/null 2>&1; then
        range="origin/${base_branch}..HEAD"
    else
        local last_tag
        last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
        if [ -n "$last_tag" ]; then
            range="${last_tag}..HEAD"
        else
            return 0
        fi
    fi

    local invalid_commit
    invalid_commit=$(git log --oneline --no-merges "$range" | while read -r hash msg; do
        if ! echo "$msg" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+'; then
            echo "$hash $msg"
            break
        fi
    done || true)

    if [ -n "$invalid_commit" ]; then
        log_blocking "git history" "1" "Commit does not follow Conventional Commits: ${invalid_commit}"
    fi
}

check_markdown_links() {
    while IFS= read -r -d '' file; do
        while IFS= read -r link; do
            local url
            url=$(echo "$link" | grep -oE '\(([^)]+)\)' | tr -d '()' || true)

            if [[ "$url" =~ ^#.*$ ]]; then continue; fi
            if [[ "$url" =~ ^https?://.*$ ]]; then continue; fi
            if [[ "$url" =~ ^mailto:.*$ ]]; then continue; fi

            if [[ "$url" != /* ]]; then
                local dir
                dir=$(dirname "$file")
                local target="$dir/$url"
                if [ ! -e "$target" ]; then
                    log_blocking "$file" "1" "Broken relative link: $url"
                fi
            fi
        done < <(grep -oE '\[([^\]]+)\]\(([^)]+)\)' "$file" || true)
    done < <(find . -name '*.md' -type f ! -path './.git/*' -print0)
}

check_wip_commits() {
    local base_branch="${GITHUB_BASE_REF:-main}"

    if [ -z "${GITHUB_BASE_REF:-}" ] || ! git rev-parse "origin/${base_branch}" >/dev/null 2>&1; then
        return 0
    fi

    local wip_commit
    wip_commit=$(git log --format='%H %s' --no-merges "origin/${base_branch}..HEAD" | grep -iE '\b(WIP|fixup|squash!|amend)\b' | head -n 1 || true)

    if [ -n "$wip_commit" ]; then
        log_blocking "git history" "1" "PR contains WIP/fixup commit: ${wip_commit}"
    fi
}

check_merge_commits() {
    local base_branch="${GITHUB_BASE_REF:-main}"

    if [ -z "${GITHUB_BASE_REF:-}" ] || ! git rev-parse "origin/${base_branch}" >/dev/null 2>&1; then
        return 0
    fi

    local merge_commit
    merge_commit=$(git log --format='%H %s' --merges "origin/${base_branch}..HEAD" | head -n 1 || true)

    if [ -n "$merge_commit" ]; then
        log_warning "git history" "1" "Feature branch contains merge commit (rebase preferred): ${merge_commit}"
    fi
}

check_governance_files
check_codeowners
check_conventional_commits
check_markdown_links
check_wip_commits
check_merge_commits

echo ""
echo "# Reviewer Gate Report"
echo ""
echo "| Metric | Count |"
echo "|--------|-------|"
echo "| Blocking issues | ${BLOCKING_COUNT} |"
echo "| Warnings | ${WARNING_COUNT} |"
echo ""

if [ "$BLOCKING_COUNT" -gt 0 ]; then
    echo "## Verdict: CHANGES REQUESTED"
    echo ""
    echo "Blocking findings must be resolved before merge."
    echo ""
    echo "### Findings"
    sed 's/|/ | /g' "$REVIEWER_FINDINGS_FILE"
    exit 1
else
    echo "## Verdict: APPROVED"
    echo ""
    if [ "$WARNING_COUNT" -gt 0 ]; then
        echo "Approved with ${WARNING_COUNT} warning(s). Consider addressing them."
        echo ""
        echo "### Warnings"
        grep '^WARNING|' "$REVIEWER_FINDINGS_FILE" | sed 's/|/ | /g'
    else
        echo "All automated reviewer checks passed."
    fi
    exit 0
fi
