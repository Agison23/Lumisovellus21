#!/bin/bash

# Test Database Setup Script for Lumisovellus Backend

echo "🚀 Setting up test environment for Lumisovellus Backend..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Start the test database
echo "📦 Starting test database container..."
docker compose -f docker-compose.test.yml up -d

# Wait for the database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Check if the database is accessible
echo "🔍 Checking database connection..."
until docker exec lumisovellus-testdb mysqladmin ping -h localhost --silent; do
    echo "Waiting for database..."
    sleep 2
done

echo "✅ Database is ready!"

# Setup the database schema
echo "🗄️ Setting up database schema..."
npm run test:db:setup

echo "🎉 Test environment setup complete!"
echo ""
echo "You can now run:"
echo "  npm run test:db        # Run tests with test database"
echo "  npm run test:db:watch  # Run tests in watch mode"
echo "  npm run test:docker    # Run full test suite with Docker"
echo ""
echo "To clean up the test environment:"
echo "  docker compose -f docker-compose.test.yml down"
