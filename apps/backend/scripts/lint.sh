#!/bin/sh

# Lint script for backend
# This script runs ESLint on the backend codebase

echo "🔍 Running ESLint on backend..."
echo "=================================="

# Change to backend directory
cd "$(dirname "$0")/.."

# Run ESLint on all files
npx eslint . --ignore-pattern "dist/**" --ignore-pattern "node_modules/**"

# Check exit code
if [ $? -eq 0 ]; then
    echo "✅ ESLint passed - no issues found"
    exit 0
else
    echo "❌ ESLint failed - please fix the issues above"
    exit 1
fi
