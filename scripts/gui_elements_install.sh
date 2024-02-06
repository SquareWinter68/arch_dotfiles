#!/bin/bash

echo "Do you want to install Gui elements
this includes rofi, swww, mpv, slurp, grim and wlogout
? (y/n)"
read userInput

# Convert userInput to lowercase using tr
userInputLower=$(echo "$userInput" | tr '[:upper:]' '[:lower:]')

# Alternatively, using parameter expansion
# userInputLower="${userInput,,}"

if [ "$userInputLower" == "y" ]; then
    echo "Installing GUI elements..."
    sudo pacman -Sy rofi grim slurp mpv
    yay -Sy swww wlogout
    # Add your installation command here
elif [ "$userInputLower" == "n" ]; then
    echo "Installation canceled."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
