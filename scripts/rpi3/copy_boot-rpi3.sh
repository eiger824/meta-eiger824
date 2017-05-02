#!/bin/bash

if [ -z "${MACHINE}" ]; then
	echo "Environment variable MACHINE not set"
	echo "Example: export MACHINE=raspberrypi3"
	exit 1
fi

if [ "${MACHINE}" != "raspberrypi3" ]; then
	echo "Invalid MACHINE: ${MACHINE}"
	exit 1
fi

BOOTLDRFILES="bootcode.bin \
              cmdline.txt \
              config.txt \
              fixup_cd.dat \
              fixup.dat \
              fixup_db.dat \
              fixup_x.dat \
              start_cd.elf \
              start_db.elf \
              start.elf \
              start_x.elf"


DTBS="bcm2709-rpi-2-b.dtb \
      bcm2710-rpi-3-b.dtb \
      bcm2710-rpi-cm3.dtb"

if [ "x${1}" = "x" ]; then
	echo -e "\nUsage: ${0} <block device>\n"
	exit 0
fi

if [ ! -d /media/card ]; then
	echo "Temporary mount point [/media/card] not found"
	exit 1
fi

if [ -z "$OETMP" ]; then
	echo -e "\nWorking from local directory"
	SRCDIR=.
else
	echo -e "\nOETMP: $OETMP"

	if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
		echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
		exit 1
	fi

	SRCDIR=${OETMP}/deploy/images/${MACHINE}
fi 

# Determine if u-Boot or regular images have been created
if [ -f ${SRCDIR}/uImage ]
then
	IMAGETYPE=uImage
else
	IMAGETYPE=Image
fi

echo "Detected image type: $IMAGETYPE"

for f in ${BOOTLDRFILES}; do
	if [ ! -f ${SRCDIR}/bcm2835-bootfiles/${f} ]; then
		echo "Bootloader file not found: ${SRCDIR}/bcm2835-bootfiles/$f"
		exit 1
	fi
done

for f in ${DTBS}; do
	if [ ! -f ${SRCDIR}/${IMAGETYPE}-${f} ]; then
		echo "dtb not found: ${SRCDIR}/${IMAGETYPE}-${f}"
		exit 1
	fi
done
	
if [ ! -f ${SRCDIR}/${IMAGETYPE} ]; then
	echo "Kernel file not found: ${SRCDIR}/${IMAGETYPE}"
	exit 1
fi

if [ -b ${1} ]; then
	DEV=${1}
else
	DEV=/dev/${1}1

	if [ ! -b ${DEV} ]; then
		DEV=/dev/${1}p1

		if [ ! -b ${DEV} ]; then
			echo "Block device not found: /dev/${1}1 or /dev/${1}p1"
			exit 1
		fi
	fi
fi

echo "Formatting FAT partition on ${DEV}"
sudo mkfs.vfat -F 32 ${DEV} -n BOOT

echo "Mounting ${DEV}"
sudo mount ${DEV} /media/card

echo "Copying bootloader files"
sudo cp ${SRCDIR}/bcm2835-bootfiles/* /media/card

if [ $? -ne 0 ]; then
	echo "Error copying bootloader files"
	sudo umount ${DEV}
	exit 1
fi

echo "Creating overlay directory"
sudo mkdir /media/card/overlays

if [ $? -ne 0 ]; then
	echo "Error creating overlays directory"
	sudo umount ${DEV}
	exit 1
fi

echo "Copying overlay dtbs"
sudo cp ${SRCDIR}/${IMAGETYPE}-*-overlay.dtb /media/card/overlays/

if [ $? -ne 0 ]; then
	echo "Error copying overlays"
	sudo umount ${DEV}
	exit 1
fi

echo "Renaming overlay dtbs to dtbos"
THISDIR=$(pwd)
cd /media/card/overlays
for file in `ls`
do
	n=`echo $file | sed -e 's/'${IMAGETYPE}'-//g' -e 's/-overlay//g' -e 's/dtb/dtbo/g'`
	echo "$file --> $n"
	sudo mv $file $n
done
cd ${THISDIR}

echo "Copying dtbs"
for f in ${DTBS}; do
	sudo cp ${SRCDIR}/${IMAGETYPE}-${f} /media/card/${f}

	if [ $? -ne 0 ]; then
		echo "Error copying dtb: $f"
		sudo umount ${DEV}
		exit 1
	fi
done

echo "Copying kernel"
sudo cp ${SRCDIR}/${IMAGETYPE} /media/card/kernel7.img

if [ $? -ne 0 ]; then
	echo "Error copying kernel"
	sudo umount ${DEV}
	exit 1
fi

if [ -f ./config.txt ]; then
	echo "Copying local config.txt to card"
	sudo cp ./config.txt /media/card

	if [ $? -ne 0 ]; then
		echo "Error copying local config.txt to card"
		sudo umount ${DEV}
		exit 1
	fi
fi
  
if [ -f ./cmdline.txt ]; then
	echo "Copying local cmdline.txt to card"
	sudo cp ./cmdline.txt /media/card

	if [ $? -ne 0 ]; then
		echo "Error copying local cmdline.txt to card"
		sudo umount ${DEV}
		exit 1
	fi
fi

echo "Unmounting ${DEV}"
sudo umount ${DEV}

echo "Done"

