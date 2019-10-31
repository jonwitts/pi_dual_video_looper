#!/bin/bash

# A simple Dual Video Looper for the Raspberry Pi 4
#
# author:  Jon Witts
# license: GPL-3.0, see LICENSE included in this package
#
# A Bash Dual Video Looper for the Raspberry Pi 4 and a Python3 shutdown button and LED indicator
# https://github.com/jonwitts/pi_dual_video_looper

# stop the cursor blinking and clear the screen
setterm --cursor off
clear

# we assume that there is one USB drive attached at /dev/sda1
pmount -r /dev/sda1 > /dev/null 2>&1

# now play the 2 video files, looping it with bash
# files need to be named as below...
# hdmi0.mp4 will output on HDMI0 --display 2
# hdmo1.mp4 will output on HDMI1 --display 7
# As labelled on the Pi4 board
# Both audio tracks will output to the audio jack
# probably best to only have audio on one video track!

while true
do
    omxplayer -b --adev local --display 2 /media/sda1/hdmi0.mp4 > /dev/null 2>&1 &
    omxplayer -b --adev local --display 7 /media/sda1/hdmi1.mp4 > /dev/null 2>&1
done
