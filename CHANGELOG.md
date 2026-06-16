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

## [0.2.0] - 2026-06-16

### Added
- **Reviewer Enforcement Gate**: new `.github/workflows/reviewer-gate.yml` that posts real PR reviews and creates blocking status checks.
- `.github/scripts/reviewer-checks.sh` deterministic governance and git-hygiene checks for CI/CD.
- GitLab `reviewer-gate` job in `.gitlab-ci.yml` for MR enforcement parity.
- Reviewer agent now documents dual-mode operation: advisory (chat) and enforcement (CI/CD).
- Reviewer agent permissions expanded to allow `gh pr review` and GitHub Checks API calls.
- Orchestrator Phase 6 explicitly handles Reviewer verdicts and blocks merge on requested changes.
- Documentation for the Reviewer Gate in `README.md` and `CONTRIBUTING.md`.
- GitLab CI/CD pipeline (`.gitlab-ci.yml`) with governance, lint, and build stages.
- GitLab issue templates for bug reports, feature requests, and security vulnerabilities.
- GitLab merge request template with compliance and testing checklists.
- GitHub release workflow for automated semantic versioning and CHANGELOG generation.
- GitLab release job for tag-based releases.
- `scripts/release.sh` for manual semantic version bumping and CHANGELOG updates.
- `VERSION` file for single-source-of-truth versioning.

### Changed
- Reviewer agent description updated from "read-only — never modifies code" to "read-only for source code, but can post PR reviews and status checks".

### Deprecated
- 

### Removed
- 

### Fixed
- 

### Security
- 

## [0.1.0] - 2026-06-16

### Added
- Initial release of the Argus Framework.
- Comprehensive skill system for AI agents (ISO 20022, SEPA, eIDAS, GDPR, DORA, MiCA, PCI-DSS, PSD2, OWASP Top 10, etc.).
- Codex Wallet project-specific skills (GitHub CLI, backlog-writer, issue-writer, build-check, code-review, etc.).
- Repository governance: CODEOWNERS, CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md, LICENSE.
- GitHub issue templates (bug report, feature request, security vulnerability).
- GitHub pull request template with compliance checklist.
- GitHub CI workflow with conventional commit lint, markdown link validation, and governance checks.
- `.gitignore` with patterns for AI agents, IDE files, and build artifacts.
- Documentation: README.md, AGENTIC-INSTALLATION.md, CHANGELOG.md.

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

[unreleased]: https://github.com/tecnosor/argus-framework/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/tecnosor/argus-framework/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/tecnosor/argus-framework/releases/tag/v0.1.0
