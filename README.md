# Branch Work

File-based project and task management that lives in git.

## Problem

**Context loss.** External tools (Jira, Linear, Notion) store work tracking outside the codebase. When you switch branches, your issue tracker doesn't follow. When you review a PR, the task context lives somewhere else.

**AI agents need structure.** Autonomous development loops need to read task requirements, update status, and commit changes—all programmatically. External APIs add latency, auth complexity, and failure modes.

**Version control mismatch.** Traditional issue trackers don't branch, merge, or diff. You can't review task changes alongside code changes.

## Solution

Track projects and tasks as files in the repository:

- **YAML metadata** for status, priority, dependencies
- **Markdown specs** for detailed requirements
- **Git branches** map 1:1 with projects
- **Shell-native** querying with standard tools

Everything versions together. Branch the code, branch the work tracking.

## Design Principles

| Principle | Implementation |
|-----------|---------------|
| Version controlled | All progress lives in git—branch, merge, review like code |
| Conflict-friendly | YAML line-based format resolves merge conflicts cleanly |
| Shell-native | Query with `grep`, `find`, `cat`—no special tooling required |
| Scales complexity | Simple tasks need one YAML file; complex ones add specs |
| Zero dependencies | Works anywhere git works |

## Architecture

```
┌─────────────────────────────────────┐
│     ralph-v2.sh                     │  AI automation loop
│     (iterates tasks, runs Claude)   │
├─────────────────────────────────────┤
│     bws.helpers.sh                  │  Logging, git, time utilities
├─────────────────────────────────────┤
│     bws.sh                          │  Project/task CRUD functions
├─────────────────────────────────────┤
│     YAML + Markdown files           │  Data layer
└─────────────────────────────────────┘
```

### Directory Structure

```
projects/
├── README.md                    # This file
├── bws.sh                       # Core query/mutation functions
├── bws.helpers.sh               # Logging, git, time utilities
├── ralph-v2.sh                  # AI automation runner
└── {project-slug}/
    ├── PROJECT.yml              # Project metadata
    └── {task-slug}/
        ├── TASK.yml             # Task metadata
        └── SPEC.md              # Optional detailed spec
```

## Data Model

### PROJECT.yml

Defines a project's metadata and current state.

```yaml
priority: 2          # 0 (critical) → 4 (backlog)
description: string  # Why this project matters
status: in_progress  # backlog | discovery | in_progress | review | done
```

**Status Lifecycle:**
```
backlog → discovery → in_progress → review → done
                          ↑            ↓
                          └────────────┘
```

- **backlog** — Identified but not started
- **discovery** — Researching scope and approach
- **in_progress** — Active development
- **review** — Awaiting feedback (can return to in_progress)
- **done** — Completed

### TASK.yml

Defines a task within a project.

```yaml
priority: 2          # 0 (critical) → 4 (backlog)
description: string  # What this task accomplishes
status: backlog      # backlog | discovery | in_progress | review | done
blocked_by:          # Optional dependencies
  - project-slug/task-slug
comments:            # Optional append-only notes
  - "2024-01-15: Started investigation"
```

**Dependencies:** A task is blocked if any `blocked_by` reference is not `done`.

```yaml
blocked_by:
  - auth-system/setup-oauth    # Same project
  - infra/deploy-db            # Cross-project
```

### SPEC.md

Optional specification for complex tasks. Include when:

- Implementation approach isn't obvious
- Multiple components or files involved
- External API contracts need definition
- Acceptance criteria require documentation

No enforced format. Common sections:

```markdown
# Task Title

## Context
Why this task exists, background info.

## Requirements
What must be true when complete.

## Approach
How to implement (optional, can be discovered).

## Files
Supporting files in task directory.
```

## Git Integration

### Branch Naming

Projects map to feature branches:

```
project/auth-system
project/billing-integration
project/mobile-app-v2
```

### Workflow

1. Create branch: `git checkout -b project/{slug}`
2. Tasks become commits or commit groups
3. PROJECT.yml and TASK.yml update alongside code
4. Merge to main when project completes

### Conflict Resolution

YAML is line-based. Keep fields atomic:

```yaml
# Good: each field on its own line
priority: 1
description: Clear single-line descriptions work best
status: in_progress
```

Multi-line values can conflict—prefer single-line entries.

## Tooling

### bws.sh — Core Functions

Query and filter projects/tasks programmatically.

```bash
source projects/bws.sh

# Projects
bws::get_project my-project
bws::list_projects --status=in_progress

# Tasks
bws::get_task my-project/my-task
bws::list_tasks my-project --status=backlog
bws::is_task_blocked my-project/my-task
bws::get_task_spec my-project/my-task
```

**Requires:** [yq](https://github.com/mikefarah/yq) (Mike Farah version)

### bws.helpers.sh — Utilities

Logging, git operations, and time functions.

```bash
source projects/bws.helpers.sh

# Logging
bws::log_info "Starting task"
bws::log_success "Task complete"
bws::log_warn "Skipping blocked task"
bws::notify "Title" "Message"

# Git
bws::git_ensure_branch "project/my-project"
bws::git_push_branch "project/my-project"

# Time
START=$(date +%s)
SECONDS=$(bws::get_seconds_since "$START")
DURATION=$(bws::get_duration "$SECONDS")  # "5m 30s"
```

### ralph-v2.sh — AI Automation

Runs Claude in a loop over project tasks.

```bash
./projects/ralph-v2.sh <project-id> [iterations]

# Example: Run 3 iterations on auth-system project
./projects/ralph-v2.sh auth-system 3
```

**What it does:**
1. Validates project exists
2. Ensures correct git branch
3. For each iteration:
   - Collects non-blocked tasks
   - Builds prompt with project/task context
   - Executes Claude in Docker sandbox
   - Pushes changes
   - Checks for completion signal

## Usage Examples

### Manual: Check project status

```bash
source projects/bws.sh

# List all in-progress projects
bws::list_projects --status=in_progress

# Get tasks for a project, filter by status
bws::list_tasks auth-system --status=backlog

# Check if a task is blocked
if bws::is_task_blocked auth-system/setup-oauth; then
  echo "Task is blocked"
fi
```

### Automated: Run AI loop

```bash
# Create project structure
mkdir -p projects/auth-system/setup-oauth
cat > projects/auth-system/PROJECT.yml << 'EOF'
priority: 1
description: Implement authentication system
status: in_progress
EOF

cat > projects/auth-system/setup-oauth/TASK.yml << 'EOF'
priority: 1
description: Configure OAuth providers
status: backlog
EOF

# Run automation
./projects/ralph-v2.sh auth-system 5
```
