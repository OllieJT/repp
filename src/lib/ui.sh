#!/usr/bin/env bash
# GUM-based interactive selection

source "$(dirname "${BASH_SOURCE[0]}")/query.sh"

repp::ui::select_plan() {
    local items
    items=$(repp::scan_plans "$@") || return $REPP_EXIT_ERROR

    if [[ -z "$items" ]]; then
        repp::log::error "no plans found"
        return $REPP_EXIT_ERROR
    fi

    gum filter --header "Select plan" <<< "$items"
}

repp::ui::display_yaml() {
    local input
    input=$(cat)

    [[ -z "$input" ]] && return $REPP_EXIT_SUCCESS

    if command -v gum &>/dev/null; then
        echo "$input" | gum format -t code
    else
        echo "$input"
    fi
    return $REPP_EXIT_SUCCESS
}
