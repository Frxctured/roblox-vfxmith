#!/usr/bin/env bash
# Reference-over-ours comparison video, both cut at the effect's first frame (real time + a half-speed copy).
#   sidebyside.sh <ref.mp4> <ref_t0_seconds> <ours.mp4> <ours_t0_seconds> <out.mp4> [label] [crop=1746:663:450:379]
# ours_t0: from compare.py's onset (or the stills' t=0). The half-speed copy is written next to it (_halfspeed.mp4).
set -euo pipefail
ref=$1; rt0=$2; ours=$3; ot0=$4; out=$5; label=${6:-OURS}; crop=${7:-1746:663:450:379}
font=/usr/share/fonts/TTF/DejaVuSans-Bold.ttf
pre=0.4; len=3.9
rs=$(python3 -c "print(max(0, $rt0 - $pre))"); os_=$(python3 -c "print(max(0, $ot0 - $pre))")
ffmpeg -v error -y -ss "$rs" -t $len -i "$ref" -ss "$os_" -t $len -i "$ours" -filter_complex \
 "[0:v]fps=60,scale=1206:458,setsar=1,drawtext=fontfile=$font:text='REFERENCE':x=12:y=10:fontsize=24:fontcolor=yellow:borderw=3[a];[1:v]fps=60,crop=$crop,scale=1206:458,setsar=1,drawtext=fontfile=$font:text='$label':x=12:y=10:fontsize=24:fontcolor=0x78D2FF:borderw=3[b];[a][b]vstack=inputs=2[v]" \
 -map "[v]" -c:v libx264 -crf 16 -pix_fmt yuv420p "$out"
ffmpeg -v error -y -i "$out" -vf "setpts=2*PTS" -r 60 -c:v libx264 -crf 16 -pix_fmt yuv420p "${out%.mp4}_halfspeed.mp4"
echo "wrote $out and ${out%.mp4}_halfspeed.mp4"
