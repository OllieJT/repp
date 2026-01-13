#!/usr/bin/env bash
# Validation functions for status and priority

bws::validate_status() {
    local status="$1"
    local valid="backlog discovery in_progress review done"

    if [[ -z "$status" ]]; then
        echo "Error: status required" >&2
        return $BWS_EXIT_ERROR
    fi

    if [[ ! " $valid " =~ " $status " ]]; then
        echo "Error: invalid status '$status'. Valid: $valid" >&2
        return $BWS_EXIT_ERROR
    fi

    return $BWS_EXIT_SUCCESS
}

bws::validate_priority() {
    local priority="$1"

    if [[ -z "$priority" ]]; then
        echo "Error: priority required" >&2
        return $BWS_EXIT_ERROR
    fi

    if ! [[ "$priority" =~ ^[0-4]$ ]]; then
        echo "Error: invalid priority '$priority'. Valid: 0-4" >&2
        return $BWS_EXIT_ERROR
    fi

    return $BWS_EXIT_SUCCESS
}
