#!/bin/bash

fn="$1"
of=`echo $1 | sed s/mp4/jpg/`

lf=`ffprobe -show_streams "$fn" 2> /dev/null | grep nb_frames | head -1 | cut -d \= -f 2`
# rm -f "$of"
let "lf = $lf - 1"
ffmpeg -i $fn -vf select=\'eq\(n,$lf\) -vframes 1 $of