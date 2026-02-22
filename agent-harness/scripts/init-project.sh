#!/bin/bash
# Initialize a new agent project
# Usage: ./init-project.sh <project-name> ["project description"]

set -e

PROJECT_NAME="${1:-}"
PROJECT_DESCRIPTION="${2:-}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./init-project.sh <project-name> [\"project description\"]"
    echo ""
    echo "This creates the initial project tracking files."
    echo "Then read agent-harness/prompts/initializer.md for scaffolding instructions."
    exit 1
fi

DESCRIPTION="${PROJECT_DESCRIPTION:-$PROJECT_NAME project}"

echo "=== Initializing Agent Project ==="
echo "Name: $PROJECT_NAME"
echo "Description: $DESCRIPTION"
echo ""

# Copy templates
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"

if [ ! -f "features.json" ]; then
    echo "Creating features.json..."
    cp "$TEMPLATES_DIR/features.json" .
fi

if [ ! -f "progress.md" ]; then
    echo "Creating progress.md..."
    cp "$TEMPLATES_DIR/progress.md" .
fi

if [ ! -f "init.sh" ]; then
    echo "Creating init.sh..."
    cp "$TEMPLATES_DIR/init.sh" .
    chmod +x init.sh
fi

# Update features.json with project info
if command -v jq &> /dev/null; then
    tmp=$(mktemp)
    jq --arg name "$PROJECT_NAME" \
       --arg desc "$DESCRIPTION" \
       --arg date "$(date -I)" \
       '.project.name = $name | 
        .project.description = $desc |
        .project.created_at = $date |
        .metadata.last_updated = $date' \
       features.json > "$tmp" && mv "$tmp" features.json
fi

echo ""
echo "=== Project Tracking Files Created ==="
echo ""
echo "Next steps:"
echo "  1. Read agent-harness/prompts/initializer.md"
echo "  2. Follow the Initializer Agent instructions"
echo "  3. Create Next.js project scaffolding"
echo "  4. Run Sprint Agent to define features"
