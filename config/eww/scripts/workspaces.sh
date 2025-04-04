#!/bin/sh

hyprctl workspaces -j | jq -c 'sort_by(.id)'

handle() {
    local hypr_event=$(echo $1 | awk -F'>>' '{print $1}')
    case $hypr_event in
        *workspace*)
            hyprctl workspaces -j | jq -c 'sort_by(.id)'
            ;;
        *) ;;
    esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
