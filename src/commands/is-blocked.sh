#!/usr/bin/env bash
# Is-blocked command handler

bws::cmd::is_blocked() {
    local task_id="$1"

    if [[ -z "$task_id" ]]; then
        echo "Error: task-id required" >&2
        echo "Usage: bws is-blocked <task-id>" >&2
        return 1
    fi

    bws::is_task_blocked "$task_id"
}
