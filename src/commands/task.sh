#!/usr/bin/env bash
# Task command handlers

repp::cmd::task::list() {
    local plan_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) plan_id="$arg" ;;
        esac
    done

    if [[ -z "$plan_id" ]]; then
        plan_id=$(repp::ui::select_plan) || return $REPP_EXIT_ERROR
    fi

    repp::list_tasks "$plan_id" ${filters[@]+"${filters[@]}"}
    return $?
}

repp::cmd::task::get() {
    local task_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) task_id="$arg" ;;
        esac
    done

    if [[ -z "$task_id" ]]; then
        task_id=$(repp::ui::select_task "" ${filters[@]+"${filters[@]}"}) || return $REPP_EXIT_ERROR
    fi

    repp::get_task "$task_id"
    return $?
}

repp::cmd::task::get_spec() {
    local task_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) task_id="$arg" ;;
        esac
    done

    if [[ -z "$task_id" ]]; then
        task_id=$(repp::ui::select_task "" ${filters[@]+"${filters[@]}"}) || return $REPP_EXIT_ERROR
    fi

    repp::get_task_spec "$task_id"
    return $?
}

repp::cmd::task::is_blocked() {
    local task_id="$1"

    if [[ -z "$task_id" ]]; then
        repp::log::error "task-id required"
        repp::log::info "Usage: repp task is-blocked <task-id>"
        return $REPP_EXIT_ERROR
    fi

    repp::is_task_blocked "$task_id"
    return $?
}

repp::cmd::task::scan() {
    local plan_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) plan_id="$arg" ;;
        esac
    done

    if [[ -z "$plan_id" ]]; then
        plan_id=$(repp::ui::select_plan) || return $REPP_EXIT_ERROR
    fi

    repp::scan_tasks "$plan_id" ${filters[@]+"${filters[@]}"}
    return $?
}
