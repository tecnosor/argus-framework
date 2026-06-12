# API Standards — {{PROJECT_NAME}}

> This document defines the API design standards for the project.
> Generated during agentic installation based on existing API analysis and user input.

---

## API Style: {{API_STANDARDS}}

---

## URL Structure

```
Base URL: https://api.{{PROJECT_DOMAIN}}/v1

Resource pattern: /{resource}
Single item:     /{resource}/{id}
Sub-resource:    /{resource}/{id}/{sub-resource}
```

### Examples

```
GET    /v1/users                    # List users
POST   /v1/users                    # Create user
GET    /v1/users/{id}               # Get user
PUT    /v1/users/{id}               # Update user (full)
PATCH  /v1/users/{id}               # Update user (partial)
DELETE /v1/users/{id}               # Delete user
GET    /v1/users/{id}/transactions  # Get user's transactions
```

---

## HTTP Methods

| Method | Usage | Idempotent | Success Code |
|--------|-------|-----------|-------------|
| GET | Retrieve resource(s) | Yes | 200 OK |
| POST | Create resource | No | 201 Created |
| PUT | Full replacement | Yes | 200 OK |
| PATCH | Partial update | Yes | 200 OK |
| DELETE | Remove resource | Yes | 204 No Content |

---

## Request Conventions

### Headers

| Header | Required | Description |
|--------|----------|-------------|
| `Authorization` | Yes (protected) | Bearer token |
| `Content-Type` | Yes (body) | `application/json` |
| `Accept` | Recommended | `application/json` |
| `Accept-Language` | Optional | Response language preference |
| `X-Request-ID` | Recommended | Client-generated correlation ID |
| `X-Idempotency-Key` | For POST | Prevents duplicate operations |

### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `page` | integer | Page number (1-based) |
| `size` | integer | Items per page (default: 20, max: 100) |
| `sort` | string | Sort field and direction: `name,asc` |
| `filter` | string | Filter expression (if supported) |
| `fields` | string | Sparse fieldset: `fields=name,email` |

---

## Response Conventions

### Success Response (Single Resource)

```json
{
  "data": {
    "id": "uuid-here",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com"
    }
  }
}
```

### Success Response (Collection)

```json
{
  "data": [
    { "id": "uuid-1", "type": "user", "attributes": { ... } },
    { "id": "uuid-2", "type": "user", "attributes": { ... } }
  ],
  "meta": {
    "page": 1,
    "size": 20,
    "totalElements": 150,
    "totalPages": 8
  }
}
```

### Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "status": 422,
    "timestamp": "2026-06-12T14:30:00Z",
    "path": "/v1/users",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address",
        "rejectedValue": "not-an-email"
      }
    ]
  }
}
```

---

## HTTP Status Codes

| Code | Usage |
|------|-------|
| 200 OK | Successful GET, PUT, PATCH |
| 201 Created | Successful POST (with Location header) |
| 204 No Content | Successful DELETE |
| 400 Bad Request | Malformed request syntax |
| 401 Unauthorized | Missing or invalid authentication |
| 403 Forbidden | Authenticated but not authorized |
| 404 Not Found | Resource does not exist |
| 409 Conflict | Duplicate resource or state conflict |
| 422 Unprocessable Entity | Validation errors |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Unexpected server error |
| 503 Service Unavailable | Temporary unavailability |

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 422 | Input validation failed |
| `AUTHENTICATION_REQUIRED` | 401 | No valid credentials |
| `ACCESS_DENIED` | 403 | Insufficient permissions |
| `RESOURCE_NOT_FOUND` | 404 | Entity does not exist |
| `DUPLICATE_RESOURCE` | 409 | Unique constraint violation |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Unexpected server error |
| `SERVICE_UNAVAILABLE` | 503 | Temporary unavailability |

---

## Versioning

**Strategy**: {{API_VERSIONING_STRATEGY}}

URL-based versioning (recommended):
```
/v1/users
/v2/users
```

---

## Pagination

**Default strategy**: Offset-based pagination

```
GET /v1/users?page=2&size=20

Response includes:
{
  "data": [...],
  "meta": {
    "page": 2,
    "size": 20,
    "totalElements": 150,
    "totalPages": 8
  },
  "links": {
    "self": "/v1/users?page=2&size=20",
    "first": "/v1/users?page=1&size=20",
    "prev": "/v1/users?page=1&size=20",
    "next": "/v1/users?page=3&size=20",
    "last": "/v1/users?page=8&size=20"
  }
}
```

---

## Security

- All endpoints require authentication (except public health checks)
- Authorization checked at resource level
- Rate limiting: {{RATE_LIMIT}} requests per {{RATE_LIMIT_WINDOW}}
- CORS restricted to known origins
- Request/response logging (no PII)
- Idempotency keys for POST operations on financial endpoints

---

## Documentation

- **OpenAPI/Swagger**: Auto-generated from code annotations
- **Endpoint**: `/v1/docs` or `/swagger-ui.html`
- **Postman Collection**: Maintained in `docs/api/` directory

---

*This document is maintained by the agentic framework. Update it when API standards change.*
