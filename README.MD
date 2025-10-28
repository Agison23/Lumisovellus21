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

| Email                     | Password | Role    | Description              |
|---------------------------|----------|---------|--------------------------|
| admin@lumisovellus.fi     | admin123 | ADMIN   | Administrative access     |
| user@lumisovellus.fi      | user123  | NORMAL  | Regular user account     |
| rescue@lumisovellus.fi    | rescue123| RESCUE  | Rescue operator account  |

You can use these credentials to authenticate and test the API endpoints.
