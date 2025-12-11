#!/bin/sh

# Database Population Script for Lumisovellus Backend
# This script populates the database with sample data

echo "🗄️  Populating Lumisovellus Database..."
echo "====================================="

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the backend directory"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found. Please create one first."
    exit 1
fi

# Check if Prisma schema exists
if [ ! -f "prisma/schema.prisma" ]; then
    echo "❌ Error: Prisma schema not found."
    exit 1
fi

echo "✅ Environment check passed"

# Run database migrations
echo "📦 Running database migrations..."
npm run db:migrate

# Check if migrations were successful
if [ $? -ne 0 ]; then
    echo "❌ Error: Database migrations failed"
    exit 1
fi

echo "✅ Database migrations completed"

# Run seed script
echo "🌱 Seeding database with sample data..."
npm run db:seed

# Check if seeding was successful
if [ $? -ne 0 ]; then
    echo "❌ Error: Database seeding failed"
    exit 1
fi

echo "✅ Database seeding completed"

echo ""
echo "🎉 Database population completed successfully!"
echo "====================================="
echo "Your database is now populated with sample data."
echo "You can now start your application with: npm run dev"
