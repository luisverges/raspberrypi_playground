#!/bin/bash

# Enabled i2c devices
modprobe i2c-dev
whereis mpg123
locate mpg123
# Start app
#python3 src/main.py
mpg123 /usr/src/app/src/music/Brian Eno The Big Ship.mp3