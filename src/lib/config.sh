#!/usr/bin/env bash
# Config file loading

BWS_ROOT=""

bws::load_config() {
    # TODO: implement config file lookup
    # 1. .bwsrc in current directory
    # 2. .bwsrc in git root
    # 3. ~/.config/bws/config
    :
}

bws::get_root() {
    # TODO: return BWS_ROOT (resolved to absolute path)
    echo "$BWS_ROOT"
}
