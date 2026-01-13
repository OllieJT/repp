# Repo Plans `repp`

File-based plan and task tracking that lives in git.

## Problem

**Context loss.** External tools (Jira, Linear, Notion) store work tracking outside the codebase. When you switch branches, your issue tracker doesn't follow. When you review a PR, the task context lives somewhere else.

**AI agents need structure.** Autonomous development loops need to read task requirements, update status, and commit changes—all programmatically. External APIs add latency, auth complexity, and failure modes.

**Version control mismatch.** Traditional issue trackers don't branch, merge, or diff. You can't review task changes alongside code changes.

## Solution

Track plans and tasks as files in the repository:

- **YAML metadata** for status, priority, dependencies
- **Markdown specs** for detailed requirements
- **Git branches** map 1:1 with plans
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

## Data Model

### PLAN.yml

```yaml
# Required
priority: number     # 0 (critical) | 1 | 2 | 3 | 4 (lowest)
description: string  # Why this plan matters
status: string       # backlog | in_progress | done
```

**Lifecycle:** `backlog → in_progress → done`

**Example:**
```yaml
priority: 1
description: Implement authentication system
status: in_progress
```

### TASK.yml

```yaml
# Required
priority: number     # 0 (critical) | 1 | 2 | 3 | 4 (lowest)
description: string  # What this task accomplishes
status: string       # backlog | in_progress | review | done

# Optional
blocked_by:          # Task IDs that must complete first
  - plan-slug/task-slug
comments:            # Append-only timestamped notes
  - "2024-01-15: Started investigation"
```

**Lifecycle:** `backlog → in_progress → review ⇄ in_progress | done`

**Example:**
```yaml
priority: 2
description: Configure OAuth providers
status: backlog
blocked_by:
  - auth-system/setup-database
```

### SPEC.md

Optional markdown file for detailed task specifications.

**Requirements:** filename must be `SPEC.md`, format must be markdown. No enforced structure.

## Commands

### Plan Commands

**`repp plan list`** — List all plans
```
--status=X        Filter by status (backlog|in_progress|done)
--min-priority=X  Filter by minimum priority (0-4)
```

**`repp plan get [plan-id]`** — Get plan details
```
Interactive selection if plan-id omitted
```

**`repp plan scan`** — List plan IDs only
```
--status=X        Filter by status
--min-priority=X  Filter by minimum priority
```

### Task Commands

**`repp task list [plan-id]`** — List tasks in a plan
```
--status=X        Filter by status (backlog|in_progress|review|done)
--min-priority=X  Filter by minimum priority (0-4)
```

**`repp task get [task-id]`** — Get task details
```
task-id format: plan-id/task-slug
Interactive selection if task-id omitted
```

**`repp task get-spec [task-id]`** — Get task specification
```
Interactive selection if task-id omitted
```

**`repp task is-blocked <task-id>`** — Check if task is blocked
```
Exit 0 = blocked
Exit 1 = not blocked
```

**`repp task scan [plan-id]`** — List task IDs only
```
--status=X        Filter by status
--min-priority=X  Filter by minimum priority
```

## Configuration

Create `.repprc` in project root:

```bash
REPP_ROOT="path/to/plans"
```

## Dependencies

- **Required:** [yq](https://github.com/mikefarah/yq) (Mike Farah version)
- **Optional:** [gum](https://github.com/charmbracelet/gum) (interactive selection, styled output)
