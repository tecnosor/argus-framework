---
name: compliance-eu
description: "DEPRECATED meta-skill. Use the individual compliance skills instead: gdpr, dora, mica, psd2, pci-dss. This skill now acts as a dispatcher that loads only the sub-skills applicable to the project scope."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator
  phase: review, planning
---

# EU Compliance Meta-Skill (Dispatcher)

> **Note:** This skill has been split into focused sub-skills. Prefer using them directly:
> - `gdpr` — General Data Protection Regulation
> - `dora` — Digital Operational Resilience Act
> - `mica` — Markets in Crypto-Assets Regulation
> - `psd2` — Payment Services Directive 2
> - `pci-dss` — Payment Card Industry Data Security Standard

## Purpose

This meta-skill acts as a dispatcher. During installation, the installer should
**only copy the sub-skills that apply to the project**. If all EU compliance
frameworks apply, this meta-skill can load all five sub-skills.

## When to Use

Use this skill only when:
- The project must comply with **multiple EU frameworks at once**
- You want a single entry point that delegates to sub-skills
- You are maintaining existing configurations that reference `compliance-eu`

For new projects, load the individual skills instead.

## Dispatch Logic

Based on the project's compliance scope (`{{COMPLIANCE_FRAMEWORKS}}`), load:

| Framework | Sub-Skill to Load |
|-----------|-------------------|
| GDPR | `gdpr` |
| DORA | `dora` |
| MiCA | `mica` |
| PSD2 | `psd2` |
| PCI-DSS | `pci-dss` |

## Installation Note

When installing Argus:

1. Read the user's compliance scope from the questionnaire
2. Copy only the applicable sub-skills:
   ```bash
   # Example: project needs GDPR and DORA only
   mkdir -p .agents/skills/gdpr .agents/skills/dora
   cp argus/.agents/skills/gdpr/SKILL.md .agents/skills/gdpr/SKILL.md
   cp argus/.agents/skills/dora/SKILL.md .agents/skills/dora/SKILL.md
   ```
3. Skip sub-skills that do not apply (e.g., skip `mica` for non-crypto projects)
4. Optionally keep `compliance-eu` as a dispatcher if the user wants a unified entry point

## Report Format

When used as dispatcher, produce a combined report:

```markdown
# EU Compliance Assessment

## Scope: [project scope]
## Date: YYYY-MM-DD

### Sub-Skill Results

| Framework | Skill | Status |
|-----------|-------|--------|
| GDPR | gdpr | ✅/🔴/🟡 |
| DORA | dora | ✅/🔴/🟡 |
| MiCA | mica | ✅/🔴/🟡 |
| PSD2 | psd2 | ✅/🔴/🟡 |
| PCI-DSS | pci-dss | ✅/🔴/🟡 |

## Overall Status: [COMPLIANT / PARTIAL / NON-COMPLIANT]
```

---

## Rules

1. **Prefer individual skills** — do not force all compliance frameworks on every project
2. **Install only what applies** — reduces noise and false positives
3. **Use this meta-skill for backward compatibility** only
4. **Sub-skills are independent** — each can be loaded and used alone
