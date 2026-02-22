# Agent Instructions

This file provides instructions for AI agents working on this project across multiple sessions.

## Agent Types

| Agent | Role | When Invoked |
|-------|------|--------------|
| **Sprint** | Feature planning | New sprint or requirement iteration |
| **Coding** | Feature implementation | Each development session |

## Workflow

```
┌─────────────────┐
│   Sprint Agent  │  <──  User provides requirements
└────────┬────────┘
         │         Generates feature list
         v
┌─────────────────┐
│  Coding Agent   │  <──  Implements one feature per session
└────────┬────────┘
         │
         │         Loop until sprint complete
         v
┌─────────────────┐
│   Sprint Agent  │  <──  Next iteration
└─────────────────┘
```

## Quick Start

### 1. Sprint Planning (Sprint Agent)

When user provides new requirements:

1. Read `agent-harness/prompts/sprint.md`
2. Analyze user requirements
3. Break down into atomic features
4. Add sprint to `features.json` with all features
5. Update `progress.md` with sprint planning notes

### 2. Development (Coding Agent)

Each development session:

1. Read `agent-harness/prompts/coder.md`
2. **Always** start by:
   - Running `pwd` to confirm directory
   - Reading `progress.md` to understand recent work
   - Reading `git log --oneline -10`
   - Running `pnpm lint && pnpm build`
3. Pick **ONE** pending feature from current sprint
4. Implement incrementally with frequent commits
5. Test thoroughly before marking complete
6. Update `progress.md` with session summary
7. Update feature status in `features.json` if complete

## Core Files

| File | Purpose | Who Updates |
|------|---------|-------------|
| `features.json` | Sprints and feature list with status | Sprint creates, Coding updates status |
| `progress.md` | Session-by-session progress log | Every agent at end of session |
| `AGENTS.md` | This file - agent instructions | Rarely modified |

## Tech Stack

- **Framework**: Next.js 16 (App Router, SSR)
- **UI**: shadcn/ui + Tailwind CSS
- **i18n**: next-intl (en/zh)
- **Theme**: next-themes (dark/light)
- **Deployment**: Cloudflare Pages
- **Code Quality**: ESLint, Prettier, Commitlint, lint-staged, Husky

## Feature Status Values

- `pending` - Not started
- `in_progress` - Currently being worked on
- `completed` - Fully implemented and tested
- `blocked` - Cannot proceed due to dependency or issue

## Sprint Status Values

- `planning` - Being defined by Sprint Agent
- `in_progress` - Features being implemented
- `completed` - All features done
- `on_hold` - Paused for some reason

## Git Commit Format

```
<type>(<scope>): <description>

[optional body]

Feature: <feature-id>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`

## Critical Rules

1. **One Feature Per Session** - Don't try to implement multiple features
2. **Always Leave Working Code** - Never end with broken tests or build
3. **Test End-to-End** - Verify features work as a user would experience them
4. **Commit Frequently** - Small, logical commits enable easy rollback
5. **Document Decisions** - Future agents (new context) need to understand why
6. **Don't Delete Features** - Only change status, never remove from `features.json`
7. **Use Translations** - All user-facing text must go through i18n
8. **Theme Aware** - All UI must work in both dark and light modes

## Commands

```bash
pnpm dev      # Start development server
pnpm build    # Production build
pnpm lint     # Run ESLint
pnpm format   # Run Prettier
```

## Project-Specific Instructions

<!-- Add project-specific notes here as the project develops -->
