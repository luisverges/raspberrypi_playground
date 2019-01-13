#!/bin/bash

# Enabled i2c devices
modprobe i2c-dev
ckconfig --list cron
ckconfig --list crond
ls /etc/
chkconfig --list | grep crond
# Start app
#python3 src/main.py
chkconfig crond on
chkconfig cron on
#echo new cron into cron file
ps -ef | grep cron
ps aux | grep crond
crontab -l | { cat; echo "* * * * * /usr/src/app/src/main.py"; } | crontab -
