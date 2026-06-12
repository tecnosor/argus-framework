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

| Skill | Purpose |
|-------|---------|
| `build-check` | Build pipeline validation |
| `code-review` | Structured code review |
| `compliance-eu` | GDPR, DORA, MiCA compliance |
| `owasp-top10` | OWASP Top 10 security checks |
| `git-flow` | Git workflow enforcement |
| `history-scan` | Git history analysis |
| `jira-integration` | Jira issue management |
| `lang-enforcer` | English language enforcement |
| `ui-ux` | UI/UX design standards |
| `project-status` | Project status reporting |
| `secure-coder` | OWASP secure coding |
| `test-driven` | TDD enforcement |

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
