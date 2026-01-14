#!/usr/bin/env bash
# Logging utilities using gum log

repp::log::error() {
    if command -v gum &>/dev/null; then
        gum log --level error "$@" >&2
    else
        echo "ERROR $*" >&2
    fi
}

repp::log::warn() {
    if command -v gum &>/dev/null; then
        gum log --level warn "$@" >&2
    else
        echo "WARN $*" >&2
    fi
}

repp::log::info() {
    if command -v gum &>/dev/null; then
        gum log --level info "$@" >&2
    else
        echo "INFO $*" >&2
    fi
}
