#!/bin/sh
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval.

DEFAULT_INTERVAL=600 # In seconds

if [ $# -lt 1 ] || [ ! -d "$1" ]; then
	printf "Usage:\n\t\e[1m%s\e[0m \e[4mDIRECTORY\e[0m [\e[4mINTERVAL\e[0m]\n" "$0"
	printf "\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every %d seconds if unspecified)." "$DEFAULT_INTERVAL"
	exit 1
fi

last_img=""  # Store the last wallpaper

while true; do
     while read -r img; do
        # Skip if it's the same as the last wallpaper
        if [ "$img" == "$last_img" ]; then
            continue
        fi

        # Set the wallpaper
        swww img --resize=fit "$img" -t fade --transition-bezier 0.55,0.055,0.675,0.19 --transition-duration 5 &
        wal -q --cols16 darken -n -i "$img"
        $HOME/.config/hypr/scripts/update-themes.sh

        # Update last_img to prevent repetition
        last_img="$img"

        sleep "${2:-$DEFAULT_INTERVAL}"
    done < <(find "$1" -type f | sort -R )
done
