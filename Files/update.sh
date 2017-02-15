#!/bin/bash

#Add color for info.
green='\e[1;32m'
red='\e[0;31m'
yellow='\e[1;33m'
CLEAR="tput sgr0"

source /opt/BSCC/Files/conf.cfg

        cd $INSTALL_LOC
        wget -q https://raw.githubusercontent.com/kicker22004/BSCC-MC-Edition/master/Files/conf.cfg -O conf.cfg
        source conf.cfg
        find=$(grep "BSCC_VERSION" conf.cfg > tmp)
        find=$(cat tmp | cut -d "=" -f2)
        clear
        echo -e ${yellow}"Version found online: $find"
        unset BSCC_VERSION
        source /opt/BSCC/Files/conf.cfg
        echo "Currently Installed Version: $BSCC_VERSION"
        $CLEAR
if [ $find = $BSCC_VERSION ]; then
        echo -e ${green}"You are up to date."
        echo "Launching Program!"
        $CLEAR
        sleep 1
        rm conf.*
        rm tmp
        exit 0
        /usr/bin/BSCC menu
else
        rm conf.*
        rm tmp
        clear
        echo -e ${red}"An Updated Version was found, Grabbing files"
        $CLEAR
        sleep 2
        cd /opt/BSCC/Files/
        wget -q https://raw.githubusercontent.com/kicker22004/BSCC-MC-Edition/master/Files/upgrade -O upgrade
        chmod +x upgrade
        /opt/BSCC/Files/upgrade
        echo -e ${green}"You are up to date."
        echo "Launching Program!"
        $CLEAR
        sleep 2
        exit 0
        source /opt/BSCC/Files/conf.cfg
        /usr/bin/BSCC menu
fi
        
