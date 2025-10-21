# Swagger Documentation Setup

This document explains how to work with Swagger documentation in the Lumisovellus backend.

## Overview

The backend uses `swagger-autogen` to automatically generate OpenAPI/Swagger documentation from JSDoc comments in the code.

## Files

- `src/swagger.ts` - Swagger configuration and generation script
- `swagger-output.json` - Generated Swagger documentation (auto-generated)

## Scripts

### Generate Swagger Documentation

```bash
# Generate Swagger documentation once
npm run build:swagger

# Watch for changes and regenerate automatically
npm run swagger:watch
```

### Development with Swagger

```bash
# Run server with Swagger auto-generation
npm run dev:full

# Run server only (without Swagger watch)
npm run dev
```

## Docker Integration

When you run `docker compose up`, Swagger documentation is automatically generated and updated. The Docker setup:

1. Generates Prisma client
2. Runs database migrations
3. Seeds the database
4. Generates Swagger documentation
5. Starts the development server with Swagger watch

## API Documentation

The generated Swagger documentation includes:

- **Authentication endpoints** (`/api/v1/auth/*`)
- **Web API endpoints** (`/web-api/v1/*`)
- **Mobile API endpoints** (`/mobile-api/v1/*`)
- **Health check endpoints** (`/health`)

## Adding New Endpoints

To add new endpoints to the Swagger documentation:

1. Add JSDoc comments to your route handlers using the `@swagger` tag
2. Include request/response schemas
3. Run `npm run build:swagger` to regenerate documentation

### Example JSDoc Comment

```javascript
/**
 * @swagger
 * /web-api/v1/example:
 *   get:
 *     summary: Get example data
 *     tags: [Web API - Example]
 *     responses:
 *       200:
 *         description: Success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: string
 *                   example: "Hello World"
 */
```

## Viewing Documentation

The Swagger UI is available at:

- **Local development**: `http://localhost:3001/api-docs` (if configured)
- **Generated JSON**: `swagger-output.json`

## Configuration

The Swagger configuration is in `src/swagger.ts`. Key settings:

- **API Version**: v2.0.0
- **Title**: Lumisovellus API
- **Host**: localhost:3001
- **Schemes**: http, https
- **Security**: JWT Bearer token

## Troubleshooting

### Swagger not updating

1. Check if `swagger-output.json` exists
2. Verify all endpoint files are included in `endpointsFiles` array
3. Ensure JSDoc comments are properly formatted
4. Run `npm run build:swagger` manually

### Docker issues

1. Check if the Swagger generation step completes successfully
2. Verify the `swagger-output.json` file is copied to the container
3. Check Docker logs for any errors during build

## Notes

- The Swagger documentation is automatically updated when you run `docker compose up`
- All API endpoints are documented including the new UUID-based user system
- Web API endpoints use the `web-api` prefix for clear separation
- Mobile API endpoints use the `mobile-api` prefix as specified in the requirements
- Authentication endpoints remain under `/api/v1/auth/*` for shared access
