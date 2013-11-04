#!/bin/bash
echo "Type the word that you want to translate to awesome, followed by [ENTER]: "

read word

result=$(grep -B 1 -w $word /Users/mikekotsch/Desktop/_inception/subtitles.srt | head -1)

IFS=' --> ' read -ra TSTAMP <<< "$result"

ffmpeg -i /Users/mikekotsch/Desktop/_inception/inception.avi -ss "${TSTAMP[0]}" -ss "${TSTAMP[1]}" -vcodec copy -acodec copy test.avi

echo "${TSTAMP[0]}"
echo "${TSTAMP[1]}"

# echo "The word $word was found here:\n$result"