#!/usr/bin/env bash
# Task command handlers

bws::cmd::task::list() {
    local project_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) project_id="$arg" ;;
        esac
    done

    if [[ -z "$project_id" ]]; then
        project_id=$(bws::ui::select_project) || return 1
    fi

    bws::list_tasks "$project_id" ${filters[@]+"${filters[@]}"}
}

bws::cmd::task::get() {
    local task_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) task_id="$arg" ;;
        esac
    done

    if [[ -z "$task_id" ]]; then
        task_id=$(bws::ui::select_task "" ${filters[@]+"${filters[@]}"}) || return 1
    fi

    bws::get_task "$task_id"
}

bws::cmd::task::ready() {
    # TODO: check if task is ready to work on
    # Exit 0=ready, 1=blocked
    :
}
