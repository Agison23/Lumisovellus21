# # North Star

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

Segments & Updates
- GET `/api/v1/segments`: List segments; supports `bbox`, `search`, and `updatedSince` filters. By default the segement coordinates of previous system would be present.
- GET `/api/v1/segments/:id/updates`: Latest updates for a given segment ID.
- GET `/api/v1/updates`: Time-window or `updatedSince` filtered segment updates; includes review details when available.

Reviews
- GET `/api/v1/snow-types`: Enumerate allowed snow/surface types for reviews.
- GET `/api/v1/reviews`: Latest reviews across segments; optional `days` (default 3).
- GET `/api/v1/reviews/all`: All reviews in a window; optional `days` (default 7).
- POST `/api/v1/segments/:id/reviews` (Auth): Create a review for a segment with rating/comments.

Help Requests
- POST `/api/v1/help-requests` (Auth): Create a help request; triggers notifications to nearby users within ~30 km and stores request metadata.
- GET `/api/v1/help-requests` (Auth): List active help requests for the rescue operator interface.
- POST `/api/v1/help-responses` (Auth): Update a helper's response state (pending/accepted/declined/completed) for a specific request.
- GET `/api/v1/help-requests/:id/helpers` (Auth): For a request, list notified helpers including distance, state, battery, and last-seen timestamps.

