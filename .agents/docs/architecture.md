# Architecture — {{PROJECT_NAME}}

> This document describes the system architecture. Generated during agentic installation
> and updated as the project evolves.

---

## Overview

**Project**: {{PROJECT_NAME}}
**Architecture Pattern**: {{ARCHITECTURE}}
**Description**: {{PROJECT_DESCRIPTION}}

---

## System Context

```
                    ┌─────────────┐
                    │   Users /    │
                    │   Clients    │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │  {{PROJECT  │
                    │   NAME}}    │
                    │  (System)   │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
        ┌─────▼─────┐ ┌───▼────┐ ┌────▼─────┐
        │ Database  │ │External│ │  Third   │
        │ ({{DB}})  │ │ APIs   │ │  Party   │
        └───────────┘ └────────┘ └──────────┘
```

---

## Bounded Contexts / Modules

{{BOUNDED_CONTEXTS}}

<!-- Installation agent: Detect modules from project structure.
     For monorepos: list packages/apps.
     For microservices: list services.
     For monoliths: list bounded contexts or major modules. -->

---

## Layer Architecture

### {{ARCHITECTURE}} Layers

```
┌─────────────────────────────────────────────┐
│              Interfaces Layer                │
│  REST Controllers, gRPC Handlers, Consumers  │
├─────────────────────────────────────────────┤
│             Application Layer                │
│  Use Cases, Commands, Queries, DTOs          │
├─────────────────────────────────────────────┤
│               Domain Layer                   │
│  Entities, Value Objects, Domain Services    │
│  Repository Interfaces, Domain Events        │
├─────────────────────────────────────────────┤
│            Infrastructure Layer              │
│  Repository Implementations, Adapters        │
│  Framework Config, External Services         │
└─────────────────────────────────────────────┘
```

### Dependency Rules

- Domain → nothing (no external dependencies)
- Application → Domain only
- Infrastructure → Domain + Application (implements interfaces)
- Interfaces → Application only (delegates to use cases)

---

## Technology Stack

| Concern | Technology | Purpose |
|---------|-----------|---------|
| Language | {{BACKEND_LANG}} | Implementation |
| Framework | {{BACKEND_FRAMEWORK}} | Application framework |
| Database | {{DATABASE}} | Persistent storage |
| Migrations | {{MIGRATION_TOOL}} | Schema management |
| Build | {{BUILD_TOOL}} | Compilation and packaging |
| Testing | {{TEST_FRAMEWORKS}} | Automated testing |
| API Docs | {{API_DOCS_TOOL}} | API documentation |

---

## Data Flow

### Command Flow (Write)
```
Client → Controller → Command Handler → Domain → Repository → Database
```

### Query Flow (Read)
```
Client → Controller → Query Handler → Repository → Database → DTO → Client
```

---

## Cross-Cutting Concerns

### Security
- Authentication: {{AUTH_MECHANISM}}
- Authorization: {{AUTHZ_MECHANISM}}
- Encryption: TLS 1.2+ in transit, AES-256 at rest

### Logging
- Framework: {{LOGGING_FRAMEWORK}}
- Levels: ERROR, WARN, INFO, DEBUG
- No PII in logs (enforced by secure-coder skill)

### Error Handling
- Global exception handler at controller level
- Domain exceptions mapped to HTTP status codes
- Consistent error response format

### Configuration
- Environment-specific profiles (dev, staging, prod)
- Secrets from environment variables / vault
- No hardcoded configuration values

---

## Deployment

{{DEPLOYMENT_DESCRIPTION}}

---

## Key Design Decisions

| Decision | Rationale | Date |
|----------|-----------|------|
| {{ARCHITECTURE}} | [why this pattern was chosen] | [date] |
| {{DATABASE}} | [why this database] | [date] |

---

*This document is maintained by the agentic framework. Update it when architecture changes.*
