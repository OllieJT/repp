#!/usr/bin/env bash
# GUM-based interactive selection

source "$(dirname "${BASH_SOURCE[0]}")/query.sh"

bws::ui::select_project() {
    local items
    items=$(bws::scan_projects "$@") || return $BWS_EXIT_ERROR

    if [[ -z "$items" ]]; then
        echo "Error: no projects found" >&2
        return $BWS_EXIT_ERROR
    fi

    gum filter --header "Select project" <<< "$items"
}

bws::ui::select_task() {
    local project_id="$1"
    shift || true

    if [[ -z "$project_id" ]]; then
        project_id=$(bws::ui::select_project) || return $BWS_EXIT_ERROR
    fi

    local items
    items=$(bws::scan_tasks "$project_id" "$@") || return $BWS_EXIT_ERROR

    if [[ -z "$items" ]]; then
        echo "Error: no tasks found" >&2
        return $BWS_EXIT_ERROR
    fi

    gum filter --header "Select task" <<< "$items"
}

bws::ui::display_yaml() {
    local input
    input=$(cat)

    [[ -z "$input" ]] && return $BWS_EXIT_SUCCESS

    if command -v gum &>/dev/null; then
        echo "$input" | gum format -t code
    else
        echo "$input"
    fi
    return $BWS_EXIT_SUCCESS
}
