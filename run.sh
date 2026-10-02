#!/usr/bin/env bash

PROJ="main"
debug_bin="./build/linux/x86_64/debug/${PROJ}"
release_bin="./build/linux/x86_64/release/${PROJ}"
copy_bin=""

if [[ "$1" == "rel" ]]; then
    [[ "$(xmake config --show 2>/dev/null | grep mode)" != *release* ]] && xmake config -m release
    copy_bin="$release_bin"
    shift
else
    [[ "$(xmake config --show 2>/dev/null | grep mode)" != *debug* ]] && xmake config -m debug
    copy_bin="$debug_bin"
fi

xmake build -j$(nproc) -v "${PROJ}" || exit $?
command cp "$copy_bin" ./"${PROJ}"
./"${PROJ}" "$@"
