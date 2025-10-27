# Manual Swagger Documentation

This document explains the manual Swagger documentation setup for the Lumisovellus API.

## Overview

The API now uses a **manually created** Swagger specification file instead of auto-generation. This provides better control over the documentation and ensures all endpoints are properly documented.

## Files

- `src/swagger-output.json` - Manual Swagger 2.0 specification with all API endpoints
- `src/swagger.ts` - Configuration file (auto-generation disabled)
- `dist/swagger-output.json` - Production build copy (auto-copied during build)

## What's Documented

The manual Swagger documentation includes complete documentation for:

### 1. Health Endpoints

- `GET /health` - Health check endpoint

### 2. Authentication Endpoints

- `POST /auth/register` - Register a new user
- `POST /auth/login` - Login user
- `POST /auth/refresh-token` - Refresh access token
- `POST /auth/reset-password` - Request password reset
- `POST /auth/logout` - Logout user
- `GET /auth/profile` - Get user profile
- `PUT /auth/profile` - Update user profile
- `PUT /auth/change-password` - Change user password
- `GET /auth/verify-token` - Verify token validity

### 3. Segments Endpoints

- `GET /api/v1/segments` - Get all segments
- `GET /api/v1/segments/{id}/updates` - Get latest updates for a segment
- `GET /api/v1/updates` - Get latest updates for all segments

### 4. Reviews Endpoints

- `GET /api/v1/snow-types` - Get all snow types
- `GET /api/v1/reviews` - Get latest reviews for all segments
- `GET /api/v1/reviews/all` - Get all reviews from last week
- `POST /api/v1/segments/{id}/reviews` - Create a review for a segment

### 5. Users/Mobile Endpoints

- `POST /api/v1/users/{deviceId}/location` - Update mobile user location
- `POST /api/v1/users/{deviceId}/battery` - Update battery status
- `GET /api/v1/users/{deviceId}/role` - Get user role
- `POST /api/v1/users/{deviceId}/role` - Update user role (Admin only)

### 6. Help Requests Endpoints

- `POST /api/v1/help-requests` - Create help request
- `GET /api/v1/help-requests` - Get help requests (Admin/Rescue only)
- `POST /api/v1/help-responses` - Update help response
- `GET /api/v1/help-requests/{id}/helpers` - Get users who can help

## Configuration

### Auto-Generation Disabled

Auto-generation has been disabled in `src/swagger.ts`. If you need to re-enable it, uncomment the following lines:

```typescript
// const swaggerAutogenInstance = swaggerAutogen();
// swaggerAutogenInstance(outputFile, endpointsFiles, doc);
```

### Build Process

The build process now automatically copies the Swagger file to the dist folder:

```json
"build": "tsc -p tsconfig.json && npm run build:swagger:copy",
"build:swagger:copy": "cp src/swagger-output.json dist/swagger-output.json || echo 'Swagger file copied'"
```

### Server Configuration

The server looks for the Swagger file in both `src/` (development) and `dist/` (production) directories:

```typescript
// Try src first (for development)
let swaggerPath = path.join(process.cwd(), 'src', 'swagger-output.json');
if (!fs.existsSync(swaggerPath)) {
  // Try dist (for production build)
  swaggerPath = path.join(process.cwd(), 'dist', 'swagger-output.json');
}
```

## Viewing Documentation

### Development

Start the development server:

```bash
npm run dev
```

Access the Swagger UI at:

- **http://localhost:3001/api-docs**

Access the JSON spec at:

- **http://localhost:3001/api-docs.json**

### Production

Build and start the production server:

```bash
npm run build
npm start
```

Access the documentation at:

- **http://localhost:3001/api-docs**

## Adding or Updating Endpoints

To add or update documentation for an endpoint:

1. Open `src/swagger-output.json`
2. Find the endpoint in the `paths` section
3. Update the documentation with:
   - Complete summary and description
   - Request parameters (path, query, body)
   - Response schemas
   - Authentication requirements
   - Example values

## Schema Definitions

All schema definitions are in the `definitions` section of `swagger-output.json`:

- `Error` - Standard error response
- `RegisterRequest` - User registration
- `LoginRequest` - User login
- `AuthResponse` - Authentication response
- `User` - User profile
- `Segment` - Ski segment
- `ReviewRequest` - Review submission
- `LocationUpdate` - Mobile user location
- `HelpRequest` - Help request
- `SuccessResponse` - Standard success response
- And more...

## Security

All protected endpoints require Bearer authentication:

```json
"security": [
  {
    "BearerAuth": []
  }
]
```

The JWT token should be included in the Authorization header:

```
Authorization: Bearer <your-token>
```

## Benefits of Manual Documentation

1. **Complete Control** - All documentation is manually crafted and reviewed
2. **Consistency** - Consistent formatting and examples across all endpoints
3. **Accuracy** - No auto-generation bugs or incomplete documentation
4. **Maintainability** - Easy to update and modify specific endpoints
5. **Quality** - Well-documented with proper examples and descriptions

## Troubleshooting

### Swagger UI not loading

1. Check that `src/swagger-output.json` exists
2. Verify the JSON file is valid
3. Check server logs for any errors

### Documentation not updating

1. Ensure the file is saved in the correct location
2. Restart the development server
3. Clear browser cache if needed

### Build issues

If the build fails:

```bash
npm run build:swagger:copy
```

## Notes

- The manual documentation uses Swagger 2.0 format
- All endpoints are documented with examples
- Schema definitions are reusable across endpoints
- The documentation is suitable for both developers and API consumers
