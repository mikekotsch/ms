#!/bin/bash
echo "Type the word that you want to translate to awesome, followed by [ENTER]: "

# Get user input
read word

# Search for specific word and give only start and end time
result=$(grep -B 1 -w $word /Users/mikekotsch/Documents/Programming/snippets/subtitles.srt | head -1)

# Replace comma with dot
tmp=${result//,/.}

# Split at the arrow
IFS=' --> ' read -a TSTAMP <<< "$tmp"

# Assign start and end with values
start="${TSTAMP[0]}"
end="${TSTAMP[3]}"

# Get duration


echo "$start and $end"
echo $t

# ffmpeg -i /Users/mikekotsch/Documents/Programming/snippets/inception.avi -ss $start -to $end -c:v copy -c:a copy test.avi

# ffmpeg -i test.avi finished.avi
