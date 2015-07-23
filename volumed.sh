#!/bin/sh

# volumed enables remote control of volume on Squeezebox/Logitech UE Radio.
# Recognized commands are "mute", "unmute" and "vol <x>" where x is between 0 and 127.
# The connection must be closed after sending a command.
# 
# To automatically load at startup:
# 1. Make the script executable (chmod +x volumed.sh)
# 2. Add it to /etc/init.d/rcS.local
# 
# To control from Fibaro HC2:
# 1. Add virtual device, configure IP and port
# 2. Add "mute" and "unmute" commands in buttons, remember newline
# 3. Add slider with "vol _sliderValue_" command


LISTEN_PORT=1337
MUTE_CMD="amixer sset PCM 0"
UNMUTE_CMD="amixer sset PCM 127"
VOLUME_CMD="amixer sset PCM "

# Initially, unmute
$UNMUTE_CMD > /dev/null

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
		mixer_val=$((64+($param*127/(100*2)))) # $param: 0-100 (Fibaro slider range), $mixer_val: 64-127 (very low-full volume)
		echo "Setting volume to $mixer_val"
		$VOLUME_CMD $mixer_val > /dev/null
	else
		echo "Unknown"
	fi

done
