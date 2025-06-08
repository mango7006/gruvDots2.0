#!/bin/bash

# get current volume (assumes pipewire with wpctl)
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')

# update Eww variable
eww update volume_level=$VOLUME

# if not already open, open the popup
eww open volume-popup

# keep it open briefly
sleep 1.5

# close popup
eww close volume-popup
