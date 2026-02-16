#!/bin/bash
# Initialize a new agent project
# Usage: ./init-project.sh "Project description" [project-type]

set -e

PROJECT_DESCRIPTION="${1:-}"
PROJECT_TYPE="${2:-generic}"

if [ -z "$PROJECT_DESCRIPTION" ]; then
    echo "Usage: ./init-project.sh \"Project description\" [project-type]"
    echo ""
    echo "Project types: generic, web-app, api, cli, mobile"
    exit 1
fi

echo "=== Initializing Agent Project ==="
echo "Description: $PROJECT_DESCRIPTION"
echo "Type: $PROJECT_TYPE"
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
    jq --arg name "New Project" \
       --arg desc "$PROJECT_DESCRIPTION" \
       --arg type "$PROJECT_TYPE" \
       --arg date "$(date -I)" \
       '.project.name = $name | 
        .project.description = $desc | 
        .project.tech_stack = [$type] |
        .project.created_at = $date |
        .metadata.last_updated = $date' \
       features.json > "$tmp" && mv "$tmp" features.json
fi

echo ""
echo "=== Project Structure Created ==="
echo ""
echo "Next steps:"
echo "  1. Read agent-harness/prompts/initializer.md"
echo "  2. Follow the initializer agent instructions"
echo "  3. Expand features.json with detailed feature breakdown"
echo "  4. Run ./init.sh to set up the development environment"
