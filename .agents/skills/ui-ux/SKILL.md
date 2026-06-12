---
name: ui-ux
description: "UI/UX design standards and best practices for {{PROJECT_NAME}}. Covers design system usage, accessibility (WCAG), responsive design, interaction patterns, visual hierarchy, and usability heuristics. Use when implementing or reviewing frontend components and pages."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: frontend-dev, reviewer
  phase: development, review
---

# UI/UX Design Standards Skill

You are applying **UI/UX design standards** for **{{PROJECT_NAME}}**.

This skill ensures all frontend work meets professional design quality,
accessibility requirements, and usability standards.

---

## Design System

### Design Tokens

Use the project's design tokens consistently. Never hardcode values.

| Token Category | Examples | Usage |
|---------------|----------|-------|
| Colors | `--color-primary`, `--color-error` | All color values |
| Typography | `--font-size-sm`, `--font-weight-bold` | All text styling |
| Spacing | `--space-1` (4px), `--space-4` (16px) | All margins, paddings, gaps |
| Border Radius | `--radius-sm`, `--radius-lg` | All rounded corners |
| Shadows | `--shadow-sm`, `--shadow-lg` | All elevation effects |
| Breakpoints | `--bp-mobile`, `--bp-tablet`, `--bp-desktop` | Responsive design |

### Component Library

Before creating a new component:
1. Check if an existing component covers the use case
2. Check if an existing component can be extended with variants
3. Only create new components when no existing option works
4. New components must follow the established patterns

---

## Accessibility (WCAG {{ACCESSIBILITY_REQUIREMENTS}})

### Level A Requirements (Must Have)

- [ ] All non-text content has text alternatives (alt text, labels)
- [ ] Pre-recorded audio/video has captions
- [ ] Information is not conveyed by color alone
- [ ] Text can be resized up to 200% without loss of content
- [ ] All functionality available via keyboard
- [ ] No keyboard traps
- [ ] Page has a descriptive `<title>`
- [ ] Focus order is logical and intuitive
- [ ] Links have descriptive text (not "click here")
- [ ] Form inputs have associated labels
- [ ] Error messages are identified and described
- [ ] Form submission errors identify the problematic field

### Level AA Requirements (Should Have)

- [ ] Text contrast ratio >= 4.5:1 (normal text) or 3:1 (large text)
- [ ] Text can be resized up to 200% without horizontal scrolling
- [ ] Multiple ways to find pages (navigation, search, sitemap)
- [ ] Headings and labels describe topic/purpose
- [ ] Focus indicator is visible on all interactive elements
- [ ] Navigation is consistent across pages
- [ ] UI components with same function have consistent identification
- [ ] Error suggestions provided when input errors are detected
- [ ] Legal/financial transactions are reversible or confirmed

### Testing Tools

| Tool | Purpose | Command/Usage |
|------|---------|---------------|
| axe-core | Automated accessibility testing | `npx axe` or browser extension |
| Lighthouse | Performance + accessibility audit | Chrome DevTools or `lighthouse` CLI |
| pa11y | Command-line accessibility testing | `pa11y http://localhost:3000` |
| WAVE | Visual accessibility evaluation | Browser extension |
| Color Contrast Checker | Verify contrast ratios | Various online tools |

---

## Responsive Design

### Breakpoint Strategy (Mobile-First)

```css
/* Base styles (mobile) */
.component { ... }

/* Tablet (>= 768px) */
@media (min-width: 768px) {
  .component { ... }
}

/* Desktop (>= 1024px) */
@media (min-width: 1024px) {
  .component { ... }
}

/* Large desktop (>= 1440px) */
@media (min-width: 1440px) {
  .component { ... }
}
```

### Responsive Checklist

- [ ] Layout adapts at all breakpoints
- [ ] Text is readable without horizontal scrolling
- [ ] Touch targets >= 44x44px on mobile
- [ ] Images scale proportionally
- [ ] Tables are horizontally scrollable on mobile (or use card layouts)
- [ ] Navigation collapses to hamburger/drawer on mobile
- [ ] Forms stack vertically on mobile

---

## Interaction Patterns

### Loading States

| Pattern | When to Use |
|---------|-------------|
| Skeleton screens | Content-heavy pages, initial load |
| Spinners | Short operations (< 2s), inline actions |
| Progress bars | Long operations with known duration |
| Progress indicators | Multi-step processes |
| Optimistic UI | Immediate feedback, rollback on error |

### Error States

- **Inline errors**: Next to the relevant field (forms)
- **Toast notifications**: Transient, non-blocking messages
- **Error pages**: Full-page errors (404, 500, offline)
- **Empty states**: When no data is available, show helpful message + CTA

### Feedback Patterns

- **Immediate**: Button press → visual change (ripple, color shift)
- **Short delay**: Form submit → loading state → success/error
- **Long operation**: File upload → progress bar → completion notification

---

## Usability Heuristics (Nielsen's 10)

1. **Visibility of System Status**: Always show what is happening
2. **Match Between System and Real World**: Use familiar language and conventions
3. **User Control and Freedom**: Support undo and redo, easy exits
4. **Consistency and Standards**: Follow platform conventions, internal consistency
5. **Error Prevention**: Prevent errors before they occur (confirmation, validation)
6. **Recognition Rather Than Recall**: Make options visible, reduce memory load
7. **Flexibility and Efficiency**: Accelerators for experts, simple paths for novices
8. **Aesthetic and Minimalist Design**: Remove irrelevant information
9. **Help Users Recognize and Recover from Errors**: Plain language error messages
10. **Help and Documentation**: Searchable, task-focused help

---

## Visual Hierarchy

### Typography Scale

```
h1: 2rem (32px) — Page title
h2: 1.5rem (24px) — Section title
h3: 1.25rem (20px) — Subsection title
h4: 1.125rem (18px) — Card title
body: 1rem (16px) — Body text
small: 0.875rem (14px) — Secondary text
caption: 0.75rem (12px) — Labels, captions
```

### Spacing Scale

```
4px (0.25rem) — Tight spacing, icon gaps
8px (0.5rem) — Related items
12px (0.75rem) — Form field gaps
16px (1rem) — Section padding, card padding
24px (1.5rem) — Section margins
32px (2rem) — Major section gaps
48px (3rem) — Page section separation
```

### Color Usage

| Purpose | Token | Usage |
|---------|-------|-------|
| Primary action | `color-primary` | Main CTA buttons, active states |
| Secondary action | `color-secondary` | Secondary buttons, links |
| Success | `color-success` | Success messages, positive indicators |
| Warning | `color-warning` | Warning messages, caution states |
| Error | `color-error` | Error messages, validation errors |
| Info | `color-info` | Informational messages |
| Text primary | `color-text-primary` | Main body text |
| Text secondary | `color-text-secondary` | Muted/secondary text |
| Background | `color-background` | Page/card backgrounds |
| Border | `color-border` | Borders, dividers |

---

## Banking-Specific UI Patterns

### Financial Data Display
- **Currency formatting**: Always show currency symbol and 2 decimal places
- **Number formatting**: Thousands separators (locale-appropriate)
- **Positive/Negative**: Green for positive, red for negative (with icons, not color alone)
- **Sensitive data**: Mask account numbers, show only last 4 digits by default

### Transaction Flows
- **Confirmation step**: Always show summary before final submission
- **Undo window**: Allow cancellation within X seconds for transfers
- **Receipt**: Show confirmation with reference number after completion
- **Status tracking**: Show transaction status (pending, completed, failed)

### Security UX
- **Session timeout warning**: Warn user before session expires
- **Sensitive action re-auth**: Require password/biometric for high-risk operations
- **Device recognition**: Notify user of new device logins
- **Activity log**: Allow users to review recent account activity

---

## Rules

1. **Always use design tokens** — never hardcode colors, sizes, or spacing
2. **Check existing components first** — reuse before creating new
3. **Mobile-first** — design for mobile, enhance for desktop
4. **Accessibility is mandatory** — WCAG {{ACCESSIBILITY_REQUIREMENTS}} minimum
5. **Test with real data** — empty states and edge cases matter
6. **Performance matters** — lazy load images, optimize bundles
7. **Consistent patterns** — same interaction = same behavior everywhere
