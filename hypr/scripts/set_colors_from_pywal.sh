#!/bin/bash

input_file="/home/squarewinter/.cache/wal/colors"
output_file="/home/squarewinter/.config/hypr/colors.conf"

if [ -f "$input_file" ]; then
    # Create or truncate the output file
    > "$output_file"

    # Read each line from the input file and write to the output file
    count=1
    while IFS= read -r line; do
        color_variable="\$color$count"
        hex_value="${line#\#}"  # Remove the leading hashtag
        echo "$color_variable = $hex_value" >> "$output_file"
        ((count++))
    done < "$input_file"

    echo "Conversion completed. Colors saved to $output_file"
else
    echo "Error: Input file $input_file not found."
fi