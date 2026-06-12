# Coding Standards — {{PROJECT_NAME}}

> This document defines the coding standards enforced across the project.
> Generated during agentic installation and updated as conventions evolve.

---

## General Rules

1. **Language**: All code, comments, and documentation must be in English
2. **Formatting**: Use project formatter (configured in project config files)
3. **No dead code**: Remove unused imports, variables, methods, and commented-out code
4. **No magic values**: Use named constants or enums
5. **Error handling**: Never swallow exceptions. Log or rethrow with context.

---

## Backend Standards ({{BACKEND_LANG}} / {{BACKEND_FRAMEWORK}})

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Classes | PascalCase | `UserService`, `PaymentController` |
| Interfaces | PascalCase (no `I` prefix) | `UserRepository`, `PaymentGateway` |
| Methods | camelCase | `findById`, `calculateTotal` |
| Variables | camelCase | `userName`, `orderItems` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE` |
| Packages | lowercase.dot.separated | `com.project.user.service` |
| Database tables | snake_case | `user_accounts`, `payment_transactions` |
| Database columns | snake_case | `created_at`, `first_name` |

### Architecture Rules

- **Constructor injection only** — never use `@Autowired` on fields
- **No `@Transactional` on infrastructure** — only on application layer
- **No business logic in controllers** — validate input, delegate to use case
- **DTOs for API boundaries** — never expose domain entities directly
- **Repository interfaces in domain** — implementations in infrastructure
- **One class per file** — except inner classes

### Error Handling

```java
// ✅ Good — specific exception with context
throw new UserNotFoundException("User not found: " + userId);

// ❌ Bad — generic exception
throw new RuntimeException("Error");

// ❌ Bad — empty catch block
try {
    doSomething();
} catch (Exception e) {
    // nothing
}
```

### Logging

```java
// ✅ Good — structured logging with context
log.info("User created: userId={}, email={}", userId, maskedEmail);

// ❌ Bad — string concatenation
log.info("User created: " + userId);

// ❌ Bad — PII in logs
log.info("User created: email={}, phone={}", email, phone);
```

---

## Frontend Standards ({{FRONTEND_LANG}} / {{FRONTEND_FRAMEWORK}})

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Components | PascalCase | `UserProfile`, `DataTable` |
| Composables/Hooks | useCamelCase | `useAuth`, `useFormValidation` |
| Stores | camelCase + Store | `authStore`, `cartStore` |
| Types/Interfaces | PascalCase | `UserDTO`, `AuthState` |
| CSS Classes | {{CSS_CONVENTION}} | `user-profile__header` / `bg-primary` |
| Test Files | ComponentName.test.ts | `UserProfile.test.ts` |
| Utility Functions | camelCase | `formatCurrency`, `debounce` |

### TypeScript Rules

- **Strict mode enabled** — no exceptions
- **No `any` type** — use `unknown` and narrow
- **No `@ts-ignore`** — fix the type error
- **No `@ts-expect-error`** — fix the type error
- **Explicit return types** on public functions
- **Interface over type alias** for object shapes (when extensible)

### Component Rules

- **Max 200 lines** per component file
- **Props typed** with interfaces, defaults for optional
- **Emits typed** with explicit event definitions
- **Scoped styles** — no global CSS leaks
- **No inline styles** — use design tokens
- **No business logic** in components — delegate to composables/services

---

## Database Standards ({{DATABASE}})

### Table Naming

```sql
-- ✅ Good
CREATE TABLE user_accounts ( ... );
CREATE TABLE payment_transactions ( ... );

-- ❌ Bad
CREATE TABLE UserAccounts ( ... );
CREATE TABLE payTxn ( ... );
```

### Column Naming

```sql
-- ✅ Good
created_at TIMESTAMP NOT NULL DEFAULT NOW()
updated_at TIMESTAMP NOT NULL DEFAULT NOW()
first_name VARCHAR(100) NOT NULL
is_active BOOLEAN NOT NULL DEFAULT TRUE

-- ❌ Bad
createdAt TIMESTAMP
fname VARCHAR(100)
active BOOLEAN
```

### Migration Rules ({{MIGRATION_TOOL}})

- All schema changes via migration scripts — never manual DDL
- Migration naming: `V001__description.sql` or project convention
- Every migration must be reversible (rollback script)
- Foreign keys must be indexed
- No `SELECT *` in views or stored procedures

---

## API Standards: {{API_STANDARDS}}

### REST Conventions

| Method | Usage | Success Code |
|--------|-------|-------------|
| GET | Read resource(s) | 200 |
| POST | Create resource | 201 |
| PUT | Full update | 200 |
| PATCH | Partial update | 200 |
| DELETE | Remove resource | 204 |

### Response Format

```json
{
  "data": { ... },
  "meta": {
    "page": 1,
    "size": 20,
    "total": 100
  }
}
```

### Error Response Format

```json
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User not found with the provided ID",
    "details": [],
    "timestamp": "2026-06-12T14:30:00Z"
  }
}
```

---

## Git Standards

### Branch Naming: {{BRANCH_NAMING}}

### Commit Messages: {{COMMIT_CONVENTION}}

### PR Requirements

- [ ] Title follows commit convention format
- [ ] Description includes: what, why, how to test
- [ ] Screenshots for UI changes
- [ ] Linked to issue/ticket
- [ ] All checks passing (build, tests, lint)
- [ ] No merge commits (rebase on target branch)

---

*This document is maintained by the agentic framework. Update it when standards change.*
