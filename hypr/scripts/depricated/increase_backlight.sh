#!/bin/bash
# The directory where brightness information is stored
brightness_dir="/sys/class/backlight/intel_backlight/"
#reading in the max brightness value
read -r max_brightness < "$brightness_dir/max_brightness" 
read -r current_brightness < "$brightness_dir/brightness" 
# finding a scaling factor of 10% of the total brightness
scaled_value=$((max_brightness * 10 / 100))
new_brightness=$((current_brightness + scaled_value))
#setting the new brightness by writing in the brightness dir if it does not exceed max value of 7500
echo $new_brightness
if [ "$new_brightness" -lt "$((max_brightness + 1))" ]; then
    echo $new_brightness > "$brightness_dir/brightness"
fi