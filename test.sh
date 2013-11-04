#!/bin/bash
echo "Type the word that you want to translate to awesome, followed by [ENTER]: "

read word

result=$(grep -B 1 -w $word /Users/mikekotsch/Documents/Programming/snippets/subtitles.srt | head -1)

# Old Version

tmp=${result//,/.}

IFS=' --> ' read -a TSTAMP <<< "$tmp"

start="${TSTAMP[0]}"
end="${TSTAMP[3]}"

# start=${tmp1%,*}
# end=${tmp2%,*}

echo "$start and $end"

ffmpeg -i /Users/mikekotsch/Documents/Programming/snippets/inception.avi -ss $start -to $end -vcodec copy -acodec copy test.avi

# ffmpeg -i test.avi finished.avi
