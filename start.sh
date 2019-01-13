#!/bin/bash

# Enabled i2c devices
modprobe i2c-dev

# Start app
python3 src/main.py

#play '/usr/src/app/src/music/Brian Eno The Big Ship.mp3'