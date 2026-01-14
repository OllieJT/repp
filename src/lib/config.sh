#!/usr/bin/env bash
# Config file loading

_REPP_CONFIG_FILE=""
REPP_ROOT=""
REPP_PRIORITIES="${REPP_PRIORITIES:-P0,P1,P2,P3,P4}"

repp::load_config() {
    local config_paths=(
        "$PWD/.repprc"
        "$(git rev-parse --show-toplevel 2>/dev/null)/.repprc"
    )

    # Add script's git root if available
    if [[ -n "${_REPP_SCRIPT_DIR:-}" ]]; then
        local script_git_root
        script_git_root="$(cd "$_REPP_SCRIPT_DIR" && git rev-parse --show-toplevel 2>/dev/null)"
        [[ -n "$script_git_root" ]] && config_paths+=("$script_git_root/.repprc")
    fi

    config_paths+=("$HOME/.config/repp/config")

    for path in "${config_paths[@]}"; do
        [[ -z "$path" || "$path" == "/.repprc" ]] && continue
        if [[ -f "$path" ]]; then
            if ! source "$path" 2>/dev/null; then
                repp::log::error "failed to source config '$path'"
                return $REPP_EXIT_ERROR
            fi
            _REPP_CONFIG_FILE="$path"
            return $REPP_EXIT_SUCCESS
        fi
    done

    repp::log::error "no config file found. Create .repprc with REPP_ROOT=\"path/to/plans\""
    return $REPP_EXIT_ERROR
}

repp::get_root() {
    [[ -z "$_REPP_CONFIG_FILE" ]] && { repp::load_config || return $REPP_EXIT_ERROR; }

    local root="${REPP_ROOT:-plans}"
    local resolved

    if [[ "$root" == /* ]]; then
        resolved="$root"
    else
        local config_dir
        config_dir="$(cd "$(dirname "$_REPP_CONFIG_FILE")" && pwd)"
        resolved="$config_dir/$root"
    fi

    if command -v realpath &>/dev/null; then
        local realpath_result
        if realpath_result="$(realpath -m "$resolved" 2>/dev/null)"; then
            resolved="$realpath_result"
        fi
    fi

    if [[ ! -d "$resolved" ]]; then
        repp::log::error "REPP_ROOT directory not found: $resolved"
        return $REPP_EXIT_ERROR
    fi

    echo "$resolved"
    return $REPP_EXIT_SUCCESS
}
