![repp](media/rpp-pill-shield.png) [![NPM Version](https://img.shields.io/npm/v/repp)](https://www.npmjs.com/package/repp) ![GitHub License](https://img.shields.io/github/license/OllieJT/Repp) [![Release](https://github.com/OllieJT/repp/actions/workflows/release.yml/badge.svg)](https://github.com/OllieJT/repp/actions/workflows/release.yml)

# Repo Plans `repp`

CLI for documenting workloads in agent-friendly codebases.

## What It Is

**The right abstraction for AI-assisted planning.** Rather than inventing new systems, repp extends markdown plan documents with frontmatter and provides a CLI for graceful automation.

**Built for agent workflows.** AI agents work best with pre-considered plans. Repp supports patterns like the Ralph Wiggum Loop—agents that plan, execute, and iterate autonomously.

**Context-efficient by design.** Planning and task selection shouldn't consume the context needed for actual work. The CLI returns only metadata, and is queryable by attributes like status and priority. This enables agents to spend context on the work, not the tooling.

## What It Is Not

**Not a replacement for team coordination.** Keep using whatever works for human alignment and reporting.

**Not a product.** Primitives your team already knows (YAML, Markdown, Bash). Opinionated enough to be useful, flexible enough to extend.

## Usage

Run directly with npx:

```sh
# Recommended
npx repp plan list
```

Or install globally:

```sh
npm install -g repp@latest
repp plan list
```

## Solution

Enable agent task selection and context management:

- **Markdown with frontmatter** for metadata and specs in one file
- **Metadata-only queries** minimize context spent on task discovery
- **Flexible filtering** by status, priority, and blocking dependencies
- **Shell-native** querying with standard tools

Agents can discover available tasks, read detailed specs when needed, and update status—all version-controlled with the code.

## Design Principles

| Principle          | Implementation                                            |
| ------------------ | --------------------------------------------------------- |
| Version controlled | All progress lives in git—branch, merge, review like code |
| Context-efficient  | Metadata queries minimize overhead for task selection     |
| Queryable          | Filter plans and tasks by status, priority, dependencies  |
| Shell-native       | Data readable with `grep`, `find`, `cat`—no lock-in       |
| Self-contained     | Each task is one file: metadata + specification           |

## Data Model

### Plans (`plans/<id>.md`)

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

| Field       | Type   | Values                         |
| ----------- | ------ | ------------------------------ |
| priority    | string | Any value (e.g., P1, P2, P3)   |
| description | string | What this plan is for          |
| status      | string | backlog \| discovery \| in_progress \| review \| done |

**Lifecycle:** `backlog → discovery → in_progress → review → done`

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

| Field       | Type     | Values                                      |
| ----------- | -------- | ------------------------------------------- |
| priority    | string   | Any value (e.g., P1, P2, P3)                |
| description | string   | What this task accomplishes                 |
| status      | string   | backlog \| in_progress \| review \| done    |
| blocked_by  | string[] | Optional: Task IDs that must complete first |

**Lifecycle:** `backlog → in_progress → review ⇄ in_progress | done`

**Comments:** Appended to `## Comments` section in markdown body via `repp plan note`.

## Commands

### Plan Commands

```sh
repp plan list
  --status=X        # Filter by status (backlog|discovery|in_progress|review|done)
  --priority=X,Y    # Filter by priority (exact match)

repp plan get [plan-id]
  # Interactive selection if plan-id omitted

repp plan scan
  --status=X        # Filter by status
  --priority=X,Y    # Filter by priority (exact match)

repp plan prioritize [plan-id] [priority]
  # priority: any alphanumeric (e.g., 1, P1, high)
  # Interactive input if args omitted

repp plan review [plan-id]
  # Transition plan to review status

repp plan complete [plan-id]
  # Transition plan to done status

repp plan note [plan-id] "comment"
  # Appends to ## Comments section

repp plan is-blocked <plan-id>
  # Exit 0 = blocked, Exit 1 = not blocked

repp plan validate
  # Find plans with missing or invalid frontmatter
```

### Config Commands

```sh
repp config show
  # Output resolved settings (defaults merged with user config)
```

## Configuration

Plans live in `{git-root}/plans/`. Optionally add `plans/settings.json`:

```json
{
	"$schema": "https://unpkg.com/repp@latest/src/schema/settings.schema.json",
	"priorities": ["P0", "P1", "P2", "P3", "P4"]
}
```

| Field        | Type       | Default                      | Description               |
| ------------ | ---------- | ---------------------------- | ------------------------- |
| `priorities` | `string[]` | `["P0","P1","P2","P3","P4"]` | Priority values for tasks |

## Agent Tooling

Convenience tools for AI agents:

- **Skills** for plan/task workflows via Claude Code
- **Sub-agent configuration** for autonomous Ralph loop execution

## Dependencies

- [yq](https://github.com/mikefarah/yq) (Mike Farah version)
- [gum](https://github.com/charmbracelet/gum) (interactive selection, styled output)
