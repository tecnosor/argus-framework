---
name: lang-enforcer
description: "Detects and fixes non-English content in source code, documentation, and configuration files. Reports violations as LANG-NNN entries. Auto-fixes comments and documentation after confirmation. Requires explicit confirmation for identifier renames. Never modifies i18n/translation files."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: all-agents
  phase: development, review
---

# Language Enforcer Skill

You are enforcing **English-only** content across the **{{PROJECT_NAME}}** codebase.

All source code, comments, documentation, configuration files, commit messages,
and issue descriptions must be in English.

---

## Scope

### In Scope (Check These)
- Source code comments (`//`, `/* */`, `#`, `<!-- -->`)
- Variable, method, class, and module names
- Documentation files (`.md`, `.txt`, `.adoc`)
- Configuration files (`.yml`, `.yaml`, `.json`, `.properties`, `.xml`)
- Commit messages
- PR/MR descriptions
- Error messages and log statements in code
- Test descriptions and assertions

### Out of Scope (Never Touch These)
- **i18n/translation files**: `src/i18n/`, `src/main/resources/i18n/`, `locales/`, `translations/`
- **User-facing strings**: UI labels, error messages shown to end users (these go through i18n)
- **Proper nouns**: Company names, product names, people names
- **Technical terms**: Established non-English technical terms (e.g., "middleware" is fine)
- **URLs and paths**: File paths, URLs, package names
- **Regular expressions**: Pattern strings
- **Test data**: Sample data used in tests (may contain non-English for testing purposes)

---

## Detection Process

### Step 1: Scan for Non-English Content

```bash
# Scan comments in source files
grep -rn "// \|/\*\|#\|<!--" --include="*.java" --include="*.ts" --include="*.tsx" \
  --include="*.vue" --include="*.py" --include="*.go" --include="*.rs" \
  src/ | grep -v "node_modules"

# Scan documentation
grep -rn "." --include="*.md" --include="*.txt" --include="*.adoc" docs/

# Scan configuration
grep -rn "." --include="*.yml" --include="*.yaml" --include="*.properties" \
  src/main/resources/ config/
```

### Step 2: Identify Non-English Content

For each match, determine if the content is non-English:
- Look for accented characters (á, é, í, ó, ú, ñ, ü, ç, etc.)
- Look for common non-English words and patterns
- Consider context — technical terms may look non-English but are standard

### Step 3: Classify Violations

| Severity | Type | Auto-Fix |
|----------|------|----------|
| LANG-001 | Non-English comment | Yes (translate and replace) |
| LANG-002 | Non-English documentation | Yes (translate and replace) |
| LANG-003 | Non-English identifier (variable/method/class) | **Ask user first** |
| LANG-004 | Non-English commit message | No (historical — note only) |
| LANG-005 | Non-English configuration value | Yes (if not user-facing) |
| LANG-006 | Non-English error/log message | Yes (translate in code) |

---

## Fix Process

### Auto-Fix (Comments and Documentation)

For LANG-001, LANG-002, LANG-005, LANG-006:

1. Translate the content to English
2. Replace in the file
3. Report the change: `LANG-001: [file:line] — Translated comment from [language] to English`

### Manual Fix (Identifiers)

For LANG-003 (identifier renames):

1. **STOP and ask the user** before renaming any identifier
2. Present the finding: `LANG-003: [file:line] — Identifier "[name]" is in [language]`
3. Suggest an English equivalent
4. Only rename after explicit user confirmation
5. Use LSP rename to update all references across the codebase

### No Fix (Historical)

For LANG-004 (commit messages):

1. Report the finding
2. Note it for future reference
3. Do not attempt to rewrite git history

---

## Report Format

```markdown
# Language Enforcement Report

## Summary
- **Files Scanned**: X
- **Violations Found**: Y
  - LANG-001 (comments): X
  - LANG-002 (docs): X
  - LANG-003 (identifiers): X
  - LANG-004 (commits): X
  - LANG-005 (config): X
  - LANG-006 (messages): X

## Violations

### Auto-Fixed
1. LANG-001: `src/service/UserService.java:42` — Comment translated from Spanish
2. LANG-002: `docs/arquitectura.md` — Section header translated

### Requires Confirmation
1. LANG-003: `src/model/Usuario.java` — Class name "Usuario" → suggest "User"
2. LANG-003: `src/service/PagoService.java:15` — Method "procesarPago" → suggest "processPayment"

### Noted (No Action)
1. LANG-004: Commit abc123 — "Arreglar bug de autenticación"
```

---

## Rules

1. **Never touch i18n files** — this is the most important rule
2. **Never auto-rename identifiers** — always ask the user first
3. **Never rewrite git history** — commit messages are noted, not fixed
4. **Preserve meaning** — translations must be accurate, not just literal
5. **Respect proper nouns** — company/product names are not violations
6. **Be conservative** — when in doubt, flag it rather than auto-fix
7. **Use LSP for renames** — ensure all references are updated when renaming identifiers
