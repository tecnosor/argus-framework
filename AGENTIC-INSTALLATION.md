# Agentic Installation Guide

> **This document is the master self-installation script for the Banking Compliance Agentic Framework (Argus).**
> Any AI coding agent (OpenCode, Cursor, Windsurf, Cline, Aider, etc.) can read this file to fully
> install and configure the framework into their workspace, adapting it to the specific project.

---

## Quick Start for AI Agents

**If you are an AI coding agent reading this:** Follow the phases below in order.
**Do not skip phases.** Each phase depends on the previous one.

**If you are a human:** You do not need to do anything. Just tell your AI agent
"Install Argus in this workspace" and the agent will read this file and follow it.

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

## How to Use This Guide (IMPORTANT)

### For AI Agents with Limited Context

**If your context window is small or you tend to lose track:**

1. **Read this file in chunks.** Do not try to read it all at once.
2. **After completing each phase, write a checkpoint file.**
3. **Use the checkpoint file to resume if you lose context.**

### Checkpoint System

**Create a checkpoint file after each phase:**

```bash
# Create a checkpoint file
mkdir -p .argus-installation
echo "Phase 0 completed. Detected: Java 21, Spring Boot, PostgreSQL" > .argus-installation/phase-0-checkpoint.md
```

**Checkpoint file template:**

```markdown
# Argus Installation Checkpoint

## Phase Completed: [number]
## Timestamp: [when]
## Status: [completed / in-progress / failed]

## What was detected:
- Language: [X]
- Framework: [X]
- Database: [X]
- Build tool: [X]
- AI Platform: [X]

## Decisions made:
- [list of decisions]

## Next phase: [number]
## Next action: [what to do next]
```

**If you lose context:** Read the latest checkpoint file and resume from the next phase.

---

## Phase 0: Workspace Detection

### BEFORE YOU START

**Do not ask the user any questions yet.** First, silently analyze the workspace.
This phase should take 1-3 minutes. Do not rush it.

### Step-by-Step Detection

#### Step 0.1: Check for existing Argus installation

```bash
# Check if Argus is already installed
ls -la .agents/ 2>/dev/null || echo "No .agents directory found"
ls -la AGENTS.md 2>/dev/null || echo "No AGENTS.md found"
```

If `.agents/` exists and has files, Argus may already be installed. Ask the user:
"I see an existing .agents/ directory. Do you want to re-install Argus or update it?"

#### Step 0.2: Detect programming language

```bash
# Check for common project files
ls package.json 2>/dev/null && echo "Node.js project detected"
ls pom.xml 2>/dev/null && echo "Maven project detected"
ls build.gradle 2>/dev/null && echo "Gradle project detected"
ls go.mod 2>/dev/null && echo "Go project detected"
ls Cargo.toml 2>/dev/null && echo "Rust project detected"
ls requirements.txt 2>/dev/null && echo "Python project detected"
ls pyproject.toml 2>/dev/null && echo "Python project detected"
ls composer.json 2>/dev/null && echo "PHP project detected"
```

**Action:** Write down what you found. If multiple files exist, note all of them.

#### Step 0.3: Detect framework

```bash
# For Node.js
ls node_modules 2>/dev/null && cat package.json | grep -E '"dependencies"|"devDependencies"' -A 5

# For Java
ls src/main/java 2>/dev/null && find src/main/java -maxdepth 2 -name "*.java" | head -5

# For Python
ls src/ 2>/dev/null && find src -maxdepth 2 -name "*.py" | head -5
```

**Action:** Identify the framework from the imports and directory structure.

#### Step 0.4: Detect build system

```bash
# Check for build files
ls Makefile 2>/dev/null && echo "Makefile detected"
cat package.json 2>/dev/null | grep -E '"scripts"' -A 20
ls mvnw 2>/dev/null && echo "Maven wrapper detected"
ls gradlew 2>/dev/null && echo "Gradle wrapper detected"
ls docker-compose.yml 2>/dev/null && echo "Docker Compose detected"
ls Dockerfile 2>/dev/null && echo "Docker detected"
```

**Action:** Write down the build commands.

#### Step 0.5: Detect project structure

```bash
# Check for monorepo structure
ls packages/ 2>/dev/null && echo "Monorepo packages/ detected"
ls apps/ 2>/dev/null && echo "Monorepo apps/ detected"
ls services/ 2>/dev/null && echo "Microservices services/ detected"
ls src/ 2>/dev/null && echo "Standard src/ detected"

# Count files by type
find . -maxdepth 3 -name "*.java" | wc -l
find . -maxdepth 3 -name "*.ts" | wc -l
find . -maxdepth 3 -name "*.tsx" | wc -l
find . -maxdepth 3 -name "*.vue" | wc -l
```

**Action:** Determine if monorepo, microservices, or single project.

#### Step 0.6: Detect AI platform

```bash
# Check for AI platform configuration
ls opencode.json 2>/dev/null && echo "OpenCode detected"
ls .opencode/ 2>/dev/null && echo "OpenCode directory detected"
ls .cursorrules 2>/dev/null && echo "Cursor detected"
ls .cursor/ 2>/dev/null && echo "Cursor directory detected"
ls .windsurfrules 2>/dev/null && echo "Windsurf detected"
ls .clinerules 2>/dev/null && echo "Cline detected"
```

**Action:** Note which platform. If none detected, use the default `.agents/` path.

#### Step 0.7: Detect database

```bash
# Check for database files
find . -maxdepth 3 -name "*.sql" | head -5
find . -maxdepth 3 -name "*.liquibase" | head -5
find . -maxdepth 3 -name "*.migration" | head -5
ls prisma/schema.prisma 2>/dev/null && echo "Prisma detected"
ls src/main/resources/db 2>/dev/null && echo "Database migrations detected"
```

**Action:** Note database technology if found.

#### Step 0.8: Detect CI/CD

```bash
ls .github/workflows/ 2>/dev/null && echo "GitHub Actions detected"
ls .gitlab-ci.yml 2>/dev/null && echo "GitLab CI detected"
ls Jenkinsfile 2>/dev/null && echo "Jenkins detected"
```

**Action:** Note CI/CD platform.

#### Step 0.9: Write detection summary

After all detection steps, create a summary file:

```bash
mkdir -p .argus-installation
cat > .argus-installation/detection-summary.md << 'EOF'
# Workspace Detection Summary

## Project Type: [single/monorepo/microservices]
## Language: [Java/Python/TypeScript/etc.]
## Framework: [Spring Boot/Nuxt/etc.]
## Database: [PostgreSQL/MySQL/etc.]
## Build Tool: [Maven/npm/etc.]
## AI Platform: [OpenCode/Cursor/etc.]
## CI/CD: [GitHub Actions/etc.]

## Files Detected:
- [list of key files]

## Decisions Needed:
- [list of what to ask user]
EOF
```

**Write the checkpoint:**
```bash
echo "Phase 0 completed. Detection summary saved." > .argus-installation/phase-0-checkpoint.md
```

---

## Phase 1: User Questionnaire

### BEFORE YOU START

**Read the detection summary from Phase 0.**
**Do not ask questions you already know the answer to.**

### How to Ask Questions

**For each question:**
1. State what you detected (if anything)
2. Ask the user to confirm or correct
3. Write the answer down

**Example:**
```
Q: I detected this is a Java project using Maven. Is that correct?
   If yes, press Enter. If no, tell me what it actually is.
```

### Questions (Skip what you already know)

#### Q1: Project Name
```
What is the project name? (Auto-detected: [X] - confirm or correct)
```

#### Q2: Project Description
```
Briefly describe what this project does. (1-2 sentences)
```

#### Q3: AI Platform
```
Which AI coding agent are you using? (Auto-detected: [X])
Options: OpenCode, Cursor, Windsurf, Cline, Aider, Other
```

#### Q4: Available Models
```
What models do you have access to? (List provider/model-id)

I will assign:
- Orchestrator: [needs strong reasoning]
- Backend Dev: [needs strong code generation]
- Frontend Dev: [needs strong UI/code generation]
- Reviewer: [needs strong analysis]
- Testing: [needs test generation]
```

#### Q5: Technology Stack
```
Confirm the technology stack:
- Backend: [detected] (correct?)
- Frontend: [detected] (correct?)
- Database: [detected] (correct?)
- Build: [detected] (correct?)
```

#### Q6: Architecture
```
What architecture pattern does this project follow?
- DDD + Clean Architecture + CQRS
- Hexagonal Architecture
- Layered Architecture
- MVC
- Other: ___
```

#### Q7: Design Patterns
```
What design patterns are mandatory?
- [ ] SOLID principles
- [ ] Constructor injection only
- [ ] Repository pattern
- [ ] CQRS
- [ ] Event-driven
- [ ] Other: ___
```

#### Q8: Compliance
```
Which compliance frameworks apply?
- [ ] GDPR
- [ ] DORA
- [ ] MiCA
- [ ] PCI-DSS
- [ ] PSD2
- [ ] Other: ___
```

#### Q9: Security Tools
```
What security scanning tools are in use?
SonarQube / Fortify / Snyk / Dependabot / Trivy / None
```

#### Q10: Data Classification
```
What data types are handled?
- [ ] PII (personal data)
- [ ] Financial data
- [ ] Credentials/tokens
- [ ] Public data only
```

#### Q11: Issue Tracker
```
What issue tracker do you use?
(Auto-detected: [X])
Jira / GitHub Issues / GitLab / None
```

#### Q12: Git Workflow
```
What Git workflow do you follow?
- GitFlow (main, develop, feature/*)
- GitHub Flow (main + feature branches)
- Trunk-Based
- Other: ___
```

#### Q13: Commit Convention
```
What commit message format do you use?
- Conventional Commits (feat:, fix:, etc.)
- Jira prefix (PROJ-123: description)
- Free format
```

#### Q14: Definition of Done
```
What is your Definition of Done?
- [ ] Code review required?
- [ ] Test coverage minimum? (what %)
- [ ] Security scan pass?
- [ ] Documentation updated?
- [ ] Performance benchmarks?
```

#### Q15: Branch Naming
```
What branch naming convention?
- feature/PROJ-123-short-description
- fix/PROJ-456-bug
- Other: ___
```

#### Q16: Coding Standards
```
Are there existing coding standards documents? (point to files)
```

#### Q17: Naming Conventions
```
What are the naming conventions?
- Backend: classes (PascalCase), methods (camelCase), tables (snake_case)
- Frontend: components (PascalCase), hooks (useCamelCase), CSS (BEM/Tailwind)
```

#### Q18: API Standards
```
What API design standards?
- REST with OpenAPI
- GraphQL
- gRPC
- Versioning: /v1/ or header-based
```

#### Q19: Modules
```
What modules/bounded contexts should I know about?
```

#### Q20: Additional Constraints
```
Any additional constraints?
- Performance requirements (API < Xms, page < Ys)
- Accessibility (WCAG level)
- Forbidden libraries
- Other preferences
```

### After All Questions

**Write the answers file:**
```bash
cat > .argus-installation/user-answers.md << 'EOF'
# User Answers

## Q1: Project Name
{{PROJECT_NAME}}

## Q2: Description
{{PROJECT_DESCRIPTION}}

## Q3: AI Platform
{{AGENT_PLATFORM}}

## Q4: Models
- Orchestrator: {{ORCHESTRATOR_MODEL}}
- Backend: {{BACKEND_MODEL}}
- Frontend: {{FRONTEND_MODEL}}
- Reviewer: {{REVIEWER_MODEL}}
- Testing: {{TESTING_MODEL}}

## Q5: Technology Stack
- Backend: {{BACKEND_LANG}} / {{BACKEND_FRAMEWORK}}
- Frontend: {{FRONTEND_LANG}} / {{FRONTEND_FRAMEWORK}}
- Database: {{DATABASE}}
- Build: {{BUILD_TOOL}}

## Q6: Architecture
{{ARCHITECTURE}}

## Q7: Design Patterns
{{DESIGN_PATTERNS}}

## Q8: Compliance
{{COMPLIANCE_FRAMEWORKS}}

## Q9: Security Tools
{{SECURITY_TOOLS}}

## Q10: Data Classification
{{DATA_CLASSIFICATION}}

## Q11: Issue Tracker
{{ISSUE_TRACKER}} / {{ISSUE_TRACKER_URL}}

## Q12: Git Workflow
{{GIT_WORKFLOW}}

## Q13: Commit Convention
{{COMMIT_CONVENTION}}

## Q14: Definition of Done
{{DEFINITION_OF_DONE}}

## Q15: Branch Naming
{{BRANCH_NAMING}}

## Q16: Coding Standards
{{NAMING_CONVENTIONS}}

## Q17: API Standards
{{API_STANDARDS}}

## Q18: Modules
{{MODULES}}

## Q19: Performance
{{PERFORMANCE_REQUIREMENTS}}

## Q20: Accessibility
{{ACCESSIBILITY_REQUIREMENTS}}
EOF
```

**Write the checkpoint:**
```bash
echo "Phase 1 completed. All questions answered." > .argus-installation/phase-1-checkpoint.md
```

---

## Phase 2: Installation Execution

### IMPORTANT: Read the answers file first

```bash
cat .argus-installation/user-answers.md
```

### Step 2.1: Determine Installation Paths

**Decision table:**

| Platform | Agents Path | Skills Path | Rules Path |
|----------|-------------|-------------|------------|
| **OpenCode** | `.agents/agents/` | `.agents/skills/` | `AGENTS.md` |
| **Cursor** | `.agents/agents/` | `.agents/skills/` | `.cursorrules` |
| **Windsurf** | `.agents/agents/` | `.agents/skills/` | `.windsurfrules` |
| **Cline** | `.agents/agents/` | `.agents/skills/` | `.clinerules` |
| **Generic** | `.agents/agents/` | `.agents/skills/` | `AGENTS.md` |

**Default: Use `.agents/` paths. Always create `AGENTS.md` at root for compatibility.**

### Step 2.2: Create Directory Structure

```bash
# Create directories
mkdir -p .agents/agents
mkdir -p .agents/skills
mkdir -p .agents/rules
mkdir -p .agents/docs
mkdir -p .agents/memory/.orchestrator
mkdir -p .agents/memory/.backend-dev
mkdir -p .agents/memory/.frontend-dev
mkdir -p .agents/memory/.reviewer
mkdir -p .agents/memory/.testing
```

**Verify:**
```bash
ls -la .agents/
```

### Step 2.3: Copy Agent Definitions

**Read each agent file from the Argus framework source, replace placeholders, and write to the target workspace.**

#### How to Copy Agent Files

```bash
# Option 1: If the Argus framework is in the same workspace
# (you are reading this file from the Argus repo)
cp .agents/agents/orchestrator.md .agents/agents/orchestrator.md
# Note: This is the same file, so just read it and modify it

# Option 2: If the Argus framework is in a different directory
# (e.g., user cloned it separately)
cp /path/to/argus-framework/.agents/agents/orchestrator.md .agents/agents/orchestrator.md

# Option 3: If you have the content in memory
# Just write the file directly
```

**For each agent, do the following:**

1. Read the agent template from the Argus source
2. Find all `{{PLACEHOLDER}}` markers
3. Replace each with the value from the user answers file
4. Write the result to `.agents/agents/[name].md`

**Agents to copy:**

```bash
# List of agent files to copy
AGENTS=(
  "orchestrator.md"
  "backend-dev.md"
  "frontend-dev.md"
  "reviewer.md"
  "testing.md"
)

# Copy each agent
for agent in "${AGENTS[@]}"; do
  echo "Copying agent: $agent"
  # Replace this with actual copy command
  # cp /path/to/argus/.agents/agents/$agent .agents/agents/$agent
done
```

**After copying, replace placeholders:**

```bash
# Use sed or a text editor to replace placeholders
# Example for orchestrator.md:
sed -i '' 's/{{PROJECT_NAME}}/YourProjectName/g' .agents/agents/orchestrator.md
sed -i '' 's/{{ORCHESTRATOR_MODEL}}/claude-sonnet-4/g' .agents/agents/orchestrator.md

# Repeat for ALL placeholders in ALL agent files
# (see the full placeholder list at the end of this document)
```

**For AI agents using text tools:**

```
1. Read the template file (e.g., orchestrator.md)
2. Use the edit tool to replace "{{PROJECT_NAME}}" with the actual project name
3. Use the edit tool to replace "{{ORCHESTRATOR_MODEL}}" with the chosen model
4. Repeat for every placeholder in the file
5. Write the modified file to .agents/agents/orchestrator.md
6. Do this for ALL 5 agent files
```

**CRITICAL: Do not leave any {{PLACEHOLDER}} unfilled.**

**Verification command:**
```bash
grep -r "{{" .agents/agents/ --include="*.md"
# This should return NOTHING. If it returns anything, you missed placeholders.
```

### Step 2.4: Copy Skill Definitions

**For each skill, copy the SKILL.md and replace placeholders.**

```bash
# List of skills to copy
SKILLS=(
  "build-check"
  "code-review"
  "compliance-eu"
  "git-flow"
  "history-scan"
  "jira-integration"
  "lang-enforcer"
  "owasp-top10"
  "project-status"
  "secure-coder"
  "test-driven"
  "ui-ux"
)

# Copy each skill
for skill in "${SKILLS[@]}"; do
  echo "Copying skill: $skill"
  mkdir -p ".agents/skills/$skill"
  # cp /path/to/argus/.agents/skills/$skill/SKILL.md .agents/skills/$skill/SKILL.md
done
```

**For AI agents using text tools:**

```
1. Create the directory: .agents/skills/build-check/
2. Read the template: .agents/skills/build-check/SKILL.md (from Argus source)
3. Replace all placeholders
4. Write the file to .agents/skills/build-check/SKILL.md
5. Repeat for ALL 12 skills
```

**Verification command:**
```bash
grep -r "{{" .agents/skills/ --include="*.md"
# This should return NOTHING
```

### Step 2.5: Generate AGENTS.md (Root Rules)

**Read the template from `.agents/rules/AGENTS-TEMPLATE.md`**

**Replace all placeholders with user answers.**

**Write the result to `AGENTS.md` at the project root.**

```bash
# Copy template
cp .agents/rules/AGENTS-TEMPLATE.md AGENTS.md

# Replace placeholders
sed -i '' 's/{{PROJECT_NAME}}/YourProjectName/g' AGENTS.md
# ... repeat for ALL placeholders
```

**For AI agents:**

```
1. Read .agents/rules/AGENTS-TEMPLATE.md
2. Create a new file AGENTS.md at the project root
3. Copy the content from AGENTS-TEMPLATE.md
4. Replace ALL placeholders with values from user answers
5. Write the file
```

### Step 2.6: Generate Project Documentation

**Copy each doc template and replace placeholders:**

```bash
# Copy doc templates
DOCS=(
  "architecture.md"
  "coding-standards.md"
  "security-policy.md"
  "database-schema.md"
  "ui-ux-guidelines.md"
  "api-standards.md"
)

for doc in "${DOCS[@]}"; do
  echo "Generating doc: $doc"
  # cp /path/to/argus/.agents/docs/$doc .agents/docs/$doc
  # Replace placeholders
  sed -i '' 's/{{PROJECT_NAME}}/YourProjectName/g' .agents/docs/$doc
done
```

### Step 2.7: Configure Platform-Specific Settings

**For OpenCode:**

```bash
# Check if opencode.json exists
ls opencode.json 2>/dev/null || echo "No opencode.json found"

# If exists, update it
# If not, create it
```

**For Cursor:**

```bash
# Create .cursorrules if it doesn't exist
# Or update existing .cursorrules
```

**For Windsurf:**

```bash
# Create .windsurfrules if it doesn't exist
# Or update existing .windsurfrules
```

### Write checkpoint

```bash
echo "Phase 2 completed. All files installed." > .argus-installation/phase-2-checkpoint.md
```

---

## Phase 3: Verification

### Step 3.1: Check all agent files exist

```bash
echo "=== Checking agent files ==="
ls -la .agents/agents/*.md
```

**Expected: 5 files**
- orchestrator.md
- backend-dev.md
- frontend-dev.md
- reviewer.md
- testing.md

### Step 3.2: Check all skill files exist

```bash
echo "=== Checking skill files ==="
ls -la .agents/skills/*/SKILL.md
```

**Expected: 12 files**

### Step 3.3: Check for leftover placeholders

```bash
echo "=== Checking for placeholders ==="
PLACEHOLDER_COUNT=$(grep -r "{{" .agents/ --include="*.md" | wc -l)
echo "Placeholder count: $PLACEHOLDER_COUNT"

if [ "$PLACEHOLDER_COUNT" -eq 0 ]; then
  echo "✅ No placeholders found"
else
  echo "❌ Found $PLACEHOLDER_COUNT placeholders. These MUST be fixed:"
  grep -r "{{" .agents/ --include="*.md"
fi
```

**If placeholders found: STOP and fix them.**

### Step 3.4: Check AGENTS.md exists

```bash
echo "=== Checking AGENTS.md ==="
ls -la AGENTS.md 2>/dev/null && echo "✅ AGENTS.md exists" || echo "❌ AGENTS.md missing"
```

### Step 3.5: Check documentation exists

```bash
echo "=== Checking documentation ==="
ls -la .agents/docs/*.md
```

**Expected: 6 files**

### Step 3.6: Check memory directories

```bash
echo "=== Checking memory directories ==="
ls -la .agents/memory/
```

**Expected: 5 directories**
- .orchestrator
- .backend-dev
- .frontend-dev
- .reviewer
- .testing

### Step 3.7: Verify all files are in English

```bash
echo "=== Checking for non-English content ==="
# This is a basic check - grep for common non-ASCII characters
# A full check requires the lang-enforcer skill
grep -r "[áéíóúñüç]" .agents/ --include="*.md" | head -10
```

### Step 3.8: Final verification summary

```bash
cat << 'EOF'
## Verification Summary

| Check | Status |
|-------|--------|
| Agent files (5) | ✅/❌ |
| Skill files (12) | ✅/❌ |
| No placeholders | ✅/❌ |
| AGENTS.md exists | ✅/❌ |
| Documentation (6) | ✅/❌ |
| Memory dirs (5) | ✅/❌ |
| All English | ✅/❌ |

## Result: [PASS / FAIL]
EOF
```

### Write checkpoint

```bash
echo "Phase 3 completed. Verification done." > .argus-installation/phase-3-checkpoint.md
```

---

## Phase 4: Post-Installation Summary

**Present this to the user:**

```markdown
## Installation Complete

### Installed Components
- **5 Agents**: Orchestrator, Backend Dev, Frontend Dev, Reviewer, Testing
- **12 Skills**: build-check, code-review, compliance-eu, owasp-top10, git-flow,
  history-scan, jira-integration, lang-enforcer, ui-ux, project-status, secure-coder, test-driven
- **6 Documentation Files**: architecture, coding-standards, security-policy, database-schema,
  ui-ux-guidelines, api-standards
- **1 Rules File**: AGENTS.md at project root

### How to Use
1. The **Orchestrator** is your entry point
2. Start any request with the Orchestrator
3. The Orchestrator will delegate to the right agents
4. Each agent follows the 7-phase SDLC
5. The Reviewer is the final gate before any merge

### Key Workflows
- **New Feature**: Orchestrator → Backend/Frontend Dev → Testing → Reviewer
- **Bug Fix**: Orchestrator → Dev → Testing → Reviewer
- **Security Audit**: Orchestrator → Reviewer
- **Code Review**: @reviewer with PR/MR URL

### Customization
- Edit any agent in `.agents/agents/` to adjust behavior
- Edit any skill in `.agents/skills/<name>/SKILL.md`
- Edit `AGENTS.md` to update project-wide rules
- Re-run this installation to regenerate documentation
```

### Write final checkpoint

```bash
echo "Phase 4 completed. Installation finished." > .argus-installation/phase-4-checkpoint.md
```

---

## Placeholder Reference

All placeholders used in agent and skill templates:

| Placeholder | Description | Source |
|-------------|-------------|--------|
| `{{PROJECT_NAME}}` | Project name | Q1 |
| `{{PROJECT_DESCRIPTION}}` | Brief project description | Q1 |
| `{{BACKEND_LANG}}` | Backend language | Q5 |
| `{{BACKEND_FRAMEWORK}}` | Backend framework | Q5 |
| `{{FRONTEND_LANG}}` | Frontend language | Q5 |
| `{{FRONTEND_FRAMEWORK}}` | Frontend framework | Q5 |
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
| `{{PROJECT_KEY}}` | Jira project key | Q11 |
| `{{GIT_WORKFLOW}}` | Git workflow strategy | Q12 |
| `{{COMMIT_CONVENTION}}` | Commit message format | Q13 |
| `{{DEFINITION_OF_DONE}}` | Definition of Done checklist | Q14 |
| `{{BRANCH_NAMING}}` | Branch naming convention | Q15 |
| `{{NAMING_CONVENTIONS}}` | Code naming conventions | Q17 |
| `{{API_STANDARDS}}` | API design standards | Q18 |
| `{{ORCHESTRATOR_MODEL}}` | Model for Orchestrator | Q3 |
| `{{BACKEND_MODEL}}` | Model for Backend Dev | Q3 |
| `{{FRONTEND_MODEL}}` | Model for Frontend Dev | Q3 |
| `{{REVIEWER_MODEL}}` | Model for Reviewer | Q3 |
| `{{TESTING_MODEL}}` | Model for Testing | Q3 |
| `{{AGENT_PLATFORM}}` | AI coding agent platform | Q2 + detection |
| `{{TEST_FRAMEWORKS}}` | Testing frameworks | Detection |
| `{{MIGRATION_TOOL}}` | DB migration tool | Detection |
| `{{MIN_COVERAGE}}` | Minimum test coverage % | Q14 |
| `{{PERFORMANCE_REQUIREMENTS}}` | Performance SLAs | Q20 |
| `{{ACCESSIBILITY_REQUIREMENTS}}` | Accessibility level | Q20 |

---

## Anti-Patterns to Avoid

1. **Do NOT skip workspace detection** — always analyze before asking questions
2. **Do NOT ask questions you can answer from code** — detect first, confirm later
3. **Do NOT leave any `{{PLACEHOLDER}}` unfilled** — every placeholder must be resolved
4. **Do NOT create files in non-English** — all output must be in English
5. **Do NOT overwrite existing AGENTS.md without asking** — merge or ask user
6. **Do NOT assume compliance scope** — always confirm with user (Q8)
7. **Do NOT skip verification** — run all checks in Phase 3
8. **Do NOT install skills the project does not need** — skip irrelevant skills
9. **Do NOT forget to create checkpoint files** — they save progress
10. **Do NOT mix up source and destination paths** — copy FROM Argus TO project

---

## Tips for Models with Limited Context

### If you have a small context window:

1. **Read this file in sections.** Do not read the whole file at once.
2. **Complete one phase at a time.** Do not start Phase 2 until Phase 1 is fully done.
3. **Write checkpoint files.** They save your progress so you can resume.
4. **Use the file system to store information.** Do not keep everything in memory.
5. **Read the checkpoint file at the start of every phase.** It tells you what to do next.
6. **If you get confused, re-read the current phase.** Do not guess.
7. **Use the `grep` command to find placeholders.** It is faster than reading files.
8. **If a file is too long, read it in chunks.** Use `head` and `tail` to read parts.

### If you are unsure about a step:

1. Read the detection summary: `cat .argus-installation/detection-summary.md`
2. Read the user answers: `cat .argus-installation/user-answers.md`
3. Read the current checkpoint: `cat .argus-installation/phase-X-checkpoint.md`
4. If still unsure, ask the user: "I need to confirm: [specific question]"

### If you lose context mid-installation:

1. List checkpoint files: `ls .argus-installation/`
2. Read the latest checkpoint
3. Follow the "Next phase" instruction
4. Resume from where you left off

---

## Common Errors and How to Fix Them

### Error: "No such file or directory"

**Cause:** You are trying to copy from the wrong path.
**Fix:** Check where the Argus framework files are. If you are in the Argus repo,
use `.agents/` as the source. If you are in the target project, the source is elsewhere.

### Error: "Placeholder count > 0 after replacement"

**Cause:** You missed some placeholders or used wrong placeholder names.
**Fix:** Run `grep -r "{{" .agents/ --include="*.md"` to find all remaining placeholders.
Replace them one by one.

### Error: "Permission denied"

**Cause:** You cannot write to the target directory.
**Fix:** Check file permissions. Use `ls -la` to see who owns the directory.

### Error: "File already exists"

**Cause:** The target file already exists (e.g., from a previous installation).
**Fix:** Ask the user: "File X already exists. Overwrite, skip, or merge?"

---

## Command Cheat Sheet

### File Operations

```bash
# Copy a file
cp source.txt destination.txt

# Copy a directory recursively
cp -r source_dir/ destination_dir/

# Create a directory
mkdir -p path/to/directory

# List files
ls -la directory/

# Read a file
cat file.txt

# Read first 20 lines
head -20 file.txt

# Read last 20 lines
tail -20 file.txt

# Find a file
find . -name "filename"

# Search for text in files
grep -r "search_term" directory/

# Count lines
wc -l file.txt

# Check file size
ls -lh file.txt
```

### Placeholder Replacement

```bash
# Replace a placeholder in a file
sed -i '' 's/{{PLACEHOLDER}}/value/g' file.txt

# Replace a placeholder in all files
sed -i '' 's/{{PLACEHOLDER}}/value/g' .agents/agents/*.md

# Find all placeholders
grep -r "{{" .agents/ --include="*.md"

# Count remaining placeholders
grep -r "{{" .agents/ --include="*.md" | wc -l
```

### Git Operations

```bash
# Check git status
git status

# Add files
git add .

# Commit
git commit -m "message"

# Push
git push origin branch

# Create branch
git checkout -b new-branch

# Switch branch
git checkout branch

# List branches
git branch -a
```

---

## Quick Reference: Installation Order

```
1. Phase 0: Workspace Detection
   - Check existing files
   - Detect language, framework, build system
   - Write detection summary

2. Phase 1: User Questionnaire
   - Ask questions (skip what you know)
   - Write answers file

3. Phase 2: Installation
   - Create directories
   - Copy agent files (replace placeholders)
   - Copy skill files (replace placeholders)
   - Generate AGENTS.md
   - Generate documentation
   - Configure platform

4. Phase 3: Verification
   - Check all files exist
   - Check no placeholders remain
   - Check all English
   - Write summary

5. Phase 4: Post-Installation
   - Show user the summary
   - Explain how to use
```

---

**Remember: This framework is designed to be installed by any AI agent, regardless of
its capabilities. Take your time, follow the steps, and use checkpoints to save progress.**

**Five eyes. Seven phases. Zero compliance violations.**
