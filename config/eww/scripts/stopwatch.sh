#!/bin/bash

STATE="$HOME/.cache/stopwatch"
ACTIVE="$STATE/active"
START="$STATE/start-time"
ADJ="$STATE/adj-time"

mkdir -p "$STATE"

start() {
    if [ ! -f $START ]; then
        date +"%s%N" > $START
    fi
    
    if [ $(cat $ACTIVE) == "false" ]; then
        echo "true" > $ACTIVE
    fi
}

stop() {
    # Read the previously stored adjustment time, default to 0
    local prev_adj=0
    if [ -f $ADJ ]; then
        read prev_adj < $ADJ
    fi

    # Ensure we're only adding the elapsed time since the last start
    if [ -f $START ]; then
        local start_time
        read start_time < $START
        local cur_time=$(date +"%s%N")
        local elapsed_time=$((cur_time - start_time))
        local new_adj=$((prev_adj + elapsed_time))

        echo "$new_adj" > $ADJ
        rm -f $START
    fi
}

reset() {
    rm $ADJ $START
    if [ $(cat $ACTIVE) == "true" ]; then
        echo "false" > $ACTIVE
    fi
}

poll_h() {
    local adj_time=0
    if [ -f $ADJ ]; then
        read adj_time < $ADJ
    fi
    local cur_time=$(date +"%s%N")
    local start_time=$cur_time
    
    if [ -f $START ]; then
        read start_time < $START
    fi

    echo $((cur_time - start_time + adj_time))
}

poll() {
    local time_passed=$(poll_h)

    # Convert to seconds, minutes, hours, and deciseconds
    local hours=$((time_passed / 3600000000000))
    local minutes=$(((time_passed / 60000000000) % 60))
    local seconds=$(((time_passed / 1000000000) % 60))
    local deciseconds=$(((time_passed / 100000000) % 10))

    # Format the result as hh:mm:ss.d
    printf "%02d:%02d:%02d.%d\n" "$hours" "$minutes" "$seconds" "$deciseconds"
}

# Ensure exactly one argument is passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {start|stop|reset|poll}" >&2
    exit 1
fi

# Handle command-line argument
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    reset)
        reset
        ;;
    poll)
        poll
        ;;
    *)
        echo "Invalid option: $1" >&2
        echo "Usage: $0 {start|stop|reset}" >&2
        exit 1
        ;;
esac
