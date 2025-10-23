# Testing Setup for Lumisovellus Backend

This document explains how to set up and run tests for the Lumisovellus backend application.

## Overview

The testing setup includes:
- **Vitest** as the test runner
- **MySQL test database** running in Docker
- **Prisma** for database operations
- **Integration tests** for API endpoints and database operations
- **Unit tests** for utility functions

## Prerequisites

- Node.js (v20.10.0 or higher)
- Docker and Docker Compose
- npm

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Test Database

```bash
# Run the automated setup script
./scripts/test-setup.sh

# Or manually:
docker compose -f docker-compose.test.yml up -d
npm run test:db:setup
```

### 3. Run Tests

```bash
# Run all tests with test database
npm run test:db

# Run tests in watch mode
npm run test:db:watch

# Run tests with Docker (automated setup/teardown)
npm run test:docker
```

## Test Scripts

| Script | Description |
|--------|-------------|
| `npm test` | Run tests without database |
| `npm run test:db` | Run tests with test database |
| `npm run test:db:watch` | Run tests in watch mode with test database |
| `npm run test:coverage` | Run tests with coverage report |
| `npm run test:migrate` | Run Prisma migrations on test database |
| `npm run test:db:setup` | Push schema to test database |
| `npm run test:docker` | Full automated test with Docker setup/teardown |

## Test Database Configuration

The test database uses the following configuration:
- **Host**: localhost:3307
- **Database**: testdb
- **Username**: root
- **Password**: testpassword

Environment variables are loaded from `.env.test` file.

## Test Structure

```
src/test/
├── setup.ts              # Global test setup
├── vitest.setup.ts       # Vitest configuration
├── unit/                 # Unit tests
│   └── utils.test.ts
└── integration/          # Integration tests
    ├── user.test.ts
    └── segment.test.ts
```

## Writing Tests

### Unit Tests

Unit tests should be placed in `src/test/unit/` and test individual functions without external dependencies.

```typescript
import { describe, it, expect } from "vitest";

describe("MyFunction", () => {
  it("should work correctly", () => {
    expect(myFunction(input)).toBe(expectedOutput);
  });
});
```

### Integration Tests

Integration tests should be placed in `src/test/integration/` and test database operations and API endpoints.

```typescript
import { describe, it, expect, beforeEach } from "vitest";
import { testPrisma } from "../vitest.setup";

describe("User Integration Tests", () => {
  beforeEach(async () => {
    await testPrisma.user.deleteMany();
  });

  it("should create a user", async () => {
    const user = await testPrisma.user.create({
      data: userData,
    });
    expect(user).toBeDefined();
  });
});
```

## Database Testing

The test setup automatically:
1. Cleans the database before each test suite
2. Provides a `testPrisma` client for database operations
3. Runs tests sequentially to avoid conflicts

## Troubleshooting

### Database Connection Issues

If you encounter database connection issues:

1. Ensure Docker is running
2. Check if the test database container is up:
   ```bash
   docker compose -f docker-compose.test.yml ps
   ```
3. Restart the test database:
   ```bash
   docker compose -f docker-compose.test.yml down
   docker compose -f docker-compose.test.yml up -d
   ```

### Test Failures

- Check that the test database is properly set up
- Ensure all required environment variables are set in `.env.test`
- Verify that Prisma schema is up to date

### Clean Up

To clean up test resources:

```bash
# Stop and remove test database
docker compose -f docker-compose.test.yml down

# Remove test database volume (optional)
docker volume rm backend_mysql_test_data
```

## Best Practices

1. **Use beforeEach/afterEach** to clean up test data
2. **Test one thing at a time** - keep tests focused
3. **Use descriptive test names** that explain what is being tested
4. **Mock external dependencies** in unit tests
5. **Use integration tests** for database operations
6. **Clean up after tests** to avoid test pollution

## Environment Variables

The following environment variables are used in testing:

- `DATABASE_URL`: Test database connection string
- `NODE_ENV`: Set to 'test'
- `PORT`: Test server port (3001)
- `JWT_SECRET`: Test JWT secret key

These are configured in the `.env.test` file.
