#!/bin/bash

# Input files
AUDIO_FILE="$1"
ICON="$2"
SUMMARY="$3"
BODY="$4"

# Send the notification
NOTIF_ID=$(gdbus call --session \
             --dest org.freedesktop.Notifications \
             --object-path /org/freedesktop/Notifications \
             --method org.freedesktop.Notifications.Notify \
             "" \
             0 \
             "$ICON" \
             "$SUMMARY" \
             "$BODY" \
             [] \
             {} \
                 300000 | awk '{print $2}' | sed 's/,)//' )

# Get the current volume of the output audio device
DEVICE=$(pactl list short sinks | awk '{print $2}' | head -n 1)  # Assuming 1 audio output device
INITIAL_VOLUME=$(pactl list sinks | grep -A 10 "$DEVICE" | grep 'Volume' | awk '{print $5}' | sed 's/%//' | head -n 1)

# Play the audio file
paplay "$AUDIO_FILE" &  # Run paplay in background
PAPLAYER_PID=$!

# Gradually increase the volume
VOLUME_INCREMENT=1  # Percentage increment for each step
CURRENT_VOLUME=$INITIAL_VOLUME
(
  while [ "$CURRENT_VOLUME" -lt 100 ]; do
    pactl set-sink-volume "$DEVICE" "${CURRENT_VOLUME}%"
    sleep 5  # Adjust for smoother volume increase
    CURRENT_VOLUME=$((CURRENT_VOLUME + VOLUME_INCREMENT))
  done
) &
VOLUME_PID=$!   # Store the process ID of the volume control loop

# Listen for NotificationClosed signal
dbus-monitor "interface='org.freedesktop.Notifications',member='NotificationClosed'" |
while read -r line; do
    if [[ "$line" =~ uint32\ ([0-9]+) ]]; then
        CLOSED_ID=${BASH_REMATCH[1]}
        if [[ "$CLOSED_ID" == "$NOTIF_ID" ]]; then
            # Stop the audio
            kill $PAPLAYER_PID 2>/dev/null
            kill $VOLUME_PID 2>/dev/null
            # Reset the volume to its initial value
            pactl set-sink-volume "$DEVICE" "${INITIAL_VOLUME}%"
            # Kill dbus-monitor
            pkill -P $$ dbus-monitor
            break
        fi
    fi
done
