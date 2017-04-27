#!/bin/bash

set -e

if [ "$(basename $(pwd))" != "build-rpi3" ];then
    echo "Run this script from the build directory"
    exit 0
else
    THISDIR=$(pwd)
    SCRIPTDIR=$THISDIR/../meta-rpi/scripts
    BOOTSCRIPTDIR=$THISDIR/../meta-eiger824/scripts/rpi3
fi

cd $SCRIPTDIR
echo -n "The SD card will now be formatted and 2 partitions will be made. Proceed? [y/N]: "
read ans

case $ans in
    y|Y)
	sudo ./mk2parts.sh sdb 
	;;
    *)
	echo "Aborting..."
	exit 0
	;;
esac

export OETMP=$THISDIR/oe6/rpi/tmp-morty
export MACHINE=raspberrypi3
# Change if needed
export IMAGENAME=console-image-eiger824

echo "Checking if SD card is mounted ..."
if [[ ! -z "$(df -H | grep sdb)" ]]; then
    echo "Unmounting first"
    sudo umount /dev/sdb*
fi

echo -n "Copying boot files to first partition (hit any key to continue)"
read foo

cd $BOOTSCRIPTDIR
./copy_boot-rpi3.sh sdb

echo -n "Copying rootfs to second partition (hit any key to continue)"
read bar

echo -n "Enter optional hostname (hit just enter to take default - rpi3): "
read name
if [ -z $name ]; then
	name="rpi3"
fi
./copy_rootfs.sh sdb $IMAGENAME $name

