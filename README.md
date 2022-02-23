# Bash script to check internet connection and send it to telegram

- Author: IndiferenteJack

## Usage

1. Add this script to anywhere (ex. /etc/cron.d/) --> (`git clone https://github.com/IndiferenteJack/pingscript.git`)
2. Edit and change the variables and execute or start it with crontab (ex. @reboot /etc/cron.d/pingscript.sh >> /var/log/pinghome-record.log)

For the bot create it with botFather and grab the token (neccesary) and the chat id in here https://api.telegram.org/bot<YourBOTToken>/getUpdates.
