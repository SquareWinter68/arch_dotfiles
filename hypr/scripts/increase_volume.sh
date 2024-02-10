#!/bin/bash

# Get a list of all sinks (output devices)
sinks=$(pactl list sinks short | awk '{print $1}')

for sink in $sinks; do
    pactl set-sink-volume "$sink" +10%
done
