# Authentication System

This document explains how to use the authentication system that has been added to the Lumisovellus backend.

## Environment Setup

Create a `.env` file in the backend directory with the following variables:

```env
# Database
DATABASE_URL="mysql://root:password@localhost:3306/lumisovellus"

# Server Configuration
PORT=3001
NODE_ENV=development

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d
JWT_REFRESH_EXPIRES_IN=30d

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# Password Hashing
BCRYPT_ROUNDS=12
```

## Authentication Endpoints

### Public Endpoints (No Authentication Required)

#### Register User
- **POST** `/api/v1/auth/register`
- **Body:**
  ```json
  {
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "password": "password123",
    "role": "NORMAL" // Optional: NORMAL, PREMIUM, ADMIN, RESCUE
  }
  ```

#### Login
- **POST** `/api/v1/auth/login`
- **Body:**
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```

#### Refresh Token
- **POST** `/api/v1/auth/refresh-token`
- **Body:**
  ```json
  {
    "refreshToken": "your-refresh-token"
  }
  ```

#### Reset Password
- **POST** `/api/v1/auth/reset-password`
- **Body:**
  ```json
  {
    "email": "john@example.com"
  }
  ```

### Protected Endpoints (Authentication Required)

All protected endpoints require the `Authorization` header:
```
Authorization: Bearer <access-token>
```

#### Logout
- **POST** `/api/v1/auth/logout`

#### Get Profile
- **GET** `/api/v1/auth/profile`

#### Update Profile
- **PUT** `/api/v1/auth/profile`
- **Body:**
  ```json
  {
    "firstName": "John",
    "lastName": "Smith",
    "email": "johnsmith@example.com",
    "phoneNumber": "+1234567890"
  }
  ```

#### Change Password
- **PUT** `/api/v1/auth/change-password`
- **Body:**
  ```json
  {
    "currentPassword": "oldpassword",
    "newPassword": "newpassword123"
  }
  ```

#### Verify Token
- **GET** `/api/v1/auth/verify-token`

## Protected Routes

The following existing routes now require authentication:

### User Routes
- `POST /api/v1/users/:deviceId/location` - Update user location
- `POST /api/v1/users/:deviceId/battery` - Update battery status
- `GET /api/v1/users/:deviceId/role` - Get user role
- `POST /api/v1/users/:deviceId/role` - Update user role (Admin only)

### Help Routes
- `POST /api/v1/help-requests` - Create help request
- `GET /api/v1/help-requests` - Get help requests (Admin/Rescue only)
- `POST /api/v1/help-responses` - Update help response

## User Roles

- **NORMAL**: Regular users
- **PREMIUM**: Premium users
- **ADMIN**: Administrative users
- **RESCUE**: Rescue team members

## Authentication Middleware

The system includes several middleware functions:

- `authenticateToken`: Verifies JWT token and adds user to request
- `requireRole(roles)`: Ensures user has one of the specified roles
- `requireAdmin`: Ensures user is an admin
- `optionalAuth`: Optionally authenticates if token is provided

## Error Responses

All endpoints return standardized error responses:

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Access token required",
    "details": null
  },
  "meta": {
    "timestamp": "2024-01-01T00:00:00.000Z"
  }
}
```

## Security Features

- Password hashing with bcrypt
- JWT tokens with configurable expiration
- Role-based access control
- Input validation with Zod
- Rate limiting
- CORS protection
- Helmet security headers

## Usage Example

1. Register a new user:
   ```bash
   curl -X POST http://localhost:3001/api/v1/auth/register \
     -H "Content-Type: application/json" \
     -d '{"firstName":"John","email":"john@example.com","password":"password123"}'
   ```

2. Login to get tokens:
   ```bash
   curl -X POST http://localhost:3001/api/v1/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"john@example.com","password":"password123"}'
   ```

3. Use the access token for protected routes:
   ```bash
   curl -X GET http://localhost:3001/api/v1/auth/profile \
     -H "Authorization: Bearer <access-token>"
   ```
