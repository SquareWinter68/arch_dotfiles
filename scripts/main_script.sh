#!/bin/bash

echo "This Script will download and copy the dotfiles form the github repository.
Do you want to continue? (y/n)"
read userInput

# Convert userInput to lowercase using tr
userInputLower=$(echo "$userInput" | tr '[:upper:]' '[:lower:]')

# Alternatively, using parameter expansion
# userInputLower="${userInput,,}"

if [ "$userInputLower" == "y" ]; then
    cp -r arch_dotfiles ~/.config/
    source ./yay_install.sh
    source ./hyprland_install.sh
    source ./waybar_install.sh
    source ./bluetooth_and_sound_utils.sh
    source ./gui_elements_install.sh
    source ./edit_bashrc_and_bash_profile.sh
    # Add your installation command here
elif [ "$userInputLower" == "n" ]; then
    echo "Installation canceled."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
