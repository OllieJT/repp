#!/usr/bin/env bash
# Plan/task query functions

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/validate.sh"

repp::get_plan() {
    local id="$1"

    if [[ -z "$id" ]]; then
        repp::log::error "plan-id required"
        return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local file="$root/$id/PLAN.yml"

    if [[ ! -f "$file" ]]; then
        repp::log::info "plan '$id' not found"
        return $REPP_EXIT_ERROR
    fi

    if command -v gum &>/dev/null; then
        { echo "id: $id"; cat "$file"; } | gum format -t code
    else
        echo "id: $id"
        cat "$file"
    fi
    return $REPP_EXIT_SUCCESS
}

repp::list_plans() {
    local filter_status=""
    local filter_priority=""

    for arg in "$@"; do
        case "$arg" in
            --status=*) filter_status="${arg#*=}" ;;
            --priority=*) filter_priority="${arg#*=}" ;;
        esac
    done

    if [[ -n "$filter_status" ]]; then
        repp::validate_status "$filter_status" || return $REPP_EXIT_ERROR
    fi
    if [[ -n "$filter_priority" ]]; then
        repp::validate_priorities "$filter_priority" || return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local found=0

    for f in "$root"/*/PLAN.yml; do
        [[ -f "$f" ]] || continue

        local id
        id=$(basename "$(dirname "$f")")
        local status
        status=$(yq '.status' "$f")
        local priority
        priority=$(yq '.priority' "$f")

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" ]] && ! repp::priority_in_list "$priority" "$filter_priority" && continue

        [[ $found -gt 0 ]] && echo "---"
        echo "id: $id"
        cat "$f"
        ((found++)) || true
    done

    [[ $found -eq 0 ]] && repp::log::info "no plans found"
    return $REPP_EXIT_SUCCESS
}

repp::get_task() {
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
    local file="$root/$plan_id/$task_slug/TASK.yml"

    if [[ ! -f "$file" ]]; then
        repp::log::info "task '$id' not found"
        return $REPP_EXIT_ERROR
    fi

    if command -v gum &>/dev/null; then
        { echo "id: $id"; cat "$file"; } | gum format -t code
    else
        echo "id: $id"
        cat "$file"
    fi
    return $REPP_EXIT_SUCCESS
}

repp::list_tasks() {
    local plan_id="$1"
    shift || true
    local filter_status=""
    local filter_priority=""

    if [[ -z "$plan_id" ]]; then
        repp::log::error "plan-id required"
        return $REPP_EXIT_ERROR
    fi

    for arg in "$@"; do
        case "$arg" in
            --status=*) filter_status="${arg#*=}" ;;
            --priority=*) filter_priority="${arg#*=}" ;;
        esac
    done

    if [[ -n "$filter_status" ]]; then
        repp::validate_status "$filter_status" || return $REPP_EXIT_ERROR
    fi
    if [[ -n "$filter_priority" ]]; then
        repp::validate_priorities "$filter_priority" || return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local plan_dir="$root/$plan_id"

    if [[ ! -d "$plan_dir" ]]; then
        repp::log::info "plan '$plan_id' not found"
        return $REPP_EXIT_ERROR
    fi

    local found=0

    for f in "$plan_dir"/*/TASK.yml; do
        [[ -f "$f" ]] || continue

        local task_slug
        task_slug=$(basename "$(dirname "$f")")
        local id="$plan_id/$task_slug"
        local status
        status=$(yq '.status' "$f")
        local priority
        priority=$(yq '.priority' "$f")

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" ]] && ! repp::priority_in_list "$priority" "$filter_priority" && continue

        [[ $found -gt 0 ]] && echo "---"
        echo "id: $id"
        cat "$f"
        ((found++)) || true
    done

    [[ $found -eq 0 ]] && repp::log::info "no tasks found in '$plan_id'"
    return $REPP_EXIT_SUCCESS
}

repp::scan_plans() {
    local filter_status=""
    local filter_priority=""

    for arg in "$@"; do
        case "$arg" in
            --status=*) filter_status="${arg#*=}" ;;
            --priority=*) filter_priority="${arg#*=}" ;;
        esac
    done

    if [[ -n "$filter_status" ]]; then
        repp::validate_status "$filter_status" || return $REPP_EXIT_ERROR
    fi
    if [[ -n "$filter_priority" ]]; then
        repp::validate_priorities "$filter_priority" || return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local found=0

    for f in "$root"/*/PLAN.yml; do
        [[ -f "$f" ]] || continue

        local id
        id=$(basename "$(dirname "$f")")
        local status
        status=$(yq '.status' "$f")
        local priority
        priority=$(yq '.priority' "$f")

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" ]] && ! repp::priority_in_list "$priority" "$filter_priority" && continue

        echo "$id"
        ((found++)) || true
    done

    [[ $found -eq 0 ]] && repp::log::info "no plans found"
    return $REPP_EXIT_SUCCESS
}

repp::scan_tasks() {
    local plan_id="$1"
    shift || true
    local filter_status=""
    local filter_priority=""

    if [[ -z "$plan_id" ]]; then
        repp::log::error "plan-id required"
        return $REPP_EXIT_ERROR
    fi

    for arg in "$@"; do
        case "$arg" in
            --status=*) filter_status="${arg#*=}" ;;
            --priority=*) filter_priority="${arg#*=}" ;;
        esac
    done

    if [[ -n "$filter_status" ]]; then
        repp::validate_status "$filter_status" || return $REPP_EXIT_ERROR
    fi
    if [[ -n "$filter_priority" ]]; then
        repp::validate_priorities "$filter_priority" || return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local plan_dir="$root/$plan_id"

    if [[ ! -d "$plan_dir" ]]; then
        repp::log::info "plan '$plan_id' not found"
        return $REPP_EXIT_ERROR
    fi

    local found=0

    for f in "$plan_dir"/*/TASK.yml; do
        [[ -f "$f" ]] || continue

        local task_slug
        task_slug=$(basename "$(dirname "$f")")
        local id="$plan_id/$task_slug"
        local status
        status=$(yq '.status' "$f")
        local priority
        priority=$(yq '.priority' "$f")

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" ]] && ! repp::priority_in_list "$priority" "$filter_priority" && continue

        echo "$id"
        ((found++)) || true
    done

    [[ $found -eq 0 ]] && repp::log::info "no tasks found in '$plan_id'"
    return $REPP_EXIT_SUCCESS
}

repp::get_task_spec() {
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
    local file="$root/$plan_id/$task_slug/SPEC.md"

    if [[ ! -f "$file" ]]; then
        repp::log::info "could not find spec for task '$id'"
        return $REPP_EXIT_ERROR
    fi

    if command -v gum &>/dev/null; then
        gum format < "$file"
    else
        cat "$file"
    fi
    return $REPP_EXIT_SUCCESS
}

repp::is_task_blocked() {
    # Exit codes use INVERTED semantics for conditional usage:
    #   0 (REPP_EXIT_SUCCESS) = task IS blocked
    #   1 (REPP_EXIT_ERROR)   = task is NOT blocked (or error)
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
    local file="$root/$plan_id/$task_slug/TASK.yml"

    if [[ ! -f "$file" ]]; then
        repp::log::error "task '$id' not found"
        return $REPP_EXIT_ERROR
    fi

    local blockers
    blockers=$(yq '.blocked_by // [] | .[]' "$file" 2>/dev/null)

    # No blockers = not blocked
    [[ -z "$blockers" ]] && return $REPP_EXIT_ERROR

    while IFS= read -r blocker_id; do
        local blocker_plan="${blocker_id%/*}"
        local blocker_task="${blocker_id#*/}"
        local blocker_file="$root/$blocker_plan/$blocker_task/TASK.yml"

        if [[ ! -f "$blocker_file" ]]; then
            repp::log::warn "blocker '$blocker_id' not found"
            # Missing blocker treated as blocked (conservative)
            return $REPP_EXIT_SUCCESS
        fi

        local blocker_status
        blocker_status=$(yq '.status' "$blocker_file")

        if [[ "$blocker_status" != "done" ]]; then
            # Found incomplete blocker = task is blocked
            return $REPP_EXIT_SUCCESS
        fi
    done <<< "$blockers"

    # All blockers complete = not blocked
    return $REPP_EXIT_ERROR
}
