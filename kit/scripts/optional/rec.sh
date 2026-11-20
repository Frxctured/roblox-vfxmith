#!/bin/bash
# OPTIONAL, Linux only (niri + wf-recorder). Records a Studio window's viewport at 60 fps and logs the start time.
#   WIN=<niri window id> GEOM="x,y WxH" rec.sh <out dir> <seconds> <tag>
# WIN: `niri msg windows` lists the ids. GEOM: the viewport's screen region (measure it once on your screen, e.g.
# with `slurp`). Writes <dir>/_raw_<tag>.mp4 and <dir>/_rec_<tag>.start (unix seconds when the recording began):
# play the effect only after the .start file exists. A lock lets several callers take turns.
arm=$1; secs=$2; tag=$3
[ -z "$WIN" ] || [ -z "$GEOM" ] || [ -z "$tag" ] && { echo "usage: WIN=<id> GEOM=\"x,y WxH\" rec.sh <dir> <seconds> <tag>"; exit 2; }
mkdir -p "$arm"
rm -f "$arm/_rec_${tag}.start"
exec 9>"${TMPDIR:-/tmp}/vfxmith_rec.lock"
flock 9
niri msg action focus-window --id "$WIN"
sleep 0.3
date +%s.%N > "$arm/_rec_${tag}.start"
timeout -s INT "$secs" wf-recorder -g "$GEOM" -r 60 -f "$arm/_raw_${tag}.mp4" -y >/dev/null 2>&1
echo done
