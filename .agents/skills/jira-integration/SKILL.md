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

> **All templates below use placeholders from the Argus installation questionnaire.**
> Replace every `{{PLACEHOLDER}}` with the actual project value before creating issues.
> Templates marked with `[CONDITIONAL]` should only be used when the relevant scope applies.

### Parameterized Epic

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "[EPIC] {{FEATURE_AREA}} — {{PROJECT_NAME}}",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Goal\nEnable {{FEATURE_AREA}} for {{PROJECT_DESCRIPTION}}.\n\n## Scope\n- Backend: {{BACKEND_LANG}}/{{BACKEND_FRAMEWORK}}\n- Frontend: {{FRONTEND_LANG}}/{{FRONTEND_FRAMEWORK}}\n- Database: {{DATABASE}}\n- Architecture: {{ARCHITECTURE}}\n\n## Compliance\nApplicable frameworks: {{COMPLIANCE_FRAMEWORKS}}\n\n## Success Criteria\n- [ ] All user stories completed\n- [ ] All tests passing (coverage >= {{MIN_COVERAGE}})\n- [ ] Security review passed (OWASP Top 10)\n- [ ] Compliance review passed" }]
      }]
    },
    "issuetype": { "name": "Epic" },
    "priority": { "name": "High" },
    "labels": ["epic", "compliance", "{{FEATURE_AREA_SLUG}}"]
  }
}
```

### Epic (Minimal)

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

### Parameterized User Story

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "As a {{USER_ROLE}}, I want {{GOAL}}, so that {{BENEFIT}}",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Context\nPart of epic {{EPIC_KEY}} for {{PROJECT_NAME}}.\n\n## Acceptance Criteria\n\n```gherkin\nGiven {{PRECONDITION}}\nWhen {{ACTION}}\nThen {{EXPECTED_RESULT}}\n```\n\n## Technical Notes\n- Backend: {{BACKEND_LANG}}/{{BACKEND_FRAMEWORK}}\n- Frontend: {{FRONTEND_LANG}}/{{FRONTEND_FRAMEWORK}} if applicable\n- Affected modules: {{AFFECTED_MODULES}}\n\n## Compliance Scope\n{{COMPLIANCE_FRAMEWORKS}}\n\n## Security Considerations\n{{SECURITY_SCOPE}}" }]
      }]
    },
    "issuetype": { "name": "Story" },
    "priority": { "name": "Medium" },
    "labels": ["story", "{{FEATURE_AREA_SLUG}}"],
    "customfield_story_points": {{STORY_POINTS}}
  }
}
```

### User Story (Minimal)

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

### Parameterized Technical Subtask

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "[TECH] {{SUBTASK_TITLE}}",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Parent Story\n{{PARENT_STORY_KEY}}\n\n## Technical Details\n- Files to modify: {{AFFECTED_FILES}}\n- API changes: {{API_CHANGES}}\n- Database changes: {{DATABASE_CHANGES}}\n- Architecture pattern: {{ARCHITECTURE}}\n\n## Implementation Notes\n{{IMPLEMENTATION_NOTES}}\n\n## Definition of Done\n- [ ] Implementation complete\n- [ ] Unit tests added (coverage >= {{MIN_COVERAGE}})\n- [ ] Build passes: {{BUILD_COMMAND}}\n- [ ] Tests pass: {{TEST_COMMAND}}\n- [ ] Lint passes: {{LINT_COMMAND}}" }]
      }]
    },
    "issuetype": { "name": "Sub-task" },
    "parent": { "key": "{{PARENT_STORY_KEY}}" },
    "labels": ["technical", "{{FEATURE_AREA_SLUG}}"]
  }
}
```

### Technical Subtask (Minimal)

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

### Parameterized Bug Report

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "[BUG] {{BUG_TITLE}}",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Steps to Reproduce\n{{REPRO_STEPS}}\n\n## Expected Behavior\n{{EXPECTED_BEHAVIOR}}\n\n## Actual Behavior\n{{ACTUAL_BEHAVIOR}}\n\n## Environment\n- Project: {{PROJECT_NAME}}\n- Stack: {{BACKEND_LANG}}/{{BACKEND_FRAMEWORK}}, {{FRONTEND_LANG}}/{{FRONTEND_FRAMEWORK}}\n- Detected by: {{TEST_TYPE}}\n\n## Evidence\n{{EVIDENCE}}\n\n## Related Story\n{{PARENT_STORY_KEY}}\n\n## Regression\n{{REGRESSION}}" }]
      }]
    },
    "issuetype": { "name": "Bug" },
    "priority": { "name": "{{BUG_PRIORITY}}" },
    "labels": ["bug", "{{FEATURE_AREA_SLUG}}"],
    "parent": { "key": "{{PARENT_STORY_KEY}}" }
  }
}
```

### Bug Report (Minimal)

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

### Parameterized Security Ticket [CONDITIONAL]

Use when a security issue is found during review.

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "[SECURITY] {{SECURITY_TITLE}}",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## OWASP Category\n{{OWASP_CATEGORY}}\n\n## Severity\n{{SECURITY_SEVERITY}}\n\n## Description\n{{SECURITY_DESCRIPTION}}\n\n## Location\n{{AFFECTED_FILES}}\n\n## Impact\n{{SECURITY_IMPACT}}\n\n## Proposed Fix\n{{PROPOSED_FIX}}\n\n## Related Story\n{{PARENT_STORY_KEY}}" }]
      }]
    },
    "issuetype": { "name": "{{SECURITY_ISSUE_TYPE}}" },
    "priority": { "name": "{{SECURITY_PRIORITY}}" },
    "labels": ["security", "owasp", "{{FEATURE_AREA_SLUG}}"]
  }
}
```

### Parameterized Compliance Ticket [CONDITIONAL]

Use when a compliance gap is found during review.

```json
{
  "fields": {
    "project": { "key": "{{PROJECT_KEY}}" },
    "summary": "[COMPLIANCE] {{COMPLIANCE_TITLE}}",
    "description": {
      "type": "doc",
      "version": 1,
      "content": [{
        "type": "paragraph",
        "content": [{ "type": "text", "text": "## Regulation\n{{COMPLIANCE_REGULATION}}\n\n## Requirement\n{{COMPLIANCE_REQUIREMENT}}\n\n## Gap Description\n{{GAP_DESCRIPTION}}\n\n## Location\n{{AFFECTED_FILES}}\n\n## Risk\n{{COMPLIANCE_RISK}}\n\n## Proposed Remediation\n{{PROPOSED_REMEDIATION}}\n\n## Related Story\n{{PARENT_STORY_KEY}}" }]
      }]
    },
    "issuetype": { "name": "{{COMPLIANCE_ISSUE_TYPE}}" },
    "priority": { "name": "{{COMPLIANCE_PRIORITY}}" },
    "labels": ["compliance", "{{COMPLIANCE_REGULATION_SLUG}}", "{{FEATURE_AREA_SLUG}}"]
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

---

## Template Placeholder Reference

In addition to the standard Argus placeholders, Jira templates use these specific placeholders:

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{{FEATURE_AREA}}` | Name of the feature area or epic topic | "User Authentication" |
| `{{FEATURE_AREA_SLUG}}` | Lowercase, hyphenated version for labels | "user-authentication" |
| `{{USER_ROLE}}` | Role in the user story | "bank customer" |
| `{{GOAL}}` | What the user wants | "reset my password" |
| `{{BENEFIT}}` | Why the user wants it | "regain access to my account" |
| `{{EPIC_KEY}}` | Jira key of the parent epic | "PROJ-100" |
| `{{PARENT_STORY_KEY}}` | Jira key of the parent story | "PROJ-101" |
| `{{PRECONDITION}}` | Gherkin precondition | "I am on the login page" |
| `{{ACTION}}` | Gherkin action | "I click forgot password" |
| `{{EXPECTED_RESULT}}` | Gherkin expected result | "I receive a reset email" |
| `{{STORY_POINTS}}` | Fibonacci story points | "5" |
| `{{AFFECTED_MODULES}}` | Modules affected by the story | "auth, email" |
| `{{SECURITY_SCOPE}}` | Security considerations | "Touches password reset flow" |
| `{{SUBTASK_TITLE}}` | Short title of the technical subtask | "Implement password reset service" |
| `{{AFFECTED_FILES}}` | Files to modify | `src/auth/...` |
| `{{API_CHANGES}}` | API changes needed | "POST /v1/auth/reset-password" |
| `{{DATABASE_CHANGES}}` | Database changes needed | "Add token table" |
| `{{IMPLEMENTATION_NOTES}}` | Implementation guidance | "Use bcrypt, TTL 15min" |
| `{{BUG_TITLE}}` | Short bug description | "Login fails with valid credentials" |
| `{{REPRO_STEPS}}` | Steps to reproduce | "1. Enter email..." |
| `{{EXPECTED_BEHAVIOR}}` | Expected behavior | "User logs in" |
| `{{ACTUAL_BEHAVIOR}}` | Actual behavior | "Error 500 returned" |
| `{{TEST_TYPE}}` | Who/what found the bug | "Unit test", "Manual QA" |
| `{{EVIDENCE}}` | Logs, screenshots, stack traces | "stack trace attached" |
| `{{REGRESSION}}` | Whether it's a regression | "Yes, worked in v1.2" |
| `{{BUG_PRIORITY}}` | Bug priority | "High" |
| `{{SECURITY_TITLE}}` | Security issue title | "SQL injection in search endpoint" |
| `{{OWASP_CATEGORY}}` | OWASP category | "A03: Injection" |
| `{{SECURITY_SEVERITY}}` | Severity | "Critical" |
| `{{SECURITY_DESCRIPTION}}` | Issue description | "User input concatenated into SQL" |
| `{{SECURITY_IMPACT}}` | Impact | "Data exfiltration possible" |
| `{{PROPOSED_FIX}}` | Suggested fix | "Use parameterized queries" |
| `{{SECURITY_ISSUE_TYPE}}` | Jira issue type | "Bug" or "Security" |
| `{{SECURITY_PRIORITY}}` | Priority | "Critical" |
| `{{COMPLIANCE_TITLE}}` | Compliance gap title | "Missing data export endpoint" |
| `{{COMPLIANCE_REGULATION}}` | Regulation name | "GDPR" |
| `{{COMPLIANCE_REGULATION_SLUG}}` | Lowercase slug | "gdpr" |
| `{{COMPLIANCE_REQUIREMENT}}` | Specific requirement | "Right to data portability" |
| `{{GAP_DESCRIPTION}}` | What is missing | "No endpoint to export user data" |
| `{{COMPLIANCE_RISK}}` | Risk of non-compliance | "Regulatory fine, user complaints" |
| `{{PROPOSED_REMEDIATION}}` | How to fix | "Add /v1/user/export endpoint" |
| `{{COMPLIANCE_ISSUE_TYPE}}` | Jira issue type | "Bug" or "Task" |
| `{{COMPLIANCE_PRIORITY}}` | Priority | "High" |

---

## How to Use the Templates

### Step 1: Choose the right template
- New feature area → Epic
- User-facing requirement → User Story
- Technical implementation task → Technical Subtask
- Test failure → Bug Report
- Security finding → Security Ticket
- Compliance gap → Compliance Ticket

### Step 2: Replace placeholders
Use values from the Argus installation questionnaire and the current task context.

### Step 3: Create the issue
Use the Jira MCP tool or REST API with the populated JSON.

### Step 4: Link issues
- Link stories to epics (parent relationship)
- Link subtasks to stories (parent relationship)
- Link bugs/security/compliance tickets to the related story

### Example: Creating a User Story

```bash
# 1. Read the template
# 2. Replace placeholders with actual values
# 3. Save to story.json
# 4. Create the issue

curl -s -X POST \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d @story.json \
  "${JIRA_URL}/issue"
```

---

## Rules

1. **Always use parameterized templates when possible** — they save time and ensure consistency
2. **Replace all placeholders before creating the issue** — never submit raw templates
3. **Link related issues** — maintain traceability across epics, stories, and bugs
4. **Set correct priority** — security and compliance issues are typically High or Critical
5. **Use slugs for labels** — lowercase and hyphenated (e.g., `user-authentication`)
