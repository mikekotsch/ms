#!/bin/bash


### FUNCTIONS
function set_start_end {
    PARAMETER="$@"
    start=$(echo "$PARAMETER" | awk '{print $1}')
    start=${start//,/.}
    end=$(echo "$PARAMETER" | awk '{print $3}')
    end=${end//,/.}
}

function has_time {
    PARAMETER="$@"
    [[ "$PARAMETER" == *--\>* ]] && _RESULT=1 || _RESULT=0
    echo $_RESULT
}

function get_movie_title {
    PARAMETER="$@"
    title=$(echo "$PARAMETER" | awk -F '-' '{print $1}')
    title=$(basename $title)
    title="${title%.*}"
    start=$(echo "$PARAMETER" | awk -F '-' '{print $2}')
}

function get_snippets {
    for line in $(seq 1 5);do
        result=$(grep -B $line -r -w --include='*.srt' $1 --exclude='*.mp4' * | head -1)
        [[ $(has_time $result) == "1" ]] && break
    done
    echo $result
}

function get_delta {
    diff_hours_in_minutes="$(( ( ${end:0:2} - ${start:0:2} ) * 60 ))"
    diff_minutes_in_seconds="$(( ( ${diff_hours_in_minutes} + ${end:3:2} - ${start:3:2} ) * 60 ))"
    diff_seconds_in_milliseconds="$(( ( ${diff_minutes_in_seconds} + ${end:6:2} - ${start:6:2} ) *1000 ))"
    diff_milliseconds="$(( ( ${diff_seconds_in_milliseconds} +  ${end:9:3} - ${start:9:3})  ))"
    seconds_decimal=$(bc <<< "scale=3; ${diff_milliseconds} / 1000")
    delta="00:00:${seconds_decimal}"
    echo $delta
}

function get_clip {
    ffmpeg -i ./assets/$3.mp4 -ss $1 -t $2 -vcodec copy -acodec copy test.mp4
}

### INPUT
echo "Type what you want to translate and press [ENTER]: "
read input

### GET SNIPPETS
result=$(get_snippets $input)

### GET START & END TIME
set_start_end $result
get_movie_title $start
get_delta
get_clip $start $delta $title

### PRINT RESULT
echo "Start: $start"
echo "End:   $end"
echo "Title: $title"
echo "Delta: $delta"

# echo "${end:3:2}"





