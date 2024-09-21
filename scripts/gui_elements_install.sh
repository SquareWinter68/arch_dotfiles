#!/bin/bash

echo "Do you want to install Gui elements
this includes rofi, swww, mpv, slurp, grim, wlogout, dunst, pywal, pywalfox
? (y/n)"
read userInput

# Convert userInput to lowercase using tr
userInputLower=$(echo "$userInput" | tr '[:upper:]' '[:lower:]')

# Alternatively, using parameter expansion
# userInputLower="${userInput,,}"

if [ "$userInputLower" == "y" ]; then
    echo "Installing GUI elements..."
    sudo pacman -Sy rofi grim slurp mpv python-pywal dunst neofetch hyprlock
    yay -Sy swww wlogout python-pywalfox catnip
    # Add your installation command here
elif [ "$userInputLower" == "n" ]; then
    echo "Installation canceled."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
