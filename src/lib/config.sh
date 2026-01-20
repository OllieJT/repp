#!/usr/bin/env bash
# Config and settings

_REPP_SETTINGS_LOADED=false
REPP_PRIORITIES=()

repp::get_root() {
    local git_root
    git_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        repp::log::error "not in a git repository"
        return $REPP_EXIT_ERROR
    }

    local root="$git_root/projects"
    if [[ ! -d "$root" ]]; then
        repp::log::error "projects directory not found: $root"
        return $REPP_EXIT_ERROR
    fi

    echo "$root"
    return $REPP_EXIT_SUCCESS
}

repp::load_settings() {
    [[ "$_REPP_SETTINGS_LOADED" == true ]] && return $REPP_EXIT_SUCCESS

    local git_root settings_file
    git_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        repp::log::error "not in a git repository"
        return $REPP_EXIT_ERROR
    }

    settings_file="$git_root/projects/settings.json"

    if [[ -f "$settings_file" ]]; then
        local priorities_json
        priorities_json="$(yq -oy '.priorities // ["P0","P1","P2","P3","P4"]' "$settings_file" 2>/dev/null)"
        if [[ $? -eq 0 && -n "$priorities_json" ]]; then
            mapfile -t REPP_PRIORITIES < <(echo "$priorities_json" | yq -oy '.[]' 2>/dev/null)
        else
            REPP_PRIORITIES=("P0" "P1" "P2" "P3" "P4")
        fi
    else
        REPP_PRIORITIES=("P0" "P1" "P2" "P3" "P4")
    fi

    _REPP_SETTINGS_LOADED=true
    return $REPP_EXIT_SUCCESS
}

repp::get_priorities() {
    repp::load_settings || return $REPP_EXIT_ERROR
    printf '%s\n' "${REPP_PRIORITIES[@]}"
}
