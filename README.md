# Forever

> A framework for long-running AI agents that work effectively across multiple context windows.

Based on [Anthropic's research](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) on effective agent harnesses.

## The Problem

AI agents struggle with complex, long-running tasks because:
1. Each new session starts with no memory of previous work
2. Agents tend to do too much at once, running out of context mid-implementation
3. Agents may declare "done" prematurely without proper verification
4. Code can be left in broken states between sessions

## The Solution

Three specialized agents working together:

### Initializer Agent (Project Scaffolding)
Sets up the foundational environment (one-time):
- Next.js 16 + shadcn/ui project scaffolding
- i18n (next-intl) with en/zh support
- Dark/Light theme (next-themes)
- Cloudflare Pages deployment config
- Code quality tools (ESLint, Prettier, Commitlint, lint-staged, Husky)

### Sprint Agent (Feature Planning)
Translates requirements into actionable features:
- Analyzes user requirements
- Breaks down into atomic, session-sized features
- Creates sprint in `features.json` with acceptance criteria
- Defines implementation order and dependencies

### Coding Agent (Feature Implementation)
Each session makes incremental progress:
- Reviews previous work via git logs and `progress.md`
- Picks ONE feature to implement
- Tests thoroughly end-to-end
- Leaves clean, working code
- Documents progress for next session

## Workflow

```
┌─────────────────┐
│  Initializer    │  ──>  Project scaffolding (one-time)
└────────┬────────┘
         │
         v
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

```bash
# 1. Initialize tracking files
./agent-harness/scripts/init-project.sh "Your project description" "Project Name"

# 2. Point your AI agent to AGENTS.md
# The agent will read instructions and begin scaffolding

# 3. After scaffolding, run Sprint Agent with your requirements
# Example: "Add user authentication with email and social login"

# 4. Check status anytime
./agent-harness/scripts/status.sh
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Next.js 16 (App Router, SSR) |
| UI | shadcn/ui + Tailwind CSS |
| i18n | next-intl (en/zh) |
| Theme | next-themes (dark/light) |
| Deployment | Cloudflare Pages |
| Code Quality | ESLint, Prettier, Commitlint, lint-staged, Husky |

## Framework Structure

```
.
├── AGENTS.md              # Main instructions for AI agents
├── features.json          # Sprints and features with status
├── progress.md            # Session-by-session progress log
├── init.sh                # Development environment setup
│
└── agent-harness/
    ├── prompts/
    │   ├── initializer.md # Initializer Agent prompt (scaffolding)
    │   ├── sprint.md      # Sprint Agent prompt (planning)
    │   └── coder.md       # Coding Agent prompt (implementation)
    ├── templates/
    │   ├── features.json  # Template for feature tracking
    │   ├── progress.md    # Template for progress log
    │   └── init.sh        # Template for setup script
    └── scripts/
        ├── init-project.sh # Initialize tracking files
        └── status.sh       # Show current project status
```

## Key Principles

1. **One Feature Per Session** - Don't try to do too much
2. **Always Working Code** - Never leave broken state
3. **End-to-End Testing** - Verify as a user would
4. **Frequent Commits** - Enable easy rollback
5. **Documentation** - Future sessions need context
6. **Use Translations** - All user-facing text via i18n
7. **Theme Aware** - Test both dark and light modes

## Feature Status Lifecycle

```
pending → in_progress → completed
                ↓
             blocked (if dependency issue)
```

## Sprint Status Values

- `planning` - Being defined by Sprint Agent
- `in_progress` - Features being implemented
- `completed` - All features done
- `on_hold` - Paused for some reason

## Using with AI Agents

When starting a new session:

```
Please read AGENTS.md and follow the instructions.
```

The agent will:
1. Determine the appropriate role (Initializer/Sprint/Coding)
2. Follow the protocol for that role
3. Make incremental, tested progress
4. Document everything for the next session

## Commands

```bash
npm run dev      # Start development server
npm run build    # Production build
npm run lint     # Run ESLint
npm run format   # Run Prettier
```

## Git Commit Format

```
<type>(<scope>): <description>

Feature: <feature-id>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`

## References

- [Anthropic's Original Article](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Claude Agent SDK Quickstart](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)

## License

MIT
