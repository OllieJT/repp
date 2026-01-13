# Implementation Plan: repp CLI

spec: todo/setup-cli.md

## Prompt

@todo/setup-cli.md @README.md Continue work on this CLI tool by planning a clear implementation plan for the following work. You should avoid any assumptions and ask clarifying questions as needed.


---

## Steps

### 1. Create directory structure
- `src/repp` - main entry point
- `src/lib/` - library files
- `src/commands/` - subcommand handlers

### 2. Implement `src/lib/config.sh`
- `repp::load_config` - find and source config file
- `repp::get_root` - return REPP_ROOT (resolved to absolute path)
- Create default if none found

### 3. Implement `src/lib/query.sh`
Adapt from `reference/scripts/repp.sh`:
- `repp::get_plan`
- `repp::list_plans`
- `repp::get_task`
- `repp::list_tasks`
- `repp::get_task_spec`
- `repp::is_task_blocked`

Changes from reference:
- Use `repp::get_root` instead of hardcoded `REPP_ROOT`
- Keep same function signatures

### 3.1. Implement `src/lib/validate.sh`
- `repp::validate_status`
- `repp::validate_priority`

### 4. Implement `src/lib/ui.sh`
- `repp::ui::select_plan` - `gum filter` over plan list, returns ID
- `repp::ui::select_task` - `gum filter` over task list, returns ID
- `repp::ui::display_yaml` - styled YAML output

### 5. Implement `src/commands/plan.sh`
- `repp::cmd::plan::list` - list plans, pass through filters
- `repp::cmd::plan::get` - get plan, interactive select if no arg

### 6. Implement `src/commands/task.sh`
- `repp::cmd::task::list` - list tasks, interactive plan select if no arg
- `repp::cmd::task::get` - get task, interactive select if no arg

### 7. Implement `src/commands/task-spec.sh`
- `repp::cmd::task_spec::get` - get spec, interactive select if no arg

### 8. Implement `src/commands/is-blocked.sh`
- `repp::cmd::is_blocked` - check blocked status, return exit code

### 9. Implement `src/repp` (main entry point)
- Parse resource + action from args
- Route to appropriate command handler
- Handle `--help` at each level
