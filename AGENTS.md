# Agent Instructions

This file provides instructions for AI agents working on this project across multiple sessions.

## Quick Start

### First Session (Initializer)

If `features.json` does not exist or is empty, you are the **Initializer Agent**.

1. Read `agent-harness/prompts/initializer.md` for detailed instructions
2. Set up the project structure
3. Create comprehensive `features.json` with all features marked as "pending"
4. Create `init.sh` to set up the development environment
5. Initialize `progress.md` with session 0
6. Create initial git commit

### Subsequent Sessions (Coding Agent)

If `features.json` exists with features, you are the **Coding Agent**.

1. Read `agent-harness/prompts/coder.md` for detailed instructions
2. **Always** start by:
   - Running `pwd` to confirm directory
   - Reading `progress.md` to understand recent work
   - Reading `git log --oneline -10` to see recent commits
   - Running `./init.sh` to verify the environment works
3. Pick **ONE** pending high-priority feature from `features.json`
4. Implement incrementally with frequent commits
5. Test thoroughly before marking complete
6. Update `progress.md` with session summary
7. Update feature status in `features.json` if complete

## Core Files

| File | Purpose | Who Updates |
|------|---------|-------------|
| `features.json` | List of all features with status | Initializer creates, Coding Agent updates status only |
| `progress.md` | Session-by-session progress log | Every agent at end of session |
| `init.sh` | Development environment setup | Initializer creates, can be extended |
| `AGENTS.md` | This file - agent instructions | Rarely modified |

## Critical Rules

1. **One Feature Per Session** - Don't try to implement multiple features
2. **Always Leave Working Code** - Never end with broken tests or build
3. **Test End-to-End** - Verify features work as a user would experience them
4. **Commit Frequently** - Small, logical commits enable easy rollback
5. **Document Decisions** - Future agents (new context) need to understand why
6. **Don't Delete Features** - Only change status, never remove from `features.json`

## Status Values

- `pending` - Not started
- `in_progress` - Currently being worked on
- `completed` - Fully implemented and tested
- `blocked` - Cannot proceed due to dependency or issue

## Git Commit Format

```
<type>(<scope>): <description>

[optional body]

Feature: <feature-id>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

## Project-Specific Instructions

<!-- Add project-specific notes here as the project develops -->

