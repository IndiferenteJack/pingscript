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
echo $(date) 'Starting monitoring'
curl -s --max-time 10 -X POST ${botapi} --data "chat_id=${groupId1}" --data "disable_web_page_preview=true" --data "text=${infomessage1}" --connect-timeout 30 > /dev/null

if [ ! -f /var/log/pinghome-log.txt ] || grep -Fxq "" /var/log/pinghome-log.txt; 
then
    echo "offline" > /var/log/pinghome-log.txt;
fi
sleep 2

# ENTER LOOP
while :
do

ping -c 4 $server > /dev/null
status=$?
if [ $status -eq 0 ] 
  then 
    status="up" 
  else 
    status="down"
fi

if [ $status = up ] && grep -Fxq "offline" /var/log/pinghome-log.txt
then
     echo $(date) 'Internet is back up.'
     curl -s --max-time 10 -X POST ${botapi} --data "chat_id=${groupId1}" --data "disable_web_page_preview=true" --data "text=${infomessage2}" --connect-timeout 30 > /dev/null
     echo "online" > /var/log/pinghome-log.txt

elif [ $status = down ] && grep -Fxq "online" /var/log/pinghome-log.txt
then
    echo $(date) 'Internet timeout.'
    curl -s --max-time 10 -X POST ${botapi} --data "chat_id=${groupId1}" --data "disable_web_page_preview=true" --data "text=${infomessage3}" --connect-timeout 30 > /dev/null
    echo "offline" > /var/log/pinghome-log.txt
    
fi

sleep $interval
#echo 'Sleep time ' ${interval}

done

exit
