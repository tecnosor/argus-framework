# UI/UX Guidelines — {{PROJECT_NAME}}

> This document defines the UI/UX design standards for the project.
> Generated during agentic installation based on frontend analysis and user input.

---

## Design System

### Framework: {{FRONTEND_FRAMEWORK}}
### Styling: {{STYLING_APPROACH}}

---

## Design Tokens

### Colors

| Token | Value | Usage |
|-------|-------|-------|
| `--color-primary` | {{PRIMARY_COLOR}} | Primary actions, brand |
| `--color-secondary` | {{SECONDARY_COLOR}} | Secondary actions |
| `--color-success` | {{SUCCESS_COLOR}} | Success states |
| `--color-warning` | {{WARNING_COLOR}} | Warning states |
| `--color-error` | {{ERROR_COLOR}} | Error states, destructive actions |
| `--color-info` | {{INFO_COLOR}} | Informational messages |
| `--color-text-primary` | {{TEXT_PRIMARY}} | Main body text |
| `--color-text-secondary` | {{TEXT_SECONDARY}} | Muted text |
| `--color-background` | {{BACKGROUND_COLOR}} | Page backgrounds |
| `--color-surface` | {{SURFACE_COLOR}} | Card/panel backgrounds |
| `--color-border` | {{BORDER_COLOR}} | Borders and dividers |

### Typography

| Token | Size | Weight | Usage |
|-------|------|--------|-------|
| `--font-h1` | 2rem (32px) | 700 | Page titles |
| `--font-h2` | 1.5rem (24px) | 600 | Section titles |
| `--font-h3` | 1.25rem (20px) | 600 | Subsection titles |
| `--font-body` | 1rem (16px) | 400 | Body text |
| `--font-small` | 0.875rem (14px) | 400 | Secondary text |
| `--font-caption` | 0.75rem (12px) | 400 | Labels, captions |

**Font Family**: {{FONT_FAMILY}}

### Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--space-1` | 4px | Tight gaps, icon spacing |
| `--space-2` | 8px | Related items |
| `--space-3` | 12px | Form field gaps |
| `--space-4` | 16px | Card padding, section padding |
| `--space-6` | 24px | Section margins |
| `--space-8` | 32px | Major section gaps |
| `--space-12` | 48px | Page section separation |

### Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | 4px | Buttons, inputs |
| `--radius-md` | 8px | Cards, modals |
| `--radius-lg` | 16px | Large panels |
| `--radius-full` | 9999px | Pills, avatars |

### Shadows

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | Subtle | Cards, dropdowns |
| `--shadow-md` | Medium | Modals, popovers |
| `--shadow-lg` | Strong | Elevated elements |

---

## Component Library

{{COMPONENT_LIBRARY}}

<!-- Installation agent: Detect component library from:
     - package.json dependencies (Vuetify, Ant Design, MUI, etc.)
     - Custom component directory structure
     - Storybook configuration
     List available components and their usage patterns. -->

---

## Layout Patterns

### Page Structure

```
┌──────────────────────────────────────────┐
│                 Header                    │
├──────────┬───────────────────────────────┤
│          │                               │
│ Sidebar  │         Main Content          │
│          │                               │
│          │                               │
│          │                               │
├──────────┴───────────────────────────────┤
│                 Footer                    │
└──────────────────────────────────────────┘
```

### Responsive Breakpoints

| Breakpoint | Width | Layout |
|-----------|-------|--------|
| Mobile | < 768px | Single column, hamburger nav |
| Tablet | 768px - 1023px | Collapsible sidebar |
| Desktop | 1024px - 1439px | Full sidebar + content |
| Large | >= 1440px | Full sidebar + content + optional panel |

---

## Interaction Patterns

### Loading States

| Component | Pattern |
|-----------|---------|
| Page load | Skeleton screens |
| Button action | Spinner + disabled state |
| Data fetch | Skeleton or spinner overlay |
| Form submit | Button loading state |
| File upload | Progress bar |

### Error Handling

| Type | Pattern |
|------|---------|
| Form validation | Inline error below field |
| API error | Toast notification (auto-dismiss 5s) |
| Network error | Full-page offline state |
| 404 | Dedicated not-found page |
| 500 | Error page with retry option |

### Empty States

- Show helpful illustration
- Explain why the list/page is empty
- Provide a clear call to action

---

## Accessibility Requirements: WCAG {{ACCESSIBILITY_REQUIREMENTS}}

### Mandatory Checks

- [ ] Color contrast >= 4.5:1 (normal text), >= 3:1 (large text)
- [ ] All interactive elements keyboard-accessible
- [ ] Focus indicators visible
- [ ] All images have alt text
- [ ] Form inputs have labels
- [ ] ARIA attributes used correctly
- [ ] Heading hierarchy is logical (h1 → h2 → h3, no skipping)
- [ ] Touch targets >= 44x44px on mobile

### Testing Tools

- **axe-core**: Automated testing in CI
- **Lighthouse**: Performance + accessibility audit
- **Manual keyboard testing**: Tab through all interactive elements
- **Screen reader testing**: NVDA/VoiceOver for critical flows

---

## Banking-Specific UI Patterns

### Financial Data

- **Currency**: Always show symbol + 2 decimal places (€1,234.56)
- **Thousands separator**: Locale-appropriate
- **Positive/Negative**: Green ↑ / Red ↓ with icons (not color alone)
- **Account numbers**: Masked by default (•••• 1234), toggle to reveal

### Transaction Flows

1. **Input** → 2. **Review** → 3. **Confirm** (with re-auth) → 4. **Processing** → 5. **Receipt**

### Security UX

- Session timeout warning (2 minutes before)
- Re-authentication for sensitive operations
- New device login notifications
- Activity log accessible from account settings

---

## Performance Targets

| Metric | Target |
|--------|--------|
| First Contentful Paint | < 1.8s |
| Largest Contentful Paint | < 2.5s |
| Cumulative Layout Shift | < 0.1 |
| Time to Interactive | < 3.8s |
| Bundle size (gzipped) | < {{MAX_BUNDLE_SIZE}} |

---

*This document is maintained by the agentic framework. Update it when design standards change.*
