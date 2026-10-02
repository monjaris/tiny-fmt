#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1

MODE="release"  # or debug

PROJ="furmat"
OS="$(xmake lua -c 'print(os.host())')"
PLAT="$(xmake lua -c 'print(os.arch())')"


if [ "$1" = "dev" ]; then
    MODE="debug"
    shift
fi
lib="./build/${OS}/${PLAT}/${MODE}/lib${PROJ}.so"


xmake config --mode="$MODE" --yes

max_jobs=16
xmake build -j"${max_jobs}" "${PROJ}" || exit $?

mv "${lib}" "./libfurmat.so"
