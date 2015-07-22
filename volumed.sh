#!/bin/bash

LISTEN_PORT=1337
MUTE_CMD="amixer sset PCM 0"
UNMUTE_CMD="amixer sset PCM 127"
VOLUME_CMD="amixer sset PCM "

# Initially, unmute
$UNMUTE_CMD

while true; do

	received_str=`nc -l -p $LISTEN_PORT`
	cmd=`echo $received_str | awk '{print $1}'`
	param=`echo $received_str | awk '{print $2}'`

	echo "Received command: $received_str"
	
	if [ "$cmd" == "mute" ]; then
		echo "Muting"
		$MUTE_CMD > /dev/null
	elif [ "$cmd" == "unmute" ]; then
		echo "Unmuting"
		$UNMUTE_CMD > /dev/null
	elif [ "$cmd" == "vol" ]; then
		echo "Setting volume to $param"
		$VOLUME_CMD $param > /dev/null
	else
		echo "Unknown"
	fi

done
