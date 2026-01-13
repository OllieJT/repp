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
