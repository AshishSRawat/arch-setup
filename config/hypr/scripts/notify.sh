#!/bin/bash
trap 'if [ "$ALERT_PID" ]; then kill $ALERT_PID 2>/dev/null; fi; exit' SIGINT

ALERT_SCRIPT="$HOME/.config/calcurse/alert.sh"
AUDIO_FILE="$HOME/Audio/Music/yoasobi.mp3"
ICON="/usr/share/icons/Papirus-Dark/24x24/categories/alarm-clock.svg"

time_to_sleep() {
    # Input: hh:mm where hh and mm are the time left
    TIME_LEFT="$1"

    # Extract hours and minutes from input
    read hours minutes <<< "$TIME_LEFT"
    hours=$((10#$hours))
    minutes=$((10#$minutes))


    # get current time
    CURRENT_TIME_TRUNC=$(date -d "$(date +'%Y-%m-%d %H:%M:00')" +'%s')
    CURRENT_TIME=$(date +"%s")

    # Calculate the time to add in seconds
    ADD_TIME=$(( (hours * 60 * 60) + (minutes * 60) ))

    # Calculate time to sleep
    FUTURE_TIME=$((CURRENT_TIME_TRUNC + ADD_TIME))
    TIME_TO_SLEEP=$((FUTURE_TIME - CURRENT_TIME))
    echo "$FUTURE_TIME $TIME_TO_SLEEP"
}

# Loop to monitor the output of `calcurse -n`
CLOSEST_TIME=$((2**63 - 1))
ALERT_PID=""
while true; do
    # Get the next appointment's time left (e.g., "[00:03] Testing @ 8:00 AM")
    NEXT_APPOINTMENT=$(calcurse -n | sed -n '2p')
    APPT="$(calcurse -n | sed 's/\[[0-9]\{2\}:[0-9]\{2\}\] //')"
    SUMMARY="$(echo "$APPT" | sed -n '1p')"
    BODY="$(echo "$APPT" | sed -n '2p')"

    if [ -z "$NEXT_APPOINTMENT" ]; then
        if [ "$ALERT_PID" ]; then
            kill $ALERT_PID 2>/dev/null
            PID=""
        fi
        sleep 60
        continue  # Skip the rest of the loop and check for appointments again
    fi

    # Extract the time left part [hh:mm] from the string
    TIME_LEFT=$(echo "$NEXT_APPOINTMENT" | sed -E 's/\[([0-9]{2}):([0-9]{2})\].*/\1 \2/')

    # Convert the time left into seconds
    read future_time sleep_time <<< $(time_to_sleep "$TIME_LEFT")

    if [ $future_time -lt $CLOSEST_TIME ]; then
        CLOSEST_TIME=$future_time

        # kill the current alarm if it exists
        if [ "$ALERT_PID" ]; then
            kill $ALERT_PID 2>/dev/null
            ALERT_PID=""
        fi
        # spawn a new process in which we sleep until it's time
        (
            sleep $sleep_time
            $ALERT_SCRIPT "$AUDIO_FILE" "$ICON" "$SUMMARY" "$BODY"
        ) &
        ALERT_PID=$!
    fi

    # if the alarm has completed, reset so we can set a new alarm
    if ! ps -p $ALERT_PID > /dev/null; then
        CLOSEST_TIME=$((2**63 - 1))
        ALERT_PID=""
    fi
    sleep 60

done
