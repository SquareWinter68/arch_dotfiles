#!/bin/bash

echo "Do you want to install Hyprland (wayland compositor/window manager) As well as other needed system tools Kitty(terminal emulator), Starship (shell prompt) and Thunar(file manager)? (y/n)"
read userInput

# Convert userInput to lowercase using tr
userInputLower=$(echo "$userInput" | tr '[:upper:]' '[:lower:]')

# Alternatively, using parameter expansion
# userInputLower="${userInput,,}"

if [ "$userInputLower" == "y" ]; then
    echo "Installing Hyprland..."
    sudo pacman -Sy hyprland kitty thunar starship
    # Add your installation command here
elif [ "$userInputLower" == "n" ]; then
    echo "Installation canceled."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
