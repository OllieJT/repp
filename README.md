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

- **YAML metadata** for status, priority, dependencies
- **Markdown specs** for detailed requirements
- **Git branches** map 1:1 with plans
- **Shell-native** querying with standard tools

Everything versions together. Branch the code, branch the work tracking.

## Design Principles

| Principle          | Implementation                                            |
| ------------------ | --------------------------------------------------------- |
| Version controlled | All progress lives in git—branch, merge, review like code |
| Conflict-friendly  | YAML line-based format resolves merge conflicts cleanly   |
| Shell-native       | Data readable with `grep`, `find`, `cat`—no lock-in       |
| Scales complexity  | Simple tasks need one YAML file; complex ones add specs   |
| Zero dependencies  | Works anywhere git works                                  |

## Data Model

### PLAN.yml

```yaml
priority: string     # Any value (e.g., P1, P2, P3)
description: string  # What this plan is for
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
priority: string     # Any value (e.g., P1, P2, P3)
description: string  # What this task accomplishes
status: string       # backlog | in_progress | review | done

blocked_by: # Optional: Task IDs that must complete first
  - plan-slug/task-slug
comments: # Optional: Append notes to improve contextual awareness
  - string
```

**Lifecycle:** `backlog → in_progress → review ⇄ in_progress | done`

**Example:**

```yaml
priority: 2
description: Configure OAuth providers
status: review
blocked_by:
  - auth-system/setup-database
comments:
  - "Implemented Google Oauth"
  - "Implemented GitHub Oauth"
  - "Updated ./SPEC.md"
```

### SPEC.md

Optional markdown file for detailed task specifications.

**Requirements:** filename must be `SPEC.md`, format must be markdown.

There is no expected structure for spec files.

**Example:**

```md
## assignee: Agent

# Requirements

- [x] Update our BetterAuth configuration to use Oauth.
- [x] Add Google as an Oauth Provider
- [x] Add GitHub as an Oauth Provider
- [ ] Add Apple as an Oauth Provider

## Guidelines

...
```

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
```

#### Get task specification

```sh
repp task get-spec [task-id]
  # Interactive selection if task-id omitted
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
```

## Configuration

Create `.repprc` in project root:

```bash
# Path to your plans folder, relative to this file.
REPP_ROOT="path/to/plans"

# Optional: Custom priority values for interactive selection (default: P0,P1,P2,P3,P4)
REPP_PRIORITIES="critical,high,medium,low"
```

## Dependencies

- [yq](https://github.com/mikefarah/yq) (Mike Farah version)
- [gum](https://github.com/charmbracelet/gum) (interactive selection, styled output)
