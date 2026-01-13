#!/usr/bin/env bash
# Validation functions for status and priority

bws::validate_status() {
    local status="$1"
    local valid="backlog discovery in_progress review done"

    if [[ -z "$status" ]]; then
        bws::log::error "status required"
        return $BWS_EXIT_ERROR
    fi

    if [[ ! " $valid " =~ " $status " ]]; then
        bws::log::error "invalid status '$status'. Valid: $valid"
        return $BWS_EXIT_ERROR
    fi

    return $BWS_EXIT_SUCCESS
}

bws::validate_priority() {
    local priority="$1"

    if [[ -z "$priority" ]]; then
        bws::log::error "priority required"
        return $BWS_EXIT_ERROR
    fi

    if ! [[ "$priority" =~ ^[0-4]$ ]]; then
        bws::log::error "invalid priority '$priority'. Valid: 0-4"
        return $BWS_EXIT_ERROR
    fi

    return $BWS_EXIT_SUCCESS
}
