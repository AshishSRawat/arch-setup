#!/bin/bash

. "${HOME}/.cache/wal/colors.sh"
CONFIG="${HOME}/.config/rofi/config.rasi"

sed -i "s/\(color0:.*\)#.\{6\}/\1$color0/g" $CONFIG
sed -i "s/\(color1:.*\)#.\{6\}/\1$color1/g" $CONFIG
sed -i "s/\(color2:.*\)#.\{6\}/\1$color2/g" $CONFIG
sed -i "s/\(color3:.*\)#.\{6\}/\1$color3/g" $CONFIG
sed -i "s/\(color4:.*\)#.\{6\}/\1$color4/g" $CONFIG
sed -i "s/\(color5:.*\)#.\{6\}/\1$color5/g" $CONFIG
sed -i "s/\(color6:.*\)#.\{6\}/\1$color6/g" $CONFIG
sed -i "s/\(color7:.*\)#.\{6\}/\1$color7/g" $CONFIG
sed -i "s/\(color8:.*\)#.\{6\}/\1$color8/g" $CONFIG
sed -i "s/\(color9:.*\)#.\{6\}/\1$color9/g" $CONFIG
sed -i "s/\(color10:.*\)#.\{6\}/\1$color10/g" $CONFIG
sed -i "s/\(color11:.*\)#.\{6\}/\1$color11/g" $CONFIG
sed -i "s/\(color12:.*\)#.\{6\}/\1$color12/g" $CONFIG
sed -i "s/\(color13:.*\)#.\{6\}/\1$color13/g" $CONFIG
sed -i "s/\(color14:.*\)#.\{6\}/\1$color14/g" $CONFIG
sed -i "s/\(color15:.*\)#.\{6\}/\1$color15/g" $CONFIG
sed -i "s/\(bg:.*\)#.\{6\}\(.*\)/\1$color0\2/g" $CONFIG

perl -i -pe '
    if ($c < 3) {
        s/(linear-gradient.*)#.{6}, #.{6}/$1'"$color0, $color5"'/ and $c++;
    } else {
        s/(linear-gradient.*)#.{6}, #.{6}/$1'"$color0, $color1"'/;
    }
' "$CONFIG"
