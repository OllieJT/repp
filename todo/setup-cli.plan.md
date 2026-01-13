# Implementation Plan: bws CLI

spec: todo/setup-cli.md

## Steps

### 1. Create directory structure
- `src/bws` - main entry point
- `src/lib/` - library files
- `src/commands/` - subcommand handlers

### 2. Implement `src/lib/config.sh`
- `bws::load_config` - find and source config file
- `bws::get_root` - return BWS_ROOT (resolved to absolute path)
- Create default if none found

### 3. Implement `src/lib/core.sh`
Adapt from `reference/scripts/bws.sh`:
- `bws::get_project`
- `bws::list_projects`
- `bws::get_task`
- `bws::list_tasks`
- `bws::get_task_spec`
- `bws::is_task_blocked`

Changes from reference:
- Use `bws::get_root` instead of hardcoded `BWS_ROOT`
- Keep same function signatures

### 3.1. Implement `src/lib/validate.sh`
- `bws::validate_status`
- `bws::validate_priority`

### 4. Implement `src/lib/ui.sh`
- `bws::ui::select_project` - `gum filter` over project list, returns ID
- `bws::ui::select_task` - `gum filter` over task list, returns ID
- `bws::ui::display_yaml` - styled YAML output

### 5. Implement `src/commands/project.sh`
- `bws::cmd::project::list` - list projects, pass through filters
- `bws::cmd::project::get` - get project, interactive select if no arg

### 6. Implement `src/commands/task.sh`
- `bws::cmd::task::list` - list tasks, interactive project select if no arg
- `bws::cmd::task::get` - get task, interactive select if no arg

### 7. Implement `src/commands/task-spec.sh`
- `bws::cmd::task_spec::get` - get spec, interactive select if no arg

### 8. Implement `src/commands/is-blocked.sh`
- `bws::cmd::is_blocked` - check blocked status, return exit code

### 9. Implement `src/bws` (main entry point)
- Parse resource + action from args
- Route to appropriate command handler
- Handle `--help` at each level
