#!/bin/bash
if [ $1 == "region" ]; then
    xfce4-screenshooter -rc
fi
if [ $1 == "fullscreen" ]; then
    maim ~/pics/screenshots/$(date +%s).png
fi
if [ $1 == "window" ]; then
    maim -i $(xdotool getactivewindow) ~/pics/screenshots/$(date +%s).png
fi