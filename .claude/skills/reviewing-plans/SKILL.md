---
name: reviewing-plans
description: Reviews plan documents for structure and Repp metadata compliance. Validates frontmatter (status, priority, description), phase sizing, and task checkboxes. Use when creating or reviewing any plan in plans/.
---

# Reviewing Plans

Review plan documents for Repp compliance before finalizing.

## Quick Start

When reviewing a plan, check:

1. **Frontmatter** - Has required fields with valid values
2. **Phases** - Broken into manageable, focused sections
3. **Tasks** - Use markdown checkboxes for trackable items

## Frontmatter Requirements

Every plan must start with YAML frontmatter:

```markdown
---
status: backlog
priority: P1
description: Brief summary of what this plan accomplishes
---
```

### Required Fields

| Field         | Values                               | Notes                           |
| ------------- | ------------------------------------ | ------------------------------- |
| `status`      | `backlog` \| `in_progress` \| `done` | Current lifecycle state         |
| `priority`    | From `plans/settings.json`           | Default: P0-P4                  |
| `description` | String                               | Concise summary (1-2 sentences) |

### Priority Values

Read `plans/settings.json` for valid priorities. Default if not configured:

```json
["P0", "P1", "P2", "P3", "P4"]
```

## Phase Structure

Plans should break work into phases. Each phase:

- Has a clear heading (`## Phase: Name` or `### 1. Name`)
- Contains 3-7 related tasks
- Can be completed in a single work session
- Has defined inputs/outputs

**Too large:** A phase with 15+ tasks or multiple unrelated concerns
**Too small:** A phase with 1 task that could merge with another

## Task Checkboxes

Use markdown checkboxes to track completion within the plan body:

```markdown
## Phase 1: Setup

- [ ] Create database schema
- [ ] Add migration script
- [ ] Update seed data

## Phase 2: Implementation

- [x] Define API endpoints
- [ ] Implement handlers
- [ ] Add validation
```

### Checkbox Rules

- One task per checkbox
- Tasks should be concrete and verifiable
- Keep task descriptions under 80 characters
- Indent sub-tasks if needed

```markdown
- [ ] Implement user authentication
  - [ ] Add login endpoint
  - [ ] Add logout endpoint
  - [ ] Add token refresh
```

## Review Checklist

When reviewing a plan, verify:

**Frontmatter**

- [ ] Has opening `---` delimiter
- [ ] `status` is one of: backlog, in_progress, done
- [ ] `priority` matches a value in settings.json
- [ ] `description` is present and concise

**Structure**

- [ ] Phases are clearly delineated
- [ ] Each phase has 3-7 tasks
- [ ] No phase tries to do too much

**Tasks**

- [ ] All actionable items use `- [ ]` checkbox syntax
- [ ] Tasks are specific and verifiable
- [ ] No vague tasks like "finish implementation"

## Example: Well-Structured Plan

```markdown
---
status: backlog
priority: P1
description: Add user notification preferences
---

# Plan: Notification Preferences

## Summary

Allow users to configure which notifications they receive.

## Phase 1: Data Model

- [ ] Add preferences table migration
- [ ] Create NotificationPreference model
- [ ] Add default preferences on user creation

## Phase 2: API

- [ ] GET /preferences endpoint
- [ ] PATCH /preferences endpoint
- [ ] Add request validation

## Phase 3: UI

- [ ] Preferences page component
- [ ] Toggle controls for each notification type
- [ ] Save/cancel actions

## Verification

- [ ] Preferences persist across sessions
- [ ] Email notifications respect preferences
- [ ] Push notifications respect preferences
```

## Common Issues

**Missing frontmatter** - Plan starts with `#` instead of `---`

**Invalid status** - Using values like "wip", "pending", "complete"

**No checkboxes** - Using bullet points (`-`) without checkbox syntax (`- [ ]`)

**Monolithic phases** - Single phase with 20+ tasks

**Vague tasks** - "Fix bugs", "Clean up code", "Finish feature"

## Guidelines

- New plans start with `status: backlog`
- Set `status: in_progress` when work begins
- Check off tasks as completed
- Set `status: done` when all checkboxes checked
- Priority indicates urgency, not complexity
