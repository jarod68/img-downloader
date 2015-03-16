#!/opt/bin/bash

# ---------------------------------------------------------------------------
# Author: Matthieu Holtz
# Year:   2015
# ---------------------------------------------------------------------------

LOG_FILE="/volume1/Raspberry/raps-img/downloader/downloader-task.log"

openelec=`date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`" - LOG: "`/volume1/Raspberry/raps-img/downloader/downloader.sh -u "http://downloads.raspberrypi.org/openelec_latest" -r "/volume1/Raspberry/raps-img/downloader/openelec" -p`
echo "$openelec" >> $LOG_FILE

raspbian=`date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`" - LOG: "`/volume1/Raspberry/raps-img/downloader/downloader.sh -u "http://downloads.raspberrypi.org/raspbian_latest" -r "/volume1/Raspberry/raps-img/downloader/raspbian" -p`
echo "$raspbian" >> $LOG_FILE

ubuntu=`date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`" - LOG: "`/volume1/Raspberry/raps-img/downloader/downloader.sh -u "http://downloads.raspberrypi.org/ubuntu_latest" -r "/volume1/Raspberry/raps-img/downloader/ubuntu" -p`
echo "$ubuntu" >> $LOG_FILE

exit 0