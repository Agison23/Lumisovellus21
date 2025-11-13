#!/bin/sh
# This script ensures that all necessary database setup is done before starting the server.

# Exit immediately if a command exits with a non-zero status.
set -e

echo "▶️ Starting backend setup..."

# 1. Generate Prisma Client
echo " prisma generate: Ensuring Prisma Client is up to date..."
npx prisma generate

# 2. Run database migrations
echo " db:migrate: Applying any pending database migrations..."
npm run db:migrate

# 3. Run database seed script
echo " db:seed: Populating the database with initial data..."
npm run db:seed

# 4. Start the development server
echo "🚀 Starting the development server..."
exec npm run dev
