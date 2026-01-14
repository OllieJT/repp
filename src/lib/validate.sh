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

    if ! [[ "$priority" =~ ^[0-4]$ ]]; then
        repp::log::error "invalid priority '$priority'. Valid: 0-4"
        return $REPP_EXIT_ERROR
    fi

    return $REPP_EXIT_SUCCESS
}
