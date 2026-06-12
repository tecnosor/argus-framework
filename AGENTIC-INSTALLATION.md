# Agentic Installation Guide

> **This document is the master self-installation script for the Banking Compliance Agentic Framework.**
> Any AI coding agent (OpenCode, Cursor, Windsurf, Cline, Aider, etc.) can read this file to fully
> install and configure the framework into their workspace, adapting it to the specific project.

---

## Purpose

This framework provides a complete set of AI agents and skills designed for banking/financial
software development with strict compliance requirements (OWASP, GDPR, DORA, MiCA, PCI-DSS).
It follows an Agile SDLC workflow mimicking enterprise banking compliance processes.

**This guide instructs you (the AI coding agent) on how to:**

1. Analyze the target workspace
2. Ask the user the right configuration questions
3. Adapt all agents and skills to the specific project
4. Install everything in the correct locations
5. Generate project-specific documentation
6. Verify the installation

---

## Phase 0: Workspace Detection

Before asking any questions, silently analyze the workspace to gather:

### 0.1 Project Detection Checklist

```
[ ] Identify programming language(s) and frameworks
    - Check: package.json, pom.xml, build.gradle, Cargo.toml, go.mod, requirements.txt, etc.
    - Check: src/ structure, main entry points

[ ] Identify project type
    - Monorepo vs single project
    - Microservices vs monolith
    - Backend only / Frontend only / Full-stack

[ ] Identify build system
    - Maven / Gradle / npm / yarn / pnpm / bun / cargo / go / pip / poetry
    - Build commands (compile, test, lint)

[ ] Identify CI/CD
    - GitHub Actions / GitLab CI / Jenkins / Azure DevOps
    - Check: .github/workflows/, .gitlab-ci.yml, Jenkinsfile

[ ] Identify issue tracker
    - Jira (check for jira config files, .jira/, environment variables)
    - GitHub Issues / GitLab Issues
    - Azure DevOps Boards

[ ] Identify Git workflow
    - Check: .git/config, existing branches, .gitflow, commit history patterns
    - Branch naming conventions in use
    - Commit message conventions (conventional commits, etc.)

[ ] Identify existing code standards
    - Linter configs: .eslintrc, .prettierrc, checkstyle.xml, .editorconfig
    - Architecture patterns: DDD, Clean Architecture, Hexagonal, MVC
    - Check for existing AGENTS.md, .cursorrules, .windsurfrules

[ ] Identify testing frameworks
    - JUnit / Mockito / Vitest / Jest / pytest / Go testing
    - E2E: Playwright / Cypress / Selenium
    - Coverage tools: JaCoCo / Istanbul / coverage.py

[ ] Identify database technology
    - PostgreSQL / MySQL / Oracle / MongoDB / etc.
    - Migration tools: Liquibase / Flyway / Alembic / Prisma

[ ] Identify security/compliance tools already in use
    - SonarQube / Fortify / Snyk / Dependabot
    - Check for existing security policies

[ ] Identify AI coding agent platform
    - OpenCode: check for opencode.json, .opencode/
    - Cursor: check for .cursorrules, .cursor/
    - Windsurf: check for .windsurfrules
    - Cline: check for .clinerules
    - Generic: check for .agents/, AGENTS.md
```

### 0.2 Technology Stack Summary Template

After detection, build this internal summary:

```
Project Name: [detected from package.json, pom.xml, or directory name]
Languages: [e.g., Java 21, TypeScript 5.3]
Frameworks: [e.g., Spring Boot 3.2, Nuxt 3, React 18]
Build System: [e.g., Maven 3.9, npm 10]
Database: [e.g., PostgreSQL 16 with Liquibase]
Testing: [e.g., JUnit 5 + Mockito, Vitest]
CI/CD: [e.g., GitHub Actions]
Issue Tracker: [e.g., Jira at https://company.atlassian.net]
Git Workflow: [e.g., GitFlow with conventional commits]
Architecture: [e.g., DDD + Clean Architecture + CQRS]
AI Agent Platform: [e.g., OpenCode v1.x]
```

---

## Phase 1: User Questionnaire

After workspace detection, ask the user the following questions. Group them logically
and adapt based on what you already detected (skip what is obvious, confirm what is ambiguous).

### 1.1 General Configuration

```
Q1: What is the project name and a brief description?
    (Auto-detected: [X] - confirm or correct)

Q2: Which AI coding agent platform are you using?
    (Auto-detected: [X] - I will install in the correct paths)

Q3: What models do you have available? (list provider/model-id)
    - I need to assign models to agents:
      * Orchestrator: needs strong reasoning (recommended: Claude Sonnet 4, GPT-4o, Gemini 2.5 Pro)
      * Backend Dev: needs strong code generation (recommended: Claude Sonnet 4, GPT-4o)
      * Frontend Dev: needs strong UI/code generation (recommended: Claude Sonnet 4, GPT-4o)
      * Reviewer: needs strong analysis, read-only (recommended: Claude Sonnet 4, o3)
      * Testing: needs test generation (recommended: Claude Haiku 4, GPT-4o-mini for speed)

Q4: What is your team size and composition?
    (Helps calibrate WIP limits, review requirements, etc.)
```

### 1.2 Technology Stack Confirmation

```
Q5: Confirm the detected technology stack:
    - Backend language/framework: [detected]
    - Frontend language/framework: [detected]
    - Database: [detected]
    - Build tool: [detected]
    - Anything I missed?

Q6: What architecture pattern does this project follow?
    - DDD + Clean Architecture + CQRS
    - Hexagonal Architecture
    - Layered Architecture (Controller-Service-Repository)
    - Other: ___

Q7: What design patterns and principles are mandatory?
    - SOLID principles
    - Constructor injection only (no field injection)
    - Repository pattern
    - CQRS (Command/Query separation)
    - Event-driven patterns
    - Other: ___
```

### 1.3 Compliance & Security Scope

```
Q8: Which compliance frameworks apply to this project?
    [ ] GDPR (personal data handling)
    [ ] DORA (digital operational resilience)
    [ ] MiCA (crypto asset markets)
    [ ] PCI-DSS (payment card data)
    [ ] PSD2 (payment services)
    [ ] SOX (financial reporting)
    [ ] Other: ___

Q9: What security scanning tools are in use?
    - SonarQube / Fortify / Snyk / Dependabot / Trivy / Other

Q10: Are there specific data classification levels?
    - Public / Internal / Confidential / Restricted
    - What data types are handled? (PII, financial, credentials, etc.)
```

### 1.4 Workflow & Process

```
Q11: What issue tracker do you use?
    (Auto-detected: [X])
    - Jira: I need the project key and base URL
    - GitHub Issues: I need the repo owner/name
    - GitLab Issues: I need the project path
    - None: I will use local task tracking

Q12: What Git workflow do you follow?
    (Auto-detected: [X])
    - GitFlow (main, develop, feature/*, release/*, hotfix/*)
    - GitHub Flow (main + feature branches)
    - Trunk-Based Development
    - Other: ___

Q13: What are your commit message conventions?
    - Conventional Commits (feat:, fix:, chore:, etc.)
    - Jira ticket prefix (PROJ-123: description)
    - Other: ___

Q14: What is your Definition of Done?
    - Code review required?
    - Minimum test coverage? (e.g., 80%)
    - Security scan must pass?
    - Documentation updated?
    - Performance benchmarks?
    - Other: ___

Q15: What are your branch naming conventions?
    - feature/PROJ-123-short-description
    - fix/PROJ-123-short-description
    - Other: ___
```

### 1.5 Project-Specific Rules

```
Q16: Are there existing coding standards documents I should reference?
    - Point me to files, wikis, or URLs

Q17: What are the naming conventions?
    - Backend: classes (PascalCase), methods (camelCase), DB tables (snake_case), etc.
    - Frontend: components (PascalCase), hooks (useCamelCase), CSS (BEM/Tailwind), etc.

Q18: What API design standards apply?
    - REST with OpenAPI spec
    - GraphQL
    - gRPC
    - Versioning strategy: /v1/ or header-based

Q19: Are there specific modules or bounded contexts I should know about?
    (Helps create module-specific AGENTS.md files)

Q20: Any additional constraints or preferences?
    - Language for code/docs (default: English)
    - Forbidden libraries or patterns
    - Performance requirements (API < Xms, page load < Ys)
    - Accessibility requirements (WCAG level)
```

---

## Phase 2: Installation Execution

After gathering answers, execute the following installation steps.

### 2.1 Determine Installation Paths

Based on the detected AI coding agent platform:

| Platform | Agents Path | Skills Path | Rules Path | Config File |
|----------|-------------|-------------|------------|-------------|
| **OpenCode** | `.agents/agents/` | `.agents/skills/` | `AGENTS.md` | `opencode.json` |
| **Cursor** | `.cursor/agents/` (if supported) | `.cursor/skills/` (if supported) | `.cursorrules` | `.cursor/` |
| **Windsurf** | `.agents/agents/` | `.agents/skills/` | `.windsurfrules` | N/A |
| **Cline** | `.agents/agents/` | `.agents/skills/` | `.clinerules` | N/A |
| **Generic** | `.agents/agents/` | `.agents/skills/` | `AGENTS.md` | N/A |

**Default: Use `.agents/` paths (agent-agnostic standard).**
Also create `AGENTS.md` at project root for maximum compatibility.

### 2.2 Copy Agent Definitions

For each agent file in `.agents/agents/`:

1. Read the template from this framework
2. Replace all `{{PLACEHOLDER}}` markers with user-provided values
3. Write the adapted file to the target workspace

**Agents to install:**

| Agent | File | Mode | Purpose |
|-------|------|------|---------|
| Orchestrator | `orchestrator.md` | primary | SDLC workflow coordinator |
| Backend Developer | `backend-dev.md` | subagent | Backend implementation |
| Frontend Developer | `frontend-dev.md` | subagent | Frontend implementation |
| Reviewer | `reviewer.md` | subagent | Security/compliance gate |
| Testing | `testing.md` | subagent | QA and test automation |

### 2.3 Copy Skill Definitions

For each skill folder in `.agents/skills/`:

1. Read the SKILL.md template
2. Replace all `{{PLACEHOLDER}}` markers
3. Write the adapted SKILL.md to the target workspace

**Skills to install:**

| Skill | Folder | Purpose |
|-------|--------|---------|
| build-check | `build-check/` | Build pipeline validation |
| code-review | `code-review/` | Structured code review |
| compliance-eu | `compliance-eu/` | GDPR, DORA, MiCA compliance |
| owasp-top10 | `owasp-top10/` | OWASP Top 10 security checks |
| git-flow | `git-flow/` | Git workflow enforcement |
| history-scan | `history-scan/` | Git history analysis |
| jira-integration | `jira-integration/` | Jira issue management |
| lang-enforcer | `lang-enforcer/` | English language enforcement |
| ui-ux | `ui-ux/` | UI/UX design standards |
| project-status | `project-status/` | Project status reporting |
| secure-coder | `secure-coder/` | OWASP secure coding |
| test-driven | `test-driven/` | TDD enforcement |

### 2.4 Generate AGENTS.md (Root Rules)

Using the workspace analysis and user answers, generate a project-specific `AGENTS.md`
at the project root. Use the template in `.agents/rules/AGENTS-TEMPLATE.md` and fill in:

- Project name and description
- Technology stack details
- Architecture patterns
- Coding standards (detected + user-provided)
- Build/test/lint commands
- Agent and skill references
- Compliance requirements
- Definition of Done

### 2.5 Generate Project Documentation

Create or update the `.agents/docs/` folder with:

| Document | Purpose | Source |
|----------|---------|--------|
| `architecture.md` | System architecture overview | Codebase analysis + user input |
| `coding-standards.md` | Coding conventions and rules | Detected configs + user input |
| `security-policy.md` | Security requirements | Compliance scope + user input |
| `database-schema.md` | Database design and conventions | Migration files + user input |
| `ui-ux-guidelines.md` | UI/UX design system | Frontend code + user input |
| `api-standards.md` | API design conventions | Existing APIs + user input |

### 2.6 Create Module-Specific AGENTS.md (If Needed)

If the project has distinct modules/bounded contexts (e.g., microservices, monorepo packages),
create additional `AGENTS.md` files in those subdirectories with module-specific rules.

Detection heuristic:
- Monorepo with `packages/` or `apps/` → one AGENTS.md per package
- Microservices → one AGENTS.md per service root
- Bounded contexts in DDD → one AGENTS.md per context folder

### 2.7 Configure Platform-Specific Settings

**For OpenCode:**
Generate or update `opencode.json` with agent configurations:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "orchestrator": {
      "mode": "primary",
      "model": "{{ORCHESTRATOR_MODEL}}",
      "description": "SDLC workflow coordinator for banking compliance projects",
      "permission": {
        "edit": "allow",
        "bash": "allow",
        "read": "allow",
        "glob": "allow",
        "grep": "allow",
        "webfetch": "allow",
        "task": "allow"
      }
    },
    "backend-dev": {
      "mode": "subagent",
      "model": "{{BACKEND_MODEL}}",
      "description": "Backend developer for {{BACKEND_TECH}} services",
      "permission": {
        "edit": "allow",
        "bash": "allow",
        "read": "allow",
        "glob": "allow",
        "grep": "allow"
      }
    },
    "frontend-dev": {
      "mode": "subagent",
      "model": "{{FRONTEND_MODEL}}",
      "description": "Frontend developer for {{FRONTEND_TECH}} applications",
      "permission": {
        "edit": "allow",
        "bash": "allow",
        "read": "allow",
        "glob": "allow",
        "grep": "allow"
      }
    },
    "reviewer": {
      "mode": "subagent",
      "model": "{{REVIEWER_MODEL}}",
      "description": "Security, compliance and standards reviewer - final gate before merge",
      "permission": {
        "edit": "deny",
        "bash": {
          "*": "deny",
          "git log*": "allow",
          "git diff*": "allow",
          "git branch*": "allow",
          "grep *": "allow",
          "rg *": "allow"
        },
        "read": "allow",
        "glob": "allow",
        "grep": "allow",
        "webfetch": "allow"
      }
    },
    "testing": {
      "mode": "subagent",
      "model": "{{TESTING_MODEL}}",
      "description": "Senior QA engineer for test planning and execution",
      "permission": {
        "edit": "allow",
        "bash": "allow",
        "read": "allow",
        "glob": "allow",
        "grep": "allow"
      }
    }
  }
}
```

**For Cursor:**
Generate `.cursorrules` with condensed project rules from AGENTS.md.

**For Windsurf:**
Generate `.windsurfrules` with condensed project rules.

---

## Phase 3: Verification

After installation, verify:

```
[ ] All agent files exist and have valid YAML frontmatter
[ ] All skill SKILL.md files exist and have valid frontmatter
[ ] AGENTS.md exists at project root with project-specific content
[ ] No {{PLACEHOLDER}} markers remain in any file
[ ] Documentation files are generated in .agents/docs/
[ ] Platform-specific config is valid (opencode.json, .cursorrules, etc.)
[ ] Memory directories exist for each agent
[ ] All files are in English
```

### 3.1 Verification Commands

```bash
# Check all agent files exist
ls .agents/agents/*.md

# Check all skill files exist
ls .agents/skills/*/SKILL.md

# Check for leftover placeholders
grep -r "{{" .agents/ --include="*.md"

# Check AGENTS.md exists
cat AGENTS.md

# Validate opencode.json (if OpenCode)
cat opencode.json | python -m json.tool
```

---

## Phase 4: Post-Installation Summary

After successful installation, present the user with:

```markdown
## Installation Complete

### Installed Components
- **5 Agents**: Orchestrator, Backend Dev, Frontend Dev, Reviewer, Testing
- **12 Skills**: build-check, code-review, compliance-eu, owasp-top10, git-flow,
  history-scan, jira-integration, lang-enforcer, ui-ux, project-status, secure-coder, test-driven
- **Documentation**: architecture, coding-standards, security-policy, database-schema,
  ui-ux-guidelines, api-standards

### How to Use
1. The **Orchestrator** is your entry point - it coordinates the full SDLC workflow
2. Start any request with the Orchestrator and it will delegate to the right agents
3. Each agent follows the banking compliance Agile SDLC phases
4. The Reviewer is the final gate before any merge request

### Key Workflows
- **New Feature**: Orchestrator → Feature Definition → Backend/Frontend Dev → Testing → Reviewer
- **Bug Fix**: Orchestrator → Backend/Frontend Dev → Testing → Reviewer
- **Security Audit**: Orchestrator → Reviewer (OWASP + Compliance scan)
- **Code Review**: @reviewer with PR/MR URL

### Customization
- Edit any agent in `.agents/agents/` to adjust behavior
- Edit any skill in `.agents/skills/<name>/SKILL.md` to adjust rules
- Edit `AGENTS.md` to update project-wide rules
- Re-run installation to regenerate documentation
```

---

## Placeholder Reference

All placeholders used in agent and skill templates:

| Placeholder | Description | Source |
|-------------|-------------|--------|
| `{{PROJECT_NAME}}` | Project name | Q1 |
| `{{PROJECT_DESCRIPTION}}` | Brief project description | Q1 |
| `{{BACKEND_LANG}}` | Backend language (e.g., Java 21) | Q5 |
| `{{BACKEND_FRAMEWORK}}` | Backend framework (e.g., Spring Boot 3.2) | Q5 |
| `{{FRONTEND_LANG}}` | Frontend language (e.g., TypeScript) | Q5 |
| `{{FRONTEND_FRAMEWORK}}` | Frontend framework (e.g., Nuxt 3) | Q5 |
| `{{DATABASE}}` | Database technology | Q5 |
| `{{BUILD_TOOL}}` | Build system | Q5 |
| `{{BUILD_COMMAND}}` | Build/compile command | Q5 + detection |
| `{{TEST_COMMAND}}` | Test execution command | Q5 + detection |
| `{{LINT_COMMAND}}` | Lint command | Q5 + detection |
| `{{ARCHITECTURE}}` | Architecture pattern | Q6 |
| `{{DESIGN_PATTERNS}}` | Required design patterns | Q7 |
| `{{COMPLIANCE_FRAMEWORKS}}` | Applicable compliance frameworks | Q8 |
| `{{SECURITY_TOOLS}}` | Security scanning tools | Q9 |
| `{{DATA_CLASSIFICATION}}` | Data classification levels | Q10 |
| `{{ISSUE_TRACKER}}` | Issue tracker type | Q11 |
| `{{ISSUE_TRACKER_URL}}` | Issue tracker base URL | Q11 |
| `{{PROJECT_KEY}}` | Jira project key (if Jira) | Q11 |
| `{{GIT_WORKFLOW}}` | Git workflow strategy | Q12 |
| `{{COMMIT_CONVENTION}}` | Commit message format | Q13 |
| `{{DEFINITION_OF_DONE}}` | Definition of Done checklist | Q14 |
| `{{BRANCH_NAMING}}` | Branch naming convention | Q15 |
| `{{NAMING_CONVENTIONS}}` | Code naming conventions | Q17 |
| `{{API_STANDARDS}}` | API design standards | Q18 |
| `{{ORCHESTRATOR_MODEL}}` | Model for Orchestrator agent | Q3 |
| `{{BACKEND_MODEL}}` | Model for Backend Dev agent | Q3 |
| `{{FRONTEND_MODEL}}` | Model for Frontend Dev agent | Q3 |
| `{{REVIEWER_MODEL}}` | Model for Reviewer agent | Q3 |
| `{{TESTING_MODEL}}` | Model for Testing agent | Q3 |
| `{{AGENT_PLATFORM}}` | AI coding agent platform | Q2 + detection |
| `{{TEST_FRAMEWORKS}}` | Testing frameworks in use | Detection |
| `{{MIGRATION_TOOL}}` | DB migration tool | Detection |
| `{{MIN_COVERAGE}}` | Minimum test coverage % | Q14 |
| `{{PERFORMANCE_REQUIREMENTS}}` | Performance SLAs | Q20 |
| `{{ACCESSIBILITY_REQUIREMENTS}}` | Accessibility level | Q20 |

---

## Anti-Patterns to Avoid During Installation

1. **Do NOT skip workspace detection** - always analyze before asking questions
2. **Do NOT ask questions you can answer from code** - detect first, confirm later
3. **Do NOT leave any `{{PLACEHOLDER}}` unfilled** - every placeholder must be resolved
4. **Do NOT create files in non-English** - all output must be in English
5. **Do NOT overwrite existing AGENTS.md without asking** - merge or ask user
6. **Do NOT assume compliance scope** - always confirm with user (Q8)
7. **Do NOT skip verification** - run all checks in Phase 3
8. **Do NOT install skills the project does not need** - skip irrelevant skills (e.g., MiCA for non-crypto projects)
