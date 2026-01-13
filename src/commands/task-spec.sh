#!/usr/bin/env bash
# Task spec command handler

bws::cmd::task_spec::get() {
    local task_id=""
    local filters=()

    for arg in "$@"; do
        case "$arg" in
            --*) filters+=("$arg") ;;
            *) task_id="$arg" ;;
        esac
    done

    if [[ -z "$task_id" ]]; then
        task_id=$(bws::ui::select_task "" ${filters[@]+"${filters[@]}"}) || return $BWS_EXIT_ERROR
    fi

    bws::get_task_spec "$task_id"
    return $?
}
