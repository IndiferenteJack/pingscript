#!/bin/sh

# Server online-status check with reporting to telegram
# INDIFERENTEJACK SCRIPT #

# Server variables to change
server="google.com"  #ip or dns to check
interval=60   #interval to test

# Telegram variables
botToken="xxxxxxx"
groupId1="xxxxx"
botapi="https://api.telegram.org/bot${botToken}/sendMessage"
infomessage1= %e2%9a%a1 Initiated bot %0A$(date +"%a, %d. %B %Y, %H:%M:%S")
infomessage2= %e2%9c%85 Connection back up! %0A$(date +"%a, %d. %B %Y, %H:%M:%S")
infomessage3= %f0%9f%9a%a8 Connection timeout! %0A$(date +"%a, %d. %B %Y, %H:%M:%S")

# START ACTION DO NOT CHANGE #
timeout=0

curl -s --max-time 10 -X POST ${botapi} --data "chat_id=${groupId1}" --data "disable_web_page_preview=true" --data "text=infomessage1" --connect-timeout 30 > /dev/null

sleep 2

while :
do

ping -c 4 $server > /dev/null
status=$?

if [ $status -eq 0 ] && grep -Fxq "offline" pinghome-log.txt
then 
   if [ $timeout -eq 0 ]
        then
        curl -s --max-time 10 -X POST ${botapi} --data "chat_id=${groupId1}" --data "disable_web_page_preview=true" --data "text=infomessage2" --connect-timeout 30 > /dev/null
        timeout=1
	echo "online" > pinghome.txt
   fi

elif [ $status -ne 0 ] && grep -Fxq "online" pinghome.txt
then
   if [ $timeout -eq 1 ] 
        then
        curl -s --max-time 10 -X POST ${botapi} --data "chat_id=${groupId1}" --data "disable_web_page_preview=true" --data "text=infomessage3" --connect-timeout 30 > /dev/null
        timeout=0
	echo "offline" > pinghome.txt
   fi
fi

sleep $interval

done

exit