sinks=$(pactl list sinks short | awk '{print $1}')

case $1 in
    up)
        # Unmute all sinks
        pactl set-sink-mute $sinks 0

        # Set the volume to 100% if it was at or above 90%
        for sink in $sinks; do
            current_volume=$(pactl list sinks | grep 'Volume: front-left' | awk '{sum += $5} END {print sum/NR}' | sed 's/%//')
            pactl set-sink-mute $sink 0
            if [ "$current_volume" -ge 90 ]; then
                pactl set-sink-volume "$sink" 100%
            else
                pactl set-sink-volume "$sink" +10%
            fi
        done
        ;;
    down)
        # Unmute all sinks
        pactl set-sink-mute $sinks 0

        # Mute if the volume is at or below 10%, otherwise decrease volume
        for sink in $sinks; do
            current_volume=$(pactl list sinks | grep 'Volume: front-left' | awk '{sum += $5} END {print sum/NR}' | sed 's/%//')
            pactl set-sink-mute $sink 0
            if [ "$current_volume" -le 10 && "$current_volume" -ge 0 ]; then
                pactl set-sink-volume "$sink" -$current_volume%
            elif [ "$current_volume" -eq 0 ]; then
                pactl set-sink-mute $sink 1
            else
                pactl set-sink-volume "$sink" -10%
            fi
        done
        ;;
    mute)
        # Mute all sinks
        for sink in $sinks; do
            pactl set-sink-mute $sink 1
        done
        ;;
esac

volume=$(pactl list sinks | grep 'Volume: front-left' | awk '{sum += $5} END {print sum/NR}' | sed 's/%//')


send_notification() {
	if [ "$1" = "mute" ] || [ "$volume" -eq 0 ]; then ICON="$HOME/.config/dunst/icons/volume-xmark-solid.svg"; elif [ "$volume" -lt 33 ]; then ICON="$HOME/.config/dunst/icons/volume-off-solid.svg"; elif [ "$volume" -lt 66 ]; then ICON="$HOME/.config/dunst/icons/volume-low-solid.svg"; else ICON=$HOME/.config/dunst/icons/volume-high-solid.svg; fi
	if [ "$1" = "mute" ]; then TEXT="Currently muted"; else TEXT="Currently at ${volume}%"; fi

	dunstify -a "Volume" -r 1415 -h int:value:"$volume" -i "$ICON" "Volume" -t 2000
}

case $1 in
	mute)
		send_notification mute;;
	*)
		send_notification;;
esac