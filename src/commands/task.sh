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

repp::cmd::task::prioritize() {
    local task_id=""
    local priority=""

    for arg in "$@"; do
        case "$arg" in
            */*) task_id="$arg" ;;
            *) priority="$arg" ;;
        esac
    done

    if [[ -z "$task_id" ]]; then
        task_id=$(repp::ui::select_task) || return $REPP_EXIT_ERROR
    fi

    if [[ -z "$priority" ]]; then
        if command -v gum &>/dev/null; then
            IFS=',' read -ra opts <<< "$REPP_PRIORITIES"
            priority=$(gum choose --header "Select priority" "${opts[@]}") || return $REPP_EXIT_ERROR
        else
            repp::log::error "priority required"
            return $REPP_EXIT_ERROR
        fi
    fi

    repp::set_task_priority "$task_id" "$priority"
    return $?
}

repp::cmd::task::review() {
    local task_id="$1"

    if [[ -z "$task_id" ]]; then
        task_id=$(repp::ui::select_task) || return $REPP_EXIT_ERROR
    fi

    repp::set_task_status "$task_id" "review"
    return $?
}

repp::cmd::task::complete() {
    local task_id="$1"

    if [[ -z "$task_id" ]]; then
        task_id=$(repp::ui::select_task) || return $REPP_EXIT_ERROR
    fi

    repp::set_task_status "$task_id" "done"
    return $?
}

repp::cmd::task::note() {
    local task_id="$1"
    local comment="$2"

    if [[ -z "$task_id" ]]; then
        task_id=$(repp::ui::select_task) || return $REPP_EXIT_ERROR
    fi

    if [[ -z "$comment" ]]; then
        if command -v gum &>/dev/null; then
            comment=$(gum input --header "Enter comment") || return $REPP_EXIT_ERROR
        else
            repp::log::error "comment required"
            return $REPP_EXIT_ERROR
        fi
    fi

    repp::add_task_comment "$task_id" "$comment"
    return $?
}
