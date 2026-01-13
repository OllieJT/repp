#!/usr/bin/env bash
# Project command handlers

bws::cmd::project::list() {
    bws::list_projects "$@"
    return $?
}

bws::cmd::project::get() {
    local project_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) project_id="$arg" ;;
        esac
    done

    if [[ -z "$project_id" ]]; then
        project_id=$(bws::ui::select_project ${filters[@]+"${filters[@]}"}) || return $BWS_EXIT_ERROR
    fi

    bws::get_project "$project_id"
    return $?
}

bws::cmd::project::scan() {
    bws::scan_projects "$@"
    return $?
}
