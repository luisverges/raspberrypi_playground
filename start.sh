#!/bin/bash

# Enabled i2c devices
modprobe i2c-dev

# Start app
#python3 test.py
python3 src/main.py


#echo new cron into cron file
#crontab -l | { cat; echo "* * * * * main.py"; } | crontab -
