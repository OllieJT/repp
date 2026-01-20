#!/usr/bin/env bash
# Init command

repp::cmd::init() {
    local git_root plans_dir settings_file

    git_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        repp::log::error "not in a git repository"
        return $REPP_EXIT_ERROR
    }

    plans_dir="$git_root/plans"
    settings_file="$plans_dir/settings.json"

    if [[ ! -d "$plans_dir" ]]; then
        mkdir -p "$plans_dir"
        repp::log::info "created $plans_dir"
    fi

    if [[ ! -f "$settings_file" ]]; then
        cat > "$settings_file" <<'EOF'
{
	"$schema": "https://unpkg.com/repp@latest/src/schema/settings.schema.json"
}
EOF
        repp::log::info "created $settings_file"
    fi

    return $REPP_EXIT_SUCCESS
}
