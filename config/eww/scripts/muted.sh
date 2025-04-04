#!/bin/bash

echo `pactl get-sink-mute 0 | awk 'NR == 1 {print $2}' | sed 's/%//'`

handle() {
    echo `pactl get-sink-mute 0 | awk 'NR == 1 {print $2}' | sed 's/%//'`
}

pactl subscribe | rg --line-buffered "on sink" | while read -r _; do handle ; done
