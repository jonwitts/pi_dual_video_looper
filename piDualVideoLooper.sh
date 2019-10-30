#!/bin/bash

# A simple Dual Video Looper for the Raspberry Pi 4
#
# author:  Jon Witts
# license: GPL-3.0, see LICENSE included in this package
#
# A Bash Dual Video Looper for the Raspberry Pi 4 and a Python3 shutdown button and LED indicator
# https://github.com/jonwitts/pi_dual_video_looper

# first find the first attached USB drive
# scan in reverse order to find the first!
mounts=( "/media/usb7" "/media/usb6" "/media/usb5" "/media/usb4" "/media/usb3" "/media/usb2" "/media/usb1" "/media/usb0" "/media/usb")
usbmount=""
for i in "${mounts[@]}"
do
    if mountpoint -q $i; then
        usbmount=$i
    fi
done

# now play the 2 video files, looping it with bash
# files need to be named as below...
# left.mp4 will output on HDMI0 --display 2
# right.mp4 will output on HDMI1 --display 7
# As labelled on the Pi4 board
while true
do
    omxplayer -b --adev local --display 2 $usbmount/left.mp4 &
    omxplayer -b --adev local --display 7 $usbmount/right.mp4
done
