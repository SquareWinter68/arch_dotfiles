#!/bin/bash
#"$WALLPAPERS_DIR/$selected_wallpaper"

#Directory containing the wallpapers
WALLPAPERS_DIR="$HOME/Pictures/wallpapers"

# Get the list of wallpapers
wallpapers=$(ls "$WALLPAPERS_DIR")

# Use Rofi to select a wallpaper
selected_wallpaper=$(echo "$wallpapers" | rofi -dmenu -i -p "Select Wallpaper")


# Check if a wallpaper is selected
if [ -n "$selected_wallpaper" ]; then
    # Run the apply_pywal.sh script with the selected wallpaper
    wal -i "$WALLPAPERS_DIR/$selected_wallpaper" -n
    swww img "$WALLPAPERS_DIR/$selected_wallpaper" --transition-type grow --transition-fps 60 --transition-duration 1.0 --transition-pos 0.810,0.972 --transition-bezier 0.65,0,0.35,1 --transition-step 255 > /dev/null 2>&1
# --transition-type grow --transition-fps 60 --transition-duration 1.0 --transition-pos 0.810,0.972 --transition-bezier 0.65,0,0.35,1 --transition-step 255
    pywalfox update > /dev/null 2>&1 
fi
source $HOME/.config/hypr/scripts/set_colors_from_pywal.sh

# Make the colors available for waybar
cp $HOME/.cache/wal/colors-waybar.css $HOME/.config/waybar

# restart waybar to apply changes

# get process id
waybar_pid=$(pgrep waybar)
#Kill current
kill "$waybar_pid" &
#start new
waybar &
