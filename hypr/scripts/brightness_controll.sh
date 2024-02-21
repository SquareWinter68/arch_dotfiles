#!/bin/bash
# The directory where brightness information is sotred
brightness_dir="/sys/class/backlight/intel_backlight/"

calculate_brightness() {
    read -r max_brightness < "$brightness_dir/max_brightness"
    read -r current_brightness < "$brightness_dir/brightness" 
    scaled_value=$((max_brightness * 10 / 100))
    brightness_percentage=$(( (current_brightness * 100) / max_brightness ))
}
calculate_brightness
send_notification() {
	if [ "$brightness_percentage" -lt 33 ]; then ICON="$HOME/.config/dunst/icons/low_brightness.png"; elif [ "$brightness_percentage" -lt 66 ]; then ICON="$HOME/.config/dunst/icons/medium_brightness.png"; else ICON=$HOME/.config/dunst/icons/high_brightness.png; fi
	dunstify -a "brightness" -r 9265 -h int:value:"$brightness_percentage" -i "$ICON" "Brightness" -t 2000
}

case $1 in
    up)
        echo $brightness_percentage
        if ((brightness_percentage + 10 >= 100)); then
            echo $max_brightness > "$brightness_dir/brightness"
        else
            new_brightness=$((current_brightness + scaled_value))
            echo $new_brightness > "$brightness_dir/brightness"
        fi
        send_notification
        ;;

    down)

        if ((brightness_percentage - 10 < 10)); then
            echo 1 > "$brightness_dir/brightness"
        else
            new_brightness=$((current_brightness - scaled_value))
             echo $new_brightness > "$brightness_dir/brightness"
        fi
        send_notification
        ;;
esac