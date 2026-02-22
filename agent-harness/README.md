# Agent Harness

> A framework for long-running AI agents that work effectively across multiple context windows.

Based on [Anthropic's research](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) on effective agent harnesses.

## The Problem

AI agents struggle with complex, long-running tasks because:
1. Each new session starts with no memory of previous work
2. Agents tend to do too much at once, running out of context mid-implementation
3. Agents may declare "done" prematurely without proper verification
4. Code can be left in broken states between sessions

## The Solution

Two specialized agents working together:

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
# 1. Copy agent-harness to your project
cp -r agent-harness /path/to/your-project/

# 2. Initialize tracking files
./agent-harness/scripts/init-project.sh "Project Name" "Optional description"

# 3. Point your AI agent to AGENTS.md
# The agent will read instructions and begin working

# 4. Run Sprint Agent with your requirements
# Example: "Add user authentication with email and social login"

# 5. Check status anytime
./agent-harness/scripts/status.sh
```

## Framework Structure

```
agent-harness/
├── README.md              # This file - framework documentation
├── prompts/
│   ├── sprint.md          # Sprint Agent prompt (planning)
│   └── coder.md           # Coding Agent prompt (implementation)
├── templates/
│   ├── features.json      # Template for feature tracking
│   └── progress.md        # Template for progress log
└── scripts/
    ├── init-project.sh    # Initialize tracking files
    └── status.sh          # Show current project status
```

## Generated Project Files

After initialization, these files are created in your project root:

```
├── AGENTS.md              # Main instructions for AI agents
├── features.json          # Sprints and features with status
└── progress.md            # Session-by-session progress log
```

## Configuration

The framework is configured via `features.json` and `AGENTS.md` in your project root:

**features.json:**
- **tech_stack**: Array of technologies used

**AGENTS.md:**
- **Tech Stack**: Define your preferred technologies
- **Commands**: Customize build/dev/test commands
- **Project-Specific Instructions**: Add domain-specific notes

## Key Principles

1. **One Feature Per Session** - Don't try to do too much
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
1. Determine the appropriate role (Sprint/Coding)
2. Follow the protocol for that role
3. Make incremental, tested progress
4. Document everything for the next session

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
