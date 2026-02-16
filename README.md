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

This framework implements a two-phase approach:

### Phase 1: Initializer Agent
Sets up the foundational environment:
- Project scaffolding
- Comprehensive feature list (`features.json`)
- Development setup script (`init.sh`)
- Progress tracking (`progress.md`)

### Phase 2: Coding Agents
Each session makes incremental progress:
- Reviews previous work via git logs and progress.md
- Picks ONE feature to implement
- Tests thoroughly end-to-end
- Leaves clean, working code
- Documents progress for next session

## Quick Start

```bash
# 1. Initialize a new project
./agent-harness/scripts/init-project.sh "Your project description" web-app

# 2. Point your AI agent to AGENTS.md
# The agent will read the instructions and begin work

# 3. Check status anytime
./agent-harness/scripts/status.sh
```

## Framework Structure

```
.
├── AGENTS.md              # Main instructions for AI agents
├── features.json          # Comprehensive feature list with status
├── progress.md            # Session-by-session progress log
├── init.sh                # Development environment setup
│
└── agent-harness/
    ├── prompts/
    │   ├── initializer.md # Prompt for first session
    │   └── coder.md       # Prompt for subsequent sessions
    ├── templates/
    │   ├── features.json  # Template for feature list
    │   ├── progress.md    # Template for progress log
    │   └── init.sh        # Template for setup script
    └── scripts/
        ├── init-project.sh # Initialize a new project
        └── status.sh       # Show current project status
```

## Key Principles

1. **Incremental Progress** - One feature per session
2. **Always Working Code** - Never leave broken state
3. **End-to-End Testing** - Verify as a user would
4. **Frequent Commits** - Enable easy rollback
5. **Documentation** - Future sessions need context

## Feature Status Lifecycle

```
pending → in_progress → completed
                ↓
             blocked (if dependency issue)
```

## Using with AI Agents

When starting a new session, simply point your AI agent to:

```
Please read AGENTS.md and follow the instructions for the appropriate agent role.
```

The agent will:
1. Determine if it's an Initializer or Coding Agent
2. Follow the appropriate protocol
3. Make incremental, tested progress
4. Document everything for the next session

## References

- [Anthropic's Original Article](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Claude Agent SDK Quickstart](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)

## License

MIT
