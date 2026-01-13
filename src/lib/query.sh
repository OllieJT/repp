#!/usr/bin/env bash
# Project/task query functions

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/validate.sh"

bws::get_project() {
    local id="$1"

    if [[ -z "$id" ]]; then
        echo "Error: project-id required" >&2
        return 1
    fi

    local root
    root="$(bws::get_root)" || return 1

    local file="$root/$id/PROJECT.yml"

    if [[ ! -f "$file" ]]; then
        echo "Note: project '$id' not found" >&2
        return 1
    fi

    echo "id: $id"
    cat "$file"
}

bws::list_projects() {
    local filter_status=""
    local filter_priority=""

    for arg in "$@"; do
        case "$arg" in
            --status=*) filter_status="${arg#*=}" ;;
            --min-priority=*) filter_priority="${arg#*=}" ;;
        esac
    done

    if [[ -n "$filter_status" ]]; then
        bws::validate_status "$filter_status" || return 1
    fi
    if [[ -n "$filter_priority" ]]; then
        bws::validate_priority "$filter_priority" || return 1
    fi

    local root
    root="$(bws::get_root)" || return 1

    local found=0

    for f in "$root"/*/PROJECT.yml; do
        [[ -f "$f" ]] || continue

        local id
        id=$(basename "$(dirname "$f")")
        local status
        status=$(yq '.status' "$f")
        local priority
        priority=$(yq '.priority' "$f")

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" && "$priority" -gt "$filter_priority" ]] && continue

        [[ $found -gt 0 ]] && echo "---"
        echo "id: $id"
        cat "$f"
        ((found++))
    done

    [[ $found -eq 0 ]] && echo "Note: no projects found" >&2
}

bws::get_task() {
    local id="$1"

    if [[ -z "$id" ]]; then
        echo "Error: task-id required" >&2
        return 1
    fi

    if [[ ! "$id" =~ ^[^/]+/[^/]+$ ]]; then
        echo "Error: task-id must be 'project-slug/task-slug'" >&2
        return 1
    fi

    local root
    root="$(bws::get_root)" || return 1

    local project_id="${id%/*}"
    local task_slug="${id#*/}"
    local file="$root/$project_id/$task_slug/TASK.yml"

    if [[ ! -f "$file" ]]; then
        echo "Note: task '$id' not found" >&2
        return 1
    fi

    echo "id: $id"
    cat "$file"
}

bws::list_tasks() {
    local project_id="$1"
    shift || true
    local filter_status=""
    local filter_priority=""

    if [[ -z "$project_id" ]]; then
        echo "Error: project-id required" >&2
        return 1
    fi

    for arg in "$@"; do
        case "$arg" in
            --status=*) filter_status="${arg#*=}" ;;
            --min-priority=*) filter_priority="${arg#*=}" ;;
        esac
    done

    if [[ -n "$filter_status" ]]; then
        bws::validate_status "$filter_status" || return 1
    fi
    if [[ -n "$filter_priority" ]]; then
        bws::validate_priority "$filter_priority" || return 1
    fi

    local root
    root="$(bws::get_root)" || return 1

    local project_dir="$root/$project_id"

    if [[ ! -d "$project_dir" ]]; then
        echo "Note: project '$project_id' not found" >&2
        return 0
    fi

    local found=0

    for f in "$project_dir"/*/TASK.yml; do
        [[ -f "$f" ]] || continue

        local task_slug
        task_slug=$(basename "$(dirname "$f")")
        local id="$project_id/$task_slug"
        local status
        status=$(yq '.status' "$f")
        local priority
        priority=$(yq '.priority' "$f")

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" && "$priority" -gt "$filter_priority" ]] && continue

        [[ $found -gt 0 ]] && echo "---"
        echo "id: $id"
        cat "$f"
        ((found++))
    done

    [[ $found -eq 0 ]] && echo "Note: no tasks found in '$project_id'" >&2
}

bws::get_task_spec() {
    local id="$1"

    if [[ -z "$id" ]]; then
        echo "Error: task-id required" >&2
        return 1
    fi

    if [[ ! "$id" =~ ^[^/]+/[^/]+$ ]]; then
        echo "Error: task-id must be 'project-slug/task-slug'" >&2
        return 1
    fi

    local root
    root="$(bws::get_root)" || return 1

    local project_id="${id%/*}"
    local task_slug="${id#*/}"
    local file="$root/$project_id/$task_slug/SPEC.md"

    if [[ ! -f "$file" ]]; then
        echo "Note: spec for '$id' not found" >&2
        return 1
    fi

    cat "$file"
}

bws::is_task_blocked() {
    local id="$1"

    if [[ -z "$id" ]]; then
        echo "Error: task-id required" >&2
        return 1
    fi

    if [[ ! "$id" =~ ^[^/]+/[^/]+$ ]]; then
        echo "Error: task-id must be 'project-slug/task-slug'" >&2
        return 1
    fi

    local root
    root="$(bws::get_root)" || return 1

    local project_id="${id%/*}"
    local task_slug="${id#*/}"
    local file="$root/$project_id/$task_slug/TASK.yml"

    if [[ ! -f "$file" ]]; then
        echo "Error: task '$id' not found" >&2
        return 1
    fi

    local blockers
    blockers=$(yq '.blocked_by // [] | .[]' "$file" 2>/dev/null)

    [[ -z "$blockers" ]] && return 1

    while IFS= read -r blocker_id; do
        local blocker_project="${blocker_id%/*}"
        local blocker_task="${blocker_id#*/}"
        local blocker_file="$root/$blocker_project/$blocker_task/TASK.yml"

        if [[ ! -f "$blocker_file" ]]; then
            return 0
        fi

        local blocker_status
        blocker_status=$(yq '.status' "$blocker_file")

        if [[ "$blocker_status" != "done" ]]; then
            return 0
        fi
    done <<< "$blockers"

    return 1
}
