#!/bin/bash

# ---------------------------------------------------------------------------
# Author: Matthieu Holtz
# Year:   2015
# ---------------------------------------------------------------------------

LOG_FILE="./downloader-task.log"

raspbian=`date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`" - LOG: "`bash ./downloader.sh -u "http://downloads.raspberrypi.org/raspbian_latest" -r "raspbian" -p`
openelec=`date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`" - LOG: "`bash ./downloader.sh -u "http://downloads.raspberrypi.org/openelec_latest" -r "openelec" -p`
ubuntu=`date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`" - LOG: "`bash ./downloader.sh -u "http://downloads.raspberrypi.org/ubuntu_latest" -r "ubuntu" -p`

echo "$raspbian" >> $LOG_FILE
echo "$openelec" >> $LOG_FILE
echo "$ubuntu" >> $LOG_FILE

exit 0