#!/bin/bash

#
# ms.sh
#
# created by mikekotsch
#

### FUNCTIONS


function render_clip {
    ffmpeg -i ./_assets/$3.mp4 -ss $1 -t $2 -vcodec copy -acodec copy ./output/$5_$3_$4.mp4
}



### INPUT
echo "Type what you want to translate and press [ENTER]: "
read input

### PARSE INPUT
parse_input "$input"

### GET START & END TIME
#set_start_end $result
#get_movie_title $start
#get_delta
#render_clip $start $delta $title $input




