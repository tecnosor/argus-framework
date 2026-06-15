# {{PROJECT_NAME}}

> {{PROJECT_DESCRIPTION}}

This project uses the **Banking Compliance Agentic Framework** — a set of AI agents
and skills designed for enterprise banking software development with strict compliance
requirements (OWASP, GDPR, DORA, MiCA).

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| **Backend Language** | {{BACKEND_LANG}} |
| **Backend Framework** | {{BACKEND_FRAMEWORK}} |
| **Frontend Language** | {{FRONTEND_LANG}} |
| **Frontend Framework** | {{FRONTEND_FRAMEWORK}} |
| **Database** | {{DATABASE}} |
| **Migration Tool** | {{MIGRATION_TOOL}} |
| **Build Tool** | {{BUILD_TOOL}} |
| **Test Frameworks** | {{TEST_FRAMEWORKS}} |
| **Architecture** | {{ARCHITECTURE}} |

---

## Build & Test Commands

```bash
# Install dependencies
{{INSTALL_COMMAND}}

# Build / Compile
{{BUILD_COMMAND}}

# Run linter
{{LINT_COMMAND}}

# Run unit tests
{{TEST_COMMAND}}

# Run integration tests
{{INTEGRATION_TEST_COMMAND}}

# Run E2E tests
{{E2E_TEST_COMMAND}}
```

---

## Project Structure

```
{{PROJECT_STRUCTURE}}
```

---

## Architecture: {{ARCHITECTURE}}

{{ARCHITECTURE_DESCRIPTION}}

### Layer Rules

- **Domain**: No framework imports. Pure business logic. Entities, value objects, domain services.
- **Application**: Use case orchestration. Commands and queries (CQRS). DTOs.
- **Infrastructure**: Database access, external service adapters, framework configuration.
- **Interfaces**: REST controllers, gRPC handlers, message consumers. Input validation only.

### Design Principles

{{DESIGN_PATTERNS}}

- SOLID principles enforced
- Constructor injection only (no field injection)
- No `@Transactional` on infrastructure layer
- No business logic in controllers
- No direct entity exposure in API (DTOs only)

---

## Compliance Requirements

| Framework | Applicable | Scope |
|-----------|-----------|-------|
| **GDPR** | {{GDPR_APPLICABLE}} | {{GDPR_SCOPE}} |
| **DORA** | {{DORA_APPLICABLE}} | {{DORA_SCOPE}} |
| **MiCA** | {{MICA_APPLICABLE}} | {{MICA_SCOPE}} |
| **PCI-DSS** | {{PCI_APPLICABLE}} | {{PCI_SCOPE}} |
| **ISO 20022** | {{ISO20022_APPLICABLE}} | {{ISO20022_SCOPE}} |
| **SEPA** | {{SEPA_APPLICABLE}} | {{SEPA_SCOPE}} |
| **eIDAS** | {{EIDAS_APPLICABLE}} | {{EIDAS_SCOPE}} |
| **OWASP Top 10** | Always | All code changes |

---

## Coding Standards

### Naming Conventions: {{NAMING_CONVENTIONS}}

### API Standards: {{API_STANDARDS}}

### Git Workflow: {{GIT_WORKFLOW}}

- **Branch naming**: `{{BRANCH_NAMING}}`
- **Commit messages**: `{{COMMIT_CONVENTION}}`

### Definition of Done

{{DEFINITION_OF_DONE}}

---

## Agents

| Agent | Mode | Purpose |
|-------|------|---------|
| **Orchestrator** | Primary | SDLC workflow coordinator. Entry point for all requests. |
| **Backend Dev** | Subagent | Backend implementation ({{BACKEND_LANG}}/{{BACKEND_FRAMEWORK}}) |
| **Frontend Dev** | Subagent | Frontend implementation ({{FRONTEND_LANG}}/{{FRONTEND_FRAMEWORK}}) |
| **Reviewer** | Subagent | Security, compliance, and standards gate (read-only) |
| **Testing** | Subagent | QA engineering, test planning and execution |

Agent definitions: `.agents/agents/`

---

## Skills

### Core Skills (Always Installed)

| Skill | Purpose |
|-------|---------|
| `build-check` | Build pipeline validation |
| `code-review` | Structured code review |
| `git-flow` | Git workflow enforcement |
| `history-scan` | Git history analysis |
| `jira-integration` | Jira issue management with parameterized templates |
| `lang-enforcer` | English language enforcement |
| `owasp-top10` | OWASP Top 10 security checks |
| `project-status` | Project status reporting |
| `secure-coder` | OWASP secure coding |
| `test-driven` | TDD enforcement |
| `ui-ux` | UI/UX design standards |

### Compliance Skills (Install Only What Applies)

| Skill | Regulation | Install If |
|-------|------------|------------|
| `gdpr` | General Data Protection Regulation | Project processes EU personal data |
| `dora` | Digital Operational Resilience Act | Project is a financial entity or ICT provider |
| `mica` | Markets in Crypto-Assets Regulation | Project handles crypto-assets |
| `psd2` | Payment Services Directive 2 | Project provides payment/account services |
| `pci-dss` | Payment Card Industry Data Security Standard | Project processes cardholder data |
| `iso-20022` | Financial Messaging Standard | Project exchanges payment messages (pain, pacs, camt) |
| `sepa` | Single Euro Payments Area | Project processes euro payments within EU/EEA |
| `eidas` | Electronic Identification and Trust Services | Project uses electronic identity, digital signatures, or KYC |
| `compliance-eu` | Dispatcher/meta-skill | Backward compatibility or all frameworks apply |

**Installation rule:** Only copy the compliance and banking skills that match `{{COMPLIANCE_FRAMEWORKS}}`.
Do not install MiCA for a non-crypto project. Do not install PCI-DSS for tokenized payment flows.

Skill definitions: `.agents/skills/`

---

## Documentation

| Document | Location |
|----------|----------|
| Architecture | `.agents/docs/architecture.md` |
| Coding Standards | `.agents/docs/coding-standards.md` |
| Security Policy | `.agents/docs/security-policy.md` |
| Database Schema | `.agents/docs/database-schema.md` |
| UI/UX Guidelines | `.agents/docs/ui-ux-guidelines.md` |
| API Standards | `.agents/docs/api-standards.md` |

---

## Installation

To install this framework in a new workspace, read `AGENTIC-INSTALLATION.md` and follow
the phased installation process. The installation script will:

1. Analyze your workspace
2. Ask configuration questions
3. Adapt all agents and skills to your project
4. Generate project-specific documentation
5. Configure your AI coding agent platform

---

## Language Standard

**All code, comments, documentation, and communication must be in English.**
The `lang-enforcer` skill will detect and report non-English content.

Exception: i18n translation files (`src/i18n/`, `locales/`, `translations/`) are excluded.
