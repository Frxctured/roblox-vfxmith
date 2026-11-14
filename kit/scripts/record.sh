#!/usr/bin/env bash
# Records the Roblox Studio window for the VFX capture loop (see README.md).
#   record.sh <out.mp4> <seconds> [--steal]
# Records the whole output at 60 fps with wf-recorder while the Studio window (Vinegar/Wine desktop) is on screen.
# By default it ONLY records when Studio is already the focused window (the user put it there for us) and exits with
# code 2 otherwise: use the freeze-frame stills (stills.py) then. --steal brings Studio to the front for the recording
# and gives focus back afterwards (it takes over the user's screen: only with their OK).
# Start the effect first (VFXCapture.playLater(name, 3.5)), then this; compare.py finds the first frame by itself.
set -euo pipefail
out=${1:?out.mp4}; secs=${2:-8}; steal=${3:-}
studio=$(niri msg -j windows | python3 -c "import json,sys; w=[x for x in json.load(sys.stdin) if x.get('app_id')=='explorer.exe' and 'Wine Desktop' in (x.get('title') or '')]; print(w[0]['id'] if w else '')")
[ -n "$studio" ] || { echo "Studio window not found" >&2; exit 1; }
prev=$(niri msg -j focused-window | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['id'] if d else '')")
if [ "$prev" != "$studio" ] && [ "$steal" != "--steal" ]; then
  echo "Studio is not the focused window: not recording (use stills.py, or --steal with the user's OK)" >&2; exit 2
fi
niri msg action focus-window --id "$studio"
sleep 0.4
focused=$(niri msg -j focused-window | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])")
if [ "$focused" != "$studio" ]; then echo "could not focus Studio" >&2; exit 1; fi
rm -f "$out"
wf-recorder -y -f "$out" -r 60 -c libx264 -p preset=ultrafast -p crf=14 >/dev/null 2>&1 &
rec=$!
sleep "$secs"
kill -INT "$rec"; wait "$rec" 2>/dev/null || true
[ -n "$prev" ] && [ "$prev" != "$studio" ] && niri msg action focus-window --id "$prev"
# wf-recorder writes black as 16 but tags the stream full range (yuvj420p, pc): re-tag it as limited range (no
# re-encode) so decoders map 16 -> 0 and the void stage reads black, as in the stills.
ffmpeg -v error -y -i "$out" -c copy -bsf:v h264_metadata=video_full_range_flag=0 "${out%.mp4}.tmp.mp4" && mv "${out%.mp4}.tmp.mp4" "$out"
echo "recorded $out ($(ffprobe -v error -show_entries format=duration -of csv=p=0 "$out")s)"
