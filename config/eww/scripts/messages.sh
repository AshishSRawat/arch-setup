#!/bin/bash

DELAY=10

next_appt() {
    calcurse -n | sed -n '2s/^[[:space:]]*//p'
    sleep $DELAY
}

todos() {
    local todo_list=$(calcurse -t --format-todo "%m %N" | grep -E '^[A-Z]+ ' | sed 's/^\([A-Z]\+\).*-\(.*\)/[\1] \2/g')
    while read -r line; do
        echo $line
        sleep $DELAY
    done <<< $todo_list
}

while true; do
    next_appt
    todos
done
