#!/bin/sh

hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'

handle() {
    local hypr_event=$(echo $1 | awk -F'>>' '{print $1}')
    case $hypr_event in
        *workspace*)
            hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'
            ;;
        *) ;;
    esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
