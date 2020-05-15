#!/bin/bash
INSTALL_LOC=/opt/BSCC
CPUINFO=`lscpu | grep "Architecture" | awk '{print $2}'`

# Make sure we run with root privileges
if [[ $UID != 0 ]]; then
# not root, use sudo
  echo "This script needs root privileges, rerunning it now using sudo!"
  sudo "${SHELL}" "$0" $*
  exit $?
fi

# get real username
if [[ $UID = 0 ]] && [[ ! -z "$SUDO_USER" ]]; then
  USER="$SUDO_USER"
else
  USER="$(whoami)"
fi

clear
echo "Thank you for choosing BSCC, This should only take a few minutes.."
echo ""

if type -p java; then
  echo found java executable in PATH
  _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
  echo found java executable in JAVA_HOME
  _java="$JAVA_HOME/bin/java"
else
  echo "Command 'java' not found, if you're on ubuntu/debian try installing one of the following:"
  echo ""
  echo "sudo apt install default-jre"
  echo "sudo apt install openjdk-11-jre-headless"
  echo "sudo apt install openjdk-8-jre-headless"
  echo ""
  echo "After you install java then run the Install script again..."
  exit 1
fi

########################################
#######  Check for Dependencies  #######
########################################
apt-get -y update
apt-get install -y screen git wget rsync unzip sysstat inotify-tools bc jq
sudo apt-get -y upgrade

if [[ ! -f /usr/bin/himalaya ]]; then
  sudo apt-get -y install npm node
  curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
  sudo apt-get -y install nodejs
  npm install --global himalaya
fi

#Grab JSON.sh from Dominictarr's Github. Thank you for this tool!!
wget https://raw.githubusercontent.com/dominictarr/JSON.sh/master/JSON.sh -O JSON.sh
###Place a few configs for faster loading later.
EIP=$(curl https://ipinfo.io/ip)

sed -i 's/EIP=.*/EIP='$EIP'/g' Files/conf.cfg


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

if [[ ! -d "$INSTALL_LOC" ]]; then
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
    chmod +x $INSTALL_LOC/Files/ingame_control
    chmod +x $INSTALL_LOC/Files/JSON.sh
    chmod +x $INSTALL_LOC/Files/kit
    chmod +x $INSTALL_LOC/Files/update.sh
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
