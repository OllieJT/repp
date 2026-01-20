![repp](media/rpp-pill-shield.png) [![NPM Version](https://img.shields.io/npm/v/repp)](https://www.npmjs.com/package/repp) ![GitHub License](https://img.shields.io/github/license/OllieJT/Repp) [![Release](https://github.com/OllieJT/repp/actions/workflows/release.yml/badge.svg)](https://github.com/OllieJT/repp/actions/workflows/release.yml)

# Repo Plans `repp`

File-based plan and task tracking that lives in your repository.

## What It Is

**Task documentation that lives with code.** Plans and specs version-controlled alongside the code they describe. Branch the code, branch the context.

**Structured for AI agents.** Agents read requirements, update status, and commit changes—all without external APIs. Detailed plans reduce context window bloat and maintain output quality.

**Code as source of truth.** Your repo reflects what the app _is_ and what needs to be _done_. Task state branches, merges, and diffs with the code.

## What It Is Not

**Not a replacement for team alignment tools.** Keep using whatever works for coordination and reporting.

**Not a product.** Primitives your team already knows (YAML, Markdown, Bash). Opinionated enough to be useful, flexible enough to extend.

## Solution

Track plans and tasks as files in the repository:

- **Markdown with frontmatter** for metadata and specs in one file
- **Git branches** map 1:1 with plans
- **Shell-native** querying with standard tools

Everything versions together. Branch the code, branch the work tracking.

## Design Principles

| Principle          | Implementation                                            |
| ------------------ | --------------------------------------------------------- |
| Version controlled | All progress lives in git—branch, merge, review like code |
| Conflict-friendly  | Frontmatter + markdown resolves merge conflicts cleanly   |
| Shell-native       | Data readable with `grep`, `find`, `cat`—no lock-in       |
| Self-contained     | Each task is one file: metadata + specification           |
| Zero dependencies  | Works anywhere git works                                  |

## Data Model

### PLAN.md

Markdown file with YAML frontmatter. Optional body for plan details.

```markdown
---
priority: P1
description: Plan description here
status: in_progress
---

Optional markdown body for plan details.
```

**Frontmatter fields:**

| Field       | Type   | Values                           |
| ----------- | ------ | -------------------------------- |
| priority    | string | Any value (e.g., P1, P2, P3)     |
| description | string | What this plan is for            |
| status      | string | backlog \| in_progress \| done   |

**Lifecycle:** `backlog → in_progress → done`

### TASK.md

Markdown file with YAML frontmatter. Body contains task specification.

```markdown
---
priority: P2
description: Task description here
status: backlog
blocked_by:
  - other-plan/other-task
---

Detailed task specification goes here.

## Comments

- First comment
- Second comment
```

**Frontmatter fields:**

| Field       | Type     | Values                                    |
| ----------- | -------- | ----------------------------------------- |
| priority    | string   | Any value (e.g., P1, P2, P3)              |
| description | string   | What this task accomplishes               |
| status      | string   | backlog \| in_progress \| review \| done  |
| blocked_by  | string[] | Optional: Task IDs that must complete first |

**Lifecycle:** `backlog → in_progress → review ⇄ in_progress | done`

**Comments:** Appended to `## Comments` section in markdown body via `repp task note`.

## Commands

### Plan Commands

#### List all plans

```sh
repp plan list
  --status=X        # Filter by status (backlog|in_progress|done)
  --priority=X,Y    # Filter by priority (exact match)
```

#### Get plan details

```sh
repp plan get [plan-id]
  # Interactive selection if plan-id omitted
```

#### List plan IDs only

```sh
repp plan scan
  --status=X        # Filter by status
  --priority=X,Y    # Filter by priority (exact match)
```

### Task Commands

#### List tasks in a plan

```sh
repp task list [plan-id]
  --status=X        # Filter by status (backlog|in_progress|review|done)
  --priority=X,Y    # Filter by priority (exact match)
```

#### Get task details

```sh
repp task get [task-id]
  # task-id format: plan-id/task-slug
  # Interactive selection if task-id omitted
  # Shows full file: frontmatter + body
```

#### Check if task is blocked

```sh
repp task is-blocked <task-id>
  # Exit 0 = blocked
  # Exit 1 = not blocked
```

#### List task IDs only

```sh
repp task scan [plan-id]
  --status=X        # Filter by status
  --priority=X,Y    # Filter by priority (exact match)
```

#### Set task priority

```sh
repp task prioritize [task-id] [priority]
  # priority: any alphanumeric (e.g., 1, P1, high)
  # Interactive input if args omitted
```

#### Transition task to review

```sh
repp task review [task-id]
  # Interactive selection if task-id omitted
```

#### Transition task to done

```sh
repp task complete [task-id]
  # Interactive selection if task-id omitted
```

#### Add comment to task

```sh
repp task note [task-id] "comment"
  # Interactive selection if task-id omitted
  # Appends to ## Comments section in markdown body
```

## Configuration

Plans live in `{git-root}/projects/`. Optionally add `projects/settings.json`:

```json
{
  "$schema": "https://unpkg.com/repp@latest/src/schema/settings.schema.json",
  "priorities": ["P0", "P1", "P2", "P3", "P4"]
}
```

| Field        | Type       | Default                       | Description                |
| ------------ | ---------- | ----------------------------- | -------------------------- |
| `priorities` | `string[]` | `["P0","P1","P2","P3","P4"]`  | Priority values for tasks  |

## Dependencies

- [yq](https://github.com/mikefarah/yq) (Mike Farah version)
- [gum](https://github.com/charmbracelet/gum) (interactive selection, styled output)
