#!/bin/bash
echo "Type the word that you want to translate to awesome, followed by [ENTER]: "

# Get user input
read word

# Search for specific word and give only start and end time
result=$(grep -B 1 -w $word /Users/mikekotsch/Documents/Programming/snippets/subtitles.srt | head -1)

# Replace comma with dot
tmp=${result//,/:}

# Split at the arrow
IFS=' --> ' read -a TSTAMP <<< "$tmp"

# Assign start and end with values
start="${TSTAMP[0]}"
echo "Start: $start"

end="${TSTAMP[3]}"
echo "End: $end"

# start="${TSTAMP[0]}"
# end="${TSTAMP[3]}"

# Get duration
t1_sec=`echo $start | sed 's/:/ /g' | awk '{print $1"*3600000+"$2"*60000+"$3"*1000"+$4}' | bc`
echo "start: $t1_sec"
t2_sec=`echo $end | sed 's/:/ /g' | awk '{print $1"*3600000+"$2"*60000+"$3"*1000"+$4}' | bc`
echo "end: $t2_sec"

difference=$[$t2_sec-$t1_sec]

_second=$[$difference/1000%60]
_milli=$[$difference%1000]

diff="00:00:$_second.$_milli"
echo "diff: $diff"

#ffmpeg -i /Users/mikekotsch/Documents/Programming/snippets/inception.avi -ss $start -t $diff -vcodec copy -acodec copy test.avi

#ffmpeg -i test.avi finished.avi
