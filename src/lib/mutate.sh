#!/usr/bin/env bash
# Plan mutation functions

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/validate.sh"
source "$(dirname "${BASH_SOURCE[0]}")/markdown.sh"

repp::resolve_plan_file() {
    local id="$1"

    if [[ -z "$id" ]]; then
        repp::log::error "plan-id required"
        return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local file="$root/$id.md"

    if [[ ! -f "$file" ]]; then
        repp::log::error "plan '$id' not found"
        return $REPP_EXIT_ERROR
    fi

    echo "$file"
    return $REPP_EXIT_SUCCESS
}

repp::set_plan_priority() {
    local id="$1"
    local priority="$2"

    repp::validate_priority "$priority" || return $REPP_EXIT_ERROR

    local file
    file=$(repp::resolve_plan_file "$id") || return $REPP_EXIT_ERROR

    repp::md::set_value "$file" ".priority = \"$priority\""
    return $REPP_EXIT_SUCCESS
}

repp::set_plan_status() {
    local id="$1"
    local status="$2"

    repp::validate_status "$status" || return $REPP_EXIT_ERROR

    local file
    file=$(repp::resolve_plan_file "$id") || return $REPP_EXIT_ERROR

    repp::md::set_value "$file" ".status = \"$status\""
    return $REPP_EXIT_SUCCESS
}

repp::add_plan_comment() {
    local id="$1"
    local comment="$2"

    if [[ -z "$comment" ]]; then
        repp::log::error "comment required"
        return $REPP_EXIT_ERROR
    fi

    local file
    file=$(repp::resolve_plan_file "$id") || return $REPP_EXIT_ERROR

    repp::md::add_comment "$file" "$comment"
    return $REPP_EXIT_SUCCESS
}
