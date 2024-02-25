#!/bin/bash
bashrc_commands=$(cat << 'EOF'
#
# ~/.bashrc
#

# If not running interactively, don't do an>
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

#The following line runs neofetch in every >
neofetch

# The following will apply the color scheme>

# Import colorscheme from 'wal' asynchronou>
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be >
source ~/.cache/wal/colors-tty.sh


# Global variable for wallpaper location
export WALLPAPERS=~/./Downloads/wallpapers

#The following line starts Starship
eval "$(starship init bash)"
#The following command specifies where screenshots m>
export GRIM_DEFAULT_DIR=~/Pictures/screenshots
EOF
)

bash_profile_commands=$(cat << 'EOF'             
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ];>
  exec Hyprland
fi
EOF
)

echo "$bashrc_commands" >> ~/.bashrc
echo "$bash_profile_commands" >> ~/.bash_profile

# Copies these config files to the users config files

cd ..
cp cp -r ./* ~/.config