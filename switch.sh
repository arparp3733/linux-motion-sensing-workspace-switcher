`pacman -Ss wmctrl > /dev/null`
if [ $? -eq 0 ]
then
	COUNTER=0
	while [  $COUNTER -lt 100 ]
	do
	    sleep 1
	    INFO=`wmctrl -d`
		NO_OF_ROWS=`wmctrl -d | wc -l`
		NO_OF_COLS=`wmctrl -d | wc -l`
		NO_OF_WORKSPACES=`wmctrl -d | wc -l`
		WORKSPACE_INDEX=`wmctrl -d | grep "*" | awk '{print $1}'`
		HPOS=`cat /sys/devices/platform/lis3lv02d/position | cut -d',' -f1 | cut -d'(' -f2`
		if [ $HPOS -ge 200 ]
			then
			let WORKSPACE_INDEX=WORKSPACE_INDEX+1
			WORKSPACE_INDEX=$(echo $[$WORKSPACE_INDEX%$NO_OF_WORKSPACES])
			`wmctrl -s $WORKSPACE_INDEX`
		elif [ $HPOS -le -200 ]
			then
			let WORKSPACE_INDEX=WORKSPACE_INDEX-1
			WORKSPACE_INDEX=$(echo $[$[$WORKSPACE_INDEX+$NO_OF_WORKSPACES]%$NO_OF_WORKSPACES])
			`wmctrl -s $WORKSPACE_INDEX`
		fi
		let COUNTER=COUNTER+1
	done

else
	echo "Package wmctrl is required."
	echo "It is not installed on your system."
	echo "Do you want to install the package and run the script(y/n)?"
	read INSTALL_CHOICE
	if [ $INSTALL_CHOICE = "y" || $INSTALL_CHOICE = "Y" ]
	then
		sudo pacman -S wmctrl
	else
		echo "Thank you for trying  my script."
	fi
fi
