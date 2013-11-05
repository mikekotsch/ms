#!/bin/bash

###_FILE="/Users/mikekotsch/Documents/Programming/snippets/subtitles.srt"
_FILE="./subtitles.srt"

### HIC SVNT LEONES.

function set_start_end {
	PARAMETER="$@"
	start=$(echo "$PARAMETER" | awk '{print $1}')
	end=$(echo "$PARAMETER" | awk '{print $3}')
}

function has_time {
	PARAMETER="$@"
	[[ "$PARAMETER" == *--\>* ]] && _RESULT=1 || _RESULT=0
	echo $_RESULT
}


# take search string from command line as well.
if [[ "$#" -eq 0 ]];then
	echo "Type the word that you want to translate to awesome, followed by [ENTER]: "
	# Get user input
	read word
else
	word="$@"
fi	

for line in $(seq 1 5);do
	result=$(grep -B $line -w "$word" ${_FILE} | head -1)
	[[ $(has_time $result) == "1" ]] && break
done
		
set_start_end $result
echo $start
echo $end

diff_hours_in_minutes="$(( ( ${end:0:2} - ${start:0:2} ) * 60 ))"
diff_minutes_in_seconds="$(( ( ${diff_hours_in_minutes} + ${end:3:2} - ${start:3:2} ) * 60 ))"
diff_seconds_in_milliseconds="$(( ( ${diff_minutes_in_seconds} + ${end:6:2} - ${start:6:2} ) *1000 ))"
diff_milliseconds="$(( ( ${diff_seconds_in_milliseconds} +  ${end:9:3} - ${start:9:3})  ))"
seconds_decimal=$(bc <<< "scale=3; ${diff_milliseconds} / 1000")
diff="00:00:${seconds_decimal}"

echo "diff: $diff"

echo "ffmpeg -i /Users/mikekotsch/Documents/Programming/snippets/inception.avi -ss ${start} -t ${diff} -vcodec copy -acodec copy test.avi"
#ffmpeg -i /Users/mikekotsch/Documents/Programming/snippets/inception.avi -ss ${start} -t ${diff} -vcodec copy -acodec copy test.avi

echo "ffmpeg -i test.avi finished.avi"
#ffmpeg -i test.avi finished.avi
