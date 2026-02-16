#!/bin/bash
# Display current project status
# Usage: ./status.sh

echo "=== Project Status ==="
echo ""

# Check if this is an initialized project
if [ ! -f "features.json" ]; then
    echo "Project not initialized. Run init-project.sh first."
    exit 1
fi

# Show git status
echo "--- Git Status ---"
git status -s 2>/dev/null || echo "Not a git repository"
echo ""

# Show recent commits
echo "--- Recent Commits ---"
git log --oneline -5 2>/dev/null || echo "No commits yet"
echo ""

# Show feature status
echo "--- Feature Status ---"
if command -v jq &> /dev/null; then
    total=$(jq '.features | length' features.json)
    pending=$(jq '[.features[] | select(.status == "pending")] | length' features.json)
    in_progress=$(jq '[.features[] | select(.status == "in_progress")] | length' features.json)
    completed=$(jq '[.features[] | select(.status == "completed")] | length' features.json)
    
    echo "Total: $total | Pending: $pending | In Progress: $in_progress | Completed: $completed"
    echo ""
    
    echo "Next features to work on:"
    jq -r '.features[] | select(.status == "pending") | select(.priority == "high") | "  - [\(.id)] \(.description)"' features.json | head -3
else
    echo "Install 'jq' for detailed feature status"
fi

echo ""
echo "--- Last Session ---"
head -20 progress.md 2>/dev/null | grep -A 15 "## Session" | head -15
