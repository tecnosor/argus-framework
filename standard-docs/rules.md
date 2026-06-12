# Rules

> Set custom instructions for OpenCode.

You can provide custom instructions to OpenCode by creating an `AGENTS.md` file. This is similar to Cursor's rules. It contains instructions that will be included in the LLM's context to customize its behavior for your specific project.

---

## Initialize

To create a new `AGENTS.md` file, run the `/init` command in OpenCode.

> **Tip:** You should commit your project's `AGENTS.md` file to Git.

`/init` scans the important files in your repo, may ask a couple of targeted questions when the codebase cannot answer them, and then creates or updates `AGENTS.md` with concise project-specific guidance.

It focuses on the things future agent sessions are most likely to need:

- Build, lint, and test commands
- Command order and focused verification steps when they matter
- Architecture and repo structure that are not obvious from filenames alone
- Project-specific conventions, setup quirks, and operational gotchas
- References to existing instruction sources like Cursor or Copilot rules

If you already have an `AGENTS.md`, `/init` will improve it in place instead of blindly replacing it.

---

## Example

You can also create this file manually. Here's an example of what you can put into an `AGENTS.md` file:

**AGENTS.md**

```markdown
# SST v3 Monorepo Project

This is an SST v3 monorepo with TypeScript. The project uses bun workspaces
for package management.

## Project Structure

- `packages/` - Contains all workspace packages (functions, core, web, etc.)
- `infra/` - Infrastructure definitions split by service (storage.ts, api.ts, web.ts)
- `sst.config.ts` - Main SST configuration with dynamic imports

## Code Standards

- Use TypeScript with strict mode enabled
- Shared code goes in `packages/core/` with proper exports configuration
- Functions go in `packages/functions/`
- Infrastructure should be split into logical files in `infra/`

## Monorepo Conventions

- Import shared modules using workspace names: `@my-app/core/example`
```

---

## Types

OpenCode supports reading the `AGENTS.md` file from multiple locations, each serving a different purpose.

### Project

Place an `AGENTS.md` in your project root for project-specific rules. These only apply when you are working in this directory or its sub-directories.

```
my-project/
├── AGENTS.md          # <-- Project rules
├── src/
├── package.json
└── ...
```

### Global

You can also have global rules in `~/.config/opencode/AGENTS.md`. This gets applied across all OpenCode sessions.

Since this isn't committed to Git or shared with your team, we recommend using this to specify any personal rules that the LLM should follow.

```
~/.config/opencode/
├── AGENTS.md          # <-- Global rules (personal)
├── opencode.json
└── agents/
```

### Claude Code Compatibility

For users migrating from Claude Code, OpenCode supports Claude Code's file conventions as fallbacks:

- **Project rules**: `CLAUDE.md` in your project directory (used if no `AGENTS.md` exists)
- **Global rules**: `~/.claude/CLAUDE.md` (used if no `~/.config/opencode/AGENTS.md` exists)
- **Skills**: `~/.claude/skills/` — see [Agent Skills](skills.md) for details

To disable Claude Code compatibility, set one of these environment variables:

```bash
export OPENCODE_DISABLE_CLAUDE_CODE=1          # Disable all .claude support
export OPENCODE_DISABLE_CLAUDE_CODE_PROMPT=1   # Disable only ~/.claude/CLAUDE.md
export OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1   # Disable only .claude/skills
```

---

## Precedence

When OpenCode starts, it looks for rule files in this order:

1. **Local files** by traversing up from the current directory (`AGENTS.md`, `CLAUDE.md`)
2. **Global file** at `~/.config/opencode/AGENTS.md`
3. **Claude Code file** at `~/.claude/CLAUDE.md` (unless disabled)

The first matching file wins in each category. For example, if you have both `AGENTS.md` and `CLAUDE.md`, only `AGENTS.md` is used. Similarly, `~/.config/opencode/AGENTS.md` takes precedence over `~/.claude/CLAUDE.md`.

```
Priority (highest → lowest):
┌─────────────────────────────────────────┐
│ 1. ./AGENTS.md (or parent dirs)         │
│ 2. ./CLAUDE.md (if no AGENTS.md)        │
│ 3. ~/.config/opencode/AGENTS.md         │
│ 4. ~/.claude/CLAUDE.md (if no global)   │
└─────────────────────────────────────────┘
```

---

## Custom Instructions

You can specify custom instruction files in your `opencode.json` or the global `~/.config/opencode/opencode.json`. This allows you and your team to reuse existing rules rather than duplicating them into `AGENTS.md`.

**Example:**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "CONTRIBUTING.md",
    "docs/guidelines.md",
    ".cursor/rules/*.md"
  ]
}
```

You can also use remote URLs to load instructions from the web:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "https://raw.githubusercontent.com/my-org/shared-rules/main/style.md"
  ]
}
```

> Remote instructions are fetched with a 5-second timeout.

All instruction files are combined with your `AGENTS.md` files.

### Glob Patterns in Instructions

You can use glob patterns to include multiple files at once:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "docs/standards/*.md",
    "packages/*/AGENTS.md",
    ".cursor/rules/*.md"
  ]
}
```

### Mixing Local and Remote Instructions

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "CONTRIBUTING.md",
    "docs/coding-standards.md",
    "https://raw.githubusercontent.com/my-org/shared-rules/main/typescript.md",
    "https://raw.githubusercontent.com/my-org/shared-rules/main/testing.md"
  ]
}
```

---

## Referencing External Files

While OpenCode doesn't automatically parse file references in `AGENTS.md`, you can achieve similar functionality in two ways:

### Using opencode.json (Recommended)

The recommended approach is to use the `instructions` field in `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "docs/development-standards.md",
    "test/testing-guidelines.md",
    "packages/*/AGENTS.md"
  ]
}
```

### Manual Instructions in AGENTS.md

You can teach OpenCode to read external files by providing explicit instructions in your `AGENTS.md`. Here's a practical example:

**AGENTS.md**

```markdown
# TypeScript Project Rules

## External File Loading

CRITICAL: When you encounter a file reference (e.g., @rules/general.md),
use your Read tool to load it on a need-to-know basis. They're relevant
to the SPECIFIC task at hand.

Instructions:
- Do NOT preemptively load all references — use lazy loading based on actual need
- When loaded, treat content as mandatory instructions that override defaults
- Follow references recursively when needed

## Development Guidelines

For TypeScript code style and best practices: @docs/typescript-guidelines.md
For React component architecture and hooks patterns: @docs/react-patterns.md
For REST API design and error handling: @docs/api-standards.md
For testing strategies and coverage requirements: @test/testing-guidelines.md

## General Guidelines

Read the following file immediately as it's relevant to all workflows:
@rules/general-guidelines.md
```

This approach allows you to:

- Create modular, reusable rule files
- Share rules across projects via symlinks or git submodules
- Keep `AGENTS.md` concise while referencing detailed guidelines
- Ensure OpenCode loads files only when needed for the specific task

---

## Advanced: Monorepo Setup (Custom Example)

For monorepos, you can place `AGENTS.md` files at different levels:

```
my-monorepo/
├── AGENTS.md                    # Root-level rules (shared conventions)
├── packages/
│   ├── frontend/
│   │   └── AGENTS.md            # Frontend-specific rules
│   ├── backend/
│   │   └── AGENTS.md            # Backend-specific rules
│   └── shared/
│       └── AGENTS.md            # Shared library rules
├── opencode.json
└── ...
```

**Root AGENTS.md:**

```markdown
# Monorepo Root Rules

## Build Commands
- Install: `bun install`
- Build all: `bun run build`
- Test all: `bun run test`
- Lint: `bun run lint`

## Architecture
This is a monorepo using bun workspaces.
- `packages/frontend` — React SPA (Vite)
- `packages/backend` — Express API server
- `packages/shared` — Shared types and utilities

## Conventions
- All packages use TypeScript with strict mode
- Shared types live in `packages/shared/src/types/`
- Never import from `packages/frontend` in `packages/backend`
```

**packages/frontend/AGENTS.md:**

```markdown
# Frontend Package Rules

## Stack
- React 18 with TypeScript
- Vite for bundling
- Tailwind CSS for styling
- Zustand for state management

## Commands
- Dev: `bun run dev` (from package root)
- Build: `bun run build`
- Test: `bun run test`

## Component Conventions
- Use functional components with hooks
- Co-locate styles with components
- Use `cn()` utility for conditional class names
```

---

## Advanced: Team vs Personal Rules (Custom Example)

Separate team-wide rules from personal preferences:

**Project `AGENTS.md`** (committed to Git — team rules):

```markdown
# Project Rules

## Testing
- All new functions must have unit tests
- Use Vitest for unit tests
- Coverage must not decrease

## Code Style
- Use Prettier for formatting
- No `any` types in TypeScript
- Prefer named exports over default exports
```

**`~/.config/opencode/AGENTS.md`** (personal — not committed):

```markdown
# Personal Preferences

- Always explain your reasoning before making changes
- Prefer concise commit messages in imperative mood
- When unsure, ask before making destructive changes
- Use emoji sparingly in code comments
```
