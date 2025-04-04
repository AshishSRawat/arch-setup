#!/bin/bash

pactl get-sink-volume 0 | awk 'NR == 1 {print $5}' | sed 's/%//'

handle() {
    pactl get-sink-volume 0 | awk 'NR == 1 {print $5}' | sed 's/%//'
}

pactl subscribe | rg --line-buffered "on sink" | while read -r _; do handle ; done
