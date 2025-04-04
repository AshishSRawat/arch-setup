if status is-interactive
    # Commands to run in interactive sessions can go here
    alias clear="clear -x"

    source "$HOME/.cache/wal/colors.fish"
    cat ~/.cache/wal/sequences

    set -g fish_key_bindings fish_vi_key_bindings 

    # starship
    export STARSHIP_CONFIG=/home/user/.config/starship/starship.toml
    starship init fish | source
end
