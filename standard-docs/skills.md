# Agent Skills

> Define reusable behavior via SKILL.md definitions.

Agent skills let OpenCode discover reusable instructions from your repo or home directory. Skills are loaded on-demand via the native `skill` tool — agents see available skills and can load the full content when needed.

---

## Place Files

Create one folder per skill name and put a `SKILL.md` inside it.

OpenCode searches these locations:

| Scope | Path |
|-------|------|
| Project config | `.opencode/skills/<name>/SKILL.md` |
| Global config | `~/.config/opencode/skills/<name>/SKILL.md` |
| Project (Claude-compatible) | `.claude/skills/<name>/SKILL.md` |
| Global (Claude-compatible) | `~/.claude/skills/<name>/SKILL.md` |
| Project (agent-compatible) | `.agents/skills/<name>/SKILL.md` |
| Global (agent-compatible) | `~/.agents/skills/<name>/SKILL.md` |

```
my-project/
├── .opencode/
│   └── skills/
│       ├── git-release/
│       │   └── SKILL.md
│       ├── code-review/
│       │   └── SKILL.md
│       └── deploy/
│           └── SKILL.md
└── ...
```

---

## Understand Discovery

For project-local paths, OpenCode walks up from your current working directory until it reaches the git worktree. It loads any matching `skills/*/SKILL.md` in `.opencode/` and any matching `.claude/skills/*/SKILL.md` or `.agents/skills/*/SKILL.md` along the way.

Global definitions are also loaded from:
- `~/.config/opencode/skills/*/SKILL.md`
- `~/.claude/skills/*/SKILL.md`
- `~/.agents/skills/*/SKILL.md`

```
Discovery order:
┌──────────────────────────────────────────────────┐
│ 1. .opencode/skills/*/SKILL.md (project)         │
│ 2. .claude/skills/*/SKILL.md (project)           │
│ 3. .agents/skills/*/SKILL.md (project)           │
│ 4. ~/.config/opencode/skills/*/SKILL.md (global) │
│ 5. ~/.claude/skills/*/SKILL.md (global)          │
│ 6. ~/.agents/skills/*/SKILL.md (global)          │
└──────────────────────────────────────────────────┘
```

---

## Write Frontmatter

Each `SKILL.md` must start with YAML frontmatter. Only these fields are recognized:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Skill identifier (must match directory name) |
| `description` | Yes | Brief description (1–1024 chars) |
| `license` | No | License identifier |
| `compatibility` | No | Compatibility info |
| `metadata` | No | String-to-string map for extra data |

Unknown frontmatter fields are ignored.

```yaml
---
name: git-release
description: Create consistent releases and changelogs
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---
```

---

## Validate Names

`name` must:

- Be 1–64 characters
- Be lowercase alphanumeric with single hyphen separators
- Not start or end with `-`
- Not contain consecutive `--`
- Match the directory name that contains `SKILL.md`

Equivalent regex:

```
^[a-z0-9]+(-[a-z0-9]+)*$
```

**Valid names:**
- `git-release`
- `code-review`
- `deploy`
- `api-testing`

**Invalid names:**
- `Git-Release` (uppercase)
- `-git-release` (starts with hyphen)
- `git--release` (consecutive hyphens)
- `git_release` (underscores not allowed)

---

## Follow Length Rules

`description` must be 1–1024 characters. Keep it specific enough for the agent to choose correctly.

**Good descriptions:**
```yaml
description: Create consistent releases and changelogs from merged PRs
description: Review TypeScript code for type safety and best practices
description: Deploy the application to staging using Docker Compose
```

**Bad descriptions (too vague):**
```yaml
description: Does stuff
description: Helper
description: Tool
```

---

## Example

Create `.opencode/skills/git-release/SKILL.md` like this:

```yaml
---
name: git-release
description: Create consistent releases and changelogs
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do

- Draft release notes from merged PRs
- Propose a version bump
- Provide a copy-pasteable `gh release create` command

## When to use me

Use this when you are preparing a tagged release.
Ask clarifying questions if the target versioning scheme is unclear.
```

### More Skill Examples

#### Code Review Skill

`.opencode/skills/code-review/SKILL.md`

```yaml
---
name: code-review
description: Perform structured code reviews following team conventions
license: MIT
metadata:
  audience: developers
  trigger: PR, pull request, review
---

## Review Checklist

1. **Architecture**: Does the change follow our layered architecture?
2. **Types**: Are all new types properly defined? No `any`?
3. **Tests**: Are there tests for new logic?
4. **Error handling**: Are errors properly caught and reported?
5. **Performance**: Any N+1 queries or unnecessary re-renders?
6. **Security**: Input validation, auth checks, no secrets in code?

## Output Format

Use this format for review comments:
- BLOCKER: Must fix before merge
- WARNING: Should fix, but not blocking
- SUGGESTION: Nice to have improvement
- NIT: Minor style preference
```

#### Deploy Skill

`.opencode/skills/deploy/SKILL.md`

```yaml
---
name: deploy
description: Deploy services to staging or production environments
license: MIT
metadata:
  audience: devops
  environments: staging, production
---

## Deployment Process

1. Run the full test suite
2. Build Docker images
3. Push to container registry
4. Update deployment manifests
5. Trigger rolling deployment
6. Verify health checks pass

## Commands

- Staging: `docker compose -f docker-compose.staging.yml up -d`
- Production: Requires approval — use `gh workflow run deploy-prod.yml`

## Rollback

If health checks fail:
1. `docker compose -f docker-compose.staging.yml down`
2. `docker compose -f docker-compose.staging.yml up -d --build`
3. Notify the team in #deployments Slack channel
```

#### Testing Skill

`.opencode/skills/testing/SKILL.md`

```yaml
---
name: testing
description: Write and run tests following project testing conventions
license: MIT
metadata:
  audience: developers
  framework: vitest
---

## Testing Conventions

### File Naming
- Unit tests: `*.test.ts`
- Integration tests: `*.integration.test.ts`
- E2E tests: `*.e2e.test.ts`

### Structure (AAA Pattern)
```typescript
describe("functionName", () => {
  it("should do something specific", () => {
    // Arrange
    const input = createMockInput();

    // Act
    const result = functionName(input);

    // Assert
    expect(result).toBe(expectedValue);
  });
});
```

### Commands
- All tests: `bun run test`
- Unit only: `bun run test:unit`
- Coverage: `bun run test:coverage`
- Watch mode: `bun run test:watch`
```

---

## Recognize Tool Description

OpenCode lists available skills in the `skill` tool description. Each entry includes the skill name and description:

```xml
<available_skills>
  <skill>
    <name>git-release</name>
    <description>Create consistent releases and changelogs</description>
  </skill>
</available_skills>
```

The agent loads a skill by calling the tool:

```typescript
skill({ name: "git-release" })
```

---

## Configure Permissions

Control which skills agents can access using pattern-based permissions in `opencode.json`:

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "pr-review": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

| Permission | Behavior |
|------------|----------|
| `allow` | Skill loads immediately |
| `deny` | Skill hidden from agent, access rejected |
| `ask` | User prompted for approval before loading |

Patterns support wildcards: `internal-*` matches `internal-docs`, `internal-tools`, etc.

---

## Override Per Agent

Give specific agents different permissions than the global defaults.

**For custom agents** (in agent frontmatter):

```yaml
---
permission:
  skill:
    "documents-*": "allow"
---
```

**For built-in agents** (in `opencode.json`):

```json
{
  "agent": {
    "plan": {
      "permission": {
        "skill": {
          "internal-*": "allow"
        }
      }
    }
  }
}
```

---

## Disable the Skill Tool

Completely disable skills for agents that shouldn't use them:

**For custom agents:**

```yaml
---
tools:
  skill: false
---
```

**For built-in agents:**

```json
{
  "agent": {
    "plan": {
      "tools": {
        "skill": false
      }
    }
  }
}
```

When disabled, the `<available_skills>` section is omitted entirely.

---

## Troubleshoot Loading

If a skill does not show up:

1. Verify `SKILL.md` is spelled in **all caps**
2. Check that frontmatter includes `name` and `description`
3. Ensure skill names are unique across all locations
4. Check permissions — skills with `deny` are hidden from agents
5. Verify the `name` field matches the directory name exactly
6. Confirm the description is between 1–1024 characters

### Common Issues

| Problem | Cause | Fix |
|---------|-------|-----|
| Skill not discovered | Wrong file name | Rename to `SKILL.md` (all caps) |
| Skill not listed | Missing frontmatter | Add `name` and `description` |
| Name mismatch | Directory name differs from `name` field | Make them identical |
| Permission denied | `deny` rule in permissions | Change to `allow` or `ask` |
| Duplicate skills | Same name in project and global | Use unique names or remove one |

---

## Sharing Skills Across Teams (Custom Example)

You can share skills across teams using Git submodules or symlinks:

### Using Git Submodules

```bash
# Add shared skills as a submodule
git submodule add https://github.com/my-org/shared-skills .opencode/skills/shared

# Symlink individual skills
ln -s shared/git-release .opencode/skills/git-release
ln -s shared/code-review .opencode/skills/code-review
```

### Using a Shared Skills Package

Create a shared npm package with skills:

```
@my-org/opencode-skills/
├── git-release/
│   └── SKILL.md
├── code-review/
│   └── SKILL.md
└── deploy/
    └── SKILL.md
```

Then install and symlink:

```bash
bun add -d @my-org/opencode-skills
# In postinstall script:
# ln -sf node_modules/@my-org/opencode-skills/* .opencode/skills/
```
