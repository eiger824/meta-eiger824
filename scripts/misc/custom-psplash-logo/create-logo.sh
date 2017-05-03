#!/bin/bash

set -e

THISDIR="${HOME}/poky-morty/meta-eiger824/scripts/misc/custom-psplash-logo"

if [ "$PWD" != "$THISDIR" ]
then
	echo "Run this script from $THISDIR (pwd is $PWD)"
	exit 1
fi

PSPLASHDIR="${HOME}/poky-morty/build*/oe6/rpi/tmp-morty/work/cortexa7hf-neon-vfpv4-poky-linux-gnueabi/psplash"

# First check if psplash working dir exists
if [ ! -d $PSPLASHDIR ]
then
	echo "Error: psplash working dir does not exist. Bitbake-it and run this script again"
	exit 1
fi

PSPLASHAPPENDDIR="${HOME}/poky-morty/meta-eiger824/recipes-core/psplash/files"
if [ ! -d $PSPLASHAPPENDDIR ]
then
	echo "Error: psplash append dir does not exist."
	exit 1 
fi

SCRIPT=$(find $PSPLASHDIR -type f -name make-image-header.sh)
if [ -z $SCRIPT ]
then
	echo "Error: script was not found"
	exit 1
fi

LOGO=$(find $PWD -type f -iname "*.png")
if [ -z $LOGO ]
then
	echo "Error: no png images where found in this dir."
	echo "Please copy the desired png image to convert to this dir and run the script"
	exit 1
fi

echo -n "Running script ..."
$SCRIPT $LOGO "POKY"
if [ $? -ne 0 ]
then
	echo -e "\rRunning script ...[fail]"
else
	
	echo -e "\rRunning script ...[ok]"
	echo "Renaming & moving..."
	OUTNAME=$(echo $LOGO | sed -e 's/\.png/\-img\.h/')
	mv "$OUTNAME" "$PSPLASHAPPENDDIR/psplash-poky-img.h"
	
fi
exit $?
