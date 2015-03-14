#!/bin/bash

# ---------------------------------------------------------------------------
# Author: Matthieu Holtz
# Year:   2015
# ---------------------------------------------------------------------------

bash ./downloader.sh -u "http://downloads.raspberrypi.org/raspbian_latest" -r "raspbian" -v
bash ./downloader.sh -u "http://downloads.raspberrypi.org/openelec_latest" -r "openelec" -v
bash ./downloader.sh -u "http://downloads.raspberrypi.org/ubuntu_latest" -r "ubuntu" -v

exit 0