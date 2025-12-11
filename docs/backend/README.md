# Original backend documentation provided by backend team in the middle of development, may not 100% reflect current state

## Backend API

### Docker Development

For running with Docker:

1. **Copy environment file:**

   ```bash
   cp .env.example .env
   ```

2. **Build and run containers:**

   ```bash
   docker-compose up --build
   ```

3. **Access the backend container:**
   ```bash
   docker-compose exec backend sh
   ```

### Local Development

#### Running the Backend

1. **Navigate to the backend directory:**

   ```bash
   cd apps/backend
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Set up the database:**

   ```bash
   # Create and copy .env file
   cp .env.example .env

   # Generate Prisma client
   npm run db:generate
   ```

4. **Run database migrations:**

   ```bash
   npm run db:migrate
   ```

5. **Seed the database with default data:**

   ```bash
   npm run db:seed
   ```

6. **Start the development server:**
   ```bash
   npm run dev
   ```

The server will start on **http://localhost:3001**

### API Documentation (Swagger)

Once the server is running, you can access the Swagger documentation at:

**http://localhost:3001/api-docs**

This interactive documentation allows you to:

- Browse all available endpoints
- Test API endpoints directly from the browser
- View request/response schemas
- See authentication requirements

### Default Users

The seed script creates the following test users:

| Email                  | Password  | Role   | Description             |
| ---------------------- | --------- | ------ | ----------------------- |
| admin@lumisovellus.fi  | admin123  | ADMIN  | Administrative access   |
| user@lumisovellus.fi   | user123   | NORMAL | Regular user account    |
| rescue@lumisovellus.fi | rescue123 | RESCUE | Rescue operator account |

You can use these credentials to authenticate and test the API endpoints.


### API Endpoints

Authentication
- POST `/auth/register`: Create a new account (email/password); returns access and refresh tokens.
- POST `/auth/login`: Authenticate with credentials; returns access and refresh tokens.
- POST `/auth/refresh-token`: Exchange a valid refresh token for fresh tokens.
- POST `/auth/reset-password`: Send password reset email if the address exists.
- POST `/auth/logout` (Auth): Invalidate the current session for the bearer token.
- GET `/auth/profile` (Auth): Return profile of the authenticated user.
- PUT `/auth/profile` (Auth): Update profile fields of the authenticated user.
- PUT `/auth/change-password` (Auth): Change password given current and new passwords.
- GET `/auth/verify-token` (Auth): Validate token; returns token status and basic user info.

Health
- GET `/health`: Liveness/status endpoint including API version and timestamp.

Users
- POST `/api/v1/users/:deviceId/location` (Auth): Upsert latest GPS coordinates for a device; used for rescue proximity and tracking.
- POST `/api/v1/users/:deviceId/battery` (Auth): Report device battery level (`low` or `normal`).
- POST `/api/v1/users/:deviceId/role` (Auth + Admin): Set a user's role; returns role and permissions.
- GET `/api/v1/users/:deviceId/role` (Auth): Get a user's role and effective permissions by deviceId.
- GET `/api/v1/users` (Auth + Admin): List all users with key fields for admin dashboards.
- GET `/api/v1/users/me` (Auth): Current user's profile snapshot and flags (e.g., `lowBattery`).
- PUT `/api/v1/users/:id` (Auth + Admin): Update user fields (name, email, role, phone) by ID.
- DELETE `/api/v1/users/:id` (Auth + Admin): Delete user account and related data by ID.

Segments & Observations
- GET `/api/v1/segments`: List segments; supports either `bbox` (OGC order `minLng,minLat,maxLng,maxLat`) or explicit `minLat|minLng|maxLat|maxLng` filters plus `search`/`updatedSince`. Each segment includes up to 3 of the latest user reviews and the most recent guide update, if available.
- GET `/api/v1/segments/:id/observations`: Combined guide update and recent user reviews for a single segment; accepts `days` (default 3) and `limit` (default 3) query parameters.
- POST `/api/v1/segments/:id/guideUpdate` (Auth + Admin): Create or replace the active guide update for a segment with up to two primary/secondary snow types.

Reviews
- GET `/api/v1/snow-types`: Enumerate allowed snow/surface types for reviews.
- GET `/api/v1/observations`: Latest observations (reviews and guide updates) across segments; supports `days` (default 3), `limit`, `page`, and `pageSize`.
- GET `/api/v1/segments/:id/observations`: Same observation payload scoped to a single segment; accepts `days`/`limit` query params.
- POST `/api/v1/segments/:id/reviews` (Auth): Create a review for a segment with rating/comments.

Help Events
- POST `/help/events` (Auth): Start a new help event (need type + location) and notify nearby users.
- GET `/help/events/nearby` (Auth): List active events within a configurable radius of the caller.
- GET `/help/events/{eventId}/view` (Auth): Context-aware view (rescuee vs. rescuer) with participants and latest status.
- POST `/help/events/{eventId}/acceptance` + DELETE `/help/events/{eventId}/acceptance` (Auth): Join or withdraw from an event as a rescuer.
- PATCH `/help/events/{eventId}` (Auth): Rescuee cancels or completes the event.
- GET `/help/events/{eventId}/stream` (Auth): Reserved for the upcoming push/streaming channel (currently returns 501).

