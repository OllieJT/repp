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
        project_id=$(bws::ui::select_project) || return $BWS_EXIT_ERROR
    fi

    bws::list_tasks "$project_id" ${filters[@]+"${filters[@]}"}
    return $?
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
        task_id=$(bws::ui::select_task "" ${filters[@]+"${filters[@]}"}) || return $BWS_EXIT_ERROR
    fi

    bws::get_task "$task_id"
    return $?
}

bws::cmd::task::get_spec() {
    local task_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) task_id="$arg" ;;
        esac
    done

    if [[ -z "$task_id" ]]; then
        task_id=$(bws::ui::select_task "" ${filters[@]+"${filters[@]}"}) || return $BWS_EXIT_ERROR
    fi

    bws::get_task_spec "$task_id"
    return $?
}

bws::cmd::task::is_blocked() {
    local task_id="$1"

    if [[ -z "$task_id" ]]; then
        echo "Error: task-id required" >&2
        echo "Usage: bws task is-blocked <task-id>" >&2
        return $BWS_EXIT_ERROR
    fi

    bws::is_task_blocked "$task_id"
    return $?
}

bws::cmd::task::scan() {
    local project_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) project_id="$arg" ;;
        esac
    done

    if [[ -z "$project_id" ]]; then
        project_id=$(bws::ui::select_project) || return $BWS_EXIT_ERROR
    fi

    bws::scan_tasks "$project_id" ${filters[@]+"${filters[@]}"}
    return $?
}
