#!/usr/bin/env bash

set -euo pipefail

# -----------------------------------------------------------------------------
# Semantic Versioning Release Script
# -----------------------------------------------------------------------------
# Usage: ./scripts/release.sh [patch|minor|major]
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
VERSION_FILE="${REPO_ROOT}/VERSION"
CHANGELOG_FILE="${REPO_ROOT}/CHANGELOG.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Get current version
get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE" | tr -d '[:space:]'
    else
        echo "0.0.0"
    fi
}

# Bump version
bump_version() {
    local version="$1"
    local type="$2"

    local major=$(echo "$version" | cut -d. -f1)
    local minor=$(echo "$version" | cut -d. -f2)
    local patch=$(echo "$version" | cut -d. -f3)

    case "$type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            log_error "Invalid bump type: $type. Use patch, minor, or major."
            exit 1
            ;;
    esac

    echo "${major}.${minor}.${patch}"
}

# Validate git state
validate_git_state() {
    if [ -n "$(git status --porcelain)" ]; then
        log_error "Working directory is not clean. Commit or stash changes before releasing."
        exit 1
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$branch" != "main" ] && [ "$branch" != "master" ]; then
        log_warn "You are on branch '$branch'. Releases should typically be created from main/master."
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Validate conventional commits since last tag
validate_commits() {
    local last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    local range="${last_tag}..HEAD"
    
    if [ -z "$last_tag" ]; then
        range="HEAD"
    fi

    local invalid_commits=$(git log --oneline --no-merges "$range" | grep -v -E '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+' || true)

    if [ -n "$invalid_commits" ]; then
        log_error "The following commits do not follow Conventional Commits format:"
        echo "$invalid_commits"
        log_error "Please fix these commits before releasing."
        exit 1
    fi

    log_info "All commits follow Conventional Commits format."
}

# Update CHANGELOG.md
update_changelog() {
    local new_version="$1"
    local date=$(date +%Y-%m-%d)
    local temp_file="${CHANGELOG_FILE}.tmp"

    log_info "Updating CHANGELOG.md..."

    # Check if [Unreleased] section has any content
    local unreleased_content=$(sed -n '/## \[Unreleased\]/,/## \[/p' "$CHANGELOG_FILE" | sed '1d;$d' | sed '/^$/d' | head -n 1)
    
    if [ -z "$unreleased_content" ]; then
        log_warn "Unreleased section appears empty. Consider adding changes before releasing."
        read -p "Continue with empty release? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # Create new release entry
    cat > "$temp_file" <<EOF
# Changelog

All notable changes to the Argus Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
-

### Changed
-

### Deprecated
-

### Removed
-

### Fixed
-

### Security
-

## [${new_version}] - ${date}

EOF

    # Extract Unreleased content and append
    sed -n '/## \[Unreleased\]/,/## \[/{ /## \[Unreleased\]/d; /## \[/d; p; }' "$CHANGELOG_FILE" >> "$temp_file"

    # Append the rest of the file (previous releases)
    sed -n '/## \[0\.1\.0\]/,\$p' "$CHANGELOG_FILE" >> "$temp_file"

    # Update comparison links
    local last_version=$(get_current_version)
    if [ "$last_version" != "0.0.0" ]; then
        # Replace the unreleased link
        sed -i '' "s|\[unreleased\]: .*|[unreleased]: https://github.com/tecnosor/argus-framework/compare/v${new_version}...HEAD|" "$temp_file"
        
        # Add new version link
        sed -i '' "/\[0\.1\.0\]:/i\\
[${new_version}]: https://github.com/tecnosor/argus-framework/compare/v${last_version}...v${new_version}" "$temp_file"
    fi

    mv "$temp_file" "$CHANGELOG_FILE"
    log_info "CHANGELOG.md updated for v${new_version}."
}

# Update VERSION file
update_version_file() {
    local new_version="$1"
    echo "$new_version" > "$VERSION_FILE"
    log_info "VERSION file updated to ${new_version}."
}

# Main
main() {
    local bump_type="${1:-patch}"

    if [ "$bump_type" != "patch" ] && [ "$bump_type" != "minor" ] && [ "$bump_type" != "major" ]; then
        echo "Usage: $0 [patch|minor|major]"
        echo ""
        echo "Bump semantic version and create release artifacts."
        echo ""
        echo "Arguments:"
        echo "  patch    Bump patch version (0.0.1 -> 0.0.2)"
        echo "  minor    Bump minor version (0.1.0 -> 0.2.0)"
        echo "  major    Bump major version (1.0.0 -> 2.0.0)"
        exit 1
    fi

    cd "$REPO_ROOT"

    log_info "Starting release process..."
    
    validate_git_state
    validate_commits

    local current_version=$(get_current_version)
    log_info "Current version: ${current_version}"

    local new_version=$(bump_version "$current_version" "$bump_type")
    log_info "New version: ${new_version}"

    read -p "Create release v${new_version}? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Release cancelled."
        exit 0
    fi

    update_changelog "$new_version"
    update_version_file "$new_version"

    git add "$CHANGELOG_FILE" "$VERSION_FILE"
    git commit -m "chore(release): bump version to ${new_version} [skip ci]"

    git tag -a "v${new_version}" -m "Release v${new_version}"
    
    log_info "Created commit and tag v${new_version}."
    log_info "Push with: git push origin main --tags"
    log_info "GitHub/GitLab will automatically create the release."
}

main "$@"
