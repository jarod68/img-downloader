#!/bin/bash

# ---------------------------------------------------------------------------
# Author: Matthieu Holtz
# Year:   2015
# ---------------------------------------------------------------------------


IMG_URL=""
DOWNLOAD_PATH="./download"
VERBOSE=false

verbose(){
	if [[ $VERBOSE = true ]]
		then
		echo $1
	fi
}

usage(){
	echo "Usage: $0 -u <url> -r <localPath> [-v]"
	echo "Options:"
	echo " -u <url>       : set the URL from where the image should be downloaded"
	echo " -r <localPath> : set the path to where the image should be downloaded in local"
	echo " -v             : Verbose. Display informations during processing the script"
	exit 1
}

download(){
	verbose "Downloading new image"
	rm "./*.zip" > /dev/null 2>&1
	curl -O -# -J -L "$IMG_URL"
	verbose "Done!"
}

process(){

	mkdir -p "$DOWNLOAD_PATH"
	cd "$DOWNLOAD_PATH"

	new_filename=`curl -sS --head -J -L http://downloads.raspberrypi.org/raspbian_latest | grep -o -E 'filename=.*$' | sed -e 's/filename=//' | tr -d '\r' | tr -d '\n'`
	old_filename=`basename *.zip 2> /dev/null | tr -d '\r' | tr -d '\n'`

	if [[ "$old_filename" == "" ]] && [[ "$new_filename" != "" ]]
		then
		verbose "No previous file"
		download
	elif [[ "$old_filename" != "" ]] && [[ "$new_filename" != "" ]] 
		then
		verbose "Previous file $old_filename, checking version with $new_filename"

	# echo "$old_filename" | od -c
	# echo "$new_filename" | od -c
	# echo "$old_filename" | wc -m
	# echo "$new_filename" | wc -m

	if [[ "$old_filename" != "$new_filename" ]]
		then
		verbose "New version detected"
		download
	else
		verbose "No new version detected"
	fi
fi
}

while getopts ":u:r:hv" opt; do

	case $opt in

		u) IMG_URL="$OPTARG" ; echo "Set URL with $IMG_URL";;
		r) DOWNLOAD_PATH="$OPTARG" ; echo "Set DOWNLOAD_PATH with $DOWNLOAD_PATH";;
		h) usage ;;
		v) VERBOSE=true ;;
		\? ) echo "Unknown option: -$OPTARG" ; usage ;;
		:  ) echo "Missing option argument for -$OPTARG" ; usage ;;
		*  ) echo "Unimplemented option: -$OPTARG" ; usage ;;

	esac

done

process

exit 0