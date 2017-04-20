#!/bin/bash

METADIR="${HOME}/poky-morty/meta"

FILES="${METADIR}/recipes-bsp/keymaps/keymaps_*.bb \
	${METADIR}/recipes-bsp/v86d/v86d_*.bb \
	${METADIR}/recipes-core/dbus/dbus_*.bb \
	${METADIR}/recipes-core/initscripts/initscripts_*.bb \
	${METADIR}/recipes-core/psplash/psplash_*.bb \
	${METADIR}/recipes-core/systemd/systemd-compat-units.bb \
	${METADIR}/recipes-kernel/modutils-initscripts/modutils-initscripts.bb"


echo -e ' \nThis script will loop through some files where certain systemd
services are masked to support compatibility with SysV.\n
Please remove the pkg_postint_${PN} part where this masking is made\n
Hit any key to proceed ...'
read foo

for file in ${FILES}
do
	if [ -f $file ]
	then
		vim $file
	else
		echo "Error, file [$file] not found. Maybe try looking for it manually?"
	fi
done
