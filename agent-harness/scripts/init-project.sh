#!/bin/bash
# Initialize agent-harness tracking files for a project
# Usage: ./init-project.sh <project-name> ["project description"]

set -e

PROJECT_NAME="${1:-}"
PROJECT_DESCRIPTION="${2:-}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./init-project.sh <project-name> [\"project description\"]"
    echo ""
    echo "This creates features.json and progress.md for agent tracking."
    exit 1
fi

DESCRIPTION="${PROJECT_DESCRIPTION:-$PROJECT_NAME project}"

echo "=== Initializing Agent Harness ==="
echo "Project: $PROJECT_NAME"
echo ""

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
echo "Done. Next: Run Sprint Agent to define features."
