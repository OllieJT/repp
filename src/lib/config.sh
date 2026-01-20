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

    local root="$git_root/plans"
    if [[ ! -d "$root" ]]; then
        repp::log::error "plans directory not found: $root"
        return $REPP_EXIT_ERROR
    fi

    echo "$root"
    return $REPP_EXIT_SUCCESS
}

repp::load_settings() {
    [[ "$_REPP_SETTINGS_LOADED" == true ]] && return $REPP_EXIT_SUCCESS

    local resolved_json
    resolved_json="$(repp::get_resolved_settings)" || return $REPP_EXIT_ERROR

    mapfile -t REPP_PRIORITIES < <(echo "$resolved_json" | yq -oy '.priorities[]' 2>/dev/null)

    _REPP_SETTINGS_LOADED=true
    return $REPP_EXIT_SUCCESS
}

repp::get_priorities() {
    repp::load_settings || return $REPP_EXIT_ERROR
    printf '%s\n' "${REPP_PRIORITIES[@]}"
}

repp::get_resolved_settings() {
    local git_root schema_file settings_file defaults_json merged_json

    git_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        repp::log::error "not in a git repository"
        return $REPP_EXIT_ERROR
    }

    schema_file="$_REPP_SCRIPT_DIR/schema/settings.schema.json"
    settings_file="$git_root/plans/settings.json"

    # Extract defaults from schema
    defaults_json="$(yq -oj '.properties | with_entries(.value = .value.default)' "$schema_file")"

    # Merge: defaults * user config (user wins)
    if [[ -f "$settings_file" ]]; then
        merged_json="$(echo "$defaults_json" | yq -oj ". * load(\"$settings_file\")")"
    else
        merged_json="$defaults_json"
    fi

    echo "$merged_json"
}
