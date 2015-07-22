#!/bin/bash

LISTEN_PORT=1337
MUTE_CMD="amixer sset PCM 0"
UNMUTE_CMD="amixer sset PCM 255"
VOLUME_CMD="amixer sset PCM "

# Initially, unmute
$UNMUTE_CMD

while /bin/true; do

	received_cmd=`nc -l -p $LISTEN_PORT`
	
	echo "Received command: $received_cmd"
	
	if [ "$received_cmd" == "mute" ]; then
		echo "Muting"
		$MUTE_CMD > /dev/null
	elif [ "$received_cmd" == "unmute" ]; then
		echo "Unmuting"
		$UNMUTE_CMD > /dev/null
	else
		echo "Unknown"
	fi

done
