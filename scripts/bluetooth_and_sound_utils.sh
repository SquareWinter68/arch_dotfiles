#!/bin/bash

echo "Do you want to install sound utils?
Include utils are: (pulseaudio-bluetooth, pulseaudio-equalizer, pulseaudio-jack, bluez, bluez-utils, and pavucontroll)
 (y/n)"
read userInput

# Convert userInput to lowercase using tr
userInputLower=$(echo "$userInput" | tr '[:upper:]' '[:lower:]')

# Alternatively, using parameter expansion
# userInputLower="${userInput,,}"

if [ "$userInputLower" == "y" ]; then
    echo "Installing sound utils..."
    sudo pacman -Sy bluez bluez-utils pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-jack pavucontrol
    # Add your installation command here
elif [ "$userInputLower" == "n" ]; then
    echo "Installation canceled."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
