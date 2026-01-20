#!/usr/bin/env bash
# Task mutation functions

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/validate.sh"
source "$(dirname "${BASH_SOURCE[0]}")/markdown.sh"

repp::resolve_task_file() {
    local id="$1"

    if [[ -z "$id" ]]; then
        repp::log::error "task-id required"
        return $REPP_EXIT_ERROR
    fi

    if [[ ! "$id" =~ ^[^/]+/[^/]+$ ]]; then
        repp::log::error "task-id must be 'plan-slug/task-slug'"
        return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local plan_id="${id%/*}"
    local task_slug="${id#*/}"
    local file="$root/$plan_id/$task_slug/TASK.md"

    if [[ ! -f "$file" ]]; then
        repp::log::error "task '$id' not found"
        return $REPP_EXIT_ERROR
    fi

    echo "$file"
    return $REPP_EXIT_SUCCESS
}

repp::set_task_priority() {
    local id="$1"
    local priority="$2"

    repp::validate_priority "$priority" || return $REPP_EXIT_ERROR

    local file
    file=$(repp::resolve_task_file "$id") || return $REPP_EXIT_ERROR

    repp::md::set_value "$file" ".priority = \"$priority\""
    return $REPP_EXIT_SUCCESS
}

repp::set_task_status() {
    local id="$1"
    local status="$2"

    repp::validate_status "$status" || return $REPP_EXIT_ERROR

    local file
    file=$(repp::resolve_task_file "$id") || return $REPP_EXIT_ERROR

    repp::md::set_value "$file" ".status = \"$status\""
    return $REPP_EXIT_SUCCESS
}

repp::add_task_comment() {
    local id="$1"
    local comment="$2"

    if [[ -z "$comment" ]]; then
        repp::log::error "comment required"
        return $REPP_EXIT_ERROR
    fi

    local file
    file=$(repp::resolve_task_file "$id") || return $REPP_EXIT_ERROR

    repp::md::add_comment "$file" "$comment"
    return $REPP_EXIT_SUCCESS
}
