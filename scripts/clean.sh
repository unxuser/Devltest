#!/bin/bash
#script is used to clear the log files.
cat /dev/null > /var/log/firewall
cat /dev/null > /var/log/messages
rm -rf  /var/log/messages-*
cat /dev/null > /var/log/wcstatus.log
rm -rf /var/log/wcstaus.log.bak
cat /dev/null > /var/log/maillog
rm -rf /var/log/maillog-*
rm -rf /tmp/*
echo "cleaned everything"
