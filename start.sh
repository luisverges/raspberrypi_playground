#!/bin/bash

# Enabled i2c devices
modprobe i2c-dev


whereis mocp
# Start app
#python3 src/main.py

mocp '/usr/src/app/src/music/Brian Eno The Big Ship.mp3'