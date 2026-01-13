#!/usr/bin/env bash
# GUM-based interactive selection

source "$(dirname "${BASH_SOURCE[0]}")/query.sh"

bws::ui::select_project() {
    local projects
    projects=$(bws::list_projects "$@") || return 1

    [[ -z "$projects" ]] && return 1

    local items
    items=$(echo "$projects" | yq eval-all -r 'select(.) | .id + (if .description then " — " + .description else "" end)')

    local selection
    selection=$(echo "$items" | gum filter --placeholder "Select project...")

    [[ -z "$selection" ]] && return 1

    echo "${selection%% — *}"
}

bws::ui::select_task() {
    local project_id="$1"
    shift || true

    if [[ -z "$project_id" ]]; then
        project_id=$(bws::ui::select_project) || return 1
    fi

    local tasks
    tasks=$(bws::list_tasks "$project_id" "$@") || return 1

    [[ -z "$tasks" ]] && return 1

    local items
    items=$(echo "$tasks" | yq eval-all -r 'select(.) | .id + (if .description then " — " + .description else "" end)')

    local selection
    selection=$(echo "$items" | gum filter --placeholder "Select task...")

    [[ -z "$selection" ]] && return 1

    echo "${selection%% — *}"
}

bws::ui::display_yaml() {
    local input
    input=$(cat)

    [[ -z "$input" ]] && return 0

    if command -v gum &>/dev/null; then
        echo "$input" | gum format -t code
    else
        echo "$input"
    fi
}
