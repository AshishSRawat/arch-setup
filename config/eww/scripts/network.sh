#!/bin/bash

handler() {
    signal=$(nmcli -f IN-USE,SIGNAL d wifi | grep "\*" | awk '{print $2}')
    ssid=$(nmcli -t -f NAME c s --active | head -n 1)

    echo '{"ssid": "'"$ssid"'", "signal": "'"$signal"'"}'
}

handler

ip monitor link | while read -r _; do
    handler
done
