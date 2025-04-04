#!/bin/bash

. "${HOME}/.cache/wal/colors.sh"

conffile="$HOME/.config/mako/config"

# Associative array, color name -> color code.
declare -A colors
colors=(
    ["background-color"]="${background}A0"
    ["text-color"]="$foreground"
    ["border-color"]="$color14"
)

for color_name in "${!colors[@]}"; do
    # replace first occurence of each color in config file
    sed -i "0,/^$color_name.*/{s//$color_name=${colors[$color_name]}/}" $conffile
done

makoctl reload
