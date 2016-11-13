#!/bin/bash
INSTALL_LOC=/opt/BSCC
CPUINFO=`lscpu | grep "Architecture" | awk '{print $2}'`

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

########################################
#######  Check for Dependencies  #######
########################################
apt-get install screen git wget rsync unzip sysstat inotify-tools bc
#Grab JSON.sh from Dominictarr's Github. Thank you for this tool!!
wget https://raw.githubusercontent.com/dominictarr/JSON.sh/master/JSON.sh -O JSON.sh

do_warning() {
if (whiptail --fb --title "Erase Everything??" --yesno "If you choose to do a clean install it will erase your Minecraft Server If you've made one already using this script.. Are you 100% sure? \


This is your only chance to back out so you have been warned!..." 20 60) then
	rm -rf $INSTALL_LOC
	rm /usr/bin/BSCC
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

#Check PC specs to see if it's ARM or X86 and grab the correct java version.
CPUINFO=`lscpu | grep "Architecture" | awk '{print $2}'`

#Install Java for Arm.
do_arm() {
if [[ "$CPUINFO" == arm* ]]; then
wget -O java.tar.gz http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-8u91-linux-arm32-vfp-hflt.tar.gz
mkdir /opt/java_jdk
tar zxvf java.tar.gz -C /opt/java_jdk --strip-components=1
rm java.tar.gz
update-alternatives --install "/usr/bin/java" "java" "/opt/java_jdk/bin/java" 1
update-alternatives --set java /opt/java_jdk/bin/java
fi
}

#Install Java for X64 PC's
do_x86() {
if [[ "$CPUINFO" == x86_64 ]]; then
wget -O java.tar.gz --no-check-certificate --no-cookies --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jre-8u91-linux-x64.tar.gz && continue
mkdir /opt/java_jdk
tar zxvf java.tar.gz -C /opt/java_jdk --strip-components=1
rm java.tar.gz
update-alternatives --install "/usr/bin/java" "java" "/opt/java_jdk/bin/java" 1
update-alternatives --set java /opt/java_jdk/bin/java
#clear
fi
}

#Check Architecture
do_java() {
if [[ "$CPUINFO" == arm* ]]; then
do_arm
else
if [[ "$CPUINFO" == x86_64 ]]; then
do_x86
fi
fi
}

#Check for java install.
if [ ! -f /usr/bin/java ]; then
do_java
fi

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
	mkdir $INSTALL_LOC/rsync_backup
	mkdir $INSTALL_LOC/archive
        mkdir $INSTALL_LOC/Files
	mkdir $INSTALL_LOC/PD_Backup
	mkdir $INSTALL_LOC/minecraft_server
	mkdir $INSTALL_LOC/Files/versions
        cp Files/* $INSTALL_LOC/Files
        echo XXX
        sleep 5
        echo XXX
        echo 40
        echo "Touching files :)"
	touch $INSTALL_LOC/Files/Allowed.list
        echo XXX
        sleep 2
        echo XXX
        echo 60
        echo "Moving main to /usr/bin/"
        cp BSCC /usr/bin/
	mv JSON.sh $INSTALL_LOC/Files/
	echo XXX
        sleep 2
        echo XXX
        echo 80
        echo "Setting Permissions"
        chown -R $USER:$USER $INSTALL_LOC
	chmod +x $INSTALL_LOC/Files/watch_login
	chmod +x $INSTALL_LOC/Files/watch_logout
	chmod +x $INSTALL_LOC/Files/ingame_control
	chmod +x $INSTALL_LOC/Files/JSON.sh
	chmod +x /usr/bin/BSCC
        echo XXX
        sleep 2
        echo XXX
        echo 100
        echo "Launching Main script, enjoy"
        echo XXX
        sleep 2
) | whiptail --gauge "Gathering info" 8 40 0
	chown -R $SUDO_USER:$SUDO_USER $INSTALL_LOC/*
	whiptail --fb --msgbox "Ok everything is in order and you should now be able to run (BSCC) and start your server builds." 20 60
	clear
	echo "Ok everything is in order and you should now be able to run (BSCC) and start your server builds."
else
        exit 0
fi

else
        do_notice
fi
