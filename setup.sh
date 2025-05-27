#!/usr/bin/env bash
set -e

# Install system packages
if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y love luarocks
fi

# Install Lua modules
if command -v luarocks >/dev/null 2>&1; then
    while read -r rock version; do
        [ -z "$rock" ] && continue
        luarocks install "$rock" "$version"
    done < "$(dirname "$0")/luarocks-requirements.txt"
else
    echo "luarocks not found; please install LuaRocks manually"
fi
