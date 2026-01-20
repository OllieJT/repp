#!/usr/bin/env bash
# Plan query functions

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/validate.sh"
source "$(dirname "${BASH_SOURCE[0]}")/markdown.sh"

repp::get_plan() {
    local id="$1"

    if [[ -z "$id" ]]; then
        repp::log::error "plan-id required"
        return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local file="$root/$id/PLAN.md"

    if [[ ! -f "$file" ]]; then
        repp::log::info "plan '$id' not found"
        return $REPP_EXIT_ERROR
    fi

    if command -v gum &>/dev/null; then
        gum format < "$file"
    else
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

    for f in "$root"/*/PLAN.md; do
        [[ -f "$f" ]] || continue

        local id
        id=$(basename "$(dirname "$f")")
        local status
        status=$(repp::md::get_value "$f" '.status')
        local priority
        priority=$(repp::md::get_value "$f" '.priority')

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" ]] && ! repp::priority_in_list "$priority" "$filter_priority" && continue

        [[ $found -gt 0 ]] && echo "---"
        echo "id: $id"
        repp::md::get_frontmatter "$f"
        ((found++)) || true
    done

    [[ $found -eq 0 ]] && repp::log::info "no plans found"
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

    for f in "$root"/*/PLAN.md; do
        [[ -f "$f" ]] || continue

        local id
        id=$(basename "$(dirname "$f")")
        local status
        status=$(repp::md::get_value "$f" '.status')
        local priority
        priority=$(repp::md::get_value "$f" '.priority')

        [[ -n "$filter_status" && "$status" != "$filter_status" ]] && continue
        [[ -n "$filter_priority" ]] && ! repp::priority_in_list "$priority" "$filter_priority" && continue

        echo "$id"
        ((found++)) || true
    done

    [[ $found -eq 0 ]] && repp::log::info "no plans found"
    return $REPP_EXIT_SUCCESS
}

repp::is_plan_blocked() {
    # Exit codes use INVERTED semantics for conditional usage:
    #   0 (REPP_EXIT_SUCCESS) = plan IS blocked
    #   1 (REPP_EXIT_ERROR)   = plan is NOT blocked (or error)
    local id="$1"

    if [[ -z "$id" ]]; then
        repp::log::error "plan-id required"
        return $REPP_EXIT_ERROR
    fi

    local root
    root="$(repp::get_root)" || return $REPP_EXIT_ERROR

    local file="$root/$id/PLAN.md"

    if [[ ! -f "$file" ]]; then
        repp::log::error "plan '$id' not found"
        return $REPP_EXIT_ERROR
    fi

    local blockers
    blockers=$(repp::md::get_value "$file" '.blocked_by // [] | .[]' 2>/dev/null)

    # No blockers = not blocked
    [[ -z "$blockers" ]] && return $REPP_EXIT_ERROR

    while IFS= read -r blocker_id; do
        local blocker_file="$root/$blocker_id/PLAN.md"

        if [[ ! -f "$blocker_file" ]]; then
            repp::log::warn "blocker '$blocker_id' not found"
            # Missing blocker treated as blocked (conservative)
            return $REPP_EXIT_SUCCESS
        fi

        local blocker_status
        blocker_status=$(repp::md::get_value "$blocker_file" '.status')

        if [[ "$blocker_status" != "done" ]]; then
            # Found incomplete blocker = plan is blocked
            return $REPP_EXIT_SUCCESS
        fi
    done <<< "$blockers"

    # All blockers complete = not blocked
    return $REPP_EXIT_ERROR
}
