# bws CLI Specification

## Overview

Bash CLI for querying BWS (Branch Work System) project and task data. Uses GUM for interactive selection when arguments are omitted.

## Commands

```
bws <resource> <action> [args] [flags]
```

### Projects
```bash
bws project list [--status=X] [--min-priority=X]
bws project get [project-id]     # Interactive if no ID
```

### Tasks
```bash
bws task list [project-id] [--status=X] [--min-priority=X]  # Interactive project select if no ID
bws task get [task-id]           # Interactive if no ID
```

### Task Specs
```bash
bws task-spec get [task-id]      # Interactive if no ID
```

### Utilities
```bash
bws is-blocked <task-id>         # Exit 0=blocked, 1=not blocked
```

## Configuration

Config file lookup order (first found wins):
1. `.bwsrc` in current directory
2. `.bwsrc` in git root (if in a repo)
3. `~/.config/bws/config`

Format:
```bash
BWS_ROOT="projects"
```

Default: `BWS_ROOT="projects"` relative to config file location.

## Interactive Mode

When required IDs are omitted, GUM prompts for selection:
- `gum filter` for searching/selecting from lists
- Automatically chains selections (e.g., select project → select task)

## File Structure

```
src/
├── bws                   # Main entry point
├── lib/
│   ├── core.sh          # Project/task query functions
│   ├── config.sh        # Config file loading
│   ├── validate.sh      # Status and priority validation
│   └── ui.sh            # GUM-based interactive selection
└── commands/
    ├── project.sh       # project list, project get
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
`project-slug/task-slug`
