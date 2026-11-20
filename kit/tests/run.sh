#!/bin/sh
# Offline checks for kit/stage.luau (no Studio): compile it and a mock final.luau with luau-compile, then run the
# mock final against a stand-in Roblox API (mock_roblox.luau) with the plain luau CLI.
#   kit/tests/run.sh [<dir with luau and luau-compile>]     (default: on PATH)
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
BIN=${1:+$1/}
OUT=${TMPDIR:-/tmp}/vfxmith_stage_test.$$
mkdir -p "$OUT"
cat "$HERE/../stage.luau" "$HERE/mock_effect.luau" > "$OUT/final.luau"
"${BIN}luau-compile" --null "$HERE/../stage.luau"
"${BIN}luau-compile" --null "$OUT/final.luau"
cat "$HERE/mock_roblox.luau" "$OUT/final.luau" "$HERE/test_stage.luau" > "$OUT/run.luau"
"${BIN}luau" "$OUT/run.luau"
rm -rf "$OUT"
