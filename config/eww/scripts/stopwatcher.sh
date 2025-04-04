#!/bin/bash


STATE="$HOME/.cache/stopwatch"
ACTIVE="$STATE/active"

active() {
    if [ -f $ACTIVE ]; then
        cat $ACTIVE
    else
        echo "false"
    fi

    inotifywait -m -e close_write $ACTIVE | while read line; do
        cat $ACTIVE
    done
}

case "$1" in
    active)
        active
        ;;
    *)
        echo "Invalid option: $1" >&2
        echo "Usage: $0 {active}" >&2
        exit 1
        ;;
esac
