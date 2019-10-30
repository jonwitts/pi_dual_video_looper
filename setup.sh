#!/bin/bash

# Setup script to install our required software and 
# configure services etc.

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./setup.sh"
  exit 1
fi

# update and upgrade existing packages
echo "Upgrading existing packages"
echo "=========================="
apt-get update
apt-get dist-upgrade -y

# install our required packages
echo "Installing dependencies..."
echo "=========================="
apt-get install wget omxplayer util-linux usbmount python3 -y
apt-get install python3-gpiozero -y
# include exFAT support
apt-get install exfat-fuse exfat-utils -y

# Configure USBMount for Stretch / Buster??
# from https://vivekanandxyz.wordpress.com/2017/12/29/detecting-and-automatically-mounting-pendrive-on-raspbian-stretch-lite/
echo "Configure USBMount..."
echo "=========================="
sed -i '/MountFlags=slave/c\MountFlags=shared' /lib/systemd/system/systemd-udevd.service
systemctl daemon-reload

# copy our bash script
echo "Install our piDualVideoLooper script..."
echo "=========================="
mkdir /piDualVideoLooper
cd /piDualVideoLooper
wget -N https://raw.githubusercontent.com/jonwitts/pi_dual_video_looper/master/piDualVideoLooper.sh
chmod +x ./piDualVideoLooper.sh

# copy our shutdown Python script
echo "Install our Python shutdown script..."
echo "=========================="
wget -N https://raw.githubusercontent.com/jonwitts/pi_dual_video_looper/master/pythonShutdown.py
chmod +x ./pythonShutdown.py

# copy and activate our systemd definitions
echo "Copy and activate our systemd definitions..."
echo "=========================="
# piDualVideoLooper service
wget -N https://raw.githubusercontent.com/jonwitts/pi_dual_video_looper/master/piDualVideoLooper.service
mv ./piDualVideoLooper.service /lib/systemd/system/piDualVideoLooper.service
chmod 644 /lib/systemd/system/piDualVideoLooper.service

# pythonShutdown service
wget -N https://raw.githubusercontent.com/jonwitts/pi_dual_video_looper/master/pythonShutdown.service
mv ./pythonShutdown.service /lib/systemd/system/pythonShutdown.service
chmod 644 /lib/systemd/system/pythonShutdown.service

# reload and enable
systemctl daemon-reload
systemctl enable piSimpleDualLooper.service
systemctl enable pythonShutdown.service

# done
echo "Done. Rebooting now"
echo "=========================="
reboot
