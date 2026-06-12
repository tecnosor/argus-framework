# Permissions

> Control which actions require approval to run.

OpenCode uses the `permission` config to decide whether a given action should run automatically, prompt you, or be blocked.

As of `v1.1.1`, the legacy `tools` boolean config is deprecated and has been merged into `permission`. The old `tools` config is still supported for backwards compatibility.

---

## Actions

Each permission rule resolves to one of:

| Action | Behavior |
|--------|----------|
| `"allow"` | Run without approval |
| `"ask"` | Prompt for approval |
| `"deny"` | Block the action |

---

## Configuration

You can set permissions globally (with `*`), and override specific tools.

**opencode.json**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "*": "ask",
    "bash": "allow",
    "edit": "deny"
  }
}
```

You can also set all permissions at once:

**opencode.json**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": "allow"
}
```

---

## Granular Rules (Object Syntax)

For most permissions, you can use an object to apply different actions based on the tool input.

**opencode.json**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": {
      "*": "ask",
      "git *": "allow",
      "npm *": "allow",
      "rm *": "deny",
      "grep *": "allow"
    },
    "edit": {
      "*": "deny",
      "packages/web/src/content/docs/*.mdx": "allow"
    }
  }
}
```

Rules are evaluated by pattern match, with the **last matching rule winning**. A common pattern is to put the catch-all `"*"` rule first, and more specific rules after it.

### How Rule Precedence Works

```
Given this config:
  "*": "ask"           ← catch-all (evaluated first)
  "git *": "allow"     ← more specific (overrides catch-all for git)
  "git push *": "deny" ← most specific (overrides git * for push)

Results:
  "git status"   → "allow" (matches "git *")
  "git push"     → "deny"  (matches "git push *", last rule wins)
  "npm install"  → "ask"   (matches only "*")
```

### Wildcards

Permission patterns use simple wildcard matching:

| Pattern | Matches |
|---------|---------|
| `*` | Zero or more of any character |
| `?` | Exactly one character |
| All other characters | Match literally |

**Examples:**

| Pattern | Matches | Doesn't Match |
|---------|---------|---------------|
| `git *` | `git status`, `git commit -m "msg"` | `npm install` |
| `*.env` | `.env`, `test.env` | `.env.local` |
| `npm ?est` | `npm test` | `npm run test` |
| `*` | Everything | Nothing |

### Home Directory Expansion

You can use `~` or `$HOME` at the start of a pattern to reference your home directory. This is particularly useful for `external_directory` rules.

| Pattern | Expands To |
|---------|------------|
| `~/projects/*` | `/Users/username/projects/*` |
| `$HOME/projects/*` | `/Users/username/projects/*` |
| `~` | `/Users/username` |

### External Directories

Use `external_directory` to allow tool calls that touch paths outside the working directory where OpenCode was started. This applies to any tool that takes a path as input (for example `read`, `edit`, `glob`, `grep`, and many `bash` commands).

Home expansion (like `~/...`) only affects how a pattern is written. It does not make an external path part of the current workspace, so paths outside the working directory must still be allowed via `external_directory`.

For example, this allows access to everything under `~/projects/personal/`:

**opencode.json**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "external_directory": {
      "~/projects/personal/**": "allow"
    }
  }
}
```

Any directory allowed here inherits the same defaults as the current workspace. Since `read` defaults to `allow`, reads are also allowed for entries under `external_directory` unless overridden. Add explicit rules when a tool should be restricted in these paths, such as blocking edits while keeping reads:

**opencode.json**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "external_directory": {
      "~/projects/personal/**": "allow"
    },
    "edit": {
      "~/projects/personal/**": "deny"
    }
  }
}
```

Keep the list focused on trusted paths, and layer extra allow or deny rules as needed for other tools (for example `bash`).

---

## Available Permissions

OpenCode permissions are keyed by tool name, plus a couple of safety guards:

| Permission Key | What It Controls | Pattern Matches |
|---------------|-----------------|-----------------|
| `read` | Reading a file | File path |
| `edit` | All file modifications (`edit`, `write`, `patch`) | File path |
| `glob` | File globbing | Glob pattern |
| `grep` | Content search | Regex pattern |
| `bash` | Running shell commands | Parsed command (e.g., `git status --porcelain`) |
| `task` | Launching subagents | Subagent type |
| `skill` | Loading a skill | Skill name |
| `lsp` | Running LSP queries | Currently non-granular |
| `question` | Asking the user questions during execution | — |
| `webfetch` | Fetching a URL | URL |
| `websearch` | Web search | Query |
| `external_directory` | Tool calls touching paths outside the project working directory | Path |
| `doom_loop` | Triggered when the same tool call repeats 3 times with identical input | — |

---

## Defaults

If you don't specify anything, OpenCode starts from permissive defaults:

- Most permissions default to `"allow"`
- `doom_loop` and `external_directory` default to `"ask"`
- `read` is `"allow"`, but `.env` files are denied by default:

```json
{
  "permission": {
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny",
      "*.env.example": "allow"
    }
  }
}
```

### Default Summary

| Permission | Default |
|-----------|---------|
| `read` | `allow` (except `.env` files → `deny`) |
| `edit` | `allow` |
| `glob` | `allow` |
| `grep` | `allow` |
| `bash` | `allow` |
| `list` | `allow` |
| `task` | `allow` |
| `skill` | `allow` |
| `lsp` | `allow` |
| `question` | `allow` |
| `webfetch` | `allow` |
| `websearch` | `allow` |
| `external_directory` | `ask` |
| `doom_loop` | `ask` |

---

## What "Ask" Does

When OpenCode prompts for approval, the UI offers three outcomes:

| Choice | Behavior |
|--------|----------|
| `once` | Approve just this request |
| `always` | Approve future requests matching the suggested patterns (for the rest of the current OpenCode session) |
| `reject` | Deny the request |

The set of patterns that `always` would approve is provided by the tool (for example, bash approvals typically whitelist a safe command prefix like `git status*`).

---

## Agents

You can override permissions per agent. Agent permissions are merged with the global config, and agent rules take precedence.

**opencode.json**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": {
      "*": "ask",
      "git *": "allow",
      "git commit *": "deny",
      "git push *": "deny",
      "grep *": "allow"
    }
  },
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "*": "ask",
          "git *": "allow",
          "git commit *": "ask",
          "git push *": "deny",
          "grep *": "allow"
        }
      }
    }
  }
}
```

You can also configure agent permissions in Markdown:

**~/.config/opencode/agents/review.md**

```yaml
---
description: Code review without edits
mode: subagent
permission:
  edit: deny
  bash: ask
  webfetch: deny
---

Only analyze code and suggest changes.
```

---

## Common Patterns

### Lock Down Everything (Ask for All Actions)

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "*": "ask"
  }
}
```

### Allow Safe Commands, Ask for Dangerous Ones

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": {
      "*": "ask",
      "git status*": "allow",
      "git log*": "allow",
      "git diff*": "allow",
      "grep *": "allow",
      "cat *": "allow",
      "ls *": "allow",
      "npm test*": "allow",
      "npm run lint*": "allow",
      "rm *": "deny",
      "rm -rf *": "deny"
    }
  }
}
```

### Read-Only Mode (No Edits, No Bash)

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "deny",
    "bash": "deny",
    "webfetch": "allow",
    "websearch": "allow"
  }
}
```

### Allow Docs Editing Only

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": {
      "*": "deny",
      "docs/**/*.md": "allow",
      "docs/**/*.mdx": "allow",
      "README.md": "allow"
    }
  }
}
```

### CI/CD Mode (Allow Everything, No Prompts)

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": "allow"
}
```

### Multi-Agent Setup with Different Permissions

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": {
      "*": "ask",
      "git *": "allow",
      "npm *": "allow"
    },
    "edit": "allow"
  },
  "agent": {
    "reviewer": {
      "description": "Read-only code reviewer",
      "mode": "subagent",
      "permission": {
        "edit": "deny",
        "bash": {
          "*": "deny",
          "git diff*": "allow",
          "git log*": "allow",
          "grep *": "allow"
        }
      }
    },
    "deployer": {
      "description": "Deployment agent with restricted shell access",
      "mode": "subagent",
      "permission": {
        "edit": "deny",
        "bash": {
          "*": "deny",
          "docker compose*": "allow",
          "kubectl*": "ask",
          "gh *": "allow"
        }
      }
    }
  }
}
```

### Protect Sensitive Files

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny",
      "*.env.example": "allow",
      "**/secrets/**": "deny",
      "**/*.pem": "deny",
      "**/*.key": "deny"
    },
    "edit": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny",
      "**/secrets/**": "deny"
    }
  }
}
```

### External Project Access

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "external_directory": {
      "~/projects/shared-lib/**": "allow",
      "~/monorepo/packages/shared/**": "allow"
    },
    "edit": {
      "~/projects/shared-lib/**": "deny"
    }
  }
}
```

This allows reading from the shared library but prevents editing it from within another project.
