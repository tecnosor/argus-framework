# Agents

> Configure and use specialized agents in OpenCode.

Agents are specialized AI assistants that can be configured for specific tasks and workflows. They allow you to create focused tools with custom prompts, models, and tool access.

You can switch between agents during a session or invoke them with the `@` mention.

> **Tip:** Use the **Plan** agent to analyze code and review suggestions without making any code changes.

---

## Types

There are two types of agents in OpenCode: **primary agents** and **subagents**.

### Primary Agents

Primary agents are the main assistants you interact with directly. You can cycle through them using the **Tab** key, or your configured `switch_agent` keybind. These agents handle your main conversation. Tool access is configured via permissions — for example, Build has all tools enabled while Plan is restricted.

OpenCode comes with two built-in primary agents: **Build** and **Plan**.

> **Tip:** You can use the **Tab** key to switch between primary agents during a session.

### Subagents

Subagents are specialized assistants that primary agents can invoke for specific tasks. You can also manually invoke them by **@ mentioning** them in your messages.

OpenCode comes with three built-in subagents: **General**, **Explore**, and **Scout**.

---

## Built-in Agents

OpenCode ships with two built-in primary agents and three built-in subagents, plus three hidden system agents.

### Build

**Mode:** `primary`

Build is the **default** primary agent with all tools enabled. This is the standard agent for development work where you need full access to file operations and system commands.

### Plan

**Mode:** `primary`

A restricted agent designed for planning and analysis. Uses the permission system to give you more control and prevent unintended changes. By default, the following are set to `ask`:

- `file edits` — All writes, patches, and edits
- `bash` — All bash commands

This agent is useful when you want the LLM to analyze code, suggest changes, or create plans without making any actual modifications to your codebase.

### General

**Mode:** `subagent`

A general-purpose agent for researching complex questions and executing multi-step tasks. Has full tool access (except todo), so it can make file changes when needed. Use this to run multiple units of work in parallel.

### Explore

**Mode:** `subagent`

A fast, read-only agent for exploring codebases. Cannot modify files. Use this when you need to quickly find files by patterns, search code for keywords, or answer questions about the codebase.

### Scout

**Mode:** `subagent`

A read-only agent for external docs and dependency research. Use this when you need to clone a dependency repository into OpenCode's managed cache, inspect library source, or cross-reference local code against upstream implementations without modifying your workspace.

### Compaction

**Mode:** `primary` *(hidden)*

System agent that compacts long context into a smaller summary. It runs automatically when needed and is not selectable in the UI.

### Title

**Mode:** `primary` *(hidden)*

System agent that generates short session titles. It runs automatically and is not selectable in the UI.

### Summary

**Mode:** `primary` *(hidden)*

System agent that creates session summaries. It runs automatically and is not selectable in the UI.

---

## Usage

### Switching Primary Agents

Use the **Tab** key to cycle through primary agents during a session. You can also use your configured `switch_agent` keybind.

### Invoking Subagents

Subagents can be invoked in three ways:

1. **Automatically** by primary agents for specialized tasks based on their descriptions.
2. **Manually** by **@ mentioning** a subagent in your message:
   ```
   @general help me search for this function
   ```
3. **Navigation between sessions**: When subagents create child sessions, use `session_child_first` (default: **Leader+Down**) to enter the first child session from the parent.

Once in a child session:

| Keybind | Default | Action |
|---------|---------|--------|
| `session_child_cycle` | **Right** | Cycle to next child session |
| `session_child_cycle_reverse` | **Left** | Cycle to previous child session |
| `session_parent` | **Up** | Return to parent session |

---

## Configuration

You can customize the built-in agents or create your own. Agents can be configured in two ways: **JSON** and **Markdown**.

### JSON Configuration

Configure agents in your `opencode.json` config file:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "{file:./prompts/build.txt}",
      "permission": {
        "edit": "allow",
        "bash": "allow"
      }
    },
    "plan": {
      "mode": "primary",
      "model": "anthropic/claude-haiku-4-20250514",
      "permission": {
        "edit": "deny",
        "bash": "deny"
      }
    },
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "permission": {
        "edit": "deny"
      }
    }
  }
}
```

### Markdown Configuration

You can also define agents using markdown files. Place them in:

- **Global:** `~/.config/opencode/agents/`
- **Per-project:** `.opencode/agents/`

**Example:** `~/.config/opencode/agents/review.md`

```yaml
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash: deny
---

You are in code review mode. Focus on:
- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations

Provide constructive feedback without making direct changes.
```

The markdown file name becomes the agent name. For example, `review.md` creates a `review` agent.

---

## Options

### Description

Use the `description` option to provide a brief description of what the agent does and when to use it. **Required.**

```json
{
  "agent": {
    "review": {
      "description": "Reviews code for best practices and potential issues"
    }
  }
}
```

### Temperature

Control the randomness and creativity of the LLM's responses. Lower values make responses more focused and deterministic; higher values increase creativity and variability.

```json
{
  "agent": {
    "plan": { "temperature": 0.1 },
    "creative": { "temperature": 0.8 }
  }
}
```

| Range | Behavior | Best For |
|-------|----------|----------|
| **0.0–0.2** | Very focused, deterministic | Code analysis, planning |
| **0.3–0.5** | Balanced with some creativity | General development tasks |
| **0.6–1.0** | More creative and varied | Brainstorming, exploration |

If no temperature is specified, OpenCode uses model-specific defaults (typically `0` for most models, `0.55` for Qwen models).

### Max Steps

Control the maximum number of agentic iterations an agent can perform before being forced to respond with text only. Useful for controlling costs.

```json
{
  "agent": {
    "quick-thinker": {
      "description": "Fast reasoning with limited iterations",
      "prompt": "You are a quick thinker. Solve problems with minimal steps.",
      "steps": 5
    }
  }
}
```

When the limit is reached, the agent receives a special system prompt instructing it to summarize its work and recommend remaining tasks.

If not set, the agent iterates until the model stops or the user interrupts.

### Disable

Set to `true` to disable an agent entirely.

```json
{
  "agent": {
    "review": { "disable": true }
  }
}
```

### Prompt

Specify a custom system prompt file for the agent. The path is relative to where the config file is located.

```json
{
  "agent": {
    "review": {
      "prompt": "{file:./prompts/code-review.txt}"
    }
  }
}
```

### Model

Override the model for a specific agent. Useful for using faster models for planning and more capable models for implementation.

```json
{
  "agent": {
    "plan": {
      "model": "anthropic/claude-haiku-4-20250514"
    }
  }
}
```

The model ID uses the format `provider/model-id`. For example, with OpenCode Zen: `opencode/gpt-5.1-codex`.

### Tools (Deprecated)

> **Deprecated.** Prefer the agent's `permission` field for new configs and more fine-grained control.

Allows you to control which tools are available. `true` enables a tool, `false` disables it.

```json
{
  "$schema": "https://opencode.ai/config.json",
  "tools": {
    "write": true,
    "bash": true
  },
  "agent": {
    "plan": {
      "tools": {
        "write": false,
        "bash": false
      }
    }
  }
}
```

Wildcards are supported in legacy `tools` entries:

```json
{
  "agent": {
    "readonly": {
      "tools": {
        "mymcp_*": false,
        "write": false,
        "edit": false
      }
    }
  }
}
```

### Permissions

Configure what actions an agent can take. Each permission key can be set to:

- `"ask"` — Prompt for approval before running the tool
- `"allow"` — Allow all operations without approval
- `"deny"` — Disable the tool

#### Available Permission Keys

| Key | Tools It Gates |
|-----|---------------|
| `read` | `read` |
| `edit` | `write`, `edit`, `apply_patch` |
| `glob` | `glob` |
| `grep` | `grep` |
| `list` | `list` |
| `bash` | `bash` |
| `task` | `task` |
| `external_directory` | Any tool reading/writing files outside the project worktree |
| `todowrite` | `todowrite`, `todoread` |
| `webfetch` | `webfetch` |
| `websearch` | `websearch` |
| `lsp` | `lsp` |
| `skill` | `skill` |
| `question` | `question` |
| `doom_loop` | Recovery prompts when an agent appears stuck |

`read`, `edit`, `glob`, `grep`, `list`, `bash`, `task`, `external_directory`, `lsp`, and `skill` accept either a shorthand action (`"allow" | "ask" | "deny"`) or an object of glob/pattern to action for fine-grained control. The remaining keys accept the shorthand action only.

**Global permission example:**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "deny"
  }
}
```

**Per-agent override:**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "edit": "deny"
  },
  "agent": {
    "build": {
      "permission": {
        "edit": "ask"
      }
    }
  }
}
```

**Markdown agent with permissions:**

```yaml
---
description: Code review without edits
mode: subagent
permission:
  edit: deny
  bash:
    "*": ask
    "git diff": allow
    "git log*": allow
    "grep *": allow
  webfetch: deny
---

Only analyze code and suggest changes.
```

**Specific bash command permissions:**

```json
{
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "git push": "ask",
          "grep *": "allow"
        }
      }
    }
  }
}
```

The last matching rule takes precedence. Put the `*` wildcard first and specific rules after:

```json
{
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "*": "ask",
          "git status *": "allow"
        }
      }
    }
  }
}
```

### Mode

Control the agent's mode. Determines how the agent can be used.

```json
{
  "agent": {
    "review": { "mode": "subagent" }
  }
}
```

| Value | Description |
|-------|-------------|
| `primary` | Main agent, selectable via Tab |
| `subagent` | Invokable via @ mention or Task tool |
| `all` | Both primary and subagent (default if omitted) |

### Hidden

Hide a subagent from the `@` autocomplete menu. Useful for internal subagents that should only be invoked programmatically by other agents via the Task tool.

```json
{
  "agent": {
    "internal-helper": {
      "mode": "subagent",
      "hidden": true
    }
  }
}
```

Hidden agents can still be invoked by the model via the Task tool if permissions allow.

### Task Permissions

Control which subagents an agent can invoke via the Task tool with `permission.task`. Uses glob patterns for flexible matching.

```json
{
  "agent": {
    "orchestrator": {
      "mode": "primary",
      "permission": {
        "task": {
          "*": "deny",
          "orchestrator-*": "allow",
          "code-reviewer": "ask"
        }
      }
    }
  }
}
```

When set to `deny`, the subagent is removed from the Task tool description entirely, so the model won't attempt to invoke it.

### Color

Customize the agent's visual appearance in the UI.

```json
{
  "agent": {
    "creative": { "color": "#ff6b6b" },
    "code-reviewer": { "color": "accent" }
  }
}
```

Accepts a valid hex color (e.g., `#FF5733`) or theme color: `primary`, `secondary`, `accent`, `success`, `warning`, `error`, `info`.

### Top P

Control response diversity. Alternative to temperature for controlling randomness.

```json
{
  "agent": {
    "brainstorm": { "top_p": 0.9 }
  }
}
```

Values range from 0.0 to 1.0. Lower values are more focused, higher values more diverse.

### Additional (Pass-through Options)

Any other options you specify are **passed through directly** to the provider as model options. This allows you to use provider-specific features and parameters.

```json
{
  "agent": {
    "deep-thinker": {
      "description": "Agent that uses high reasoning effort for complex problems",
      "model": "openai/gpt-5",
      "reasoningEffort": "high",
      "textVerbosity": "low"
    }
  }
}
```

---

## Creating Agents via CLI

You can create new agents interactively:

```bash
opencode agent create
```

This interactive command will:

1. Ask where to save the agent (global or project-specific)
2. Ask for a description of what the agent should do
3. Generate an appropriate system prompt and identifier
4. Let you select which permissions the agent should be allowed (anything not selected is denied)
5. Create a markdown file with the agent configuration

---

## Use Cases

| Agent | Purpose |
|-------|---------|
| **Build** | Full development work with all tools enabled |
| **Plan** | Analysis and planning without making changes |
| **Review** | Code review with read-only access plus documentation tools |
| **Debug** | Focused investigation with bash and read tools enabled |
| **Docs** | Documentation writing with file operations but no system commands |

---

## Examples

### Documentation Agent

`~/.config/opencode/agents/docs-writer.md`

```yaml
---
description: Writes and maintains project documentation
mode: subagent
permission:
  bash: deny
---

You are a technical writer. Create clear, comprehensive documentation.

Focus on:
- Clear explanations
- Proper structure
- Code examples
- User-friendly language
```

### Security Auditor

`~/.config/opencode/agents/security-auditor.md`

```yaml
---
description: Performs security audits and identifies vulnerabilities
mode: subagent
permission:
  edit: deny
---

You are a security expert. Focus on identifying potential security issues.

Look for:
- Input validation vulnerabilities
- Authentication and authorization flaws
- Data exposure risks
- Dependency vulnerabilities
- Configuration security issues
```

### Debug Agent (Custom Example)

`.opencode/agents/debugger.md`

```yaml
---
description: Focused debugging agent with shell and read access
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash:
    "*": ask
    "grep *": allow
    "cat *": allow
    "git log*": allow
    "git diff*": allow
  webfetch: allow
---

You are a debugging specialist. Your approach:

1. Reproduce the issue first
2. Gather evidence through logs and stack traces
3. Form a hypothesis
4. Verify the hypothesis
5. Report findings clearly with root cause analysis

Never modify code. Only investigate and report.
```

### Test Runner Agent (Custom Example)

`~/.config/opencode/agents/test-runner.md`

```yaml
---
description: Runs tests and analyzes results
mode: subagent
permission:
  edit: deny
  bash:
    "*": deny
    "npm test*": allow
    "npm run test*": allow
    "bun test*": allow
    "pytest*": allow
    "mvn test*": allow
    "go test*": allow
---

You are a test execution specialist.

1. Run the relevant test suite
2. Analyze failures and identify patterns
3. Report results with clear pass/fail summary
4. Suggest fixes for failing tests without modifying code
```

### API Tester Agent (Custom Example)

`.opencode/agents/api-tester.md`

```yaml
---
description: Tests API endpoints and validates responses
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
color: "#4ecdc4"
permission:
  edit: deny
  bash:
    "*": deny
    "curl *": allow
    "httpie *": allow
    "jq *": allow
  webfetch: allow
---

You are an API testing specialist. Focus on:

- Endpoint availability and response codes
- Response schema validation
- Error handling and edge cases
- Performance and response times
- Authentication and authorization flows

Use curl to test endpoints and jq to parse responses.
```
