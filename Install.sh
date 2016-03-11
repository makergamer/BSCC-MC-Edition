#!/bin/bash
INSTALL_LOC=/opt/BSCC

# Make sure we run with root privileges
if [ $UID != 0 ]; then
	# not root, use sudo
	echo "This script needs root privileges, rerunning it now using sudo!"
	sudo "${SHELL}" "$0" $*
	exit $? 
fi
# get real username
if [ $UID = 0 ] && [ ! -z "$SUDO_USER" ]; then
	USER="$SUDO_USER"
else
	USER="$(whoami)"
fi

do_warning() {
if (whiptail --fb --title "Erase Everything??" --yesno "If you choose to do a clean install it will erase your Minecraft Server If you've made one already using this script.. Are you 100% sure? \


This is your only chance to back out so you have been warned!..." 20 60) then
	rm -rf $INSTALL_LOC
	source Install.sh
else
	exit 0
fi
}

do_notice() {
if (whiptail --fb --title "Is Something wrong?" --yesno "You should be all setup by now. If you ran this by mistake you should leave now. \
But if your having issues you can start a clean install now." 20 60) then
	do_warning
else
	exit 0
fi
}

if [ ! -d "$INSTALL_LOC" ]; then
        if (whiptail --fb --title "BSCC-MC-Edition" --yesno "Welcome to the Bash Script Command Center - MC Edition. \


This is the first time you have ran this so everything is going to need to be built and added to your system. \


If you agree Please, continue." 15 60) then
        (
        sleep 2
        echo XXX
        echo 20
        echo "Making Directories & Moving Files"
        mkdir $INSTALL_LOC
        mkdir $INSTALL_LOC/Files
        cp Files/* $INSTALL_LOC/Files
        echo XXX
        sleep 5
        echo XXX
        echo 40
        echo "Touching files :)"
        touch $INSTALL_LOC/Files/players.list
        echo XXX
        sleep 2
        echo XXX
        echo 60
        echo "Moving main to /usr/bin/"
        cp BSCC /usr/bin/
        echo XXX
        sleep 2
        echo XXX
        echo 80
        echo "Setting Permissions"
        chown -R $USER:$USER $INSTALL_LOC
        echo XXX
        sleep 2
        echo XXX
        echo 100
        echo "Launching Main script, enjoy"
        source BSCC do_version
        echo XXX
        sleep 2
) | whiptail --gauge "Gathering info" 8 40 0

else
        exit 0
fi

else
        do_notice
fi