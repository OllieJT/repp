#!/usr/bin/env bash
# Validation functions for status and priority

repp::validate_status() {
    local status="$1"
    local valid="backlog discovery in_progress review done"

    if [[ -z "$status" ]]; then
        repp::log::error "status required"
        return $REPP_EXIT_ERROR
    fi

    if [[ ! " $valid " =~ " $status " ]]; then
        repp::log::error "invalid status '$status'. Valid: $valid"
        return $REPP_EXIT_ERROR
    fi

    return $REPP_EXIT_SUCCESS
}

repp::validate_priority() {
    local priority="$1"

    if [[ -z "$priority" ]]; then
        repp::log::error "priority required"
        return $REPP_EXIT_ERROR
    fi

    if ! [[ "$priority" =~ ^[a-zA-Z0-9]+$ ]]; then
        repp::log::error "invalid priority '$priority'. Must be alphanumeric"
        return $REPP_EXIT_ERROR
    fi

    return $REPP_EXIT_SUCCESS
}

repp::validate_priorities() {
    local priorities="$1"

    if [[ -z "$priorities" ]]; then
        repp::log::error "priorities required"
        return $REPP_EXIT_ERROR
    fi

    IFS=',' read -ra items <<< "$priorities"
    for item in "${items[@]}"; do
        repp::validate_priority "$item" || return $REPP_EXIT_ERROR
    done

    return $REPP_EXIT_SUCCESS
}

repp::priority_in_list() {
    local value="$1"
    local list="$2"

    IFS=',' read -ra items <<< "$list"
    for item in "${items[@]}"; do
        [[ "$value" == "$item" ]] && return $REPP_EXIT_SUCCESS
    done

    return $REPP_EXIT_ERROR
}
