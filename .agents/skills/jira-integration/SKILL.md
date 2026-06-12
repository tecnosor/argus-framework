---
name: jira-integration
description: "Jira issue management via MCP or REST API. Creates epics, stories, subtasks, and bugs. Updates status transitions, adds comments, links PRs. Supports Jira Cloud and Server. Use for all issue tracker operations during the SDLC workflow."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: orchestrator, backend-dev, frontend-dev, testing, reviewer
  phase: all
---

# Jira Integration Skill

You are managing **Jira issue tracker operations** for **{{PROJECT_NAME}}**.

## Purpose

Interact with Jira to create, update, and track issues throughout the SDLC workflow.
This skill supports both MCP-based Jira integration and REST API fallback.

---

## Configuration

### Required Environment Variables

```
JIRA_BASE_URL=https://your-company.atlassian.net
JIRA_PROJECT_KEY={{PROJECT_KEY}}
JIRA_API_TOKEN=<api-token>
JIRA_EMAIL=<user-email>
```

### MCP Integration (Preferred)

If a Jira MCP server is configured, use it via the `skill_mcp` tool:

```
mcp_name: "jira"
Available tools:
- create_issue
- update_issue
- add_comment
- transition_issue
- search_issues
- get_issue
- link_issues
```

### REST API Fallback

If no MCP, use `curl` with Jira REST API v3:

```bash
# Base URL
JIRA_URL="${JIRA_BASE_URL}/rest/api/3"

# Authentication header
AUTH_HEADER="Authorization: Basic $(echo -n ${JIRA_EMAIL}:${JIRA_API_TOKEN} | base64)"
```

---

## Issue Types and Templates

### Epic

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "[EPIC] Epic Title",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "Epic description and goals" }]
      }]
    },
    "issuetype": { "name": "Epic" },
    "priority": { "name": "High" },
    "labels": ["compliance", "security"]
  }
}
```

### User Story

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "As a [role], I want [goal], so that [benefit]",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Acceptance Criteria\n\n```gherkin\nGiven [precondition]\nWhen [action]\nThen [expected result]\n```" }]
      }]
    },
    "issuetype": { "name": "Story" },
    "priority": { "name": "Medium" },
    "labels": ["feature"],
    "customfield_story_points": 5
  }
}
```

### Technical Subtask

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "Implement [specific technical task]",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Technical Details\n\n- Files to modify: ...\n- API changes: ...\n- Database changes: ..." }]
      }]
    },
    "issuetype": { "name": "Sub-task" },
    "parent": { "key": "{{PROJECT_KEY}}-XXX" }
  }
}
```

### Bug Report

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "BUG: [concise bug description]",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Steps to Reproduce\n1. ...\n\n## Expected\n...\n\n## Actual\n...\n\n## Environment\n..." }]
      }]
    },
    "issuetype": { "name": "Bug" },
    "priority": { "name": "High" },
    "labels": ["bug", "regression"]
  }
}
```

---

## Status Transitions

### Standard Workflow

```
Backlog → To Do → In Progress → In Review → Testing → Done
```

### Transition IDs (Configure During Installation)

| Status | Transition ID | Notes |
|--------|--------------|-------|
| To Do | `11` | From Backlog |
| In Progress | `21` | Start working |
| In Review | `31` | PR created |
| Testing | `41` | Tests running |
| Done | `51` | Merged and verified |

**Note**: Transition IDs vary by Jira project. Detect them during installation:

```bash
curl -s -H "$AUTH_HEADER" \
  "${JIRA_URL}/issue/{{PROJECT_KEY}}-XXX/transitions" | \
  python -m json.tool
```

---

## Common Operations

### Create Issue

```bash
curl -s -X POST -H "$AUTH_HEADER" -H "Content-Type: application/json" \
  -d @issue.json \
  "${JIRA_URL}/issue"
```

### Add Comment

```bash
curl -s -X POST -H "$AUTH_HEADER" -H "Content-Type: application/json" \
  -d '{"body": {"type": "doc", "version": 1, "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Comment text"}]}]}}' \
  "${JIRA_URL}/issue/{{PROJECT_KEY}}-XXX/comment"
```

### Transition Issue

```bash
curl -s -X POST -H "$AUTH_HEADER" -H "Content-Type: application/json" \
  -d '{"transition": {"id": "21"}}' \
  "${JIRA_URL}/issue/{{PROJECT_KEY}}-XXX/transitions"
```

### Link Issues

```bash
curl -s -X POST -H "$AUTH_HEADER" -H "Content-Type: application/json" \
  -d '{"type": {"name": "relates to"}, "inwardIssue": {"key": "{{PROJECT_KEY}}-XXX"}, "outwardIssue": {"key": "{{PROJECT_KEY}}-YYY"}}' \
  "${JIRA_URL}/issueLink"
```

### Search Issues

```bash
# JQL search
curl -s -H "$AUTH_HEADER" \
  "${JIRA_URL}/search?jql=project={{PROJECT_KEY}}+AND+status=\"In+Progress\"&maxResults=50"
```

---

## SDLC Integration

### Orchestrator Phase 2: Create Issue Skeleton

1. Create Epic (if new feature area)
2. Create User Story with Gherkin acceptance criteria
3. Create Technical Subtasks linked to parent story
4. Set initial status to "In Progress"
5. Add labels for compliance scope, security scope

### Development Phase: Track Progress

1. Add implementation notes as comments
2. Update subtask status as completed
3. Link commits in comments

### Testing Phase: Track Results

1. Move story to "Testing"
2. Add test execution report as comment
3. Create Bug issues for failures
4. Link bugs to parent story

### Review Phase: Gate Decision

1. If approved: Move to "In Review", add review summary comment with PR link
2. If changes requested: Keep "In Progress", add findings comment
3. After merge: Move to "Done"

---

## Comment Templates

### Review Summary Comment

```
h3. Code Review Summary

*Verdict*: ✅ APPROVED / ❌ CHANGES REQUESTED

*PR/MR*: [link]
*Blocking Issues*: X
*Warnings*: Y

*Findings*:
- OWASP Top 10: ✅/🔴
- GDPR: ✅/🔴
- Coding Standards: ✅/🔴
- Test Coverage: ✅/🔴

[Full review report attached or linked]
```

### Test Execution Comment

```
h3. Test Execution Report

*Verdict*: PASS / FAIL

| Category | Passed | Failed | Coverage |
|----------|--------|--------|----------|
| Unit | X | X | XX% |
| Integration | X | X | N/A |
| E2E | X | X | N/A |

*Bugs Found*: X
*Performance*: Within targets ✅/❌
```

---

## Rules

1. **Always include ticket reference** in commits and PR descriptions
2. **Never skip status transitions** — follow the workflow strictly
3. **Add comments for every significant action** — maintain audit trail
4. **Link related issues** — bugs to stories, subtasks to parents
5. **Use proper Jira formatting** — ADF (Atlassian Document Format) for API v3
6. **Handle errors gracefully** — if Jira API fails, log error and continue workflow
