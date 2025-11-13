#!/bin/sh

# Format script for backend
# This script runs Prettier to format the code

echo "🎨 Running Prettier on backend..."
echo "================================="

# Change to backend directory
cd "$(dirname "$0")/.."

# Run Prettier
npx prettier --write .

# Check exit code
if [ $? -eq 0 ]; then
    echo "✅ Code formatting completed successfully"
    exit 0
else
    echo "❌ Code formatting failed"
    exit 1
fi
