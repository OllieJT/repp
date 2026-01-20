#!/usr/bin/env bash
# Plan command handlers

repp::cmd::plan::list() {
    repp::list_plans "$@"
    return $?
}

repp::cmd::plan::get() {
    local plan_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) plan_id="$arg" ;;
        esac
    done

    if [[ -z "$plan_id" ]]; then
        plan_id=$(repp::ui::select_plan ${filters[@]+"${filters[@]}"}) || return $REPP_EXIT_ERROR
    fi

    repp::get_plan "$plan_id"
    return $?
}

repp::cmd::plan::scan() {
    repp::scan_plans "$@"
    return $?
}

repp::cmd::plan::prioritize() {
    local plan_id=""
    local priority=""

    for arg in "$@"; do
        case "$arg" in
            --*) : ;;
            */*) plan_id="$arg" ;;
            *) [[ -z "$plan_id" ]] && plan_id="$arg" || priority="$arg" ;;
        esac
    done

    if [[ -z "$plan_id" ]]; then
        plan_id=$(repp::ui::select_plan) || return $REPP_EXIT_ERROR
    fi

    if [[ -z "$priority" ]]; then
        if command -v gum &>/dev/null; then
            repp::load_settings || return $REPP_EXIT_ERROR
            priority=$(gum choose --header "Select priority" "${REPP_PRIORITIES[@]}") || return $REPP_EXIT_ERROR
        else
            repp::log::error "priority required"
            return $REPP_EXIT_ERROR
        fi
    fi

    repp::set_plan_priority "$plan_id" "$priority"
    return $?
}

repp::cmd::plan::review() {
    local plan_id="$1"

    if [[ -z "$plan_id" ]]; then
        plan_id=$(repp::ui::select_plan) || return $REPP_EXIT_ERROR
    fi

    repp::set_plan_status "$plan_id" "review"
    return $?
}

repp::cmd::plan::complete() {
    local plan_id="$1"

    if [[ -z "$plan_id" ]]; then
        plan_id=$(repp::ui::select_plan) || return $REPP_EXIT_ERROR
    fi

    repp::set_plan_status "$plan_id" "done"
    return $?
}

repp::cmd::plan::note() {
    local plan_id="$1"
    local comment="$2"

    if [[ -z "$plan_id" ]]; then
        plan_id=$(repp::ui::select_plan) || return $REPP_EXIT_ERROR
    fi

    if [[ -z "$comment" ]]; then
        if command -v gum &>/dev/null; then
            comment=$(gum input --header "Enter comment") || return $REPP_EXIT_ERROR
        else
            repp::log::error "comment required"
            return $REPP_EXIT_ERROR
        fi
    fi

    repp::add_plan_comment "$plan_id" "$comment"
    return $?
}

repp::cmd::plan::is_blocked() {
    local plan_id="$1"

    if [[ -z "$plan_id" ]]; then
        repp::log::error "plan-id required"
        repp::log::info "Usage: repp plan is-blocked <plan-id>"
        return $REPP_EXIT_ERROR
    fi

    repp::is_plan_blocked "$plan_id"
    return $?
}
