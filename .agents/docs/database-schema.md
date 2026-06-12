# Database Design — {{PROJECT_NAME}}

> This document describes the database architecture, conventions, and key schema decisions.
> Generated during agentic installation based on migration files and project analysis.

---

## Overview

| Property | Value |
|----------|-------|
| **Database Engine** | {{DATABASE}} |
| **Migration Tool** | {{MIGRATION_TOOL}} |
| **Character Set** | UTF-8 |
| **Collation** | {{DB_COLLATION}} |
| **Connection Pool** | {{DB_CONNECTION_POOL}} |

---

## Schema Organization

{{SCHEMA_ORGANIZATION}}

<!-- Installation agent: Detect schemas/modules from migration files or entity definitions.
     List bounded contexts and their corresponding database schemas. -->

---

## Naming Conventions

### Tables

| Rule | Example |
|------|---------|
| Lowercase snake_case | `user_accounts`, `payment_transactions` |
| Plural nouns | `users` not `user`, `orders` not `order` |
| Prefix with module (if multi-schema) | `auth_users`, `payment_transactions` |
| Join tables: alphabetical order | `role_permissions` (not `permission_roles`) |

### Columns

| Rule | Example |
|------|---------|
| Lowercase snake_case | `first_name`, `created_at` |
| Boolean prefix `is_`, `has_`, `can_` | `is_active`, `has_verified_email` |
| Timestamp suffix `_at` | `created_at`, `updated_at`, `deleted_at` |
| Foreign key: `{referenced_table_singular}_id` | `user_id`, `order_id` |
| Primary key: `id` | `id` (UUID or BIGSERIAL) |

### Constraints

| Type | Naming | Example |
|------|--------|---------|
| Primary Key | `pk_{table}` | `pk_user_accounts` |
| Foreign Key | `fk_{table}_{ref_table}` | `fk_orders_users` |
| Unique | `uq_{table}_{columns}` | `uq_users_email` |
| Check | `ck_{table}_{description}` | `ck_users_age_positive` |
| Index | `idx_{table}_{columns}` | `idx_orders_user_id` |

---

## Standard Columns

Every table must include:

```sql
id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- or BIGSERIAL
created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
-- Optional: soft delete
deleted_at  TIMESTAMP NULL
```

---

## Migration Rules ({{MIGRATION_TOOL}})

### File Naming

```
V001__create_user_accounts_table.sql
V002__create_payment_transactions_table.sql
V003__add_email_index_to_users.sql
R__refresh_materialized_views.sql  -- repeatable migrations
```

### Rules

1. **All DDL via migrations** — never manual schema changes
2. **Forward-only** — never modify an applied migration
3. **One change per migration** — atomic schema changes
4. **Test migrations** — run against test database before production
5. **Backward compatible** — new columns must be nullable or have defaults
6. **Index foreign keys** — always create indexes on FK columns
7. **No `SELECT *`** — specify columns explicitly in views

---

## Key Entities

{{KEY_ENTITIES}}

<!-- Installation agent: Detect main entities from:
     - JPA/Hibernate entity classes
     - Migration files
     - Prisma schema
     - TypeORM entities
     List the top 10-15 entities with their relationships. -->

---

## Indexing Strategy

### Rules

1. **Primary keys** — automatically indexed
2. **Foreign keys** — always create explicit index
3. **Frequently queried columns** — index based on query patterns
4. **Composite indexes** — order columns by selectivity (most selective first)
5. **Partial indexes** — use WHERE clause for filtered queries
6. **Avoid over-indexing** — each index slows writes

### Common Indexes

```sql
-- Foreign key indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Unique constraints (auto-indexed)
CREATE UNIQUE INDEX uq_users_email ON users(email);

-- Composite index for common queries
CREATE INDEX idx_transactions_user_date ON transactions(user_id, created_at DESC);

-- Partial index for active records
CREATE INDEX idx_users_active ON users(id) WHERE is_active = TRUE;
```

---

## Performance Guidelines

1. **Pagination** — always paginate list queries (cursor-based preferred)
2. **N+1 prevention** — use JOINs or batch loading, never query in loops
3. **Connection pooling** — configured via {{DB_CONNECTION_POOL}}
4. **Query analysis** — use EXPLAIN ANALYZE for slow queries
5. **Read replicas** — route read queries to replicas when available
6. **Materialized views** — for complex aggregation queries

---

## Backup & Recovery

| Parameter | Value |
|-----------|-------|
| Backup frequency | {{BACKUP_FREQUENCY}} |
| Retention period | {{BACKUP_RETENTION}} |
| Recovery Point Objective (RPO) | {{RPO}} |
| Recovery Time Objective (RTO) | {{RTO}} |

---

*This document is maintained by the agentic framework. Update it when database schema changes.*
