# Agent Instructions

This file provides instructions for AI agents working on this project across multiple sessions.

## Project Overview

This is the **agent-harness** framework - a system for long-running AI agents that work effectively across multiple context windows. Based on [Anthropic's research](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).

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

## Commands

```bash
# Framework Scripts
./agent-harness/scripts/init-project.sh <name> "[description]"  # Initialize tracking files
./agent-harness/scripts/status.sh                               # Show project status

# Project Commands (after initialization)
pnpm dev       # Start development server
pnpm build     # Production build
pnpm lint      # Run ESLint
pnpm format    # Run Prettier

# Git Workflow
git log --oneline -10     # Review recent commits
git status                # Check working tree
```

## Tech Stack

- **Framework**: Next.js 16 (App Router, SSR)
- **UI**: React 19 + TypeScript + Tailwind CSS + shadcn/ui
- **i18n**: next-intl (en/zh)
- **Theme**: next-themes (dark/light)
- **Deployment**: Cloudflare Pages
- **Code Quality**: ESLint, Prettier, Commitlint, lint-staged, Husky

## Code Style Guidelines

### Formatting (Prettier)
```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

### Imports
- Use `@/*` alias for imports (e.g., `@/components/ui/button`)
- Group imports: React → External → Internal → Types
- Use named imports for React: `import { useState, useEffect } from 'react'`

### TypeScript
- Strict mode enabled - no `any` without justification
- Use explicit return types for functions
- Prefer interfaces for object types, types for unions
- Use `const` assertions for literal types

### Naming Conventions
- Components: PascalCase (`ThemeToggle.tsx`)
- Utilities/Hooks: camelCase (`useTheme.ts`, `utils.ts`)
- Files: camelCase for utilities, PascalCase for components
- CSS classes: Use Tailwind, follow utility-first approach

### Components
- Use `'use client'` directive for client components
- Prefer Server Components by default
- Use shadcn/ui components when available
- Extract reusable logic into custom hooks

### Internationalization
- All user-facing text must use `next-intl`
- Store translations in `messages/en.json` and `messages/zh.json`
- Use translation keys: `t('namespace.key')`

### Error Handling
- Use `try/catch` for async operations
- Log errors with context
- Provide user-friendly error messages via i18n
- Never expose internal errors to users

## Git Commit Format

```
<type>(<scope>): <description>

[optional body]

Feature: <feature-id>
```

**Types**: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`

## Status Values

| Feature Status | Description | Sprint Status | Description |
|----------------|-------------|---------------|-------------|
| `pending` | Not started | `planning` | Being defined by Sprint Agent |
| `in_progress` | Currently being worked on | `in_progress` | Features being implemented |
| `completed` | Fully implemented and tested | `completed` | All features done |
| `blocked` | Cannot proceed due to dependency | `on_hold` | Paused for some reason |

## Core Files

| File | Purpose | Who Updates |
|------|---------|-------------|
| `features.json` | Sprints and feature list with status | Sprint creates, Coding updates status |
| `progress.md` | Session-by-session progress log | Every agent at end of session |
| `AGENTS.md` | This file - agent instructions | Rarely modified |

## Session Protocol

### Start of Session
1. `pwd` to confirm directory
2. Read `progress.md` for recent work
3. `git log --oneline -10` for commit history
4. `pnpm lint && pnpm build` to verify state

### During Work
- Pick **ONE** pending feature
- Make frequent, logical commits
- Test thoroughly before marking complete

### End of Session
- Update `progress.md` with summary
- Update `features.json` if feature complete
- Ensure no lint/build errors

## Critical Rules

1. **One Feature Per Session** - Don't implement multiple features
2. **Always Leave Working Code** - Never end with broken tests or build
3. **Test End-to-End** - Verify as a user would experience
4. **Commit Frequently** - Small commits enable rollback
5. **Document Decisions** - Future agents need context
6. **Don't Delete Features** - Only change status in `features.json`
7. **Use Translations** - All user-facing text via i18n
8. **Theme Aware** - All UI must work in dark and light modes
