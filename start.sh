#!/bin/bash

# Enabled i2c devices
modprobe i2c-dev

whereis ffplay
whereis mocp
# Start app
#python3 src/main.py
ffplay '/usr/src/app/src/music/Brian Eno The Big Ship.mp3'
mocp '/usr/src/app/src/music/Brian Eno The Big Ship.mp3'