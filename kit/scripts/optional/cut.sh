#!/bin/bash
# OPTIONAL (any OS with ffmpeg). Cut one play out of a screen recording and make a 10 fps overview sheet.
#   cut.sh <dir> <tag> <play_ms> <out_name> [secs=4.5]
# <dir>/_raw_<tag>.mp4 + <dir>/_rec_<tag>.start (unix seconds when the recording began; rec.sh writes it, with another
# recorder write it yourself). play_ms = what fx:Play() returned, or fx.liveLog[cam] after fx:LiveRun().
dir=$1; tag=$2; ms=$3; out=$4; secs=${5:-4.5}
start=$(cat "$dir/_rec_${tag}.start")
ss=$(python3 -c "print(max(0, $ms/1000 - $start - 0.15))")
ffmpeg -y -loglevel error -ss "$ss" -t "$secs" -i "$dir/_raw_${tag}.mp4" -c:v libx264 -crf 18 -r 60 "$dir/${out}.mp4"
ffmpeg -y -loglevel error -i "$dir/${out}.mp4" -vf "fps=10,scale=480:-1,tile=8x6" -frames:v 1 -q:v 3 "$dir/${out}_10fps.jpg"
echo "$dir/${out}.mp4 $dir/${out}_10fps.jpg"
# every frame around one beat (e.g. a hit at 1.05 s):
#   ffmpeg -ss 0.95 -t 0.4 -i $dir/$out.mp4 -vf "scale=480:-1,tile=8x3" -frames:v 1 $dir/${out}_hit60.jpg
