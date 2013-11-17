#!/bin/bash

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

function get_movie {
    PARAMETER="$@"
}

echo "Type the word that you want to translate to awesome, followed by [ENTER]: "
read input

for line in $(seq 1 5);do
    result=$(grep -B $line -r -w --include='*.srt' $input --exclude='*.mp4' * | head -1)
    [[ $(has_time $result) == "1" ]] && break
done

echo $result
echo "$(basename $result)"

### set_start_end $result
### echo $start
### echo $end

# echo "${end:3:2}"