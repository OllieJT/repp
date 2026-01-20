# Consolidate Tasks into Plans

Remove `tasks` entirely. Plans become the only work unit with all task features merged in.

## Key Decisions
- **Multi-task plans**: Merge all tasks into parent plan's body
- **CLI naming**: Keep `repp plan`
- **File naming**: Keep `PLAN.md`
- **Status set**: 5-state (`backlog|discovery|in_progress|review|done`)

## Changes

### 1. Extend Plan Mutations (`src/lib/mutate.sh`)
Add functions:
- `repp::set_plan_priority()`
- `repp::set_plan_status()`
- `repp::add_plan_comment()`

### 2. Add Plan Blocking (`src/lib/query.sh`)
- Add `repp::is_plan_blocked()` - check `blocked_by` array in PLAN.md
- Blocker IDs are now just `plan-id` (not `plan-id/task-slug`)

### 3. Add Plan Commands (`src/commands/plan.sh`)
New handlers:
- `prioritize` - set priority
- `review` - transition to review
- `complete` - transition to done
- `note` - add comment
- `is-blocked` - check blocking status

### 4. Update Router (`src/repp`)
- Add new plan actions to routing
- Remove `task` resource entirely
- Update help text

### 5. Migration Script (`scripts/migrate-tasks-to-plans.sh`)
For each plan with tasks:
1. Merge task frontmatter fields (`blocked_by`) into PLAN.md
2. Append task bodies/comments to plan body
3. Delete task subdirectories

### 6. Delete Task Code
Remove:
- `src/commands/task.sh`
- Task functions from `query.sh`, `mutate.sh`, `ui.sh`
- Task routing/help from `src/repp`

## Files to Modify
| File | Action |
|------|--------|
| `src/lib/mutate.sh` | Add plan mutations |
| `src/lib/query.sh` | Add `is_plan_blocked`, delete task functions |
| `src/commands/plan.sh` | Add 5 new command handlers |
| `src/lib/ui.sh` | Delete `select_task` |
| `src/repp` | Add plan actions, remove task resource |
| `src/commands/task.sh` | Delete |
| `scripts/migrate-tasks-to-plans.sh` | Create |

## Verification
1. Run `repp plan list` - should work as before
2. Run `repp plan prioritize <id> P1` - should update priority
3. Run `repp plan note <id> "test"` - should add comment
4. Run `repp plan is-blocked <id>` - should check blockers
5. Run `repp task` - should error (command removed)
6. Run migration on test data with multiple tasks per plan
