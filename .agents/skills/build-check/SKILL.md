---
name: build-check
description: "Validates project build pipeline in strict sequential order: install dependencies, lint, compile, unit tests, integration tests. Stops on first failure and reports which step failed. Auto-detects project type. Use before commits, PRs, or when verifying changes compile correctly."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: all-agents
  phase: development, testing, review
---

# Build Check Skill

You are executing a **Build Pipeline Validation** for the current project.

## Purpose

Validate that the project builds correctly end-to-end. Run each step sequentially.
**Stop on first failure** and report exactly which step failed with the error output.

## Pipeline Steps

Execute in this exact order. Do NOT skip steps.

### Step 1: Install Dependencies

Detect the project type and run the appropriate command:

| Project Type | Detection | Command |
|-------------|-----------|---------|
| Maven | `pom.xml` exists | `mvn dependency:resolve` |
| Gradle | `build.gradle` exists | `gradle dependencies` |
| npm | `package.json` + `package-lock.json` | `npm ci` |
| yarn | `package.json` + `yarn.lock` | `yarn install --frozen-lockfile` |
| pnpm | `package.json` + `pnpm-lock.yaml` | `pnpm install --frozen-lockfile` |
| bun | `package.json` + `bun.lockb` | `bun install --frozen-lockfile` |
| Python (pip) | `requirements.txt` | `pip install -r requirements.txt` |
| Python (poetry) | `pyproject.toml` + poetry | `poetry install` |
| Go | `go.mod` | `go mod download` |
| Rust | `Cargo.toml` | `cargo fetch` |

**On failure**: Report dependency resolution errors. Check for network issues, version conflicts, or missing registries.

### Step 2: Lint

| Project Type | Command |
|-------------|---------|
| Maven | `mvn checkstyle:check` or configured linter |
| Gradle | `gradle lint` or `./gradlew ktlintCheck` |
| npm/yarn/pnpm/bun | `npm run lint` or `npx eslint .` |
| Python | `ruff check .` or `flake8 .` or `pylint` |
| Go | `golangci-lint run` |
| Rust | `cargo clippy -- -D warnings` |

**On failure**: Report linting violations with file:line references.

### Step 3: Compile / Build

| Project Type | Command |
|-------------|---------|
| Maven | `mvn compile -q` |
| Gradle | `gradle build -x test` |
| npm/yarn/pnpm/bun | `npm run build` |
| Python | `python -m py_compile` on changed files |
| Go | `go build ./...` |
| Rust | `cargo build` |

**On failure**: Report compilation errors. Check for type errors, missing imports, syntax issues.

### Step 4: Unit Tests

| Project Type | Command |
|-------------|---------|
| Maven | `mvn test` |
| Gradle | `gradle test` |
| npm/yarn/pnpm/bun | `npm run test:unit` or `npm test` |
| Python | `pytest -v` |
| Go | `go test ./...` |
| Rust | `cargo test` |

**On failure**: Report failing tests with test names and error messages.

### Step 5: Integration Tests (If Configured)

| Project Type | Command |
|-------------|---------|
| Maven | `mvn verify -DskipUnitTests=true` |
| Gradle | `gradle integrationTest` |
| npm/yarn/pnpm/bun | `npm run test:integration` or `npm run test:e2e` |
| Python | `pytest -m integration` |

**Skip if**: No integration test configuration detected.

## Output Format

```
## Build Check Results

| Step | Status | Duration | Notes |
|------|--------|----------|-------|
| Dependencies | ✅/❌ | Xs | |
| Lint | ✅/❌ | Xs | [violations count] |
| Compile | ✅/❌ | Xs | |
| Unit Tests | ✅/❌ | Xs | [X passed, Y failed] |
| Integration | ✅/❌/⏭️ | Xs | |

**Verdict**: ✅ BUILD PASSES | ❌ BUILD FAILS at [step]

### Failure Details (if any)
[error output with file:line references]
```

## Rules

1. **Sequential execution** — never run steps in parallel
2. **Stop on first failure** — do not continue after a step fails
3. **Report exact error** — include the failing command, exit code, and error output
4. **No auto-fix** — report failures, do not attempt to fix them
5. **Coverage check** — if a coverage tool is detected, verify minimum threshold after tests
