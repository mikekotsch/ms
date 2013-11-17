#!/bin/sh

#  ms_script.sh
#  
#
#  Created by @mikekotsch on 17/11/13.
#  Use this script to search for words spoken in movies.

_PATH="./_assets"
COUNTER=0


### FUNCTIONS

# split input into single words
function get_words_from {
    read -a words <<< $1
    for i in ${words[@]}; do
        echo $(render_clip $i $COUNTER)
        COUNTER=$[COUNTER+1]
    done
}

# extract a clip for single searched word
function render_clip {
    result=$(get_timestamps_for_word $1)
    start=$(get_start $result)
    end=$(get_end $result)
    delta=$(get_delta $start $end)
    echo $delta
    title=$(get_title $result)

    ffmpeg -i $_PATH/$title.mp4 -ss $start -t $delta -vcodec copy -acodec copy ./_output/$2_$title_$1.mp4
}

# get timestamp for searched word
function get_timestamps_for_word {
    for line in $(seq 1 5);do
        result=$(grep -B $line -r -w -i --include='*.srt' $1 --exclude='*.mp4' * | head -1)
        [[ $(has_timestamp $result) == "1" ]] && break
    done
    echo $result
}

# get difference between start & end
function get_delta {
    start=$1
    end=$2
    diff_hours_in_minutes="$(( ( ${end:0:2} - ${start:0:2} ) * 60 ))"
    diff_minutes_in_seconds="$(( ( ${diff_hours_in_minutes} + ${end:3:2} - ${start:3:2} ) * 60 ))"
    diff_seconds_in_milliseconds="$(( ( ${diff_minutes_in_seconds} + ${end:6:2} - ${start:6:2} ) * 1000 ))"
    diff_milliseconds="$(( ( ${diff_seconds_in_milliseconds} +  ${end:9:3} - ${start:9:3})  ))"
    seconds_decimal=$(bc <<< "scale=3; ${diff_milliseconds} / 1000")
    delta="00:00:${seconds_decimal}"
    echo $delta
}

# get starting timestamp
function get_start {
    PARAMETER="$@"
    start=$(echo "$PARAMETER" | awk '{print $1}')
    start=$(echo "$start" | awk -F '-' '{print $2}')
    start=${start//,/.}
    echo $start
}

# get ending timestamp
function get_end {
    PARAMETER="$@"
    end=$(echo "$PARAMETER" | awk '{print $3}')
    end=${end//,/.}
    echo $end
}

# get filename / movie title
function get_title {
    PARAMETER="$@"
    title=$(echo "$PARAMETER" | awk -F '-' '{print $1}')
    title=$(basename $title)
    title="${title%.*}"
    echo $title
}

# find out if line is a timestamp
function has_timestamp {
    PARAMETER="$@"
    [[ "$PARAMETER" == *--\>* ]] && _RESULT=1 || _RESULT=0
    echo $_RESULT
}


### INPUT
echo "Type a sentence and press [ENTER]: "
read input

get_words_from "$input"