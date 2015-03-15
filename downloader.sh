#!/bin/bash

# ---------------------------------------------------------------------------
# Author: Matthieu Holtz
# Year:   2015
# ---------------------------------------------------------------------------


IMG_URL=""
DOWNLOAD_PATH="./download"
VERBOSE=false
COMMAND=""
PORCELAIN=false

PORCELAIN_ACTION=""
PORCELAIN_FILE=""
PORCELAIN_SHA1=""

PORCELAIN_ACTION_CREATE="create"
PORCELAIN_ACTION_UPDATE="update"
PORCELAIN_ACTION_SKIP="skip"

verbose(){
	if [[ $VERBOSE = true ]]
		then
		echo "$1"
	fi
}

optionVerbose(){
	verbose "Set URL with $IMG_URL"
	verbose "Set DOWNLOAD_PATH with $DOWNLOAD_PATH"
	if [[ $PORCELAIN = true ]]
		then
		verbose "Use porcelain output = true"
	fi
	if [[ $COMMAND != "" ]]
		then
		verbose "Use success command '$COMMAND'"
	fi
}

porcelainAction(){
	if [[ $PORCELAIN = true ]]
		then
		PORCELAIN_ACTION="$1"
	fi
}

porcelainFile(){
	if [[ $PORCELAIN = true ]]
		then
		PORCELAIN_FILE="$1"
	fi
}

porcelainSHA1(){
	if [[ $PORCELAIN = true ]]
		then
		PORCELAIN_SHA1="$1"
	fi
}

porcelainEcho(){
	if [[ $PORCELAIN = true ]]
		then
		echo "action=$PORCELAIN_ACTION:file=$PORCELAIN_FILE:sha1=$PORCELAIN_SHA1"
	fi
}

usage(){
	echo "Usage: $0 -u <url> -r <localPath> [-v -c -p]"
	echo "Options:"
	echo " -u <url>       : Set the URL from where the image should be downloaded"
	echo " -r <localPath> : Set the path to where the image should be downloaded in local"
	echo " -v             : Verbose. Display informations during processing the script"
	echo " -c             : Shell command to execute if download/change in file occurs"
	echo " -p             : Porcelain output, output string in the following format'action=ACTION:file=FILENAME:sha1=FILE_SHA'"
	echo "                  where action could be equals to 'create', 'update' or 'skip' depending on the action"
	exit 1
}

changeCMD(){
	if [[ "$COMMAND" != "" ]]
		then
		eval $COMMAND
	fi
}

download(){
	verbose "Downloading new image"
	rm ./* > /dev/null 2>&1
	curl `if [[ "$VERBOSE" == false ]]; then echo "-sS"; fi` -O -# -J -L "$IMG_URL"
	changeCMD
	verbose "Done!"
}

process(){

	mkdir -p "$DOWNLOAD_PATH"
	cd "$DOWNLOAD_PATH"

	new_filename=`curl -sS --head -J -L $IMG_URL | grep -o -E 'filename=.*$' | sed -e 's/filename=//' | tr -d '\r' | tr -d '\n'`
	old_filename=`find *."${new_filename##*.}" 2> /dev/null | tr -d '\r' | tr -d '\n'`

	if [[ "$old_filename" == "" ]] && [[ "$new_filename" != "" ]]
		then
		verbose "No previous file"
		porcelainAction $PORCELAIN_ACTION_CREATE
		download
	elif [[ "$old_filename" != "" ]] && [[ "$new_filename" != "" ]] 
		then
	# echo "$old_filename" | od -c
	# echo "$new_filename" | od -c
	# echo "$old_filename" | wc -m
	# echo "$new_filename" | wc -m

	if [[ "$old_filename" != "$new_filename" ]]
		then
		verbose "Replace file $old_filename with $new_filename"
		porcelainAction $PORCELAIN_ACTION_UPDATE
		download
	else
		verbose "Keep $old_filename"
		porcelainAction $PORCELAIN_ACTION_SKIP
	fi
fi

porcelainFile "$new_filename"
porcelainSHA1 `cat "./$new_filename" | shasum | cut -d" " -f1`
}


while getopts ":u:r:c:hvp" opt; do

	case $opt in

		u) IMG_URL="$OPTARG";;
		r) DOWNLOAD_PATH="$OPTARG";;
		h) usage;;
		v) VERBOSE=true;;
		c) COMMAND="$OPTARG";;
		p) PORCELAIN=true;;
		\? ) echo "Unknown option: -$OPTARG" ; usage;;
		:  ) echo "Missing option argument for -$OPTARG" ; usage;;
		*  ) echo "Unimplemented option: -$OPTARG" ; usage;;

esac

done

optionVerbose
process
porcelainEcho

exit 0