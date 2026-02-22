#!/bin/bash
# Project Initialization Script
# Sets up the development environment for Next.js + shadcn project

set -e

echo "=== Project Initialization ==="

# Check for required tools
echo "Checking dependencies..."

if ! command -v node &> /dev/null; then
    echo "Error: Node.js is required but not installed."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "Error: npm is required but not installed."
    exit 1
fi

# Install dependencies
if [ -f "package.json" ]; then
    echo "Installing Node.js dependencies..."
    npm install
fi

# Initialize shadcn/ui if not already initialized
if [ ! -d "web/components/ui" ] && [ -f "components.json" ]; then
    echo "Initializing shadcn/ui..."
    npx shadcn@latest add button --yes
fi

# Set up git hooks
if [ -d ".husky" ]; then
    echo "Git hooks already configured."
else
    echo "Setting up git hooks..."
    npm run prepare 2>/dev/null || true
fi

# Set up environment variables
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo "Please edit .env with your actual values"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Available commands:"
echo "  npm run dev      - Start development server"
echo "  npm run build    - Production build"
echo "  npm run lint     - Run ESLint"
echo "  npm run format   - Run Prettier"
echo ""
echo "Next steps:"
echo "  1. Review features.json for the sprint plan"
echo "  2. Check progress.md for current status"
echo "  3. Start with the first pending high-priority feature"
