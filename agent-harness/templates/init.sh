#!/bin/bash
# Project Initialization Script
# Sets up the development environment for Next.js + shadcn project

set -e

echo "=== Project Initialization ==="

# Detect package manager from features.json or use pnpm as default
if [ -f "features.json" ] && command -v jq &> /dev/null; then
    PM=$(jq -r '.project.package_manager // "pnpm"' features.json)
else
    PM="${PACKAGE_MANAGER:-pnpm}"
fi

echo "Using package manager: $PM"

# Check for required tools
echo "Checking dependencies..."

if ! command -v node &> /dev/null; then
    echo "Error: Node.js is required but not installed."
    exit 1
fi

if ! command -v "$PM" &> /dev/null; then
    echo "Error: $PM is required but not installed."
    exit 1
fi

# Install dependencies
if [ -f "package.json" ]; then
    echo "Installing Node.js dependencies..."
    case "$PM" in
        pnpm) pnpm install ;;
        npm) npm install ;;
        yarn) yarn install ;;
    esac
fi

# Initialize shadcn/ui if not already initialized
if [ ! -d "web/components/ui" ] && [ -f "components.json" ]; then
    echo "Initializing shadcn/ui..."
    case "$PM" in
        pnpm) pnpm dlx shadcn@latest add button --yes ;;
        npm) npx shadcn@latest add button --yes ;;
        yarn) yarn dlx shadcn@latest add button --yes ;;
    esac
fi

# Set up git hooks
if [ -d ".husky" ]; then
    echo "Git hooks already configured."
else
    echo "Setting up git hooks..."
    case "$PM" in
        pnpm) pnpm run prepare 2>/dev/null || true ;;
        npm) npm run prepare 2>/dev/null || true ;;
        yarn) yarn run prepare 2>/dev/null || true ;;
    esac
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
case "$PM" in
    pnpm)
        echo "  pnpm dev      - Start development server"
        echo "  pnpm build    - Production build"
        echo "  pnpm lint     - Run ESLint"
        echo "  pnpm format   - Run Prettier"
        ;;
    npm)
        echo "  npm run dev      - Start development server"
        echo "  npm run build    - Production build"
        echo "  npm run lint     - Run ESLint"
        echo "  npm run format   - Run Prettier"
        ;;
    yarn)
        echo "  yarn dev      - Start development server"
        echo "  yarn build    - Production build"
        echo "  yarn lint     - Run ESLint"
        echo "  yarn format   - Run Prettier"
        ;;
esac
echo ""
echo "Next steps:"
echo "  1. Review features.json for the sprint plan"
echo "  2. Check progress.md for current status"
echo "  3. Start with the first pending high-priority feature"
