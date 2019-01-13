#!/bin/bash

# Enabled i2c devices
modprobe i2c-dev

# Start app
#python3 src/main.py

#echo new cron into cron file
ps -ef | grep cron
ps aux | grep crond
crontab -l | { cat; echo "* * * * * /usr/src/app/src/main.py"; } | crontab -
