#!/usr/bin/env bash
# Config file loading

_BWS_CONFIG_FILE=""
BWS_ROOT=""

bws::load_config() {
    local config_paths=(
        "$PWD/.bwsrc"
        "$(git rev-parse --show-toplevel 2>/dev/null)/.bwsrc"
        "$HOME/.config/bws/config"
    )

    for path in "${config_paths[@]}"; do
        [[ -z "$path" || "$path" == "/.bwsrc" ]] && continue
        if [[ -f "$path" ]]; then
            if ! source "$path" 2>/dev/null; then
                echo "Error: failed to source config '$path'" >&2
                return 1
            fi
            _BWS_CONFIG_FILE="$path"
            return 0
        fi
    done

    local default_config="$PWD/.bwsrc"
    echo 'BWS_ROOT="projects"' > "$default_config"
    source "$default_config"
    _BWS_CONFIG_FILE="$default_config"
}

bws::get_root() {
    [[ -z "$_BWS_CONFIG_FILE" ]] && bws::load_config

    local root="${BWS_ROOT:-projects}"
    local resolved

    if [[ "$root" == /* ]]; then
        resolved="$root"
    else
        local config_dir
        config_dir="$(cd "$(dirname "$_BWS_CONFIG_FILE")" && pwd)"
        resolved="$config_dir/$root"
    fi

    if command -v realpath &>/dev/null; then
        resolved="$(realpath -m "$resolved" 2>/dev/null)" || resolved="$resolved"
    fi

    if [[ ! -d "$resolved" ]]; then
        echo "Error: BWS_ROOT directory not found: $resolved" >&2
        return 1
    fi

    echo "$resolved"
}
