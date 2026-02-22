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

# Show sprint and feature status
echo "--- Sprint Status ---"
if command -v jq &> /dev/null; then
    # Count sprints
    sprint_count=$(jq '.sprints | length' features.json)
    echo "Total Sprints: $sprint_count"
    
    if [ "$sprint_count" -gt 0 ]; then
        # Show sprint summary
        jq -r '.sprints[] | "  [\(.id)] \(.name) - \(.status)"' features.json
        echo ""
        
        # Count features across all sprints
        total=$(jq '[.sprints[].features] | add | length' features.json 2>/dev/null || echo "0")
        if [ "$total" != "0" ] && [ "$total" != "null" ]; then
            pending=$(jq '[.sprints[].features[] | select(.status == "pending")] | length' features.json 2>/dev/null || echo "0")
            in_progress=$(jq '[.sprints[].features[] | select(.status == "in_progress")] | length' features.json 2>/dev/null || echo "0")
            completed=$(jq '[.sprints[].features[] | select(.status == "completed")] | length' features.json 2>/dev/null || echo "0")
            
            echo "Features: Total=$total | Pending=$pending | In Progress=$in_progress | Completed=$completed"
            echo ""
            
            echo "Next features to work on:"
            jq -r '.sprints[] | select(.status == "in_progress") | .features[] | select(.status == "pending") | select(.priority == "high") | "  - [\(.id)] \(.title)"' features.json 2>/dev/null | head -3
        fi
    else
        echo "No sprints defined yet."
        echo "Run Sprint Agent to create feature list."
    fi
else
    echo "Install 'jq' for detailed status information"
fi

echo ""
echo "--- Last Session ---"
head -20 progress.md 2>/dev/null | grep -A 15 "## Session\|## Sprint" | head -15
