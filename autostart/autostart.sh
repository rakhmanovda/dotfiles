#!/bin/bash

start_if_not_running () {
	ps cax | grep $1 > /dev/null
	if [ $? -eq 0 ]; then
		echo "Process $1 is running."
	else
		echo "Process $1 is not running."
		if [ $2 ]; then
			echo "alternative command $2 is defined"
			$2 &
		else
			echo "no alternative command found"
			$1 &
		fi
	fi
}


commands=(numlockx nm-applet polkit-gnome-au,/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 xcompmgr)
#commands=(nm-applet polkit-gnome-au)



for com in ${commands[@]}; do
	com2=$(echo $com | tr "," " ")
	echo $com2
	start_if_not_running $com2
done
