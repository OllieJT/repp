# repp CLI Specification

## Overview

Bash CLI for querying Repo Plans plan and task data. Uses GUM for interactive selection when arguments are omitted.

## Commands

```
repp <resource> <action> [args] [flags]
```

### Plans
```bash
repp plan list [--status=X] [--min-priority=X]
repp plan get [plan-id]     # Interactive if no ID
```

### Tasks
```bash
repp task list [plan-id] [--status=X] [--min-priority=X]  # Interactive plan select if no ID
repp task get [task-id]           # Interactive if no ID
```

### Task Specs
```bash
repp task-spec get [task-id]      # Interactive if no ID
```

### Utilities
```bash
repp is-blocked <task-id>         # Exit 0=blocked, 1=not blocked
```

## Configuration

Config file lookup order (first found wins):
1. `.repprc` in current directory
2. `.repprc` in git root (if in a repo)
3. `~/.config/repp/config`

Format:
```bash
REPP_ROOT="plans"
```

Default: `REPP_ROOT="plans"` relative to config file location.

## Interactive Mode

When required IDs are omitted, GUM prompts for selection:
- `gum filter` for searching/selecting from lists
- Automatically chains selections (e.g., select plan → select task)

## File Structure

```
src/
├── repp                  # Main entry point
├── lib/
│   ├── query.sh         # Plan/task query functions
│   ├── config.sh        # Config file loading
│   ├── validate.sh      # Status and priority validation
│   └── ui.sh            # GUM-based interactive selection
└── commands/
    ├── plan.sh          # plan list, plan get
    ├── task.sh          # task list, task get
    ├── task-spec.sh     # task-spec get
    └── is-blocked.sh    # is-blocked utility
```

## Dependencies

- `yq` - YAML processing
- `gum` - interactive UI

## Data Model Reference

### Valid Statuses
`backlog`, `discovery`, `in_progress`, `review`, `done`

### Valid Priorities
`0` (critical) through `4` (backlog)

### Task ID Format
`plan-slug/task-slug`
