#!/usr/bin/env bash
# Config commands

repp::cmd::config::show() {
    repp::get_resolved_settings
    return $?
}
