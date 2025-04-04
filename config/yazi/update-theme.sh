#!/bin/bash

. "$HOME/.cache/wal/colors.sh"
CONFIG="$HOME/.config/yazi/theme.toml"

echo "[manager]
cwd = { fg = \""$color10"\", bold = true, italic = true}

[mode]
normal_main = { fg = \""$color0"\", bg = \""$color2"\", bold = true }
normal_alt = { fg = \""$color10"\", bg = \""$color0"\", bold = true }

select_main = { fg = \""$color0"\", bg = \""$color10"\", bold = true }
select_alt = { fg = \""$color10"\", bg = \""$color0"\", bold = true }

unset_main = { fg = \""$color0"\", bg = \""$color10"\", bold = true }
unset_alt = { fg = \""$color10"\", bg = \""$color0"\", bold = true }" > $CONFIG
