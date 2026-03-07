# Doc Templates

Example templates for common docs/ files. Adapt to the specific project — these are starting points, not rigid formats.

## docs/architecture.md

```markdown
# Architecture

## Overview
[Project name] is a [type] application with [N] main domains:
- **[Domain 1]** — [purpose]. Entry point: `src/domain1/`
- **[Domain 2]** — [purpose]. Entry point: `src/domain2/`

## Data Flow
[Brief description of how data moves through the system.]

## Key Decisions
- **[Decision]**: [What we chose] because [why]. See `src/[relevant file]`.
- **[Decision]**: [What we chose] because [why].

## Module Dependencies
[Which modules depend on which. Direction of data flow.]

## Boundaries
- Do not create circular dependencies between [X] and [Y]
- Do not bypass [service layer] for direct database access
```

## docs/testing.md

```markdown
# Testing

## Running Tests
- All tests: `[command]`
- Single file: `[command] path/to/test`
- With coverage: `[command]`

## Organization
- Unit tests: `tests/unit/` — mirror `src/` structure
- Integration tests: `tests/integration/` — test service boundaries
- E2E tests: `tests/e2e/` — full user flows

## Patterns
- Use [factory/fixture pattern] for test data. See `tests/factories/`.
- Mock external services using [approach]. See `tests/mocks/`.
- Database tests use [transaction rollback / test database].

## What to Test
- All public API endpoints need integration tests
- Business logic in [domain] needs unit tests
- Don't test framework internals or simple getters/setters
```

## docs/conventions.md

```markdown
# Code Conventions

## Naming
- Files: [kebab-case / camelCase / PascalCase]
- Functions: [pattern]
- Components: [pattern]
- Database tables: [pattern]

## Patterns
- Error handling: [approach]. See `src/lib/errors.ts` for base classes.
- Logging: Use [logger], not console.log. See `src/lib/logger.ts`.
- Validation: [approach]. See `src/lib/validation.ts`.

## File Organization
- One [component/class/module] per file
- Co-locate tests with source: `foo.ts` → `foo.test.ts`
- Shared utilities go in `src/lib/`
```

## docs/database.md

```markdown
# Database

## Schema Overview
[Brief description of main tables/collections and relationships.]

## Migrations
- Create: `[migration create command]`
- Run: `[migration run command]`
- Never edit existing migrations — create new ones.

## Query Patterns
- Use [ORM/query builder] for all queries. See `src/db/` for repository layer.
- Avoid raw SQL except in [specific cases].
- Always use transactions for multi-table writes.

## Gotchas
- [Table X] has a soft-delete column — always filter by `deleted_at IS NULL`
- [Index Y] doesn't cover [this query pattern] — add `.limit()` to avoid full scans
```

## docs/deployment.md

```markdown
# Deployment

## Environments
- Development: [URL/details]
- Staging: [URL/details]
- Production: [URL/details]

## Deploy Process
- [Step-by-step deploy commands or CI/CD trigger]

## Environment Variables
- Required: [list critical env vars and what they do]
- See `.env.example` for full list

## Rollback
- [How to rollback a deploy]
```

## docs/api-patterns.md

```markdown
# API Patterns

## Authentication
[Auth mechanism: JWT, session, API key]. See `src/auth/` for implementation.

## Request/Response Format
- All responses follow: `{ data: T, error?: string }`
- Pagination: `?page=1&limit=20`, response includes `{ total, page, limit }`

## Error Handling
- 400: Validation errors — return field-level details
- 401: Unauthorized — token missing or expired
- 403: Forbidden — valid token but insufficient permissions
- 404: Resource not found
- 500: Unexpected — log full error, return generic message

## Versioning
[How API versions are handled, if applicable]
```
